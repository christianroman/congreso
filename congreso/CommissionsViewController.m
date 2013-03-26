//
//  CommissionsViewController.m
//  congreso
//
//  Created by Christian Roman on 24/03/13.
//  Copyright (c) 2013 Christian Roman. All rights reserved.
//

#import "CommissionsViewController.h"
#import "CommissionMembersViewController.h"
#import "CategoryCell.h"
#import "GradientView.h"
#import "Commission.h"
#import "JSONRequest.h"
#import <QuartzCore/QuartzCore.h>

#define UIColorFromRGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue&0xFF0000)>>16))/255.0 green:((float)((rgbValue&0xFF00)>>8))/255.0 blue:((float)(rgbValue&0xFF))/255.0 alpha:1.0]

@interface CommissionsViewController ()

@end

@implementation CommissionsViewController

@synthesize commissions;

- (NSString *)tabImageName
{
	return @"image-2";
}

- (NSString *)tabTitle
{
	return self.title;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        self.title = @"Comisiones";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setSeparatorColor:UIColorFromRGB(0xb6c0c8)];
    GradientView *gradient = [[GradientView alloc] initWithFrame:self.tableView.frame];
    self.tableView.backgroundView = gradient;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    if (!self.commissions)
        [self loadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.commissions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CategoryCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Commission *commission = [self.commissions objectAtIndex:[indexPath row]];
    
    [cell.title setText:commission.name];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Commission *commission = [self.commissions objectAtIndex:[indexPath row]];
    CommissionMembersViewController *commissionMembersViewController = [[CommissionMembersViewController alloc] initWithStyle:UITableViewStylePlain];
    [commissionMembersViewController setCommissionID:commission.ID];
    [self.navigationController pushViewController:commissionMembersViewController animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CAGradientLayer *selectedGrad = [CAGradientLayer layer];
    selectedGrad.frame = cell.bounds;
    selectedGrad.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(0xdfe2e3) CGColor], (id)[UIColorFromRGB(0xe1e4e5) CGColor], nil];
    
    [cell setSelectedBackgroundView:[[UIView alloc] init]];
    [cell.selectedBackgroundView.layer insertSublayer:selectedGrad atIndex:0];
}

#pragma mark - Methods
- (void)loadData
{
    self.commissions = [[NSMutableArray alloc] init];
    
    JSONRequest *request = [[JSONRequest alloc] init];
    request.delegate = self;
    
    [self showHUD];
    
    [request getAllCommissions];
    
    request = nil;
}

#pragma mark - ProgressHUD methods
- (void)reloadDataWithHUD:(BOOL)showHUD
{
    JSONRequest *request = [[JSONRequest alloc] init];
    request.delegate = self;
    
    if(showHUD)
        [self showHUD];
    
    [request getAllCommissions];
    
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
    self.commissions = objectResponse;
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
