//
//  CreateGrapsViewController.h
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 2/6/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Graps.h"
#import "ICreateGrapsHandler.h"

@interface CreateGrapsViewController : UIViewController<UIActionSheetDelegate,UIScrollViewDelegate>
{
    Graps* graps;
}

@property (nonatomic,retain) IBOutlet UITableViewCell* nameCell;
@property (nonatomic,retain) IBOutlet UITableViewCell* typeCell;
@property (nonatomic,retain) IBOutlet UITableViewCell* latCell;
@property (nonatomic,retain) IBOutlet UITableViewCell* lonCell;
@property (nonatomic,retain) IBOutlet UITableViewCell* descCell;
@property (nonatomic,assign) id<ICreateGrapsHandler> delegate;

@property (nonatomic,retain) IBOutlet UITextView* descTextView;
@property (nonatomic,retain) IBOutlet UITextField*  nameTextField;
@property (nonatomic,retain) IBOutlet UITextField* latTextField;
@property (nonatomic,retain) IBOutlet UITextField* lonTextField;
@property (nonatomic,retain) IBOutlet UILabel* typeLabel;
@property (nonatomic,retain) IBOutlet UITableView* table;

-(IBAction)onCancelClicked:(id)sender;
-(IBAction)onDoneClicked:(id)sender;

-(id)initWithNibName:(NSString *)nibNameOrNil withLat:(double)lat withLong:(double)lon withDelegate:(id<ICreateGrapsHandler>)refDelegate bundle:(NSBundle *)nibBundleOrNil ;

-(void) setViewMovedUp;
-(void) setViewBackUp;
-(BOOL) invalidCoordinate;
@end
