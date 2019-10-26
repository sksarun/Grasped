//
//  Error.m
//  Agoda.Consumer
//
//  Created by Sarun Krishnalome on 13/1/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Error.h"


@implementation Error
@synthesize code,message;

#pragma mark contructor
//constuctor class , initial data for error element.
-(id) initWithElements:(NSDictionary*)elements
{
	self = [super init];
	if(self)
	{
		/*
		 error value assign
		 
		 {"code":403,"message":"Device not allowed"}
		 */
		self->code = [[elements objectForKey:@"code"] intValue];
		self->message = [elements objectForKey:@"message"];
		[self->message retain];
	}
	return self;
}

#pragma mark memory management
-(void) dealloc
{
	[message release];
	[super dealloc];
}
@end
