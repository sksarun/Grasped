//
//  GrapsCell.h
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 2/10/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Graps.h"
#import "BaseTableViewCell.h"
@interface GrapsCell : BaseTableViewCell

@property (nonatomic,retain) IBOutlet UIImageView* grapsIcon;
@property (nonatomic,retain) IBOutlet UILabel* grapsNameLabel;
@property (nonatomic,retain) IBOutlet UILabel* grapsTypeLabel;
@property (nonatomic,retain) IBOutlet UILabel* grapsPosLabel;
-(void)setGraps:(Graps*)grap;
@end
