//
//  MainBase.h
//  BaseConnection
//
//  Created by Sarun Krishnalome on 10/1/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReachableChecker.h"
#import "IConnectionBase.h"
#import "IReachableStatus.h"

//Base class for every connection made
@interface MainBase : NSObject <IReachableStatus> {
	
	@private
	//Reachability checking
	ReachableChecker* reachchecker;
	NSString* url;
	//callback for the view class
	id<IConnectionBase>  delegate;
	
	//urlconnection instance
	NSMutableData* dataload;
	NSURLConnection*  urlconnection;
    NSInteger statusCode;
    NSString* statusDescription;
	NSTimer* timeout;
	
	//Reachable status
	BOOL isReachableDone;
	//Pending status for the connection 
	BOOL isStartPending;
	
	//Error list
	NSMutableArray* errorList;
	
}
@property (nonatomic, assign) id<IConnectionBase> delegate;
@property (nonatomic,copy) NSString* url;
@property (nonatomic,readonly) NSMutableArray* errorList;
@property (nonatomic,readonly) NSString* errorMessage;
@property (nonatomic, assign) NSInteger numberOfNetworkConnections;
@property (nonatomic, readonly) BOOL hasServerError;

-(id) initWithDelegate:(id<IConnectionBase>)callbackdelegate ;

/*
	return constant information for  the follwing information
	- ApiKeys
	- Device ID
	- Language ID
	- Version
 */
-(NSString*)getVersion;
-(NSString *)getUUID;

/*
	Handle method on URLconnection Callback
 */
-(void) onConnectionTimeout;
-(void) onConnectionFinished:(NSData*)receivedData;
-(void) onReceivedJSON:(NSDictionary*)receivedData;

//start method to execute URL connection
-(void) start;
-(void) stop;
-(void) unBindDelegate;
-(void) connectionBegin;

// Subclasses may override these
- (NSData *)HTTPBody;
- (NSString *)HTTPMethod;
- (NSString *)HTTPHeaderField;
- (NSString *)HTTPHeaderValue;

-(BOOL) isConnectionMade;
-(BOOL) isReachable;

@end
