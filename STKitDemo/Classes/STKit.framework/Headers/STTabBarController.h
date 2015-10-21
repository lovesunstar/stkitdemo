//
//  STTabBarController.h
//  STKit
//
//  Created by SunJiangting on 14-2-13.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <STKit/STViewController.h>

@protocol STTabBarControllerDelegate;
@class STTabBar, STTabBarItem;

IB_DESIGNABLE
ST_ASSUME_NONNULL_BEGIN
@interface STTabBarController : STViewController

@property(nonatomic, readonly, strong) UIView *transitionView;
@property(nonatomic) BOOL animatedWhenTransition;

@property(STPROPERTYNULLABLE nonatomic, copy)NSArray<UIViewController *> *viewControllers;
// If the number of view controllers is greater than the number displayable by a tab bar, a "More" navigation controller will automatically be shown.
// The "More" navigation controller will not be returned by -viewControllers, but it may be returned by -selectedViewController.
- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated;

@property(STPROPERTYNULLABLE nonatomic, weak) UIViewController *selectedViewController;
@property(nonatomic) NSUInteger selectedIndex;

@property(nonatomic, readonly) STTabBar *tabBar;

@property(STPROPERTYNULLABLE nonatomic, weak) id<STTabBarControllerDelegate> delegate;

/// default 49
@property(nonatomic, assign) CGFloat tabBarHeight;
@property(nonatomic, assign) CGFloat actualTabBarHeight;

- (void)setBadgeValue:(STNULLABLE NSString *)badgeValue forIndex:(NSInteger)index;
- (STNULLABLE NSString *)badgeValueForIndex:(NSInteger)index;

//- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

@end

ST_ASSUME_NONNULL_END

@interface UIViewController (STTabBarControllerItem)

// Automatically created lazily with the view controller's title if it's not set explicitly.
@property(STPROPERTYNONNULL nonatomic, strong, setter=st_setTabBarItem:) STTabBarItem *st_tabBarItem;

// If the view controller has a tab bar controller as its ancestor, return it. Returns nil otherwise.
@property(STPROPERTYNULLABLE nonatomic, readonly, strong) STTabBarController *st_tabBarController;

@end

ST_ASSUME_NONNULL_BEGIN
@protocol STTabBarControllerDelegate <NSObject>
@optional
- (BOOL)tabBarController:(STTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;

- (void)tabBarController:(STTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;

@end
ST_ASSUME_NONNULL_END
/// Default 49
extern const CGFloat STCustomTabBarHeight;