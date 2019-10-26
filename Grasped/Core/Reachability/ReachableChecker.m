//
//  ReachableChecker.m
//  BaseConnection
//
//  Created by Sarun Krishnalome on 10/1/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReachableChecker.h"


@implementation ReachableChecker
@synthesize isReachable;

#pragma mark initialize
-(id)initWithDelegate:(id<IConnectionBase>)callbackdelegate withReachableDelegate:(id<IReachableStatus>)reachdelegate
{
	self = [super init];
	
	if(self)
	{
		//Add the notification for update the reachability status change.
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
		//Always set the reachable to no
		self->isReachable = NO;
		self->delegate = callbackdelegate;
		reachabledelegate = reachdelegate;
		
		//Start init the reachbility constant for the connection check
		host =  [[Reachability reachabilityWithHostName: @"www.apple.com"] retain];
		[host startNotifier];
		internet= [[Reachability  reachabilityForInternetConnection]retain];
		[internet startNotifier];
		
		
	}
	return self;
}
-(void) dealloc
{
	[host release];
	[internet release];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

#pragma mark Reachability notice
// Callback method when any of the reachability status has been changed
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	//get the reachable result
	if([curReach currentReachabilityStatus] == NotReachable)
	{
		self->isReachable = NO;
		
	}
	else {
		self->isReachable = YES;
	}

	[self->reachabledelegate ReachablityDone];
}
@end
