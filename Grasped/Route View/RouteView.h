//
//  RouteView.h
//  Agoda.Consumer
//
//  Created by Sarun Krishnalome on 2/2/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>

@interface RouteView : UIView {
	MKMapView* mapView;
	NSMutableArray* decodeList;
}
@property (nonatomic,retain) MKMapView* mapView;
@property (nonatomic,retain) NSMutableArray* decodeList;


-(id) initWithGeoList:(NSMutableArray*)list mapView:(MKMapView*)map;
@end
