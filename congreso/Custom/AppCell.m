//
//  AppCell.m
//  Top Apps
//
//  Created by Christian Roman on 17/12/12.
//  Copyright (c) 2012 Christian Roman. All rights reserved.
//

#import "AppCell.h"

@implementation AppCell

@synthesize name;
@synthesize picture;
@synthesize state;
@synthesize district;
@synthesize districtLabel;
@synthesize party;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
