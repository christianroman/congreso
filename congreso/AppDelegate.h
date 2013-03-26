//
//  AppDelegate.h
//  congreso
//
//  Created by Christian Roman on 15/03/13.
//  Copyright (c) 2013 Christian Roman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reachability;
@class AKTabBarController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    Reachability *reachabilty;
    BOOL isReachable;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) AKTabBarController *tabBarController;

@property (strong, nonatomic) NSString *databaseName;
@property (strong, nonatomic) NSString *databasePath;

- (void)checkForWIFIConnection;

@end
