//
//  MapRouteRequest.m
//  Agoda.Consumer
//
//  Created by Sarun Krishnalome on 2/2/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapRouteRequest.h"
#import "NSString+urlEncoded.h"
#import "SystemSetting.h"

@implementation MapRouteRequest
@synthesize locationAnnotation,mapRegion,decodeList;
@synthesize routeDistance,routeDuration,IsRoutedCompleted,IsCurrentLocationRoute;

#pragma mark constuctor
-(id) initWithOriginLocation:(CLLocationCoordinate2D)origin  withDestCoordinate:(CLLocationCoordinate2D)dest  withCallback:(id<IConnectionBase>)callback
{
	self = [super initWithDelegate:callback];
	if(self)
	{	
        SystemSetting* config = [SystemSetting getSystemSetting ];
		self->IsRoutedCompleted = NO;
        self->IsCurrentLocationRoute = NO;
		//set Center for region
		self->mapRegion.center = self->hotelCoordinate;
		self->mapRegion.span.latitudeDelta = 0.1;
		self->mapRegion.span.longitudeDelta = 0.1;
		
		//create position array list
		self->decodeList = [[NSMutableArray alloc]init];
        self.url = [NSString stringWithFormat:config.routeURL,origin.latitude,origin.longitude,dest.latitude,dest.longitude];
		// start create position fetch from google api
        [self start];
        
	}
	return self;
}
#pragma mark update location

-(void) updateOriginCoordinate:(CLLocationCoordinate2D)_coordinate withDestCoor:(CLLocationCoordinate2D)_destCoor
{
    SystemSetting* config = [SystemSetting getSystemSetting ];
    self.url = [NSString stringWithFormat:config.routeURL,_coordinate.latitude,_coordinate.longitude,_destCoor.latitude,_destCoor.longitude];
    [self start];
}
#pragma mark decode googleapi point 
//calculate googlepoints to location in each point for creating the line
-(void)decodePolyLine: (NSMutableString *)encoded {
	// the method is convert data with 2base convertion
	[encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
								options:NSLiteralSearch
								  range:NSMakeRange(0, [encoded length])];
	NSInteger len = [encoded length];
	NSInteger index = 0;
	NSInteger lat=0;
	NSInteger lng=0;
	while (index < len) {
		NSInteger b;
		NSInteger shift = 0;
		NSInteger result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lat += dlat;
		shift = 0;
		result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lng += dlng;
		NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
		NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
		CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
		[self->decodeList addObject:loc];
		[loc release];
		[latitude release];
		[longitude release];
	}
}

#pragma mark override JSONhandle data from MainBase
-(void) onReceivedJSON:(NSDictionary*)receivedData
{
	//get the result array (JSON)
    
    if(![[receivedData objectForKey:@"status"] isEqualToString:@"ZERO_RESULTS"])
    {
        self->IsRoutedCompleted = YES; 
        NSArray* routeArray = [receivedData objectForKey:@"routes"];
        if([routeArray count]>0)
        {
            [self.decodeList removeAllObjects];
            NSDictionary* data = [routeArray objectAtIndex:0];
            NSDictionary* dataview = [data objectForKey:@"overview_polyline"];
            NSMutableString* lineString = [dataview objectForKey:@"points"];
            
            [self decodePolyLine:lineString];
            //CLLocation* loc =  (CLLocation*) [self.decodeList objectAtIndex:0];
            //self.locationAnnotation =  [[PlaceAnnotation alloc]initWithCoordinate:loc.coordinate];
            
            NSArray* legsArray = [data objectForKey:@"legs"];
            if([legsArray count]>0)
            {
                NSDictionary* distance = [[legsArray objectAtIndex:0] objectForKey:@"distance"];
                NSDictionary* duration = [[legsArray objectAtIndex:0] objectForKey:@"duration"];
                
                self.routeDistance = [distance objectForKey:@"text"];
                self.routeDuration = [duration objectForKey:@"text"];
            }
        }
    }
    else
    {
        self->IsRoutedCompleted = NO;
    }

}

#pragma mark memory management
-(void) dealloc
{
	[self->decodeList release];
	if(self->locationAnnotation != nil)
	{
		[self->locationAnnotation release];
	}
    [self.routeDistance release];
    [self.routeDuration release];
	[super stop];
	[super dealloc];
}
@end
