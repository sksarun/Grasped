//
//  RequestCounter.h
//  Agoda.Consumer
//
//  Created by Coleman, Peter (Agoda) on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRequestChangedHandler.h"

// The request counter singleton class. Responsible for the count.
@interface RequestCounter : NSObject {
    
    @private
    NSMutableArray*     handlers;
    int                 count;
    NSMutableDictionary*       tasks;
    
}

// Gets a value indicating whether has the
@property (nonatomic, readonly) BOOL hasPending;

// Gets the instance.
+ (RequestCounter*)instance;

// Increments the request counter.
- (void) increment:(NSString*)className;

// Decrements the request counter.
- (void) decrement:(NSString*)className;

// Registers the delegate for notification.
- (void) registerForNotification: (id<IRequestChangedHandler>) delegate;

@end
