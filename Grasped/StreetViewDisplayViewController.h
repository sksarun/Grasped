//
//  StreetViewDisplayViewController.h
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 4/26/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StreetViewRequest.h"

@interface StreetViewDisplayViewController : UIViewController<IConnectionBase>
{
    StreetViewRequest* streetRequest;
}
@property (nonatomic,retain) IBOutlet UIImageView* streetImageView;
@property (nonatomic,retain) IBOutlet UIImageView* streetImageView2;
@property (nonatomic,retain) IBOutlet UIImageView* streetImageView3;
@property (nonatomic,retain) IBOutlet UIImageView* streetImageView4;
@property (nonatomic,retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic,retain) IBOutlet UIView* loadingView;
-(IBAction)closeView:(id)sender;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withOrigin:(CLLocationCoordinate2D)origin;
-(void)startLoad;
@end
