//
//  CommissionMembersViewController.m
//  congreso
//
//  Created by Christian Roman on 24/03/13.
//  Copyright (c) 2013 Christian Roman. All rights reserved.
//

#import "CommissionMembersViewController.h"
#import "GradientView.h"
#import "Member.h"
#import "MemberDetailViewController.h"
#import "AppCell.h"
#import "State.h"
#import "SVPullToRefresh.h"
#import "JSONRequest.h"
#import <QuartzCore/QuartzCore.h>


#define UIColorFromRGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue&0xFF0000)>>16))/255.0 green:((float)((rgbValue&0xFF00)>>8))/255.0 blue:((float)(rgbValue&0xFF))/255.0 alpha:1.0]

@interface CommissionMembersViewController ()

@end

@implementation CommissionMembersViewController

@synthesize commissionID;
@synthesize members;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorColor = UIColorFromRGB(0xd0d0d0);
    
    GradientView *gradient = [[GradientView alloc] initWithFrame:self.tableView.frame];
    self.tableView.backgroundView = gradient;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    /* Custom Back UIButton */
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"backButton"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 6)]
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"backButtonSelected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 6)]
                                                      forState:UIControlStateHighlighted
                                                    barMetrics:UIBarMetricsDefault];
    
    /* PullToRefresh control
    [self.tableView addPullToRefreshWithActionHandler:^{
        
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [self reloadDataWithHUD:NO];
            
        });
    }];
    
    self.tableView.pullToRefreshView.arrowColor = UIColorFromRGB(0x3d3328);
    self.tableView.pullToRefreshView.textColor = UIColorFromRGB(0x3d3328);
     */
    
    if (!self.members)
        [self loadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.members && self.members.count)
        return self.members.count;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    AppCell *cell = (AppCell *) [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AppCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    UIImage *image = [UIImage imageNamed:@"cell"];
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:image];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:cell.frame];
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellSelected"]];
    cell.selectedBackgroundView = backgroundView;
    
    Member *member = [self.members objectAtIndex:indexPath.row];
    
    [cell.name setText:member.name];
    
    if(member.state && member.state.name){
        [cell.state setText:member.state.name];
    } else {
        [cell.state setText:@"N/A"];
    }
    
    if(member.district){
        NSString *districtValue = [[member.district componentsSeparatedByString:@"-"] objectAtIndex:1];
        [cell.district setText:districtValue];
    } else {
        [cell.districtLabel setHidden:YES];
        [cell.district setHidden:YES];
    }
    
    [cell.party setImage:[UIImage imageNamed:member.party]];
    cell.picture.clipsToBounds = YES;
    
    if (member.uiimage != nil){
        [[cell picture] setImage: member.uiimage];
    } else {
        UIImage *placeHolder = [UIImage imageNamed:@"picturePreFrame"];
        [[cell picture] setImage:placeHolder];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(queue, ^{
            
            NSString *imageUrl = [NSString stringWithFormat:@"http://sil.gobernacion.gob.mx/Archivos/Fotos/%@.jpg", member.image];
            
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            UIImage *image = [UIImage imageWithData:imageData];
            member.uiimage = image;
            
            AppCell *theCell = (AppCell *)[_tableView cellForRowAtIndexPath:indexPath];
            
            if ([[_tableView visibleCells] containsObject: theCell]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[theCell picture] setImage:member.uiimage];
                    [theCell setNeedsLayout];
                });
            }
        });
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberDetailViewController *memberDetailViewController = [[MemberDetailViewController alloc] initWithNibName:NSStringFromClass([MemberDetailViewController class]) bundle:nil];
    [memberDetailViewController setMember:[members objectAtIndex:[indexPath row]]];
    [self.navigationController pushViewController:memberDetailViewController animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71.0f;
}

#pragma mark - Methods
- (void)loadData
{
    self.members = [[NSMutableArray alloc] init];
    
    JSONRequest *request = [[JSONRequest alloc] init];
    request.delegate = self;
    
    [self showHUD];
    
    [request getCommissionMembers:commissionID];
    
    request = nil;
}

#pragma mark - ProgressHUD methods
- (void)reloadDataWithHUD:(BOOL)showHUD
{
    JSONRequest *request = [[JSONRequest alloc] init];
    request.delegate = self;
    
    if(showHUD)
        [self showHUD];
    
    [request getCommissionMembers:commissionID];
    
    request = nil;
}

- (void)showHUD
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	HUD.delegate = self;
	HUD.labelText = @"Cargando...";
    HUD.minSize = CGSizeMake(135.f, 135.f);
    [HUD show:YES];
}

- (void)hideHUDWithError:(NSString *)error
{
	HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
	HUD.mode = MBProgressHUDModeCustomView;
	HUD.labelText = @"Error";
    HUD.detailsLabelText = error;
    
    [HUD hide:YES afterDelay:3];
}

- (void)hideHUD
{
    if(![HUD isHidden])
        [HUD hide:YES];
}

#pragma mark - MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
	[HUD removeFromSuperview];
	HUD = nil;
}

#pragma mark - JSONRequestDelegate
- (void)didReceiveJSONResponse:(id)objectResponse
{
    self.members = objectResponse;
    [self.tableView reloadData];
    
    if(![HUD isHidden])
        [self hideHUD];
}

- (void)didNotReceiveJSONResponse:(NSError *)error
{    
    [self hideHUDWithError:@"Ha sucedido un error"];
    NSLog(@"Error peticion: %@", [error localizedDescription]);
}

@end
