//
//  GrapsManager.m
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 2/4/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import "GrapsManager.h"
#import "EGODatabase.h"
#import  "Graps.h"

#define MERCATOR_OFFSET 268435456
#define MERCATOR_RADIUS 85445659.44705395

@implementation GrapsManager
@synthesize mapRegion,mapAnnotations,grapsList,delegate;
@synthesize placeAroundList;

-(id)initWithDelegate:(id<IManagerHandler>)refDelegate
{
    self = [super init];
    if (self) {
        
        self->sqlHandler = [[SQLHandler alloc]initWithDelegate:self];
        self.delegate = refDelegate;
		//Default for bangkok
		self->mapRegion.center.latitude = 13.7531;
		self->mapRegion.center.longitude = 100.715;
		self->mapRegion.span.latitudeDelta = 0.1;
		self->mapRegion.span.longitudeDelta = 0.1;
		
		
        self->grapsList = [[NSMutableArray alloc]init];   
        self->placeAroundList = [[NSMutableArray alloc]init];
        
        //create the annotation arrays
        self->mapAnnotations = [[NSMutableArray alloc]init];
    }
    return self;
}
-(void) updateRegion:(CLLocationCoordinate2D)coor
{
    self->mapRegion.center.latitude = coor.latitude;
    self->mapRegion.center.longitude = coor.longitude;
}
-(void) reloadAnnotation
{
    [self->mapAnnotations removeAllObjects];
    for(Graps* grap in self->grapsList)
    {
        [self->mapAnnotations addObject:[[[PlaceAnnotation alloc]initWithGraps:grap]autorelease]];
    }
    for(Graps* grap in self->placeAroundList)
    {
        [self->mapAnnotations addObject:[[[PlaceAnnotation alloc]initWithGraps:grap]autorelease]];
    }
}
-(void) loadTransSQL
{
    NSString* sql  = [NSString stringWithFormat:@"SELECT * from Graps"];
    
    [self->sqlHandler prepareSQL:sql withDB:@"Graps.DB"]; 
    [self->sqlHandler executeSQL];
    
}
-(NSIndexPath*)getGrapIndex:(int)grapID
{
    for(int i = 0 ; i < [self.grapsList count];i++)
    {
        Graps* grap = [self.grapsList objectAtIndex:i];
        if(grap.grapID == grapID)
        {
            return [NSIndexPath indexPathForRow:i inSection:0];
        }
    }
    return nil;
}
-(void)onSQLComplete:(NSDictionary*)info
{
    EGODatabaseResult* result = [info objectForKey:@"resultList"];
    [result retain];

    // add place object from result.
    for(EGODatabaseRow* row in result) 
    {   
        Graps* grap = [[Graps alloc] initWithTitle:[row stringForColumn:@"graps_title"] withType:[row intForColumn:@"graps_type_id"] withCoordinate:CLLocationCoordinate2DMake([row doubleForColumn:@"graps_latitude"],[row doubleForColumn:@"graps_longitude"]) withDesc:[row stringForColumn:@"graps_desc"] withID:[row intForColumn:@"Graps_id"]];
        [self->grapsList addObject:grap];
        [grap release];
    }
    [result release];
     
    for(Graps* grap in self->grapsList)
    {
        [self->mapAnnotations addObject:[[[PlaceAnnotation alloc]initWithGraps:grap]autorelease]];
    }
    [self.delegate onDataPreparedCompleted];

}
-(void) addGraps:(Graps*)grap
{
    [self->grapsList addObject:grap];
    [self->mapAnnotations addObject:[[[PlaceAnnotation alloc]initWithGraps:grap]autorelease]];
}
-(void) updateGraps:(Graps*)graps
{
    for(Graps* grap in self->grapsList)
    {
        if(grap.grapID == graps.grapID )
        {
            grap.grapsDesc = graps.grapsDesc;
            grap.grapsType = graps.grapsType;
            grap.grapsTitle = graps.grapsTitle;
            grap.coordinate = graps.coordinate;
        }
    }
}

