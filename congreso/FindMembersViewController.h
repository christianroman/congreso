//
//  FindMembersViewController.h
//  congreso
//
//  Created by Christian Roman on 24/03/13.
//  Copyright (c) 2013 Christian Roman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JSONRequest.h"
#import "MBProgressHUD.h"

@interface FindMembersViewController : UIViewController <CLLocationManagerDelegate, JSONRequest, MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

- (IBAction)searchNearby:(id)sender;

@end
