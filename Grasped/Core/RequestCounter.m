//
//  RequestCounter.m
//  Agoda.Consumer
//
//  Created by Coleman, Peter (Agoda) on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RequestCounter.h"

@interface RequestCounter (Private) 

// Fires the delegates
- (void)fireAll;

@end

@implementation RequestCounter

#pragma mark Static Members

// The instance.
static RequestCounter* instance;

#pragma mark Static Methods
    
// Gets the instance.
+ (RequestCounter*)instance {
    @synchronized(self) {
        if(instance == nil) {
            
            // Initialize the instance.
            instance = [[RequestCounter alloc] init];
        }
    }
    
    // Returns the request counter instance.
    return instance;
}

#pragma mark Constructor

// Initializes a new instance of the RequestCounter class.
- (id)init {
    self = [super init];
    
    if(self) {
        self->handlers = [[NSMutableArray alloc] init];
        self->tasks = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

#pragma mark Properties

// Gets a value indicating whether the request counter has pending requests or not.
- (BOOL) hasPending {
    BOOL pending = NO;
    
    @synchronized(self) {
        pending = self->count > 0;
    }
    
    return pending;
}

#pragma mark Methods

// Increments the count.
- (void) increment:(NSString*)className {
    
    @synchronized(self) {
        [self->tasks setObject:@"Task" forKey:className];
        self->count++;
    }
    
    // Send off the message
    [self fireAll];
}

// Decrements the count.
- (void) decrement:(NSString*)className {
    
    @synchronized(self) {
        [self->tasks removeObjectForKey:className];
        if (self->count > 0) {
            self->count--;
        }
    }
    
    // Fire it all.
    [self fireAll];
}

// Registers a delegate for notification.
- (void)registerForNotification:(id<IRequestChangedHandler>)delegate {
    if(![self->handlers containsObject:delegate]) {
        [self->handlers addObject:delegate];
    }
}

@end

@implementation RequestCounter (Private) 

// Fires all the registered delegates.
- (void)fireAll {
    
    // Loop round
    for (id<IRequestChangedHandler> delegate in self->handlers) {
        [delegate onRequestChanged: self.hasPending];
    }
}

@end
