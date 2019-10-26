//
//  NSString+urlEncoded.m
//  Agoda.Consumer
//
//  Created by Sarun Krishnalome on 3/2/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSString+urlEncoded.h"


@implementation NSString (urlencode)

-(NSString *) urlEncoded
{
	CFStringRef urlString = CFURLCreateStringByAddingPercentEscapes(
																	NULL,
																	(CFStringRef)self,
																	NULL,
																	(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
																	kCFStringEncodingUTF8 );
    return [(NSString *)urlString autorelease];
}

@end
