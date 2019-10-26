//
//  CreateGrapsViewController.m
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 2/6/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import "CreateGrapsViewController.h"

@implementation CreateGrapsViewController
@synthesize nameCell,descCell,latCell,lonCell,typeCell;
@synthesize nameTextField,descTextView,latTextField,lonTextField,typeLabel;
@synthesize delegate,table;

-(id)initWithNibName:(NSString *)nibNameOrNil withLat:(double)lat withLong:(double)lon withDelegate:(id<ICreateGrapsHandler>)refDelegate  bundle:(NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self->graps = [[Graps alloc] initWithTitle:@"" withType:EGeneralPlace withCoordinate:CLLocationCoordinate2DMake(lat, lon) withDesc:@"" withID:0];
        self.delegate = refDelegate;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if([self invalidCoordinate])
    {
        self.latTextField.enabled = YES;
        self.lonTextField.enabled = YES;
    }
    self.latTextField.text = [NSString stringWithFormat:@"%.4f",self->graps.coordinate.latitude];
     self.lonTextField.text = [NSString stringWithFormat:@"%.4f",self->graps.coordinate.longitude];
    self->typeLabel.text = self->graps.grapsTypeString;
    
     self.table.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"woodshelf.png"]];
    // Do any additional setup after loading the view from its nib.
}
-(BOOL) invalidCoordinate
{
    return self->graps.coordinate.latitude == 0 && self->graps.coordinate.longitude==0;    
}
-(IBAction)onCancelClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
-(IBAction)onDoneClicked:(id)sender
{
    if([self.nameTextField.text length] > 0 )
    {
        self->graps.grapsTitle = self.nameTextField.text;
        self->graps.grapsDesc = self.descTextView.text;
       if(self.delegate)
       {
           [self.delegate onCreateGrapsDone:self->graps];
       }
       [self dismissModalViewControllerAnimated:YES];
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
        self->graps.grapsType = buttonIndex;
        self->typeLabel.text = self->graps.grapsTypeString;
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
@end
