//
//  MemberDetailViewController.m
//  congreso
//
//  Created by Christian Roman on 19/03/13.
//  Copyright (c) 2013 Christian Roman. All rights reserved.
//

#import "MemberDetailViewController.h"
#import "Member.h"
#import "State.h"

#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface MemberDetailViewController ()

@end

@implementation MemberDetailViewController

@synthesize member;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = (member.kind == 1) ? @"Diputado" : @"Senador";
    
    [picture setImage:member.uiimage];
    [nameLabel setText:member.name];
    [state setText:member.state.name];
    [substitute setText:member.substitute];
    [party setImage:[UIImage imageNamed:member.party]];
    
    if(member.kind == 1){
        
        if(member.district){
            
            NSString *districtValue = [[member.district componentsSeparatedByString:@"-"] objectAtIndex:1];
            [district setText:districtValue];
            
        }
        
        if(member.header){
            [header setText:member.header];
        } else {
            [substitute setFrame:CGRectMake(substitute.frame.origin.x, header.frame.origin.y, substitute.frame.size.width, substitute.frame.size.height)];
            
            [substituteLabel setFrame:CGRectMake(substituteLabel.frame.origin.x, header.frame.origin.y, substituteLabel.frame.size.width, substituteLabel.frame.size.height)];
            
            [headerLabel setHidden:YES];
            [header setHidden:YES];
        }
        
    } else {
        
        if(!member.state || !member.state.name){
            
            [substitute setFrame:CGRectMake(substitute.frame.origin.x, district.frame.origin.y, substitute.frame.size.width, substitute.frame.size.height)];
            
            [substituteLabel setFrame:CGRectMake(substituteLabel.frame.origin.x, district.frame.origin.y, substituteLabel.frame.size.width, substituteLabel.frame.size.height)];
            
            [state setText:@"N/A"];
            
        } else {
        
        [substitute setFrame:CGRectMake(substitute.frame.origin.x, district.frame.origin.y, substitute.frame.size.width, substitute.frame.size.height)];
        
        [substituteLabel setFrame:CGRectMake(substituteLabel.frame.origin.x, district.frame.origin.y, substituteLabel.frame.size.width, substituteLabel.frame.size.height)];
        
        }
        
        [district setHidden:YES];
        [header setHidden:YES];
        [districtLabel setHidden:YES];
        [headerLabel setHidden:YES];
        
        [party setFrame:CGRectMake(substituteLabel.frame.origin.x, 103, party.frame.size.width, party.frame.size.height)];
        
    }
    
    if(IS_WIDESCREEN){
        
        [bgHeader setFrame:CGRectMake(bgHeader.frame.origin.x, bgHeader.frame.origin.y, bgHeader.frame.size.width, 196)];
        [bgHeader setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgHeader-568h"]]];
        
        [pictureFrame setImage:[UIImage imageNamed:@"pictureFrame3"]];
        
        [pictureFrame setFrame:CGRectMake(pictureFrame.frame.origin.x, pictureFrame.frame.origin.y, pictureFrame.frame.size.width, 196)];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
