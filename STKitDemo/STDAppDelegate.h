//
//  STDAppDelegate.h
//  STKitDemo
//
//  Created by SunJiangting on 13-12-6.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCSiriWaveformView;
@interface STDAppDelegate : UIResponder <UIApplicationDelegate>

@property(strong, nonatomic) UIWindow *window;

- (UIViewController *)startViewController;
- (UIViewController *)tabBarController;
- (UIViewController *)sideBarController;
- (void)replaceRootViewController:(UIViewController *)newViewController
                 animationOptions:(UIViewAnimationOptions)options;
@end