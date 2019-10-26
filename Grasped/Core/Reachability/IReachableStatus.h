//
//  IReachableStatus.h
//  BaseConnection
//
//  Created by Sarun Krishnalome on 11/1/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 Protocol detect the rechable status and callback when it's ready
 */
@protocol IReachableStatus

/*
 Callback fired when the reachability is complete to check
 */
-(void) ReachablityDone;


@end
