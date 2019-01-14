//
//  AppDelegate.m
//  BoiToan
//
//  Created by LongLy on 21/12/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "AppDelegate.h"
#import "BTChiTayViewController.h"
#import "DALibViewController.h"
#import "CMCMNavigationViewController.h"
//#import "BTCalendarViewController.h"
@import Firebase;
@import GoogleMobileAds;

@interface AppDelegate ()<UITabBarControllerDelegate, UITabBarDelegate, GADInterstitialDelegate>
@property(nonatomic) UITabBarController *tabbar;
@property (nonatomic)GADInterstitial *interstitial;
@property(nonatomic) UIViewController *vcSelection;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Use Firebase library to configure APIs.
    [FIRApp configure];
    // Initialize the Google Mobile Ads SDK.
    [GADMobileAds configureWithApplicationID:@"ca-app-pub-2427874870616509~4027932660"];

    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.tabbar = [[UITabBarController alloc] init];
    self.tabbar.tabBar.barTintColor = sBackgroundColor;
    self.tabbar.tabBar.tintColor = sTinColor;
    self.tabbar.delegate = self;
    self.tabbar.viewControllers = [self viewControllers];
    self.window.rootViewController = self.tabbar;
    [self.window makeKeyAndVisible];
    [self.window makeKeyAndVisible];
    
    return YES;
}
-(void)setUpAdsinterstitial{
    self.interstitial = [self createAndLoadInterstitial];
    self.interstitial.delegate = self;
}
-(void)showInterstitial {
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self.vcSelection];
    } else {
        NSLog(@"Ad wasn't ready");
    }
    self.interstitial = [self createAndLoadInterstitial];
}

- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID:kXBinterstitial];
    GADRequest *request = [GADRequest request];
    [interstitial loadRequest:request];
    return interstitial;
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    self.interstitial = [self createAndLoadInterstitial];
}

- (NSArray *) viewControllers {
    
//    id calViewController = [[BTCalendarViewController alloc] init];
//    CMCMNavigationViewController *calendarNC = [[CMCMNavigationViewController alloc] initWithRootViewController:calViewController];
//    [calendarNC.navigationBar setTintColor:sBackgroundColor];
//    UIImage *infoIcon1 = [UIImage imageNamed:@"ic_boi"];
//    UIImage *infoIconSelected1 =[UIImage imageNamed:@"ic_boi"];
//    calendarNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Calendar"
//                                                      image:infoIcon1
//                                                  selectedImage:infoIconSelected1];
    //////
    //Home View Controllers
    //////
    id homeViewController = [[BTChiTayViewController alloc] init];
    CMCMNavigationViewController *homeNC = [[CMCMNavigationViewController alloc] initWithRootViewController:homeViewController];
    [homeNC.navigationBar setTintColor:sBackgroundColor];
    UIImage *infoIcon0 = [UIImage imageNamed:@"ic_tay"];
    UIImage *infoIconSelected0 =[UIImage imageNamed:@"ic_tay"];
    homeNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Chỉ Tay"
                                                      image:infoIcon0
                                              selectedImage:infoIconSelected0];
    
    id searchController = [[DALibViewController alloc] init];
    CMCMNavigationViewController *searchNC = [[CMCMNavigationViewController alloc] initWithRootViewController:searchController];
    [searchNC.navigationBar setBackgroundColor:sBackgroundColor];
    UIImage *infoIcon3 = [UIImage imageNamed:@"ic_boi"];
    UIImage *infoIconSelected3 =[UIImage imageNamed:@"ic_boi_seleted"];
    searchNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Bói Số Điện Thoại"
                                                        image:infoIcon3
                                                selectedImage:infoIconSelected3];
    return @[homeNC, searchNC];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    self.vcSelection = viewController;
    [self showInterstitial];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
