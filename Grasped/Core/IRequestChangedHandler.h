//
//  IRequestChangedHandler.h
//  Agoda.Consumer
//
//  Created by Coleman, Peter (Agoda) on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


// The request counter changed handler.
@protocol IRequestChangedHandler <NSObject>

// Called when a request has changed.
- (void) onRequestChanged: (BOOL)requiresDisplay;

@end
