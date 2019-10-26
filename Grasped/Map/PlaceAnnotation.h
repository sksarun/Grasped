//
//  PlaceAnnotation.h
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 2/4/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Graps.h"

@interface PlaceAnnotation : NSObject<MKAnnotation>

@property (nonatomic,readonly)Graps* graps;
@property (nonatomic,readonly)CLLocationCoordinate2D coordinate;

- (id) initWithGraps:(Graps*) grap;
@end
