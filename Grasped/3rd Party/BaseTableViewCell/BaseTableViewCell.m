//
//  BaseTableViewCell.m
//  GiftDIY
//
//  Created by Tong on 1/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseTableViewCell.h"


@implementation BaseTableViewCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	
	self = [super initWithStyle:style reuseIdentifier:identifier];
    if (self) {
        // Initialization code.
		self.backgroundView = [[[UACellBackgroundView alloc] initWithFrame:CGRectZero] autorelease];
		
    }
    return self;
}

- (void)setPosition:(UACellBackgroundViewPosition)newPosition {	
	self.backgroundView = [[[UACellBackgroundView alloc] initWithFrame:CGRectZero] autorelease];
	[(UACellBackgroundView *)self.backgroundView setPosition:newPosition];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    [super dealloc];
}


@end
