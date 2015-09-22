//
//  STSideBarController.h
//  STKit
//
//  Created by SunJiangting on 13-11-19.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import <STKit/STDefines.h>
#import <UIKit/UIKit.h>
#import <STKit/STShadow.h>
#import <STKit/STViewController.h>


//// 侧滑生效的范围
/**
 * @abstract 侧滑导航在哪些区域通过左滑手势可以打开
 *
 * @attention 默认从最左端可以产生侧滑效果。
 */
typedef NS_ENUM(NSInteger, STSideInteractiveArea) {
    STSideInteractiveAreaNone          = 0,// 无任何侧滑效果
    STSideInteractiveAreaNavigationBar = 1 << 0,// 导航条可以通过手势侧滑
    STSideInteractiveAreaContentView   = 1 << 1,// 中间区域可以通过手势侧滑
    STSideInteractiveAreaAll           = (STSideInteractiveAreaNavigationBar | STSideInteractiveAreaContentView)
};

ST_ASSUME_NONNULL_BEGIN
@interface STSideBarController : STViewController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithNibName:(STNULLABLE NSString *)nibNameOrNil bundle:(STNULLABLE NSBundle *)nibBundleOrNil NS_DEPRECATED_IOS(2_0, 2_0, "Please use initWithRootViewController:");

/// sideBar 的最大宽度
@property(nonatomic) CGFloat maxSideWidth;

/// 左侧阴影的Layer
@property(nonatomic, strong, readonly) STShadow *shadow;

@property(STPROPERTYNULLABLE nonatomic, copy) NSArray *viewControllers;
- (void)setViewControllers:(STNULLABLE NSArray *)viewControllers animated:(BOOL)animated;

/// 当前选中的ViewController
@property(STPROPERTYNULLABLE nonatomic, readonly, weak) UIViewController *selectedViewController;
@property(nonatomic) NSUInteger       selectedIndex;
/// sidebar 是否在可见区域,当侧边栏出现时sideAppeared = YES
@property(nonatomic) BOOL sideAppeared;
/// 滑动手势
@property(nonatomic, strong, readonly) UIPanGestureRecognizer *panGestureRecognizer;

/**
 * @abstract 打开/关闭侧边栏,重复打开,则无效.
 *
 * @param    animated 是否需要动画
 */
- (void)revealSideViewControllerAnimated:(BOOL)animated;
- (void)concealSideViewControllerAnimated:(BOOL)animated;

/// 从最左侧抢占手势
@property(nonatomic) BOOL supportsEdgeInteractive;

@end

@interface UIViewController (SideBarController)

@property(STPROPERTYNULLABLE nonatomic, readonly, weak) STSideBarController *st_sideBarController;

@property(nonatomic, setter=st_setSideInteractionArea:) STSideInteractiveArea st_sideInteractionArea;

@end
ST_ASSUME_NONNULL_END
