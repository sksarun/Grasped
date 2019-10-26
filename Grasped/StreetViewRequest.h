//
//  StreetViewRequest.h
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 4/26/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainBase.h"
#import <CoreLocation/CoreLocation.h>

@interface StreetViewRequest : MainBase
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,retain) UIImage* image0;
@property (nonatomic,retain) UIImage* image90;
@property (nonatomic,retain) UIImage* image180;
@property (nonatomic,retain) UIImage* image270;
-(id) initWithOriginLocation:(CLLocationCoordinate2D)origin  withCallback:(id<IConnectionBase>)callback;
-(void) startDownload;
@end
