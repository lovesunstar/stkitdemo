//
//  STNavigationController.h
//  STKit
//
//  Created by SunJiangting on 14-2-13.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import <STKit/STDefines.h>

#import <STKit/STShadow.h>
#import <STKit/STViewController.h>

typedef NS_ENUM(NSInteger, STViewControllerTransitionType) {
    STViewControllerTransitionTypePush,
    STViewControllerTransitionTypePop,
};

ST_ASSUME_NONNULL_BEGIN
@interface STNavigationControllerTransitionContext : NSObject

@property (nonatomic, readonly) UIViewController    *fromViewController;
@property (nonatomic, readonly) UIViewController    *toViewController;

// fromTransitionView 不一定是fromViewController.view。动画一定要在fromTransitionView上做.
@property (nonatomic, readonly) UIView              *fromView;
@property (nonatomic, readonly) UIView              *toView;
// 动画完成的比例
@property (nonatomic, readonly) CGFloat              completion;
@property (nonatomic, readonly) STViewControllerTransitionType transitionType;
@property (nonatomic, readonly) UIView              *transitionView;
//@property (nonatomic, readonly) BOOL                 transitionWithInteraction;

@end
ST_ASSUME_NONNULL_END

/// UINavigationController
@class STNavigationBar;
@protocol STNavigationControllerDelegate;
@interface STNavigationController : STViewController

- (STNONNULL instancetype)initWithRootViewController:(UIViewController * ST_NULLABLE)rootViewController; // Convenience method pushes the root view controller without animation.

- (void)pushViewController:(UIViewController * ST_NONNULL)viewController animated:(BOOL)animated; // Uses a horizontal slide transition. Has no effect if the view controller is already in the stack.

- (UIViewController * ST_NULLABLE)popViewControllerAnimated:(BOOL)animated; // Returns the popped controller.
- (NSArray * ST_NULLABLE)popToViewController:(UIViewController * ST_NONNULL)viewController animated:(BOOL)animated; // Pops view controllers until the one specified is on top. Returns the popped controllers.
- (NSArray * ST_NULLABLE)popToRootViewControllerAnimated:(BOOL)animated; // Pops until there's only a single view controller left on the stack. Returns the popped controllers.

@property(STPROPERTYNULLABLE nonatomic, readonly, strong) UIViewController *topViewController; // The top view controller on the stack.
@property(STPROPERTYNULLABLE nonatomic, readonly, strong) UIViewController *visibleViewController; // Return modal view controller if it exists. Otherwise the top view controller.

@property(STPROPERTYNULLABLE nonatomic, copy) NSArray<UIViewController *> *viewControllers; // The current view controller stack.
- (void)setViewControllers:(NSArray<__kindof UIViewController *> * ST_NULLABLE)viewControllers animated:(BOOL)animated; // If animated is YES, then simulate a push or pop depending on whether the new top view controller was
                                           // previously in the stack.
@property(STPROPERTYNONNULL nonatomic, readonly) STNavigationBar *navigationBar; // The navigation bar managed by the controller. Pushing, popping or setting navigation
                                                               // items on a managed navigation bar is not supported.

@property(STPROPERTYNULLABLE nonatomic, weak) id<STNavigationControllerDelegate> delegate;
///
@property(STPROPERTYNONNULL nonatomic, readonly) UIGestureRecognizer *interactivePopGestureRecognizer;

@property(STPROPERTYNONNULL nonatomic, strong, readonly) UIView *transitionView;

@property(STPROPERTYNULLABLE nonatomic, strong, readonly) STShadow *shadow;

@property(nonatomic) CGFloat maximumPopAnimationMaskAlpha;

@end

/// NavigationController Push/Pop时间
extern CGFloat const STTransitionViewControllerAnimationDuration;

@interface UIViewController (STNavigationController)

@property(nonatomic, setter=st_setNavigationBarHidden:) BOOL st_navigationBarHidden;

@property(STPROPERTYNULLABLE nonatomic, readonly, strong) STNavigationBar *st_navigationBar;
@property(STPROPERTYNULLABLE nonatomic, readonly, strong) STNavigationController *st_navigationController;

/// @li 从最左侧开始生效返回手势，这个变量决定距离左侧多少可以激活手势，设置为0，则禁止左滑跟随返回
/// @li 有些套了手机壳的手机，壳边缘比较厚，设置比较小的话，影响操作，很难触发。
@property(nonatomic, setter=st_setMaximumInteractivePopEdgeDistance:) CGFloat st_maximumInteractivePopEdgeDistance; // 默认 30pt,系统默认13。
/// Pop/Push ViewController时，前一个ViewController's view的偏移量（iOS7的返回效果）。
/// 变量应该为Unsigned
@property(nonatomic, setter=st_setInteractivePopTransitionOffset:) CGFloat st_interactivePopTransitionOffset; // default 80pt

@end
/// 30pt
extern CGFloat const STMaximumInteractivePopEdgeDistance;
/// 80pt
extern CGFloat const STInteractivePopTransitionOffset;

@protocol STNavigationControllerDelegate <UINavigationControllerDelegate>

@optional
/// 是否可以使用自定义的transition切换,如果返回False，则使用默认动画
- (BOOL)navigationController:(STNavigationController * ST_NONNULL)navigationController
shouldBeginTransitionContext:(STNavigationControllerTransitionContext * ST_NONNULL)transitionContext;

- (void)navigationController:(STNavigationController * ST_NONNULL)navigationController willBeginTransitionContext:(STNavigationControllerTransitionContext * ST_NONNULL)transitionContext;

- (void)navigationController:(STNavigationController * ST_NONNULL)navigationController transitingWithContext:(STNavigationControllerTransitionContext * ST_NONNULL)transitionContext;

- (void)navigationController:(STNavigationController * ST_NONNULL)navigationController didEndTransitionContext:(STNavigationControllerTransitionContext * ST_NONNULL)transitionContext;
@end