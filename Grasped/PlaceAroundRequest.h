//
//  PlaceAroundRequest.h
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 4/16/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainBase.h"
#import <CoreLocation/CoreLocation.h>

@interface PlaceAroundRequest : MainBase
@property (nonatomic,retain) NSMutableArray* places;
-(id) initWithOriginLocation:(CLLocationCoordinate2D)origin  withCallback:(id<IConnectionBase>)callback;

@end
