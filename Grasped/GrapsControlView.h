//
//  GrapsControlView.h
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 2/5/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "IMapControlHandler.h"
#import "MapRouteRequest.h"
#import "PlaceAroundRequest.h"
#import "RouteView.h"
#import "Graps.h"
@class GrapsManager;
@class PlaceAnnotation;
@interface GrapsControlView : UIView<IConnectionBase>
{
    CGPoint tempPoint;
    MapRouteRequest* routeRequest;
    PlaceAroundRequest* placeAroundRequest;
	RouteView* routeView;
    
    BOOL isMoveCurrent;
}
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView* loadingindicator;
@property (nonatomic,retain) GrapsManager* grapManager;
@property (nonatomic,retain) IBOutlet MKMapView* mapView;
@property (nonatomic,retain) IBOutlet UIView* viewTouch;
@property (nonatomic,retain) IBOutlet UIView* textView;
@property (nonatomic,retain) IBOutlet UILabel* textLabel;
@property (nonatomic,assign) id<IMapControlHandler> delegate;
-(void) setupMapContent:(GrapsManager*)grapsManager;
-(void)refreshAnnotations:(GrapsManager*)grapsManager;
-(void)moveToCurrentlocation;
-(void)updateGrapRoute:(Graps*)grap withCoordinate:(CLLocationCoordinate2D)coor;
-(void)updateCenter:(double)lat withLon:(double)lon;

-(PlaceAnnotation*)openCallout:(Graps*)grap;
-(PlaceAnnotation*)openCallout:(double)lat withLongitude:(double)lon;
-(IBAction)onGeneratePlace:(id)sender;
@end
