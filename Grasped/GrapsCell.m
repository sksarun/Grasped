//
//  GrapsCell.m
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 2/10/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import "GrapsCell.h"

@implementation GrapsCell
@synthesize grapsPosLabel,grapsNameLabel,grapsTypeLabel,grapsIcon;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setGraps:(Graps*)grap
{
    self.grapsNameLabel.text = grap.grapsTitle;
    self.grapsTypeLabel.text = grap.grapsTypeString;
    self.grapsPosLabel.text = [NSString stringWithFormat:@"%.2f %.2f",grap.coordinate.latitude,grap.coordinate.longitude];
    self.grapsIcon.image = grap.grapImage;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)dealloc
{
    self.grapsIcon = nil;
    self.grapsNameLabel = nil;
    self.grapsPosLabel = nil;
    self.grapsTypeLabel = nil;
    [super dealloc];
}

@end
