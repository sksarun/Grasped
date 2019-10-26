//
//  PlaceSearchCell.h
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 4/22/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Graps.h"

@interface PlaceSearchCell : UITableViewCell
@property (nonatomic,retain) IBOutlet UILabel* name;
@property (nonatomic,retain) IBOutlet UILabel* location;
-(void)setGraps:(Graps*)grap;
@end
