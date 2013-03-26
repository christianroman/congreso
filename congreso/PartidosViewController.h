//
//  PartidosViewController.h
//  congreso
//
//  Created by Christian Roman on 24/03/13.
//  Copyright (c) 2013 Christian Roman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JSONRequest.h"
#import "MBProgressHUD.h"

@interface PartidosViewController : UIViewController <JSONRequest, MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    __weak IBOutlet UITableView *tableView;
    NSMutableArray *items;
    NSString *partySelected;
}

@end
