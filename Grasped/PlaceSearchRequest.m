//
//  PlaceSearchRequest.m
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 4/22/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import "PlaceSearchRequest.h"
#import "SystemSetting.h"
#import "Graps.h"

@implementation PlaceSearchRequest
@synthesize places,searchText;
-(void)dealloc
{
    self.places = nil;
    [super dealloc];
}

-(void)startWithSearchText:(NSString*)text
{
  if([self isConnectionMade])
  {
      [self stop];
  }
SystemSetting* config = [SystemSetting getSystemSetting ];
self.url = [NSString stringWithFormat:config.placeSearchURL,text];
 [self start];
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
            // NSString* iconPath = [result objectForKey:@"icon"];
            NSString* name = [result objectForKey:@"formatted_address"];
            NSString* desc = @"desc";
            
            double lat =      [[location objectForKey:@"lat"] doubleValue];
            double lon = [[location objectForKey:@"lng"] doubleValue];
            
            Graps* graps = [[Graps alloc] initWithTitle:name withType:EGeneralPlace withCoordinate:CLLocationCoordinate2DMake(lat, lon) withDesc:desc withID:999];
            
            [self.places addObject:graps];
            [graps release];
        }
    }
    
}
@end
