//
//  IMapControlHandler.h
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 2/5/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IMapControlHandler

-(void)onGrapsAddedWithLat:(double)lat andLong:(double)lon;
-(void)onGrapSelected:(int)grapID;
-(void)onPlaceFinished:(NSMutableArray*)places;
-(void)onCurrentLocationUpdate;
@end
