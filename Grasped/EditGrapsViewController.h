//
//  EditGrapsViewController.h
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 4/29/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Graps.h"
#import "IEditGrapsHandler.h"
#import "SQLHandler.h"
#import "ISQLUpdate.h"

@interface EditGrapsViewController : UIViewController<UIActionSheetDelegate,ISQLUpdate>
{
    SQLHandler* sqlHandler;
}
-(id)initWithNibName:(NSString *)nibNameOrNil withGrap:(Graps*)grap withDelegate:(id<IEditGrapsHandler>)refDelegate bundle:(NSBundle *)nibBundleOrNil;
@property (nonatomic,retain)Graps* currentGrap;
@property (nonatomic,assign) id<IEditGrapsHandler> delegate;
@property (nonatomic,retain) IBOutlet UITableViewCell* nameCell;
@property (nonatomic,retain) IBOutlet UITableViewCell* typeCell;
@property (nonatomic,retain) IBOutlet UITableViewCell* latCell;
@property (nonatomic,retain) IBOutlet UITableViewCell* lonCell;
@property (nonatomic,retain) IBOutlet UITableViewCell* descCell;

@property (nonatomic,retain) IBOutlet UITextView* descTextView;
@property (nonatomic,retain) IBOutlet UITextField*  nameTextField;
@property (nonatomic,retain) IBOutlet UITextField* latTextField;
@property (nonatomic,retain) IBOutlet UITextField* lonTextField;
@property (nonatomic,retain) IBOutlet UILabel* typeLabel;
@property (nonatomic,retain) IBOutlet UITableView* table;

-(IBAction)onCancelClicked:(id)sender;
-(IBAction)onDoneClicked:(id)sender;

-(void) setViewMovedUp;
-(void) setViewBackUp;
-(BOOL) invalidCoordinate;
@end
