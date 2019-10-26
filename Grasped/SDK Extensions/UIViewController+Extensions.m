//
//  UIViewController+Extensions.m
//  Agoda.Consumer
//
//  Created by Tan, Michael (Agoda) on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+Extensions.h"
#import "Agoda_ConsumerAppDelegate.h"
#import <objc/runtime.h>
#import "GANTracker.h"
#import "RegexKitLite.h"
#import "ConnectivityMessageBroker.h"

@implementation UIViewController (NIB)

- (id)getNibObjectFromNibName:(NSString *)nibName forKindOfClass:(id)kindOfClass {
    id nibObject = nil;
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@", kindOfClass];
    NSArray *filteredNibObjects = [nibObjects filteredArrayUsingPredicate:predicate];
    if (filteredNibObjects.count) {
        nibObject = [filteredNibObjects objectAtIndex:0];
    }
    else {
        NSAssert2(NO, @"Could not find %@ nib object in nib file :%@.", [kindOfClass description], nibName);
    }
    return nibObject;
}

@end

@implementation UIViewController (UIViewController_AlertView)

- (void)printGenericServerFailureMessage {
    [self printErrorMessage:NSLocalizedStringWithDefaultValue(@"Common_ErrorMessage_ServerFailure",
                                                              nil, [NSBundle mainBundle],
                                                              @"Server unavailable momentarily. Please wait a few seconds and try again.",
                                                              @"Generic server failure error message")];
}

- (void)printGenericConnectivityFailureMessage {
    [ConnectivityMessageBroker registerMessage];
}

- (void)logError:(NSError *)error {
    NSLog(@"Error: %@", [NSString stringWithFormat:@"%@ code:%d %@",[error domain],[error code],[error localizedDescription]]);    
}

- (void)logErrorMessage:(NSString*)errorMsg {
    NSLog(@"Error Message: %@", errorMsg);
}

-(void) printErrorMessage:(NSString*)errorMsg
{
    UIAlertView* alertview = [[UIAlertView alloc] initWithTitle:NSLocalizedStringWithDefaultValue(@"Common_Error", 
                                                                                                  nil, 
                                                                                                  [NSBundle mainBundle], 
                                                                                                  @"Error", 
                                                                                                  @"error text") 
                                                        message:errorMsg 
                                                       delegate:nil 
                                              cancelButtonTitle:NSLocalizedStringWithDefaultValue(@"Common_Ok", 
                                                                                                  nil, 
                                                                                                  [NSBundle mainBundle], 
                                                                                                  @"Ok", 
                                                                                                  @"Ok text")
                                              otherButtonTitles:nil];
	[alertview show];
	[alertview release];
}

-(void) printError:(NSError *)error
{
    UIAlertView* alertview = [[UIAlertView alloc] initWithTitle:NSLocalizedStringWithDefaultValue(@"Common_Error", 
                                                                                                  nil, 
                                                                                                  [NSBundle mainBundle], 
                                                                                                  @"Error", 
                                                                                                  @"error text") 
                                                        message:[NSString stringWithFormat:@"%@ code:%d %@",[error domain],[error code],[error localizedDescription]] 
                                                       delegate:nil 
                                              cancelButtonTitle:NSLocalizedStringWithDefaultValue(@"Common_Ok", 
                                                                                                  nil, 
                                                                                                  [NSBundle mainBundle], 
                                                                                                  @"Ok", 
                                                                                                  @"Ok text")
                                              otherButtonTitles:nil];
	[alertview show];
	[alertview release];
}

- (void)printReachabilityErrorMessage {
	// the reachability is not complete, so display the message to the user.
    [self printErrorMessage:NSLocalizedStringWithDefaultValue(@"Common_Error_Connection_Failed",
                                                              nil, [NSBundle mainBundle],
                                                              @"No Internet connection. Please check your connection and try again.",
                                                              @"error in connection")];
}

@end

@implementation UIViewController (GoogleAnalytics)

- (NSString *)description {
    // This assumes all View Controllers follow a strict naming convention with a postfix of ViewController
    // and uses capitalization for the first letter for each word.
    // Example: MyInitialViewController
    // This will set the description to "My Initial Page"
    NSString *className = [NSString stringWithCString:class_getName([self class]) encoding:NSUTF8StringEncoding];
    NSMutableString *pageName = [className mutableCopy];
    [pageName replaceOccurrencesOfString:@"ViewController" 
                              withString:@"" 
                                 options:NSLiteralSearch 
                                   range:NSMakeRange(0, [pageName length])];
    
    // Remove dependency on iOS SDK 4.0 NSRegularExpressionSearch by using RegexKitLite
    [pageName replaceOccurrencesOfRegex:@"[A-Z]"
                             withString:@" $0"
                                  range:NSMakeRange(1, [pageName length] - 1)];

//    [pageName replaceOccurrencesOfString:@"[A-Z]"
//                              withString:@" $0"
//                                 options:NSRegularExpressionSearch
//                                   range:NSMakeRange(1, [pageName length] - 1)];
    
    [pageName appendString:@" Page"];
    return [pageName autorelease];
}

- (void)viewDidLoad {
    if ([self isKindOfClass:[UIViewController class]]) {
        if ((![self isKindOfClass:[UITabBarController class]]) &&
            (![self isKindOfClass:[UINavigationController class]])) {
#if 1
            NSError *error;
            if (![[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"/%@", self]
                                                 withError:&error]) {
                NSLog(@"error in trackPageview");
                NSLog(@"%@", error);
            }
#else
            NSLog(@"%@", self);
#endif
        }
    }
}

@end
