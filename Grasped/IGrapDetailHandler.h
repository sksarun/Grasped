//
//  IGrapDetailHandler.h
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 4/24/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Graps;
@protocol IGrapDetailHandler <NSObject>

-(void)onLocationSelect:(double)lat wihtLong:(double)lon;
-(void)onCurrentRouteWithGrap:(Graps*)grap;
-(void)onSelectRouteGrap:(Graps*)grap;
-(void)onSelectMapRouteWithGraos:(Graps*)grap;
-(void)onGrapsEditFinish:(Graps*)grap;
@end
