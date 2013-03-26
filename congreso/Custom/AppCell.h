//
//  AppCell.h
//  Top Apps
//
//  Created by Christian Roman on 17/12/12.
//  Copyright (c) 2012 Christian Roman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomView;

@interface AppCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UIImageView *picture;
@property (nonatomic, weak) IBOutlet UILabel *state;
@property (nonatomic, weak) IBOutlet UILabel *district;
@property (nonatomic, weak) IBOutlet UILabel *districtLabel;
@property (nonatomic, weak) IBOutlet UIImageView *party;

@end
