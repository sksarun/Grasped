//
//  com_tong_graspedViewController.h
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 1/28/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <CoreLocation/CoreLocation.h>
#import "GrapsManager.h"
#import "GrapsControlView.h"
#import "IMapControlHandler.h"
#import "ICreateGrapsHandler.h"
#import "GrapsCell.h"
#import "Graps.h"
#import "IPlaceSearchHandler.h"
#import "IGrapDetailHandler.h"


@interface GrapsMainViewController : UIViewController<UIActionSheetDelegate,IManagerHandler,IMapControlHandler,ICreateGrapsHandler,IPlaceSearchHandler,IGrapDetailHandler>
{
    GrapsManager* grapsManager;
    
    BOOL isStreetViewRequest;
    BOOL isSelectRouteRequest;
}
@property (nonatomic,assign) IBOutlet GrapsCell* tempCell;
@property (nonatomic,retain) IBOutlet GrapsControlView* grapsView;
@property (nonatomic,retain) IBOutlet UIView* grapsListView;
@property (nonatomic,retain) IBOutlet UITableView* table;

@property (nonatomic,retain) Graps* tempGrap;
-(IBAction)switchToList:(id)sender;
-(IBAction)switchtoMap:(id)sender;
-(IBAction)preparedAdded:(id)sender;
-(IBAction)searchPlaces:(id)sender;
-(IBAction)streetView:(id)sender;

-(void)locationSearch;
@end
