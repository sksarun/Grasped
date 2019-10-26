//
//  GrapsManager.h
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 2/4/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Graps.h"
#import "PlaceAnnotation.h"
#import "SQLHandler.h"
#import "ISQLUpdate.h"
#import "IManagerHandler.h"
@interface GrapsManager : NSObject<ISQLUpdate>
{
    SQLHandler* sqlHandler;
    id<IManagerHandler> delegate;
}
@property (nonatomic,readonly) NSMutableArray* mapAnnotations;
@property (nonatomic,readonly) MKCoordinateRegion mapRegion;
@property (nonatomic,readonly) NSMutableArray* grapsList;
@property (nonatomic,readonly) NSMutableArray* placeAroundList;
@property (nonatomic,assign) id <IManagerHandler> delegate;
-( NSMutableArray*) grapListForSection:(int)section;
-(void)removeGrapAtIndexPath:(NSIndexPath*)indexPath;
-(id)initWithDelegate:(id<IManagerHandler>)refDelegate;
- (MKCoordinateSpan)coordinateSpanWithMapView:(MKMapView *)mapView
                             centerCoordinate:(CLLocationCoordinate2D)centerCoordinate
                                 andZoomLevel:(NSUInteger)zoomLevel;
-(void) loadTransSQL;
-(void) addGraps:(Graps*)grap;
-(void) commitGraps:(Graps*)graps;
-(void) updateGraps:(Graps*)graps;
-(NSIndexPath*)getGrapIndex:(int)grapID;
-(void) updateRegion:(CLLocationCoordinate2D)coor;
-(void) reloadAnnotation;
@end

