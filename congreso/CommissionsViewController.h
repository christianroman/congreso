//
//  CommissionsViewController.h
//  congreso
//
//  Created by Christian Roman on 24/03/13.
//  Copyright (c) 2013 Christian Roman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JSONRequest.h"
#import "MBProgressHUD.h"

@interface CommissionsViewController : UITableViewController <JSONRequest, MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}

@property (nonatomic, strong) NSArray *commissions;

@end
