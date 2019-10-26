//
//  NSDate+Calculate.h
//  Agoda.Consumer
//
//  Created by Sarun Krishnalome on 27/1/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (datecalculate)

//calculate for different days for two NSDate given
-(NSInteger)dateSubstract:(NSDate*)subDate;

// get the specify future date from specific date
-(NSDate*) nextDate:(NSInteger)number;

// get the next year date from specific date
-(NSDate*) nextYearDate;

// get the next day date from specific date
-(NSDate*) nextDayDate;

// get the yesterday date from specific date
-(NSDate*) yesterdayDate;

@end
