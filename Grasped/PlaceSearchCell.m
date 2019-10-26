//
//  PlaceSearchCell.m
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 4/22/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import "PlaceSearchCell.h"

@implementation PlaceSearchCell
@synthesize name,location;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setGraps:(Graps *)grap
{
    self.name.text = grap.grapsTitle;
    self.location.text = [NSString stringWithFormat:@"%f %f",grap.coordinate.latitude,grap.coordinate.longitude];
}

@end
