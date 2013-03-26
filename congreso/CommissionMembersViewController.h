//
//  CommissionMembersViewController.h
//  congreso
//
//  Created by Christian Roman on 24/03/13.
//  Copyright (c) 2013 Christian Roman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "JSONRequest.h"

@interface CommissionMembersViewController : UITableViewController <JSONRequest, MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}

@property (nonatomic, assign) int commissionID;
@property (nonatomic, strong) NSMutableArray *members;

@end
