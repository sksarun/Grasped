//
//  com_tong_graspedAppDelegate.m
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 1/28/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import "GrapsDelegate.h"

#import "GrapsMainViewController.h"

@implementation GrapsDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize navController,facebook;
- (void)dealloc
{
    [navController release];
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    self.facebook = [[Facebook alloc] initWithAppId:@"230332933737581" andDelegate:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }

    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[[GrapsMainViewController alloc] initWithNibName:@"GrapsMainViewController_iPhone" bundle:nil] autorelease];
    } else {
        self.viewController = [[[GrapsMainViewController alloc] initWithNibName:@"GrapsMainViewController_iPad" bundle:nil] autorelease];
    }
    self.navController = [[[UINavigationController alloc] initWithRootViewController:self.viewController] autorelease];
    self.navController .navigationBar.tintColor = [UIColor colorWithRed:46.0/255.0 green:74.0/255 blue:118.0/255.0 alpha:1.0];
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)FBRequest:(Graps*)grap
{
    
    if (![facebook isSessionValid]) {
        [facebook authorize:nil];
    }
    NSString* string = @"13.24";
    double lat = [string doubleValue];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"You friend send grasp to you",  @"message",
                                   [NSString stringWithFormat:@"%f",grap.coordinate.latitude],@"graplat",
                                   nil];
    
    [facebook dialog:@"apprequests"
           andParams:params
         andDelegate:self]; 

}
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


// For iOS 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [facebook handleOpenURL:url]; 
}

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
}
#pragma mark FBDialog Delegate
/**
 * Called when the dialog succeeds and is about to be dismissed.
 */
- (void)dialogDidComplete:(FBDialog *)dialog
{
    NSLog(@"Complete");
}

/**
 * Called when the dialog succeeds with a returning url.
 */
- (void)dialogCompleteWithUrl:(NSURL *)url
{
    NSLog(@"CompleteURL");
}

/**
 * Called when the dialog get canceled by the user.
 */
- (void)dialogDidNotCompleteWithUrl:(NSURL *)url
{
    NSLog(@"NotCompleteURL");
}

/**
 * Called when the dialog is cancelled and is about to be dismissed.
 */
- (void)dialogDidNotComplete:(FBDialog *)dialog
{
    NSLog(@"NotComplete");
}

/**
 * Called when dialog failed to load due to an error.
 */
- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error
{
    NSLog(@"Failed");
}
@end
