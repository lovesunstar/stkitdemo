//
//  STViewController.h
//  STKit
//
//  Created by SunJiangting on 13-10-5.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import <STKit/STDefines.h>
#import <UIKit/UIKit.h>

@interface STViewController : UIViewController

@property(nonatomic, assign, getter=isInteractivePopGestureEnabled) BOOL interactivePopGestureEnabled;

- (void)backViewControllerAnimated:(BOOL)animated;

@end

#import <STKit/STNavigationController.h>
#import <STKit/STTabBarController.h>