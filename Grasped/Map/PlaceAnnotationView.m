//
//  PlaceAnnotationView.m
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 2/4/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import "PlaceAnnotationView.h"
#import "PlaceAnnotation.h"

@implementation PlaceAnnotationView 
@synthesize observerRef;

- (id)initWithAnnotation:(id <MKAnnotation>)annotation withNotationImage:(UIImage*)pinImage  reuseIdentifier:(NSString *)reuseIdentifier
{
     self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGRect frame = self.frame;
        frame.size = CGSizeMake(48.0, 48.0);
        self.frame = frame;
        self.centerOffset = CGPointMake(-6.0, -10.0);
        self.canShowCallout = YES;
        if(pinImage!= nil)
        {
            self.image = pinImage;
            self.opaque = NO;
        }
    }
    return self;
}
-(id)initWithAnnotation:(id<MKAnnotation>)annotation  withType:(GrapsType)type reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self defineImage];
        CGRect frame = self.frame;
        frame.size = CGSizeMake(48.0, 48.0);
        self.frame = frame;
        self.contentMode = UIViewContentModeScaleToFill;
        self.canShowCallout = YES;
        UIButton* rightBt = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        rightBt.tag = 2;
        self.rightCalloutAccessoryView = rightBt;
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
         button.frame = CGRectMake(0, 0, 35, 35);
        button.tag = 1;
        [button setImage:[UIImage imageNamed:@"routemap.png"] forState:UIControlStateNormal];
        self.leftCalloutAccessoryView = button;
       
    }
    return self;
}
-(void)defineImage
{
    PlaceAnnotation* anno = (PlaceAnnotation*)self.annotation;
    self.image = anno.graps.grapImage;
    self.opaque = NO;
}
-(void)setObserverObject:(id)obj withContext:(NSString*)context
{   
    self.observerRef = obj;
    self->hasObserver = YES;
    [self addObserver:self.observerRef 
           forKeyPath:@"selected"
              options:NSKeyValueObservingOptionNew
              context:context];
}

-(void) dealloc
{
    if(self->hasObserver)
    {
        [self removeObserver:observerRef forKeyPath:@"selected"];
    }
    [super dealloc];
}
@end
