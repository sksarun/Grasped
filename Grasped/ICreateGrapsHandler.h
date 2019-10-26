//
//  ICreateGrapsHandler.h
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 2/9/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Graps.h"

@protocol ICreateGrapsHandler <NSObject>

-(void)onCreateGrapsDone:(Graps*)graps;
@end
