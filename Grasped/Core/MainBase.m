//
//  MainBase.m
//  BaseConnection
//
//  Created by Sarun Krishnalome on 10/1/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainBase.h"
#import "SBJsonParser.h"
#import "Error.h"
#import "RequestCounter.h"

@implementation MainBase
@synthesize errorList,errorMessage,url;
@synthesize delegate;
@synthesize numberOfNetworkConnections = _numberOfNetworkConnections;

-(NSString*) errorMessage
{
	if([self.errorList count] > 0)
	{
		Error* error = [self.errorList objectAtIndex:0];
		return  [NSString stringWithFormat:NSLocalizedStringWithDefaultValue(@"Common_Error_MainBase", nil, [NSBundle mainBundle], @"ERROR:%d Message:%@", @"Generic error message with error code"),error.code,error.message];
	}
	return @"";
}

#pragma mark constuctor

// another type for constructor 
/*
	initial with fixURL binding with static text and requestUrl
	for example
	initialUrl = http:\/\/sandbox.api.mobile.agoda.com/HotelManager.svc/search/location
	static text = v1.0/ApiKey/DeviceId/LanguageId
	requestURL = 
 */
-(id) initWithDelegate:(id<IConnectionBase>)callbackdelegate 
{
	self = [super init];
	if(self)
	{			
		// Set the delegate.
		self->delegate = callbackdelegate;
		//initial the reachable to be false first before the checking is begin
		self->isReachableDone = NO;
		//create the reachecker to run asynchronyse reachability checking
		self->reachchecker = [[ReachableChecker alloc]initWithDelegate:callbackdelegate withReachableDelegate:self];
	}
	return self;
}
#pragma mark getData Constant 
- (NSString *)getUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return [(NSString *)string autorelease];
}

// Gets a value indicating if the container contains a server error.
- (BOOL) hasServerError {
    return [self->errorList count] > 0;
}

/*
 for construct requestURL in Child class
 return application version 
 */
-(NSString*)getVersion
{
	return @"v1.0";
}

#pragma mark memory management
-(void) dealloc
{
    if (self->statusDescription) {
        [self->statusDescription release];
        self->statusDescription = nil;
    }
	self->delegate = nil;
	[self->reachchecker release];
	[self.url release];
	[self stop];
	if(self->timeout !=nil)
	{	
		[self->timeout invalidate];
		[self->timeout release];
	}
	if(self->dataload != nil)
	{
		[self->dataload release];
	}
	if(self->errorList != nil)
	{
		[self->errorList removeAllObjects];
		[self->errorList release];
	}
	[super dealloc];
}


#pragma mark NSURLConnection Implementation

// Response before data is the correct order. In fact, you should be clearing any data in this method 
// (in case you receive multiple responses through redirections and any intervening data is made obsolete).
//
// You receive a connection:didReceiveResponse: message to tell you that a reply header has been received
// but this occurs before any body content.
//
// If you need access to all elements of the reply, you should simply store the response and the data 
// as they come in and only handle them in connectionDidFinishLoading: (or if your data is long, you
// can handle incrementally in connection:didReceiveData:).
//
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *refResponse = (NSHTTPURLResponse *)response;
//    NSLog(@"Status code = %d", refResponse.statusCode);
//    NSLog(@"Localized String for Status code = %@", [NSHTTPURLResponse localizedStringForStatusCode:refResponse.statusCode]);
//    NSLog(@"%@", refResponse.allHeaderFields);
    self->statusCode = refResponse.statusCode;
    if (self->statusDescription) {
        [self->statusDescription release];
        self->statusDescription = nil;
    }
    self->statusDescription = [NSHTTPURLResponse localizedStringForStatusCode:refResponse.statusCode];
    [self->statusDescription retain];
}

// Called when the connection has received some data.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	//append the receive data from server
	[self->dataload appendData:data];
}

// Called when the connection has finished loader.
- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
	
	//timeout cancellation
	[self->timeout invalidate];
	
	
	//check out the data received
	if(self->dataload != nil)
	{
		[self onConnectionFinished:self->dataload];
	}
	
	//push the event to delegate class
	if(self->delegate != nil)
	{	
		// check is there any error response from server
		if([self.errorList count] > 0 )
		{	
			// fire the error callback when has the error in the list
			[self->delegate onDownloadFailed:self];
		}
		else {
			// data successfully download.. fire the callback to the view for perform next process
			[self->delegate onDownloadComplete:self];
		}

	}
	
	// release unused variable
	[self->dataload release];
	self->dataload = nil;
	[self->urlconnection release];
	self->urlconnection = nil;
    
    // decrease the counter
    [[RequestCounter instance]decrement:NSStringFromClass([self class])];
}

// Called when there has been an error on the connection.
- (void) connection:(NSURLConnection *)connection didFailWithError: (NSError *)error {
    
	[self->timeout invalidate];
	if(error != nil) 
	{	
		[self->delegate connectionError:self withError:error];
	}
	[self->urlconnection release];
	self->urlconnection = nil;

    [[RequestCounter instance]decrement:NSStringFromClass([self class])];
}

// Disables caching
- (NSCachedURLResponse*) connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
	return	nil;
}

