//
//  Graps.h
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 2/4/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef enum grapsType {
	EGeneralPlace=0 , ERestaurantPlace,ESportPlace, EDepartmentPlace,  EResidencePlace,ESchoolPlace,EGovernmentPlace,EWorkPlace,EBank,EFuel,EAirport,EPark,EHospital,ECoffeeShop,EService,ETheater,EFactory,EMusuem,EDock,EPub,EFarm,EStation
} GrapsType;

@interface Graps : NSObject
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,assign) GrapsType grapsType;
@property (nonatomic,retain) NSString* grapsTitle;
@property (nonatomic,retain) NSString* grapsDesc;
@property (nonatomic,retain) NSString* grapsTypeString;
@property (nonatomic,assign) int grapID;
@property (nonatomic,readonly) UIImage* grapImage;

-(id)initWithTitle:(NSString*)title withType:(GrapsType)type withCoordinate:(CLLocationCoordinate2D)location withDesc:(NSString*)desc withID:(int)refGrapID;
@end
