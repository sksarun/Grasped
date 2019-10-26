//
//  PlaceAnnotation.m
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 2/4/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import "PlaceAnnotation.h"

@implementation PlaceAnnotation
@synthesize graps,coordinate;

- (id) initWithGraps:(Graps*) grap
{
    self = [super init];
    if(self)
    {
        self->graps = [grap retain];
    }
    return self;
}
-(NSString*)title
{
    return self->graps.grapsTitle;
}
-(NSString*) subtitle
{
    return self->graps.grapsDesc;
}
-(CLLocationCoordinate2D) coordinate
{
    return self.graps.coordinate;
}
-(void) dealloc
{
    if(self->graps)
    {
        [self->graps release];
    }
    [super dealloc];
}
@end