-(void)removeGrapAtIndexPath:(NSIndexPath*)indexPath
{
  
    if(indexPath.section == 0)
    {
        Graps* grap = [self->grapsList objectAtIndex:indexPath.row];
        NSString* sql = [NSString stringWithFormat:@"DELETE FROM Graps where Graps_id =%d",grap.grapID];
        [self->grapsList removeObjectAtIndex:indexPath.row];
        [self->sqlHandler prepareSQL:sql withDB:@"Graps.DB"]; 
        [self->sqlHandler updateSQL];
       
    }
    else {
        [self->placeAroundList removeObjectAtIndex:indexPath.row];
        [self onSQLUpdateComplete];
    }
}
-(void) commitGraps:(Graps*)graps
{
    [self->grapsList addObject:graps];
    NSString* sql = [NSString stringWithFormat:@"INSERT into Graps(graps_type_id,graps_title,graps_latitude,graps_longitude,graps_desc) VALUES(%d,'%@',%f,%f,'%@');",graps.grapsType,graps.grapsTitle,graps.coordinate.latitude,graps.coordinate.longitude,graps.grapsDesc];
    [self->sqlHandler prepareSQL:sql withDB:@"Graps.DB"]; 
    [self->sqlHandler updateSQL];
}
-(void)onSQLUpdateComplete
{
    [self reloadAnnotation];
    [self.delegate onUpdateComplete];
}

#pragma mark -
#pragma mark Map conversion methods

- (double)longitudeToPixelSpaceX:(double)longitude
{
    return round(MERCATOR_OFFSET + MERCATOR_RADIUS * longitude * M_PI / 180.0);
}

- (double)latitudeToPixelSpaceY:(double)latitude
{
    return round(MERCATOR_OFFSET - MERCATOR_RADIUS * logf((1 + sinf(latitude * M_PI / 180.0)) / (1 - sinf(latitude * M_PI / 180.0))) / 2.0);
}
-( NSMutableArray*) grapListForSection:(int)section
{
    if(section ==0 )return self.grapsList;
    return self.placeAroundList;
}
- (double)pixelSpaceXToLongitude:(double)pixelX
{
    return ((round(pixelX) - MERCATOR_OFFSET) / MERCATOR_RADIUS) * 180.0 / M_PI;
}

- (double)pixelSpaceYToLatitude:(double)pixelY
{
    return (M_PI / 2.0 - 2.0 * atan(exp((round(pixelY) - MERCATOR_OFFSET) / MERCATOR_RADIUS))) * 180.0 / M_PI;
}

#pragma mark -
#pragma mark Helper methods

- (MKCoordinateSpan)coordinateSpanWithMapView:(MKMapView *)mapView
                             centerCoordinate:(CLLocationCoordinate2D)centerCoordinate
                                 andZoomLevel:(NSUInteger)zoomLevel
{
    // convert center coordiate to pixel space
    double centerPixelX = [self longitudeToPixelSpaceX:centerCoordinate.longitude];
    double centerPixelY = [self latitudeToPixelSpaceY:centerCoordinate.latitude];
    
    // determine the scale value from the zoom level
    NSInteger zoomExponent = 20 - zoomLevel;
    double zoomScale = pow(2, zoomExponent);
    
    // scale the map’s size in pixel space
    CGSize mapSizeInPixels = mapView.bounds.size;
    double scaledMapWidth = mapSizeInPixels.width * zoomScale;
    double scaledMapHeight = mapSizeInPixels.height * zoomScale;
    
    // figure out the position of the top-left pixel
    double topLeftPixelX = centerPixelX - (scaledMapWidth / 2);
    double topLeftPixelY = centerPixelY - (scaledMapHeight / 2);
    
    // find delta between left and right longitudes
    CLLocationDegrees minLng = [self pixelSpaceXToLongitude:topLeftPixelX];
    CLLocationDegrees maxLng = [self pixelSpaceXToLongitude:topLeftPixelX + scaledMapWidth];
    CLLocationDegrees longitudeDelta = maxLng - minLng;
    
    // find delta between top and bottom latitudes
    CLLocationDegrees minLat = [self pixelSpaceYToLatitude:topLeftPixelY];
    CLLocationDegrees maxLat = [self pixelSpaceYToLatitude:topLeftPixelY + scaledMapHeight];
    CLLocationDegrees latitudeDelta = -1 * (maxLat - minLat);
    
    // create and return the lat/lng span
    MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);
    return span;
}

@end
