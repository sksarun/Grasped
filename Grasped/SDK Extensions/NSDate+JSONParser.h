//
//  NSDate+JSONParser.h
//  YCS Allotment
//
//  Created by Peter Coleman on 11/13/10.
//  Copyright 2010 Agoda. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (JSONParser)

+ (NSDate*) initFromJsonString: (NSString*) jsonValue;

@end
