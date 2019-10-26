//
//  IEditGrapsHandler.h
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 4/30/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Graps;
@protocol IEditGrapsHandler <NSObject>
-(void)onEditGraps:(Graps*)grap;
@end
