//
//  PlaceSearchViewController.m
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 4/22/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import "PlaceSearchViewController.h"
#import "Graps.h"

@interface PlaceSearchViewController ()

@end

@implementation PlaceSearchViewController
@synthesize placeSearchCell,table,searchBar,delegate;
-(id)initWithNibName:(NSString *)nibNameOrNil withDelegate:(id<IPlaceSearchHandler>)refDelegate bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self->placeSearchRequest = [[PlaceSearchRequest alloc] initWithDelegate:self];
        self.delegate = refDelegate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)onCloseBtClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString* wellFormText  = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [self->placeSearchRequest startWithSearchText:wellFormText];
}
#pragma mark scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{	
	//hide searchBar keyboard when user scrolling tableview
	if([self.searchBar isFirstResponder])
	{
		[self.searchBar resignFirstResponder];
	}
}
#pragma mark TableView delegate

//return the UITableViewCell for each row of the searchView component
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlaceCellId";
	static NSString *CellNib = @"PlaceSearchCell";
    
    PlaceSearchCell* cell = (PlaceSearchCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
		cell = self.placeSearchCell;
		self.placeSearchCell = nil;
	}
    
    Graps* grap = [self->placeSearchRequest.places objectAtIndex:indexPath.row];
    [cell setGraps:grap];
    return cell;
}
// return the height of each tableviewCell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    return [self->placeSearchRequest.places count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate onSearchGrapsAdded:(Graps*)[self->placeSearchRequest.places objectAtIndex:indexPath.row]];
    [self dismissModalViewControllerAnimated:YES];
}

- (void) onDownloadComplete: (id) sender
{	
    [self.table  reloadData];
}
-(void) onDownloadFailed:(id)sender
{
    //self.loadingindicator.hidden = YES;
	// the search API return some errors, so display the error.
    
    //[self logErrorMessage:self->routeRequest.errorMessage];
    //[self printGenericServerFailureMessage];
}
-(void) reachabilityFailed
{
    //self.loadingindicator.hidden = YES;
	// the reachability is not complete, so display the message to the user.
	//[self printGenericConnectivityFailureMessage];
}

-(void) connectionTimeout:(id)sender
{
	// populate this event when timeout occurs 
	// restart the connection again..
	[self->placeSearchRequest start];
}
-(void) connectionError:(id)sender withError:(NSError*)error
{
    //self.loadingindicator.hidden = YES;
	// there is error from the URLConnection... display the problem
    //[self logError:error];
	//[self printGenericServerFailureMessage];
}
@end
