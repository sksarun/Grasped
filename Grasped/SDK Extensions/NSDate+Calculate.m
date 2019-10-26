//
//  NSDate+Calculate.m
//  Agoda.Consumer
//
//  Created by Sarun Krishnalome on 27/1/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDate+Calculate.h"


@implementation NSDate (datecalculate)

-(NSInteger)dateSubstract:(NSDate*)subDate {
	
	unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSCalendar* calendar = [NSCalendar currentCalendar];
	
	NSDateComponents* componentsarr = [calendar components:flags fromDate:self];
	NSDateComponents* componentsdep  = [calendar components:flags fromDate:subDate];
	
	//reset time to 0.00 before making the comparison.
	NSDate* datearr = [calendar dateFromComponents:componentsarr];
	NSDate* datedep = [calendar dateFromComponents:componentsdep];
	
	//create gregorian for compare
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	unsigned int unitFlags = NSDayCalendarUnit;
	NSDateComponents *components = [gregorian components:unitFlags
												fromDate:datearr
												  toDate:datedep options:0];
	int days = [components day];
	[gregorian release];
	return days;
}
// get the specify future date from specific date
-(NSDate*) nextDate:(NSInteger)number
{
    // now build a NSDate object for the next day
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *offsetComponents = [[[NSDateComponents alloc] init] autorelease];
    [offsetComponents setDay:number];
	
    return [gregorian dateByAddingComponents:offsetComponents toDate: self options:0];
}

-(NSDate*) nextYearDate
{
    // now build a NSDate object for the next day
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *offsetComponents = [[[NSDateComponents alloc] init] autorelease];
    [offsetComponents setYear:1];
	
    return [gregorian dateByAddingComponents:offsetComponents toDate: self options:0];
}

-(NSDate*) nextDayDate
{
    // now build a NSDate object for the next day
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *offsetComponents = [[[NSDateComponents alloc] init] autorelease];
    [offsetComponents setDay:1];
	
    return [gregorian dateByAddingComponents:offsetComponents toDate: self options:0];
}
-(NSDate*) yesterdayDate
{
    // now build a NSDate object for the next day
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *offsetComponents = [[[NSDateComponents alloc] init] autorelease];
    [offsetComponents setDay:-1];
	
    return [gregorian dateByAddingComponents:offsetComponents toDate: self options:0];
}
@end
