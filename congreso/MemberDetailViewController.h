//
//  MemberDetailViewController.h
//  congreso
//
//  Created by Christian Roman on 19/03/13.
//  Copyright (c) 2013 Christian Roman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Member;

@interface MemberDetailViewController : UIViewController
{
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *state;
    __weak IBOutlet UILabel *district;
    __weak IBOutlet UILabel *header;
    __weak IBOutlet UILabel *substitute;
    __weak IBOutlet UIImageView *party;
    
    __weak IBOutlet UILabel *stateLabel;
    __weak IBOutlet UILabel *districtLabel;
    __weak IBOutlet UILabel *headerLabel;
    __weak IBOutlet UILabel *substituteLabel;
    
    __weak IBOutlet UIImageView *picture;
    __weak IBOutlet UIImageView *bgHeader;
    __weak IBOutlet UIImageView *pictureFrame;
}

@property (nonatomic, strong) Member *member;

@end
