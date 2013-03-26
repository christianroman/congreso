//
//  ResultsMembersViewController.m
//  congreso
//
//  Created by Christian Roman on 24/03/13.
//  Copyright (c) 2013 Christian Roman. All rights reserved.
//

#import "ResultsMembersViewController.h"
#import "GradientView.h"
#import "Member.h"
#import "MemberDetailViewController.h"
#import "AppCell.h"
#import "State.h"

#define UIColorFromRGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue&0xFF0000)>>16))/255.0 green:((float)((rgbValue&0xFF00)>>8))/255.0 blue:((float)(rgbValue&0xFF))/255.0 alpha:1.0]

@interface ResultsMembersViewController ()

@end

@implementation ResultsMembersViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        self.title = @"Resultados";
        
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [memberDetailViewController setMember:[self.members objectAtIndex:[indexPath row]]];
    [self.navigationController pushViewController:memberDetailViewController animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71.0f;
}

@end
