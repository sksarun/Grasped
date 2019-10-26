//
//  PlaceSearchViewController.h
//  Grasped
//
//  Created by ศรัณย์ กฤษณะโลม on 4/22/55 BE.
//  Copyright (c) 2555 Agoda.co.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceSearchRequest.h"
#import "PlaceSearchCell.h"
#import "IPlaceSearchHandler.h"

@interface PlaceSearchViewController : UIViewController<UIScrollViewDelegate,UISearchBarDelegate,IConnectionBase>
{
    PlaceSearchRequest* placeSearchRequest;
}
@property (nonatomic, assign)IBOutlet PlaceSearchCell* placeSearchCell;
@property (nonatomic,retain) IBOutlet UITableView* table;
@property (nonatomic,retain) IBOutlet UISearchBar* searchBar;
@property (nonatomic,assign) id<IPlaceSearchHandler> delegate;
-(IBAction)onCloseBtClicked:(id)sender;
-(id)initWithNibName:(NSString *)nibNameOrNil withDelegate:(id<IPlaceSearchHandler>)refDelegate bundle:(NSBundle *)nibBundleOrNil;
@end
