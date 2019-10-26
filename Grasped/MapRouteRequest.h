//
//  MapRouteRequest.h
//  Agoda.Consumer
//
//  Created by Sarun Krishnalome on 2/2/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainBase.h"
#import <CoreLocation/CoreLocation.h>
#import "PlaceAnnotation.h"

/*
 get the route from googlemap api for generating data 
 */
@interface MapRouteRequest : MainBase {
	
	//route contain list
	NSMutableArray* decodeList;
	//region for map data
	MKCoordinateRegion mapRegion;
	// select hotel annotation	// place for city, current location, and location given placemark
	PlaceAnnotation* locationAnnotation;
    
    //hotel coordinate
    CLLocationCoordinate2D hotelCoordinate ;
    
    NSString* routeDistance;
    NSString* routeDuration;
    
    BOOL IsRoutedCompleted;
    BOOL IsCurrentLocationRoute;
}
@property (nonatomic,readonly) NSMutableArray* decodeList;
@property (nonatomic,readonly) MKCoordinateRegion mapRegion;
@property (nonatomic,retain) PlaceAnnotation* locationAnnotation;
@property (nonatomic,copy)  NSString* routeDistance;
@property (nonatomic,copy)  NSString* routeDuration;
@property (readonly) BOOL IsRoutedCompleted;
@property (nonatomic,assign) BOOL IsCurrentLocationRoute;

-(void)decodePolyLine: (NSMutableString *)encoded;

-(id) initWithOriginLocation:(CLLocationCoordinate2D)origin withDestCoordinate:(CLLocationCoordinate2D)dest withCallback:(id<IConnectionBase>)callback;

-(void) updateOriginCoordinate:(CLLocationCoordinate2D)_coordinate withDestCoor:(CLLocationCoordinate2D)_destCoor;
@end
