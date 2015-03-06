//
//  STDAppDelegate.m
//  STKitDemo
//
//  Created by SunJiangting on 13-12-6.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STDAppDelegate.h"

#import "STDSideBarController.h"
#import "STDLeftViewController.h"
#import "STDTabBarController.h"

#import "STDStartViewController.h"

#import <STKit/STKit.h>

@interface STDAppDelegate ()

@end

@implementation STDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initializeCustomUserSetting];
    if ([application respondsToSelector:@selector(setStatusBarStyle:)]) {
        application.statusBarStyle = UIStatusBarStyleDefault;
    }

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    NSString *previousStyle = [[STPersistence standardPersistence] valueForKey:@"SelectedStyle"];
    if ([previousStyle isEqualToString:@"TabBar"]) {
        self.window.rootViewController = [self tabBarController];
    } else if ([previousStyle isEqualToString:@"SideBar"]) {
        self.window.rootViewController = [self sideBarController];
    } else {
        self.window.rootViewController = [self startViewController];
    }
    [self.window makeKeyAndVisible];
    return YES;
}

- (UIViewController *)startViewController {
    [[STPersistence standardPersistence] setValue:@"Start" forKey:@"SelectedStyle"];
    return STDStartViewController.new;
}

- (UIViewController *)tabBarController {
    [[STPersistence standardPersistence] setValue:@"TabBar" forKey:@"SelectedStyle"];
    STDTabBarController *tabBarController = [[STDTabBarController alloc] init];
    return tabBarController;
}

- (UIViewController *)sideBarController {
    [[STPersistence standardPersistence] setValue:@"SideBar" forKey:@"SelectedStyle"];
    STDLeftViewController *leftViewController = [[STDLeftViewController alloc] init];
    STDSideBarController *sideBarController = [[STDSideBarController alloc] initWithRootViewController:leftViewController];
    sideBarController.navigationBarHidden = YES;
    STNavigationController *navigationController = [[STNavigationController alloc] initWithRootViewController:sideBarController];
    return navigationController;
}

- (void)replaceRootViewController:(UIViewController *)newViewController animationOptions:(UIViewAnimationOptions)options {

    UIViewController *formerViewController = self.window.rootViewController;
    if (formerViewController == newViewController) {
        return;
    }
    void (^completion)(BOOL) = ^(BOOL finished) {
        self.window.rootViewController = newViewController;
    };
    // options 为 0 表示木有动画
    if (options == 0) {
        completion(YES);
    } else {
        [UIView transitionFromView:formerViewController.view toView:newViewController.view duration:0.65 options:options completion:completion];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as
    // an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the
    // game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the
    // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - PrivateMethod

- (void)initializeCustomUserSetting {

    [[STThemeManager currentTheme] setThemeValue:[UIColor colorWithRGB:0x999999]
                                          forKey:@"BookTextColor"
                                 whenContainedIn:NSClassFromString(@"STRichView")];
    UIFont *bookFont = [UIFont fontWithName:@"STHeitiSC-Light" size:21.];
    [[STThemeManager currentTheme] setThemeValue:bookFont forKey:@"BookTextFont" whenContainedIn:NSClassFromString(@"STRichView")];

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setValue:bookFont forKey:NSFontAttributeName];
    [dict setValue:@(2) forKey:NSKernAttributeName];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;
    [dict setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [[STThemeManager currentTheme] setThemeValue:dict forKey:@"BookTextAttributes" whenContainedIn:NSClassFromString(@"STRichView")];

    [[STCoreDataManager defaultDataManager] setModelName:@"STDModel"];
}

@end
