//
//  UIViewController+Extensions.h
//  Agoda.Consumer
//
//  Created by Tan, Michael (Agoda) on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIViewController (NIB)

- (id)getNibObjectFromNibName:(NSString *)nibName forKindOfClass:(id)kindOfClass;

@end

@interface UIViewController (UIViewController_AlertView)

- (void)printGenericServerFailureMessage;
- (void)printGenericConnectivityFailureMessage;
- (void)logError:(NSError *)error;
- (void)logErrorMessage:(NSString*)errorMsg;
-(void)printErrorMessage:(NSString*)errorMsg;
-(void)printError:(NSError *)error;
-(void)printReachabilityErrorMessage;

@end

@interface UIViewController (GoogleAnalytics)

- (NSString *)description;
- (void)viewDidLoad;

@end
