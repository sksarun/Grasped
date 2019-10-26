//
//  EditGrapsViewController.m
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 4/29/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import "EditGrapsViewController.h"

@interface EditGrapsViewController ()

@end

@implementation EditGrapsViewController
@synthesize currentGrap;
@synthesize nameCell,descCell,latCell,lonCell,typeCell;
@synthesize nameTextField,descTextView,latTextField,lonTextField,typeLabel;
@synthesize table,delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil withGrap:(Graps *)grap withDelegate:(id<IEditGrapsHandler>)refDelegate  bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.currentGrap = grap;
        self.delegate = refDelegate;
        self->sqlHandler = [[SQLHandler alloc]initWithDelegate:self];
    }
    return self;
}


-(void) dealloc
{
    self.currentGrap = nil;
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.latTextField.enabled = YES;
    self.lonTextField.enabled = YES;
   
    self.latTextField.text = [NSString stringWithFormat:@"%.4f",self.currentGrap.coordinate.latitude];
    self.lonTextField.text = [NSString stringWithFormat:@"%.4f",self.currentGrap.coordinate.longitude];
    self->typeLabel.text = self.currentGrap.grapsTypeString;
    self.nameTextField.text = self.currentGrap.grapsTitle;
    self.descTextView.text = self.currentGrap.grapsDesc;
    self.table.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"woodshelf.png"]];
    // Do any additional setup after loading the view from its nib.
}
-(BOOL) invalidCoordinate
{
    return self.currentGrap.coordinate.latitude == 0 && self.currentGrap.coordinate.longitude==0;    
}
-(IBAction)onCancelClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
-(IBAction)onDoneClicked:(id)sender
{
    if([self.nameTextField.text length] > 0 )
    {
        self.currentGrap.grapsTitle = self.nameTextField.text;
        self.currentGrap.grapsDesc = self.descTextView.text;
        self.currentGrap.coordinate = CLLocationCoordinate2DMake([self.latTextField.text doubleValue], [self.lonTextField.text doubleValue]);
        NSString* sql = [NSString stringWithFormat:@"UPDATE Graps SET graps_type_id = %d ,graps_title = '%@', graps_latitude = %f , graps_longitude = %f ,graps_desc ='%@'WHERE Graps_id = %d",self.currentGrap.grapsType,self.currentGrap.grapsTitle,self.currentGrap.coordinate.latitude,self.currentGrap.coordinate.longitude,self.currentGrap.grapsDesc,self.currentGrap.grapID] ;
        [self->sqlHandler prepareSQL:sql withDB:@"Graps.DB"]; 
        [self->sqlHandler updateSQL];
    }
}
#pragma mark TableView delegate

//return the UITableViewCell for each row of the searchView component
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch ([indexPath section]) {
		case 0:
            if([indexPath row]==0)
			{
				return self.nameCell;
			}
            else if([indexPath row]==1)
			{
				return	self.typeCell;
			}
			else if([indexPath row]==2)
			{
				return self.latCell;
			}
            else if([indexPath row] == 3)
            {
                return  self.lonCell;
            }
            else if([indexPath row] == 4)
            {
                return  self.descCell;
            }
            
		default:
			return nil;
	}
}
// return the height of each tableviewCell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row ==4 ) return 200;
	return 44;
}
//return the section for the Searchview Table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	//we have 3 section for this view
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 1 ) // type
    {
        //show type selection
        UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Choose type"
                                                                delegate:self cancelButtonTitle:@"Cancel"
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:@"General",@"Restaurant",@"Sport",@"Department Stored",@"Resident",@"School",@"Government",@"Work",@"Bank",@"Gas station",@"Airport",@"Park",@"Hospital",@"CoffeeShop",@"Service",@"Theater",@"Factory",@"Musuem",@"Dock",@"Pub",@"Farm",@"Station",nil];
        popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [popupQuery showInView:self.view];
        [popupQuery release];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	/*
	 sorting method call to business object
	 the sorting method depend on variable in 'HotelResult' Object
	 the list of sorting is shown here
	 */
    if(buttonIndex < 22)
    {
        self.currentGrap.grapsType = buttonIndex;
        self->typeLabel.text = self.currentGrap.grapsTypeString;
    }
}
-(void)setViewMovedUp
{	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5]; // if you want to slide up the view
	CGRect rect = self.view.frame;
	rect.origin.y -= 150;
	rect.size.height += 150;
	self.view.frame = rect;
	
	[UIView commitAnimations];
	
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        if([self.nameTextField isFirstResponder])
        {
            [self.nameTextField resignFirstResponder];
        }
        if([self.descTextView isFirstResponder])
        {
            [self.descTextView resignFirstResponder];
        }
    }
    [super touchesBegan:touches withEvent:event];
}
#pragma mark scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{	
    if([self.nameTextField isFirstResponder])
    {
        [self.nameTextField resignFirstResponder];
    }
    if([self.descTextView isFirstResponder])
    {
        [self.descTextView resignFirstResponder];
    }
}
#pragma mark view adjust
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self setViewMovedUp];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self setViewBackUp];
}
-(void)setViewBackUp
{
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5]; // if you want to slide up the view
	
    CGRect rect = self.view.frame;
	rect.origin.y += 150;
	rect.size.height -= 150;
	
    self.view.frame = rect;
    [UIView commitAnimations];
}    
#pragma mark sqlDelegate
-(void)onSQLComplete:(NSDictionary*)info
{
    
}
-(void)onSQLUpdateComplete
{
    if(self.delegate)
    {
        [self.delegate onEditGraps:self.currentGrap];
    }
    [self dismissModalViewControllerAnimated:YES];
}

@end
