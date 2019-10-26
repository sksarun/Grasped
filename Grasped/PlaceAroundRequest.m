//
//  PlaceAroundRequest.m
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 4/16/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import "PlaceAroundRequest.h"
#import "SystemSetting.h"
#import "Graps.h"

@implementation PlaceAroundRequest
@synthesize places;
#pragma mark constuctor
-(id) initWithOriginLocation:(CLLocationCoordinate2D)origin    withCallback:(id<IConnectionBase>)callback
{
	self = [super initWithDelegate:callback];
	if(self)
	{	
        SystemSetting* config = [SystemSetting getSystemSetting ];
        
        self.url = [NSString stringWithFormat:config.placeURL,origin.latitude,origin.longitude];
		// start create position fetch from google api
        [self start];
        
	}
	return self;
}

#pragma mark override JSONhandle data from MainBase
-(void) onReceivedJSON:(NSDictionary*)receivedData
{
    if([[receivedData objectForKey:@"status"] isEqualToString:@"OK"])
    {
        self.places = [NSMutableArray array];
         NSArray* results = [receivedData objectForKey:@"results"];
        for(NSDictionary* result in results)
        {
            NSDictionary* location = [[result objectForKey:@"geometry"] objectForKey:@"location"];
            NSString* iconPath = [result objectForKey:@"icon"];
            NSString* name = [result objectForKey:@"name"];
            NSString* desc = [result objectForKey:@"vicinity"];
            
            double lat =      [[location objectForKey:@"lat"] doubleValue];
            double lon = [[location objectForKey:@"lng"] doubleValue];
            
            Graps* graps = [[Graps alloc] initWithTitle:name withType:EGeneralPlace withCoordinate:CLLocationCoordinate2DMake(lat, lon) withDesc:desc withID:999];
            
            [self.places addObject:graps];
            [graps release];
        }
    }
    
}

#pragma mark memory management
-(void) dealloc
{
	[super stop];
	[super dealloc];
}
@end
