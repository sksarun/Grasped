//
//  PlaceAnnotationView.h
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 2/4/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Graps.h"

@interface PlaceAnnotationView : MKAnnotationView
{
    BOOL hasObserver;
    id observerRef;
    
}
@property (nonatomic,assign)  id observerRef;

-(id)initWithAnnotation:(id<MKAnnotation>)annotation  withType:(GrapsType)type reuseIdentifier:(NSString *)reuseIdentifier;
- (id)initWithAnnotation:(id <MKAnnotation>)annotation withNotationImage:(UIImage*)pinImage  reuseIdentifier:(NSString *)reuseIdentifier; 
-(void)setObserverObject:(id)obj withContext:(NSString*)context;
-(void) defineImage;
@end
