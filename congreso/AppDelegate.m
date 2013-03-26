//
//  AppDelegate.m
//  congreso
//
//  Created by Christian Roman on 15/03/13.
//  Copyright (c) 2013 Christian Roman. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
#import "MembersViewController.h"
#import "CommissionsViewController.h"
#import "PartidosViewController.h"
#import "FindMembersViewController.h"
#import "AKTabBarController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    reachabilty = [Reachability reachabilityForInternetConnection];
    
    /* */
    
    _tabBarController = [[AKTabBarController alloc] initWithTabBarHeight:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 70 : 50];
    [_tabBarController setMinimumHeightToDisplayTitle:40.0];
    
    MembersViewController *membersViewController = [[MembersViewController alloc] initWithNibName:NSStringFromClass([MembersViewController class]) bundle:nil];
    UINavigationController *firstNav = [[UINavigationController alloc] initWithRootViewController:membersViewController];
    
    CommissionsViewController *commissionsViewController = [[CommissionsViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *secondNav = [[UINavigationController alloc] initWithRootViewController:commissionsViewController];
    
    PartidosViewController *partidosViewController = [[PartidosViewController alloc] initWithNibName:NSStringFromClass([PartidosViewController class]) bundle:nil];
    UINavigationController *thirdNav = [[UINavigationController alloc] initWithRootViewController:partidosViewController];
    
    FindMembersViewController *findMembersViewController = [[FindMembersViewController alloc] initWithNibName:NSStringFromClass([FindMembersViewController class]) bundle:nil];
    UINavigationController *fourNav = [[UINavigationController alloc] initWithRootViewController:findMembersViewController];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavBar"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavBar-Landscape"] forBarMetrics:UIBarMetricsLandscapePhone];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    [_tabBarController setViewControllers:[NSMutableArray arrayWithObjects:
                                           firstNav,
                                           secondNav,
                                           thirdNav,
                                           fourNav,
                                           nil]];
    
    
    // Below you will find an example of possible customization, just uncomment the lines
    
    /*
     // Tab background Image
     [_tabBarController setBackgroundImageName:@"noise-dark-gray.png"];
     [_tabBarController setSelectedBackgroundImageName:@"noise-dark-blue.png"];
     
     // Tabs top embos Color
     [_tabBarController setTabEdgeColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8]];
     
     // Tabs Colors settings
     [_tabBarController setTabColors:@[[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.0],
     [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0]]]; // MAX 2 Colors
     
     [_tabBarController setSelectedTabColors:@[[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0],
     [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0]]]; // MAX 2 Colors
     
     // Tab Stroke Color
     [_tabBarController setTabStrokeColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
     
     // Icons Color settings
     [_tabBarController setIconColors:@[[UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1],
     [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1]]]; // MAX 2 Colors
     
     // Icon Shadow
     [_tabBarController setIconShadowColor:[UIColor blackColor]];
     [_tabBarController setIconShadowOffset:CGSizeMake(0, 1)];
     
     [_tabBarController setSelectedIconColors:@[[UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1],
     [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1]]]; // MAX 2 Colors
     
     [_tabBarController setSelectedIconOuterGlowColor:[UIColor darkGrayColor]];
     
     // Text Color
     [_tabBarController setTextColor:[UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1.0]];
     [_tabBarController setSelectedTextColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
     
     // Hide / Show glossy on tab icons
     [_tabBarController setIconGlossyIsHidden:YES];
     */
    
    [_window setRootViewController:_tabBarController];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)checkForWIFIConnection
{
    NetworkStatus netStatus = [reachabilty currentReachabilityStatus];
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
            isReachable = YES;
            break;
        }
        case ReachableViaWiFi:
        {
            isReachable = YES;
            break;
        }
        case NotReachable:
        {
            isReachable = NO;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sin conexión a internet" message:@"Verifica tu conexión a internet." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            break;
        }
    }
}

- (void)reachabilityChanged:(NSNotification*) notification
{
    [self checkForWIFIConnection];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [reachabilty stopNotifier];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    isReachable = NO;
    [reachabilty startNotifier];
    [self checkForWIFIConnection];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
