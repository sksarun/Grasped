//
//  NSDate+JSONParser.m
//  YCS Allotment
//
//  Created by Peter Coleman on 11/13/10.
//  Copyright 2010 Agoda. All rights reserved.
//

#import "NSDate+JSONParser.h"


@implementation NSDate (JSONParser)

/* Initializes a new NSDate instance */
+ (NSDate*) initFromJsonString:(NSString *)jsonValue {
		
	int seconds = 0;
	
	// Then grab the stuff out of the json value.
	// Replace the /Date(
	jsonValue = [jsonValue stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
	
	// Replace the )
	jsonValue = [jsonValue substringToIndex: [jsonValue length] -2];
	
	// Now find the time zone...
	NSRange range = [jsonValue rangeOfString:@"-"];
	
	if(range.length == 0) {
		range = [jsonValue rangeOfString:@"+"];	
	}
	
	if(range.length > 0) {
		NSString* localeIncrease = [jsonValue substringFromIndex:range.location];
		jsonValue = [jsonValue substringToIndex:range.location];
		
		// Parse it..
		int modifier = [localeIncrease characterAtIndex:0] == '+' ? 1 : 0;
		int value = 0;
		
		// Now get the other items.
		for(int i = 1; i < [localeIncrease length]; i++) {
			
			value = [[localeIncrease substringWithRange:NSMakeRange(i,1)] intValue];
			
			switch (i) {
				case 1:
					value = value * 10 * 60 * 60;
					break;
				case 2:					
					value = value * 60 * 60;
					break;
				case 3:
					value = value * 10 * 60;
					break;
				case 4:
					value = value * 60;
					break;
			}
			
			seconds += value;			
		}
		
		seconds *= modifier;		
	}
	
	// Turn that into seconds from 1970
	unsigned long long milliseconds = [jsonValue longLongValue];
	milliseconds = milliseconds / 1000;
	milliseconds += seconds;
	
	// Return this.
	return [NSDate dateWithTimeIntervalSince1970:milliseconds];
}

@end
