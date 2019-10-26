//
//  PlaceSearchRequest.h
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 4/22/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainBase.h"

@interface PlaceSearchRequest: MainBase
@property (nonatomic,retain) NSMutableArray* places;
@property (nonatomic,retain) NSString* searchText;

-(void)startWithSearchText:(NSString*)text;
@end
