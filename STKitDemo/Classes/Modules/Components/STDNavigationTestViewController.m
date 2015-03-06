//
//  STDNavigationTestViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 14-8-25.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDNavigationTestViewController.h"
#import "STDSettingViewController.h"

@interface STDNavigationTestViewController () <STNavigationControllerDelegate>

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation STDNavigationTestViewController

- (void)dealloc {
    
}

- (instancetype) initWithStyle:(UITableViewStyle)tableViewStyle {
    self = [super initWithStyle:tableViewStyle];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:2];
        
        STDTableViewCellItem *item00 = [[STDTableViewCellItem alloc] initWithTitle:@"Push一个有导航栏的" target:self action:@selector(_pushNHNBHSActionFired)];
        
        STDTableViewCellItem *item01 = [[STDTableViewCellItem alloc] initWithTitle:@"Push一个没有导航栏的" target:self action:@selector(_pushNHYBHSActionFired)];
        
        STDTableViewCellItem *item02 = [[STDTableViewCellItem alloc] initWithTitle:@"Push一个有TabBar的" target:self action:@selector(_pushNHSBHNActionFired)];
        
        STDTableViewCellItem *item03 = [[STDTableViewCellItem alloc] initWithTitle:@"Push一个没有TabBar的" target:self action:@selector(_pushNHSBHYActionFired)];
        STDTableViewSectionItem *section0 = [[STDTableViewSectionItem alloc] initWithSectionTitle:@"从屏幕最左侧右滑拖动可以返回，支持iOS6。"
                                                                                            items:@[item00, item01, item02, item03]];
        [dataSource addObject:section0];
        
        STDTableViewCellItem *item10 = [[STDTableViewCellItem alloc] initWithTitle:@"PopViewController" target:self action:@selector(_popViewControllerActionFired)];
        STDTableViewCellItem *item11 = [[STDTableViewCellItem alloc] initWithTitle:@"PopToRootViewController" target:self action:@selector(_popToRootViewControllerActionFired)];
        STDTableViewSectionItem *section1 = [[STDTableViewSectionItem alloc] initWithSectionTitle:@"PopViewController" items:@[ item10, item11]];
        [dataSource addObject:section1];

        self.dataSource = dataSource;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"测试导航";
    if (![self.customNavigationController.delegate isKindOfClass:[self class]] && [STDSettingViewController allowsCustomNavigationTransition]) {
         self.customNavigationController.delegate = self;   
    }
    if (![STDSettingViewController allowsCustomNavigationTransition]) {
        self.customNavigationController.delegate = nil;
    }
    self.scrollDirector.refreshControl.enabled = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Identifier"];
}



- (void)navigationController:(STNavigationController *)navigationController willBeginTransitionContext:(STNavigationControllerTransitionContext *)transitionContext {
    UIView *targetView;
    CGFloat originAngle;
    if (transitionContext.transitionType == STViewControllerTransitionTypePop) {
        targetView = transitionContext.fromView;
        originAngle = 0;
    } else {
        targetView = transitionContext.toView;
        originAngle = M_PI_2;
    }
    targetView.anchorPoint = CGPointMake(0.0, 1.0);
    targetView.layer.transform = CATransform3DMakeRotation(originAngle, 0.0, .0, 1.0);
}

#define finalAngel 30.0f
#define perspective 1.0/-600
#define finalAlpha 0.6f

