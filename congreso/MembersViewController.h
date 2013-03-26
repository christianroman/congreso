//
//  MembersViewController.h
//  congreso
//
//  Created by Christian Roman on 18/03/13.
//  Copyright (c) 2013 Christian Roman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONRequest.h"
#import "MBProgressHUD.h"

@interface MembersViewController : UIViewController <JSONRequest, UISearchBarDelegate, UIScrollViewDelegate, MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    __weak IBOutlet UITableView *tableView;
    __weak IBOutlet UISearchBar *searchBar;
    __weak IBOutlet UISegmentedControl *segmentedControl;
    
    int typeSearch;
}

@property (nonatomic, strong) NSMutableArray *members;

- (IBAction)segmentedControlValueChanged:(id)sender;

@end

enum {
    TypeSearchAll = 0,
    TypeSearchType1 = 1,
    TypeSearchType2 = 2
} TypeSearch;