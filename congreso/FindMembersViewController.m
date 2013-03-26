//
//  FindMembersViewController.m
//  congreso
//
//  Created by Christian Roman on 24/03/13.
//  Copyright (c) 2013 Christian Roman. All rights reserved.
//

#import "FindMembersViewController.h"
#import "JSONRequest.h"
#import "ResultsMembersViewController.h"

@interface FindMembersViewController ()

@end

@implementation FindMembersViewController

- (NSString *)tabImageName
{
	return @"image-6";
}

- (NSString *)tabTitle
{
	return self.title;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"Tu localidad";
        
        currentLocation = [[CLLocation alloc] init];
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations lastObject];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    currentLocation = newLocation;
}

#pragma mark - Methods
- (IBAction)searchNearby:(id)sender
{    
    JSONRequest *request = [[JSONRequest alloc] init];
    request.delegate = self;
    
    [self showHUD];
    
    [request getNearbyMembers:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
    
    request = nil;
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
