//
//  com_tong_graspedAppDelegate.h
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 1/28/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "Graps.h"

@class GrapsMainViewController;

@interface GrapsDelegate : UIResponder <UIApplicationDelegate,FBSessionDelegate,FBDialogDelegate>
{
    Facebook* facebook;
}
@property (nonatomic, retain) Facebook *facebook;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController* navController;
@property (strong, nonatomic) GrapsMainViewController *viewController;


-(void)FBRequest:(Graps*)grap;
@end
