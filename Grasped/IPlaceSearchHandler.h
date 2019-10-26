//
//  IPlaceSearchHandler.h
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 4/22/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Graps.h"
@protocol IPlaceSearchHandler <NSObject>
-(void)onSearchGrapsAdded:(Graps*)grap;
@end
