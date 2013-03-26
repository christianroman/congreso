//
//  PartidosViewController.m
//  congreso
//
//  Created by Christian Roman on 24/03/13.
//  Copyright (c) 2013 Christian Roman. All rights reserved.
//

#import "PartidosViewController.h"
#import "GradientView.h"
#import "PartidoCell.h"
#import "ResultsMembersViewController.h"

#define UIColorFromRGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue&0xFF0000)>>16))/255.0 green:((float)((rgbValue&0xFF00)>>8))/255.0 blue:((float)(rgbValue&0xFF))/255.0 alpha:1.0]

@interface PartidosViewController ()

@end

@implementation PartidosViewController

- (NSString *)tabImageName
{
	return @"image-4";
}

- (NSString *)tabTitle
{
	return self.title;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = @"Partidos";
        
        items = [[NSMutableArray alloc] initWithObjects:@"PRI", @"PAN", @"PRD", @"PVEM", @"MC", @"PT", @"NA", nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tableView.separatorColor = UIColorFromRGB(0xd0d0d0);
    
    tableView.tableFooterView = [[UIView alloc] init];
    
    GradientView *gradient = [[GradientView alloc] initWithFrame:tableView.frame];
    tableView.backgroundView = gradient;
    
    /* Custom Back UIButton */
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"backButton"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 6)]
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"backButtonSelected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 6)]
                                                      forState:UIControlStateHighlighted
                                                    barMetrics:UIBarMetricsDefault];
    
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
    if (items && items.count)
        return items.count;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    PartidoCell *cell = (PartidoCell *) [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PartidoCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    UIImage *image = [UIImage imageNamed:@"cell"];
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:image];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:cell.frame];
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellSelected"]];
    cell.selectedBackgroundView = backgroundView;
    
    [cell.title setText:[items objectAtIndex:indexPath.row]];
    [cell.picture setImage:[UIImage imageNamed:[items objectAtIndex:indexPath.row]]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSONRequest *request = [[JSONRequest alloc] init];
    request.delegate = self;
    
    [self showHUD];
    
    [request getAllMembersWithParty:[items objectAtIndex:indexPath.row]];
    
    request = nil;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71.0f;
}

#pragma mark - ProgressHUD methods
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
    NSMutableArray *members = [[NSMutableArray alloc] init];
    
    members = objectResponse;
    
    if(![HUD isHidden])
        [self hideHUD];
    
    if([members count]){
        
        ResultsMembersViewController *resultsMembersViewController = [[ResultsMembersViewController alloc]initWithStyle:UITableViewStylePlain];
        [resultsMembersViewController setMembers:objectResponse];
        [self.navigationController pushViewController:resultsMembersViewController animated:YES];
        
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sin resultados" message:@"No se han encontrado representantes en tu ubicación actual." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)didNotReceiveJSONResponse:(NSError *)error
{    
    [self hideHUDWithError:@"Ha sucedido un error"];
    NSLog(@"Error peticion: %@", [error localizedDescription]);
}

@end
