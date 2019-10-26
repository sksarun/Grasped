//
//  StreetViewDisplayViewController.m
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 4/26/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import "StreetViewDisplayViewController.h"

@interface StreetViewDisplayViewController ()

@end

@implementation StreetViewDisplayViewController
@synthesize scrollView,streetImageView,streetImageView2,streetImageView3,streetImageView4,loadingView;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withOrigin:(CLLocationCoordinate2D)origin;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self->streetRequest = [[StreetViewRequest alloc] initWithOriginLocation:origin withCallback:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.contentSize = CGSizeMake(1280, 320);
    
    [NSTimer scheduledTimerWithTimeInterval:.50 target:self selector:@selector(startLoad) userInfo:nil repeats:NO];
    // Do any additional setup after loading the view from its nib.
}
-(void) startLoad
{
    [self->streetRequest startDownload];
}
- (void) onDownloadComplete: (id) sender
{
	self.streetImageView.image = self->streetRequest.image0;
    self.streetImageView2.image = self->streetRequest.image90;
    self.streetImageView3.image = self->streetRequest.image180;
    self.streetImageView4.image = self->streetRequest.image270;
    self.loadingView.hidden = YES;
}
-(IBAction)closeView:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];   
}
-(void) onDownloadFailed:(id)sender
{
    
}
/* Callback fired when the initial reachability (internet access) has failed.
 */
-(void) reachabilityFailed
{
    
}

/* Callback fired when the connection errors.
 - Param: sender, the object firing the call.
 */
-(void) connectionError:(id)sender withError:(NSError*)error
{
    
}

/* Callback fired when the connection times out.
 - Param: sender, the object firing the call.
 */ 
-(void) connectionTimeout:(id)sender
{
    
}
-(void)dealloc
{
    [self->streetRequest release];
    self.streetImageView = nil;
    self.streetImageView2 = nil;
    self.streetImageView3 = nil;
    self.streetImageView4 = nil;
    self.scrollView = nil;
    [super dealloc];
}
@end
