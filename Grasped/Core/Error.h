//
//  Error.h
//  Agoda.Consumer
//
//  Created by Sarun Krishnalome on 13/1/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Error result struct
 store error result back from server
 */
@interface Error : NSObject {
	@private
	//Error code ,eg =403
	NSInteger code;
	//Error message from server , eg = "Device not allow"
	NSString* message;
}

@property (readonly) NSInteger code;
@property (readonly) NSString* message;

-(id) initWithElements:(NSDictionary*)elements;
@end
