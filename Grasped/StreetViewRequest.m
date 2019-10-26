//
//  StreetViewRequest.m
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 4/26/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import "StreetViewRequest.h"
#import "SystemSetting.h"
@implementation StreetViewRequest
@synthesize image0,image90,image180,image270,coordinate;
#pragma mark constuctor
-(id) initWithOriginLocation:(CLLocationCoordinate2D)origin    withCallback:(id<IConnectionBase>)callback
{
	self = [super initWithDelegate:callback];
	if(self)
	{	
        self.coordinate = origin;
         
		// start create position fetch from google api
        
	}
	return self;
}
-(void) startDownload
{
    SystemSetting* config = [SystemSetting getSystemSetting ];
    NSURL* imgurl = [NSURL URLWithString:[NSString stringWithFormat:config.streetViewURL,self.coordinate.latitude,self.coordinate.longitude,0]];
    self.image0 = [UIImage imageWithData:[NSData dataWithContentsOfURL:imgurl]];
    NSURL* imgurl90 = [NSURL URLWithString:[NSString stringWithFormat:config.streetViewURL,self.coordinate.latitude,self.coordinate.longitude,90]];
    self.image90 = [UIImage imageWithData:[NSData dataWithContentsOfURL:imgurl90]];
    NSURL* imgurl180 = [NSURL URLWithString:[NSString stringWithFormat:config.streetViewURL,self.coordinate.latitude,self.coordinate.longitude,180]];
    self.image180 = [UIImage imageWithData:[NSData dataWithContentsOfURL:imgurl180]];
    NSURL* imgurl270 = [NSURL URLWithString:[NSString stringWithFormat:config.streetViewURL,self.coordinate.latitude,self.coordinate.longitude,270]];
    self.image270 = [UIImage imageWithData:[NSData dataWithContentsOfURL:imgurl270]];
    [self.delegate onDownloadComplete:self];
}
#pragma mark override JSONhandle data from MainBase
-(void) onReceivedJSON:(NSDictionary*)receivedData
{

    
}

#pragma mark memory management
-(void) dealloc
{
    self.image0 = nil;
    self.image90 = nil;
    self.image180 = nil;
    self.image270 = nil;
	[super dealloc];
}
@end