#pragma mark Connection control
//The connection is finished so done the JSON data and send back to child class
-(void) onConnectionFinished:(NSData*)receivedData
{	
    if (self->statusCode != 200) {
        NSDictionary *error = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:self->statusCode], @"code", 
                               self->statusDescription, @"message", 
                               nil];
		if(self->errorList != nil)
		{
			[self->errorList release];
		}
		self->errorList = [[NSMutableArray alloc]init];
        [self->errorList addObject:[[[Error alloc] initWithElements:error] autorelease]];
    }
    else {
        NSString* stringData = [[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] autorelease];
        NSLog(@"Response Envelope = %@", stringData);
        
        // Create the parser instance.
        SBJsonParser* parser = [[[SBJsonParser alloc] init] autorelease];
        
        // Grab the elements.
        NSDictionary* elements = [parser objectWithString:stringData];
        
        NSArray* errors = [elements objectForKey:@"errors"];
        //send the json data back to child class
        if([errors count] == 0)
        {
            [self onReceivedJSON:elements];
        }
        else {
            if(self->errorList != nil)
            {
                [self->errorList release];
            }
            self->errorList = [[NSMutableArray alloc]init];
            
            for(NSDictionary* error in errors) {
                [self->errorList addObject:[[[Error alloc] initWithElements:error] autorelease]];
            }
            
        }
    }
}
// call when the timer has reach their limit for the specific timout value
-(void) onConnectionTimeout
{
    [[RequestCounter instance] decrement:NSStringFromClass([self class])];

	//cancel the connection so it can delete the urlconnection on connectionDidFinishLoading or didFailWithError
	[self->urlconnection cancel];
	//fire back to the view class to notify the timeout event
	[self->delegate connectionTimeout:self];
}
#pragma mark methods
// The view request the connection will goes here..
-(void) start
{
    if ([self.url rangeOfString:@"?"].length== 0)
    {
        self.url = [NSString stringWithFormat:@"%@?d=%@",self.url,[self getUUID]];
    }
    else
    {
        self.url = [NSString stringWithFormat:@"%@&d=%@",self.url,[self getUUID]];
    }
   
	//Check the reachability is ready or not
	if(isReachableDone)
	{
		//Start connection
		[self connectionBegin];
	}
	else 
	{
		//just wait until the reachabilityChecker send the message back
		isStartPending = YES;
	}
}

-(void) unBindDelegate
{
    self->delegate = nil;
}
-(void) stop
{	
	//Cancel all connection immediately. while the process need to be hault
	if([self isConnectionMade])
	{
        [[RequestCounter instance] decrement:NSStringFromClass([self class])];
		[self->urlconnection cancel];
		[self->urlconnection release];
		self->urlconnection = nil;
		[self->timeout invalidate];
		
	}
}
-(BOOL) isConnectionMade
{
	return self->urlconnection != nil;
}
// check if the reachability status 
-(BOOL) isReachable
{
    return [self->reachchecker isReachable];
}

- (NSData *)HTTPBody
{
    return  nil;
}

- (NSString *)HTTPMethod
{
    return @"GET";
}

- (NSString *)HTTPHeaderField 
{
    return @"Accept-Encoding";
}

- (NSString *)HTTPHeaderValue 
{
    return @"gzip, deflate";
}
-(void) connectionBegin
{
	//check the rechability before doing the connection
	if(![self->reachchecker isReachable])
	{
		//No Reachable push back to the view
		[self->delegate reachabilityFailed];
		return;
	}
	//get the plist for constant timeout interval time define
	
	if(self->timeout !=nil)
	{	
		[self->timeout invalidate];
		[self->timeout release];
        self->timeout = nil;
	}
	self->timeout = [NSTimer scheduledTimerWithTimeInterval:100
													 target:self
												   selector:@selector(onConnectionTimeout)
												   userInfo:nil
													repeats:NO];
	[self->timeout retain];

	// Initialize the payload
	if(self->dataload != nil)
	{
		[self->dataload release];
        self->dataload = nil;
	}
	self->dataload= [[NSMutableData alloc] init];
	NSLog(@"URL = %@", self.url);
	// Get the uri supplied.
	NSURL* destination = [NSURL URLWithString:self.url];
	// Build the request
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:destination];
	[request setHTTPMethod:[self HTTPMethod]];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[request setValue:[self HTTPHeaderValue] forHTTPHeaderField:[self HTTPHeaderField]]; 
    [request setHTTPBody:[self HTTPBody]];
	
	// Now make a connection
	if(self->urlconnection != nil)
	{
		[self->urlconnection release];
        self->urlconnection = nil;
	}
	self->urlconnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[self->urlconnection start];

    [[RequestCounter instance] increment:NSStringFromClass([self class])];
	// Clear up.
	[request release];
}

#pragma mark IReachableStatus Implementation

// Callback when the reachable is finish checking status
-(void) ReachablityDone
{	
	//set the reachiblity for done their job
	isReachableDone = YES;
	
	//Check if any of work is waiting
	if(isStartPending)
	{
		//Change the state back
		isStartPending = NO;
		//fire the connection
		[self connectionBegin];
	}
}


#pragma mark virtual Method
-(void) onReceivedJSON:(NSDictionary*)receivedData
{
	// For Child Class
}


@end
