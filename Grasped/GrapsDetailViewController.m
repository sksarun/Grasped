//
//  GrapsDetailViewController.m
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 4/22/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import "GrapsDetailViewController.h"
#import "PlaceAnnotation.h"
#import <QuartzCore/QuartzCore.h>
#import "EditGrapsViewController.h"
#import "GrapsDelegate.h"
@interface GrapsDetailViewController ()

@end

@implementation GrapsDetailViewController
@synthesize currentGraps,editImage,editButton;
@synthesize nameLabel,descView,locationLabel,iconImageView,descLabel,typeLabel,mapView,delegate;
-(id)initWithNibName:(NSString *)nibNameOrNil withGraps:(Graps*)grap withDelegate:(id<IGrapDetailHandler>)refDelegate withEditable:(BOOL)editable bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.currentGraps = grap;
        self.delegate = refDelegate;
        self->isEditable = editable;
    }
    return self;
}
-(void)dealloc
{
    self.nameLabel = nil;
    self.iconImageView  = nil;
    self.typeLabel = nil;
    self.descLabel = nil;
    self.locationLabel = nil;
    self.currentGraps = nil;
    self.mapView = nil;
    [super dealloc];
}
-(void) setUpData
{
    self.nameLabel.text = self.currentGraps.grapsTitle;
    self.iconImageView.image = self.currentGraps.grapImage;
    self.typeLabel.text = self.currentGraps.grapsTypeString;
    if(self.currentGraps.grapsDesc != @"")
    {
        self.descLabel.text = self.currentGraps.grapsDesc;
    }
    else {
        self.descLabel.text = @"no description";
    }
    self.locationLabel.text = [NSString stringWithFormat:@"%f %f",self.currentGraps.coordinate.latitude,self.currentGraps.coordinate.longitude];
    MKCoordinateRegion region;
    region.center = self.currentGraps.coordinate;
    region.span.latitudeDelta = 0.02;
    region.span.longitudeDelta = 0.02;
    [self.mapView setRegion:region];
    
    PlaceAnnotation *annot = [[PlaceAnnotation alloc] initWithGraps:self.currentGraps];
    [self.mapView addAnnotation:annot];
    [annot release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Detail";
    
    self.descView.layer.masksToBounds = NO;
    self.descView.layer.cornerRadius = 8; // if you like rounded corners
    self.descView.layer.shadowOffset = CGSizeMake(5, 5);
    self.descView.layer.shadowRadius = 5;
    self.descView.layer.shadowOpacity = 0.8;
    self.descView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.descView.bounds].CGPath;
    
    // Do any additional setup after loading the view from its nib.
    [self setUpData];
    
    if(!self->isEditable)
    {
        self.editImage.alpha = 0.5;
        self.editButton.enabled = NO;
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        //current location
        [self.delegate onCurrentRouteWithGrap:self.currentGraps];
        
    }
    else if(buttonIndex == 1)
    {
        // select from map 
        [self.delegate onSelectMapRouteWithGraos:self.currentGraps];
    }    
        [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)onMapButtonClicked:(id)sender
{
    [self.delegate onLocationSelect:self.currentGraps.coordinate.latitude wihtLong:self.currentGraps.coordinate.longitude];
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)onRouteClick:(id)sender
{
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"Route from"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Current location", @"Select from map", nil];
    
    // Show the sheet
    [sheet showInView:self.view];
    [sheet release];
}
-(IBAction)onEditClick:(id)sender
{
    EditGrapsViewController* editVC = [[EditGrapsViewController alloc] initWithNibName:@"EditGrapsViewController" withGrap:self.currentGraps withDelegate:self  bundle:nil];
    [self presentModalViewController:editVC animated:YES];
    [editVC release];
}
-(IBAction)onMapClick:(id)sender
{
    [self.delegate onLocationSelect:self.currentGraps.coordinate.latitude wihtLong:self.currentGraps.coordinate.longitude];
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)onSharedClicked:(id)sender
{
    GrapsDelegate* grapDelegate = (GrapsDelegate*) [[UIApplication sharedApplication] delegate ];
    [grapDelegate FBRequest:self.currentGraps];
}
-(void)onEditGraps:(Graps*)grap
{
    self.currentGraps = grap;
    [self setUpData];
    [self.delegate onGrapsEditFinish:self.currentGraps];
}
@end
