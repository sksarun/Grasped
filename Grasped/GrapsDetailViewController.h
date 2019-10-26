//
//  GrapsDetailViewController.h
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 4/22/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Graps.h"
#import "IGrapDetailHandler.h"
#import "IEditGrapsHandler.h"

@interface GrapsDetailViewController : UIViewController<UIActionSheetDelegate,IEditGrapsHandler>
{
    BOOL isEditable;
}
@property (nonatomic,retain) Graps* currentGraps;
@property (nonatomic,retain)IBOutlet UILabel* nameLabel;
@property (nonatomic,retain)IBOutlet UILabel* locationLabel;
@property (nonatomic,retain)IBOutlet UIImageView* iconImageView;
@property (nonatomic,retain)IBOutlet UITextView* descLabel;
@property (nonatomic,retain)IBOutlet UILabel* typeLabel;
@property (nonatomic,retain)IBOutlet MKMapView* mapView;
@property (nonatomic,retain)IBOutlet UIView* descView;
@property (nonatomic,assign)id<IGrapDetailHandler> delegate; 

@property (nonatomic,retain)IBOutlet UIImageView* editImage;
@property (nonatomic,retain)IBOutlet UIButton* editButton;
-(id)initWithNibName:(NSString *)nibNameOrNil withGraps:(Graps*)grap withDelegate:(id<IGrapDetailHandler>)refDelegate withEditable:(BOOL)editable bundle:(NSBundle *)nibBundleOrNil;

-(void) setUpData;
-(IBAction)onRouteClick:(id)sender;
-(IBAction)onEditClick:(id)sender;
-(IBAction)onMapClick:(id)sender;
-(IBAction)onSharedClicked:(id)sender;
-(IBAction)onMapButtonClicked:(id)sender;
@end
