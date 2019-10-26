//
//  GrapsControlView.m
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 2/5/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import "GrapsControlView.h"
#import "PlaceAnnotationView.h"
#import "PlaceAnnotation.h"
#import "GrapsManager.h"
#import "Graps.h"

@implementation GrapsControlView
@synthesize mapView,delegate,viewTouch,textView;
@synthesize grapManager,textLabel;
@synthesize loadingindicator;
NSString * const GMAP_ANNOTATION_SELECTED = @"gmapselected";

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}
-(void)dealloc
{
    self.mapView = nil;
    self.viewTouch = nil;
    self.textView = nil;
    self.grapManager = nil;
    self.textLabel = nil;
    self.loadingindicator = nil;
    [super dealloc];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch Moved");
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
    NSLog(@"Touch Ended");
    if(!self.viewTouch.hidden)
    {
    UITouch *myTouch = [touches anyObject]; 
    CGPoint location = [myTouch locationInView:self.viewTouch];
    
    CLLocationCoordinate2D coord= [self.mapView convertPoint:location toCoordinateFromView:self.mapView];
    NSLog(@"lat  %f",coord.latitude);
    NSLog(@"long %f",coord.longitude);
    
    if(self.delegate)
    {
        [self.delegate onGrapsAddedWithLat:coord.latitude andLong:coord.longitude];
    }
    //self.textView.hidden = YES;
    self.viewTouch.hidden = YES;
    }
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch Cancelled");
}
-(void)updateCenter:(double)lat withLon:(double)lon
{
    [self.grapManager updateRegion:CLLocationCoordinate2DMake(lat, lon)];
    [self.mapView setRegion:self.grapManager.mapRegion animated:TRUE];
}
-(void) setupMapContent:(GrapsManager*)grapsManager
{
    self.grapManager = grapsManager;
    [self.mapView setMapType:MKMapTypeStandard];
	self.mapView.showsUserLocation =YES;
	[self.mapView setRegion:self.grapManager.mapRegion animated:TRUE];
	[self.mapView regionThatFits:self.grapManager.mapRegion];
    
    [self.mapView addAnnotations:self.grapManager.mapAnnotations];
}
-(void)refreshAnnotations:(GrapsManager*)grapsManager
{
    self.grapManager = grapsManager;
    [self.mapView addAnnotations:self.grapManager.mapAnnotations];
}
-(PlaceAnnotation*)openCallout:(double)lat withLongitude:(double)lon
{
    for (PlaceAnnotation* place in self.grapManager.mapAnnotations ) 
    {
        if(place.graps.coordinate.latitude == lat && place.graps.coordinate.longitude == lon)
        {   
            return place;
        }
    }
    return nil;
}
-(PlaceAnnotation*)openCallout:(Graps*)grap
{
    for (PlaceAnnotation* place in self.grapManager.mapAnnotations ) 
    {
        if(place.graps.grapID == grap.grapID)
        {   
            return place;
        }
    }
    return nil;
}
// map Control

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
	if([annotation isKindOfClass:[PlaceAnnotation class]])
    {   
        static NSString* placeIdentifier = @"PlaceAnnotationIdentifier";
        PlaceAnnotation* anno = (PlaceAnnotation*) annotation;
        PlaceAnnotationView* pinView = (PlaceAnnotationView*) [self.mapView dequeueReusableAnnotationViewWithIdentifier:placeIdentifier];
        if(!pinView )
        {
            PlaceAnnotationView* customPinView = [[[PlaceAnnotationView alloc] initWithAnnotation:annotation withType:anno.graps.grapsType  reuseIdentifier:placeIdentifier] autorelease];
            
            
            return customPinView;
        }
        else {
            pinView.annotation = annotation;
            [pinView defineImage];
        }
        
        return pinView;
    }
    return nil;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([control tag] == 1) {
        
        // Left Accessory Button Tapped
       
        self.loadingindicator.hidden = NO;
        self.textView.hidden = NO;
        if(!self->routeRequest)
        {
            self->routeRequest = [[MapRouteRequest alloc]initWithOriginLocation:self.mapView.userLocation.coordinate withDestCoordinate:view.annotation.coordinate withCallback:self];
        }
        else 
        {
            [self->routeRequest updateOriginCoordinate:self.mapView.userLocation.coordinate withDestCoor:view.annotation.coordinate];
        }
        
    } else if ([control tag] == 2) {
        PlaceAnnotation* placeann = (PlaceAnnotation*) view.annotation;
        [self.delegate onGrapSelected:placeann.graps.grapID];
    
    }
    
  
}
-(void)updateGrapRoute:(Graps*)grap withCoordinate:(CLLocationCoordinate2D)coor
{
    self.loadingindicator.hidden = NO;
    if(!self->routeRequest)
    {
        self->routeRequest = [[MapRouteRequest alloc]initWithOriginLocation:coor withDestCoordinate:grap.coordinate withCallback:self];
    }
    else 
    {
        [self->routeRequest updateOriginCoordinate:coor withDestCoor:grap.coordinate];
    }
}
-(IBAction)onGeneratePlace:(id)sender
{
    if(!self->placeAroundRequest)
    {
        self->placeAroundRequest = [[PlaceAroundRequest alloc] initWithOriginLocation:self.mapView.userLocation.coordinate withCallback:self];
    }
    else {
        [self->placeAroundRequest start];
    }
}
-(void)moveToCurrentlocation
{
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if(!isMoveCurrent)
    {
        self->isMoveCurrent = YES;
        [self.delegate onCurrentLocationUpdate];
        [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
    }
    /// check if generate route or not
    /*
    if(!self->placeAroundRequest)
    {
        self->placeAroundRequest = [[PlaceAroundRequest alloc] initWithOriginLocation:self.mapView.userLocation.coordinate withCallback:self];
    }
     */
    
    if(self->routeRequest)
    {
        if([self->routeRequest isConnectionMade])
        {
            [self->routeRequest stop];
        }
        [self->routeRequest start];
    }
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    /*
    PlaceAnnotationView* placeView = (PlaceAnnotationView*) view;
    NSInteger index = [self.grapManager.mapAnnotations indexOfObject:placeView.annotation];
    Graps* result = (Graps*)[self.grapManager.grapsList objectAtIndex:index];
     */
}
#pragma mark IConnectionBase Handle
- (void) onDownloadComplete: (id) sender
{	
    if([sender isKindOfClass:[PlaceAroundRequest class]])
    {
        [self.delegate onPlaceFinished:self->placeAroundRequest.places];
    }
    else {
      	//check if there is any location detection, then the path is exist
        self.loadingindicator.hidden = YES;
        if(self->routeRequest.IsRoutedCompleted)
        {
            self.textLabel.text =  [NSString stringWithFormat:@"%@ %@",self->routeRequest.routeDistance,self->routeRequest.routeDuration];
            // create the route view when finish the route fetch from google
            //check if there is current location search,so no need to show the button.
            if(self->routeView != nil)
            {
                [self->routeView removeFromSuperview];
                [self->routeView  release];
            }
            self->routeView = [[RouteView alloc]initWithGeoList:self->routeRequest.decodeList mapView:self.mapView];
            [self.mapView addSubview:self->routeView];
        }
        else
        {
            self.textLabel.text = NSLocalizedStringWithDefaultValue(@"HotelMap_RouteFail", nil, [NSBundle mainBundle], @"cannot generate route", @"generate failed");
        }  
    }

}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
	//the region is finished change the offset , then redraw the route
	self->routeView.hidden = NO;
	[self->routeView setNeedsDisplay];
	//[self.mapView reloadInputViews];
}
// hide the route when map region has start change the offset
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
	// turn off the view of the route as the map is chaning regions. This prevents
	// the line from being displayed at an incorrect positoin on the map during the
	// transition.
	self->routeView.hidden = YES;
}
-(void) onDownloadFailed:(id)sender
{
     self.loadingindicator.hidden = YES;
	// the search API return some errors, so display the error.
    
    //[self logErrorMessage:self->routeRequest.errorMessage];
    //[self printGenericServerFailureMessage];
}
-(void) reachabilityFailed
{
     self.loadingindicator.hidden = YES;
	// the reachability is not complete, so display the message to the user.
	//[self printGenericConnectivityFailureMessage];
}

-(void) connectionTimeout:(id)sender
{
	// populate this event when timeout occurs 
	// restart the connection again..
	[self->routeRequest start];
}
-(void) connectionError:(id)sender withError:(NSError*)error
{
     self.loadingindicator.hidden = YES;
	// there is error from the URLConnection... display the problem
    //[self logError:error];
	//[self printGenericServerFailureMessage];
}


@end
