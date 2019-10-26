//
//  com_tong_graspedViewController.m
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 1/28/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import "GrapsMainViewController.h"
#import "CreateGrapsViewController.h"
#import "Graps.h"
#import "BaseTableViewCell.h"
#import "PlaceSearchViewController.h"
#import "GrapsDetailViewController.h"
#import "StreetViewDisplayViewController.h"

@implementation GrapsMainViewController
@synthesize grapsView,grapsListView;
@synthesize  tempCell;
@synthesize table,tempGrap;

-(void)dealloc
{
    self.grapsView = nil;
    self.grapsListView = nil;
    self.tempGrap = nil;
    if(self->grapsManager)
    {
        [self->grapsManager release];
    }
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Graps";
    self->grapsManager = [[GrapsManager alloc] initWithDelegate:self];
    [self->grapsManager  loadTransSQL];
    
    self.grapsView.delegate = self;
    self.navigationController.navigationBar.tintColor = [UIColor brownColor];
    //self.table.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"woodshelf.png"]];
    
   
  
}
-(void)locationSearch
{
    [self.grapsView moveToCurrentlocation];
}
-(void)onGrapsAddedWithLat:(double)lat andLong:(double)lon
{
    if(isStreetViewRequest)
    {
        isStreetViewRequest = NO;
        
        StreetViewDisplayViewController* streetVC = [[StreetViewDisplayViewController alloc] initWithNibName:@"StreetViewDisplayViewController" bundle:nil withOrigin:CLLocationCoordinate2DMake(lat, lon)];
        [self presentModalViewController:streetVC animated:YES];
        [streetVC release]; 
        self.grapsView.viewTouch.hidden = YES;
        self.grapsView.textView.hidden = YES;
    }
    else if(isSelectRouteRequest)
    {
        [self.grapsView updateGrapRoute:self.tempGrap withCoordinate:CLLocationCoordinate2DMake(lat, lon)];
    }
    else {
        self.grapsView.viewTouch.hidden = YES;
        self.grapsView.textView.hidden = YES;
        CreateGrapsViewController* createVC = [[CreateGrapsViewController alloc] initWithNibName:@"CreateGrapsViewController" withLat:lat withLong:lon withDelegate:self  bundle:nil ];
        [self presentModalViewController:createVC animated:YES];
        [createVC release]; 
    }
  
}
-(void)onGrapSelected:(int)grapID
{
    [self switchToList:nil];
    [self.table selectRowAtIndexPath:[self->grapsManager getGrapIndex:grapID] animated:NO scrollPosition:UITableViewScrollPositionTop];
    
}
-(void)onPlaceFinished:(NSMutableArray*)places
{
    [self->grapsManager.placeAroundList removeAllObjects];
    [self->grapsManager.placeAroundList addObjectsFromArray:places];
    [self.grapsView.mapView removeAnnotations:grapsManager.mapAnnotations];
    [self->grapsManager reloadAnnotation];
    [self.grapsView refreshAnnotations:self->grapsManager];
    [self.table reloadData];
}
#pragma mark CreateGrapsHandler
-(void)onCreateGrapsDone:(Graps*)graps
{
    [self.grapsView.mapView removeAnnotations:grapsManager.mapAnnotations];
    [self->grapsManager commitGraps:graps];
}
-(IBAction)streetView:(id)sender
{
    self->isStreetViewRequest = YES;
    self.grapsView.viewTouch.hidden = NO;
    self.grapsView.textView.hidden = NO;
    self.grapsView.textLabel.text = @"please click on map to add street view";
}
-(IBAction)preparedAdded:(id)sender
{
   UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"Add Graps"
                                        delegate:self
                               cancelButtonTitle:@"Cancel"
                          destructiveButtonTitle:nil
                               otherButtonTitles:@"Current location", @"Select from map", @"insert coordinate", nil];
    
    // Show the sheet
    [sheet showInView:self.view];
    [sheet release];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        #if (TARGET_IPHONE_SIMULATOR)
          [self onGrapsAddedWithLat:13.744992 andLong:100.537176];
        #else
          [self onGrapsAddedWithLat:self.grapsView.mapView.userLocation.location.coordinate.latitude andLong:self.grapsView.mapView.userLocation.location.coordinate.longitude];
        #endif
       
    }
    else if(buttonIndex == 1)
    {
        self.grapsView.viewTouch.hidden = NO;
        self.grapsView.textView.hidden = NO;
         self.grapsView.textLabel.text = @"please click on map to add grap";
    }
    else if(buttonIndex == 2)
    {
        [self onGrapsAddedWithLat:0.0 andLong:0.0];
    }
}
-(IBAction)switchToList:(id)sender
{
    [self.table  reloadData];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView transitionFromView:self.grapsView  toView:self.grapsListView duration:1 options:UIViewAnimationOptionTransitionFlipFromLeft completion:NULL];
    [UIView commitAnimations]; 
    self.view = self.grapsListView;
    self.navigationItem.rightBarButtonItem = nil;
}
-(IBAction)switchtoMap:(id)sender
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView transitionFromView:self.grapsListView  toView:self.grapsView duration:1 options:UIViewAnimationOptionTransitionFlipFromRight completion:NULL];
    [UIView commitAnimations];  
    self.view = self.grapsView;
    [self onCurrentLocationUpdate];
}
-(IBAction)searchPlaces:(id)sender
{
    PlaceSearchViewController* place = [[PlaceSearchViewController alloc]initWithNibName:@"PlaceSearchViewController" withDelegate:self bundle:nil];
    [self presentModalViewController:place animated:YES];
    [place release];
}
-(void)onCurrentLocationUpdate
{
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                                                    initWithImage:[UIImage imageNamed:@"74-location.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(locationSearch)]autorelease ];
 
}
-(void)onDataPreparedCompleted
{
    [self.grapsView  setupMapContent:self->grapsManager];
}

-(void)onUpdateComplete
{
    [self.grapsView refreshAnnotations:self->grapsManager];
    [self.table reloadData];
}
-(void)onSearchGrapsAdded:(Graps*)grap
{
    [self.grapsView.mapView removeAnnotations:grapsManager.mapAnnotations];
    [self->grapsManager commitGraps:grap];
}
#pragma mark Detail delegate
-(void)onLocationSelect:(double)lat wihtLong:(double)lon
{
    self.view = self.grapsView;
    [self.grapsView updateCenter:lat withLon:lon];
    [self.grapsView.mapView selectAnnotation:[self.grapsView openCallout:lat withLongitude:lon] animated:NO];
}
-(void)onCurrentRouteWithGrap:(Graps*)grap
{
    [self.grapsView updateGrapRoute:grap withCoordinate:self.grapsView.mapView.userLocation.coordinate];
     self.grapsView.textView.hidden = NO;
    self.view = self.grapsView;
}
-(void)onSelectRouteGrap:(Graps*)grap
{
   self.view = self.grapsListView;
}
-(void)onGrapsEditFinish:(Graps*)grap
{
    [self->grapsManager updateGraps:grap];
    [self.grapsView.mapView removeAnnotations:grapsManager.mapAnnotations];
    [self onUpdateComplete];
}
-(void)onSelectMapRouteWithGraos:(Graps*)grap
{
    self->isSelectRouteRequest = YES;
    self.tempGrap = grap;
    self.grapsView.viewTouch.hidden = NO;
    self.grapsView.textView.hidden = NO;
    self.grapsView.textLabel.text = @"please click on map to route from";
    self.view = self.grapsView;
}
#pragma mark Table Delegate
//return the UITableViewCell for each row of the searchView component
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TransCellId";
	static NSString *CellNib = @"GrapsCell";
    
    GrapsCell* cell = (GrapsCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
		cell = self.tempCell;
		self.tempCell = nil;
	}
    Graps* graps = [[self->grapsManager grapListForSection:indexPath.section] objectAtIndex:indexPath.row];
    [cell setGraps:graps];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
 
    [cell setPosition:UACellBackgroundViewPositionMiddle];
    return cell;
}
// return the height of each tableviewCell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 70;
}
//return the section for the Searchview Table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	//we have 3 section for this view
	return 2;
}
-(NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0) return @"Graps";
    return @"PlaceAround";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[self->grapsManager grapListForSection:section] count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Graps* graps = [[self->grapsManager grapListForSection:indexPath.section] objectAtIndex:indexPath.row];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        GrapsDetailViewController* grapDetailVC = [[GrapsDetailViewController alloc] initWithNibName:@"GrapsDetailViewController" withGraps:graps withDelegate:self withEditable:indexPath.section==0 bundle:nil];
        [self.navigationController pushViewController:grapDetailVC animated:YES];
        [grapDetailVC release];
    } else {
        GrapsDetailViewController* grapDetailVC = [[GrapsDetailViewController alloc] initWithNibName:@"GrapsDetailViewController_iPad" withGraps:graps withDelegate:self withEditable:indexPath.section==0 bundle:nil];
        [self.navigationController pushViewController:grapDetailVC animated:YES];
        [grapDetailVC release];
    }
    
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete

        [self.grapsView.mapView removeAnnotations:grapsManager.mapAnnotations];
        [self->grapsManager removeGrapAtIndexPath:indexPath];
    }    
}

@end
