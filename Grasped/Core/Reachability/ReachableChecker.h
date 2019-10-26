//
//  ReachableChecker.h
//  BaseConnection
//
//  Created by Sarun Krishnalome on 10/1/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "IConnectionBase.h"
#import "IReachableStatus.h"

@interface ReachableChecker : NSObject {

	//Reachability instance to check the status of internet connection 
	Reachability* host;
	Reachability* internet;
	
	//Callback to view class
	id<IConnectionBase> delegate;
	//Callback to the base class
	id<IReachableStatus> reachabledelegate;
	
	// Reachability status
	BOOL isReachable;
}
@property (nonatomic,readonly) BOOL isReachable;
-(id)initWithDelegate:(id<IConnectionBase>)callbackdelegate withReachableDelegate:(id<IReachableStatus>)reachdelegate;
-(BOOL) isReachable;
@end