- (void)navigationController:(STNavigationController *)navigationController transitingWithContext:(STNavigationControllerTransitionContext *)transitionContext {
    CGFloat completion = transitionContext.completion;
    UIView *fromView = transitionContext.fromView, *toView = transitionContext.toView;
    STViewControllerTransitionType transitionType = transitionContext.transitionType;
    UIView *targetView;
    if (transitionType == STViewControllerTransitionTypePop) {
        targetView = fromView;
    } else {
        targetView = toView;
        completion = (1.0 - completion);
    }
    targetView.layer.transform = CATransform3DMakeRotation(M_PI_2 * completion, 0.0, .0, 1.0);
    return;

    UIView *transitionView = transitionContext.transitionView;
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = perspective;
    
    CGFloat angle =  finalAngel * M_PI / 180.0f * completion;
    if(transitionType == STViewControllerTransitionTypePop){
        angle = -angle;
    }
    transform = CATransform3DRotate(transform, angle , 0.0f, 1.0f, 0.0f);
    fromView.layer.transform = transform;
    fromView.alpha =  1 - completion*(1-finalAlpha);
    
    if(targetView){
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = perspective;
        CGFloat angle =  - finalAngel * M_PI / 180.0f * (1-completion);
        if(transitionContext.transitionType == STViewControllerTransitionTypePop){
            angle = -angle;
        }
        transform = CATransform3DRotate(transform, angle , 0.0f, 1.0f, 0.0f);
        targetView.layer.transform = transform;
        targetView.alpha = finalAlpha + (1-finalAlpha)*completion;
    }
    
    UIViewController *fromViewController = transitionContext.fromViewController, *targetViewController = transitionContext.toViewController;
    CGRect fromViewFrame = fromView.frame, toViewFrame = targetView.frame;
    if (transitionType == STViewControllerTransitionTypePop) {
        CGFloat panOffset = MAX(MIN(fromViewController.interactivePopTransitionOffset, CGRectGetWidth(transitionView.bounds)), 0);
        fromViewFrame.origin.x = completion * (CGRectGetWidth(transitionView.frame) + 80);
        toViewFrame.origin.x = -panOffset + completion * panOffset - (1-completion)*80;
    } else {
        CGFloat panOffset = MAX(MIN(targetViewController.interactivePopTransitionOffset, CGRectGetWidth(transitionView.bounds)), 0);
        fromViewFrame.origin.x = -panOffset + (1.0 - completion) *panOffset - completion * 100;
        toViewFrame.origin.x = (1.0-completion) *CGRectGetWidth(transitionContext.transitionView.bounds) + (1-completion)*100;
    }
    fromView.frame = fromViewFrame;
    targetView.frame = toViewFrame;
}

- (void)navigationController:(STNavigationController *)navigationController didEndTransitionContext:(STNavigationControllerTransitionContext *)transitionContext {
    UIView *fromView = transitionContext.fromView, *toView = transitionContext.toView;
    fromView.anchorPoint = CGPointMake(0.5, 0.5);
    fromView.layer.transform = CATransform3DIdentity;
    toView.anchorPoint = CGPointMake(0.5, 0.5);
    toView.layer.transform = CATransform3DIdentity;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_popViewControllerActionFired {
    [self.customNavigationController popViewControllerAnimated:YES];
}

- (void)_popToRootViewControllerActionFired {
    [self.customNavigationController popToRootViewControllerAnimated:YES];
}

- (void)_pushNHNBHSActionFired {
    STDNavigationTestViewController * viewController = [[STDNavigationTestViewController alloc] initWithStyle:UITableViewStyleGrouped];
    viewController.navigationBarHidden = NO;
    viewController.hidesBottomBarWhenPushed = self.hidesBottomBarWhenPushed;
    [self.customNavigationController pushViewController:viewController animated:YES];
}

- (void)_pushNHYBHSActionFired {
    STDNavigationTestViewController * viewController = [[STDNavigationTestViewController alloc] initWithStyle:UITableViewStyleGrouped];
    viewController.navigationBarHidden = YES;
    viewController.hidesBottomBarWhenPushed = self.hidesBottomBarWhenPushed;
    [self.customNavigationController pushViewController:viewController animated:YES];
}

- (void)_pushNHSBHNActionFired {
    STDNavigationTestViewController * viewController = [[STDNavigationTestViewController alloc] initWithStyle:UITableViewStyleGrouped];
    viewController.navigationBarHidden = self.navigationBarHidden;
    viewController.hidesBottomBarWhenPushed = NO;
    [self.customNavigationController pushViewController:viewController animated:YES];
}

- (void)_pushNHSBHYActionFired {
    STDNavigationTestViewController * viewController = [[STDNavigationTestViewController alloc] initWithStyle:UITableViewStyleGrouped];
    viewController.navigationBarHidden = self.navigationBarHidden;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.customNavigationController pushViewController:viewController animated:YES];
}
@end
