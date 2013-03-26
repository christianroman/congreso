//
//  MembersViewController.m
//  congreso
//
//  Created by Christian Roman on 18/03/13.
//  Copyright (c) 2013 Christian Roman. All rights reserved.
//

#import "MembersViewController.h"
#import "MemberDetailViewController.h"
#import "AppCell.h"
#import "GradientView.h"
#import "Member.h"
#import "State.h"
#import "SVPullToRefresh.h"
#import "JSONRequest.h"
#import <QuartzCore/QuartzCore.h>

#define UIColorFromRGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue&0xFF0000)>>16))/255.0 green:((float)((rgbValue&0xFF00)>>8))/255.0 blue:((float)(rgbValue&0xFF))/255.0 alpha:1.0]

@interface MembersViewController ()

@end

@implementation MembersViewController

@synthesize members;

- (NSString *)tabImageName
{
	return @"image-1";
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
        self.title = @"Legisladores";
        
        typeSearch = TypeSearchType2;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tableView.separatorColor = UIColorFromRGB(0xd0d0d0);
    
    GradientView *gradient = [[GradientView alloc] initWithFrame:tableView.frame];
    tableView.backgroundView = gradient;
    
    tableView.tableFooterView = [[UIView alloc] init];
    //[tableView setSeparatorColor:UIColorFromRGB(0xb6c0c8)];
    
    /* Custom Back UIButton */
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"backButton"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 6)]
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"backButtonSelected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 6)]
                                                      forState:UIControlStateHighlighted
                                                    barMetrics:UIBarMetricsDefault];
    
    //[[UISearchBar appearance] setBackgroundImage:[UIImage imageNamed:@"searchBar_bg"]];
    //[[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchBar"]forState:UIControlStateNormal];
    
    /*============================= Segmented Control customize ===============================*/
    
    CGRect rect = segmentedControl.frame;
    [segmentedControl setFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 31.0f)];
    
    /* Unselected background */
    UIImage *unselectedBackgroundImage = [[UIImage imageNamed:@"segmentedNonSelected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    [[UISegmentedControl appearance] setBackgroundImage:unselectedBackgroundImage
                                               forState:UIControlStateNormal
                                             barMetrics:UIBarMetricsDefault];
    
    /* Selected background */
    UIImage *selectedBackgroundImage = [[UIImage imageNamed:@"segmentedSelected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    [[UISegmentedControl appearance] setBackgroundImage:selectedBackgroundImage
                                               forState:UIControlStateSelected
                                             barMetrics:UIBarMetricsDefault];
    
    /* Image between two unselected segments */
    UIImage *bothUnselectedImage = [[UIImage imageNamed:@"segmentedSepNonSelected"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 0, 2, 0)];
    [[UISegmentedControl appearance] setDividerImage:bothUnselectedImage
                                 forLeftSegmentState:UIControlStateNormal
                                   rightSegmentState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    
    /* Image between segment selected on the left and unselected on the right */
    UIImage *leftSelectedImage = [[UIImage imageNamed:@"segmentedSepLeftSelected"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 0, 2, 0)];
    [[UISegmentedControl appearance] setDividerImage:leftSelectedImage
                                 forLeftSegmentState:UIControlStateSelected
                                   rightSegmentState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    
    /* Image between segment selected on the right and unselected on the right */
    UIImage *rightSelectedImage = [[UIImage imageNamed:@"segmentedSepRightSelected"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 0, 2, 0)];
    [[UISegmentedControl appearance] setDividerImage:rightSelectedImage
                                 forLeftSegmentState:UIControlStateNormal
                                   rightSegmentState:UIControlStateSelected
                                          barMetrics:UIBarMetricsDefault];
    
    /* PullToRefresh control */
    [tableView addPullToRefreshWithActionHandler:^{
        
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [self reloadDataWithHUD:NO];
            
        });
    }];
    
    tableView.pullToRefreshView.arrowColor = UIColorFromRGB(0x3d3328);
    tableView.pullToRefreshView.textColor = UIColorFromRGB(0x3d3328);
    
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
     //[appDetailViewController setOriginalCountryCode:currentCountryCode];
     [self.navigationController pushViewController:memberDetailViewController animated:YES];
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    
    switch (typeSearch) {
        case TypeSearchAll:
            [request getAllMembers];
            break;
            
        case TypeSearchType1:
            [request getAllMembersWithType:1];
            break;
            
        case TypeSearchType2:
            [request getAllMembersWithType:2];
            
        default:
            break;
    }
    
    request = nil;
}

- (IBAction)segmentedControlValueChanged:(id)sender
{
    typeSearch = segmentedControl.selectedSegmentIndex;
    [self reloadDataWithHUD:YES];
}

#pragma mark - ProgressHUD methods
- (void)reloadDataWithHUD:(BOOL)showHUD
{
    JSONRequest *request = [[JSONRequest alloc] init];
    request.delegate = self;
    
    if(showHUD)
        [self showHUD];
    
    switch (typeSearch) {
        case TypeSearchAll:
            [request getAllMembers];
            break;
            
        case TypeSearchType1:
            [request getAllMembersWithType:1];
            break;
            
        case TypeSearchType2:
            [request getAllMembersWithType:2];
            
        default:
            break;
    }
    
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
    [tableView reloadData];
    
    if(![HUD isHidden])
        [self hideHUD];
    
    [tableView.pullToRefreshView stopAnimating];
}

- (void)didNotReceiveJSONResponse:(NSError *)error
{
    [tableView.pullToRefreshView stopAnimating];
    
    [self hideHUDWithError:@"Ha sucedido un error"];
    NSLog(@"Error peticion: %@", [error localizedDescription]);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

@end
