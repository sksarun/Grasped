//
//  Graps.m
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 2/4/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import "Graps.h"

@implementation Graps
@synthesize grapImage,grapID,grapsType,grapsTitle,coordinate,grapsDesc,grapsTypeString;

-(UIImage*)grapImage
{
    switch (self.grapsType) {
        case EResidencePlace:
            return   [UIImage imageNamed:@"home_marker.png"];
        case ERestaurantPlace:
            return  [UIImage imageNamed:@"food_marker.png"];
        case ESportPlace:
            return  [UIImage imageNamed:@"sport_marker.png"];
        case ESchoolPlace:
            return  [UIImage imageNamed:@"school_marker.png"];
        case EDepartmentPlace:
            return  [UIImage imageNamed:@"store_marker.png"];
        case EGovernmentPlace:
            return  [UIImage imageNamed:@"bank_marker.png"];
        case EWorkPlace:
            return  [UIImage imageNamed:@"work_marker.png"];
        case EBank:
            return  [UIImage imageNamed:@"bank_marker.png"];
        case EFuel:
            return  [UIImage imageNamed:@"gas_marker.png"];
        case EAirport:
            return  [UIImage imageNamed:@"airport_marker.png"];
        case EPark:
            return  [UIImage imageNamed:@"park_marker.png"];
        case EHospital:
            return  [UIImage imageNamed:@"hospital_marker.png"];
        case ECoffeeShop:
            return  [UIImage imageNamed:@"coffee_marker.png"];
        case EService:
            return  [UIImage imageNamed:@"service_marker.png"];
        case ETheater:
            return  [UIImage imageNamed:@"theater_marker.png"];
        case EFactory:
            return  [UIImage imageNamed:@"factory_marker.png"];
        case EDock:
            return  [UIImage imageNamed:@"dock_marker.png"];
        case EPub:
            return  [UIImage imageNamed:@"pub_marker.png"];
        case EFarm:
            return  [UIImage imageNamed:@"farm_marker.png"];
        case EMusuem:
            return  [UIImage imageNamed:@"museum.png"];
        case EStation:
            return [UIImage imageNamed:@"station_marker.png"];
        default:
            return  [UIImage imageNamed:@"default_marker.png"];  
            
    }
}
-(NSString*)grapsTypeString
{
    switch (self.grapsType) {
        case 0:
            return  @"General";
            break;
        case 1:
            return  @"Restaurant";
            break;
        case 2:
            return  @"Sport";
            break;
        case 3:
            return  @"Department Stored";
            break;
        case 4:
            return  @"Resident";
            break;
        case 5:
            return  @"School";
            break;
        case 6:
            return  @"Government";
            break;
        case 7:
            return  @"Work";
            break;
        case 8:
            return  @"Bank";
            break;
        case 9:
            return  @"Gas station";
            break;
        case 10:
            return  @"Airport";
            break;
        case 11:
            return  @"Park";
            break;
        case 12:
            return  @"Hospital";
            break;
        case 13:
            return  @"CoffeeShop";
            break;
        case 14:
            return  @"Service";
            break;
        case 15:
            return  @"Theater";
            break;
        case 16:
            return  @"Factory";
            break;
        case 17:
            return  @"Musuem";
            break;
        case 18:
            return  @"Dock";
            break;
        case 19:
            return  @"Pub";
            break;
        case 20:
            return  @"Farm";
            break;
        case 21:
            return  @"Station";
            break;
        default:
            break;
    }
}

-(id)initWithTitle:(NSString*)title withType:(GrapsType)type withCoordinate:(CLLocationCoordinate2D)location withDesc:(NSString *)desc  withID:(int)refGrapID 
{
    self = [super init];
    if(self)
    {
        self->grapID = refGrapID;
        self->grapsType = type;
        self->grapsTitle = [title retain];
        self->coordinate = location;
        self->grapsDesc = [desc retain];
    }
    return self;
}
-(void) dealloc
{
    if(self->grapsTitle)
    {
        [self->grapsTitle release];
    }
    if(self->grapsDesc)
    {
        [self->grapsDesc release];
        
    }
    [super dealloc];
}
@end
