//
//  STDRotateTransitionDelegate.m
//  STKitDemo
//
//  Created by SunJiangting on 15-4-3.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import "STDRotateTransitionDelegate.h"

@implementation STDRotateTransitionDelegate


- (BOOL)navigationController:(STNavigationController *)navigationController
shouldBeginTransitionContext:(STNavigationControllerTransitionContext *)transitionContext {
    return YES;
}

- (void)navigationController:(STNavigationController *)navigationController
  willBeginTransitionContext:(STNavigationControllerTransitionContext *)transitionContext {
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

- (void)navigationController:(STNavigationController *)navigationController
       transitingWithContext:(STNavigationControllerTransitionContext *)transitionContext {
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
}

- (void)navigationController:(STNavigationController *)navigationController
     didEndTransitionContext:(STNavigationControllerTransitionContext *)transitionContext {
    UIView *fromView = transitionContext.fromView, *toView = transitionContext.toView;
    fromView.anchorPoint = CGPointMake(0.5, 0.5);
    fromView.layer.transform = CATransform3DIdentity;
    toView.anchorPoint = CGPointMake(0.5, 0.5);
    toView.layer.transform = CATransform3DIdentity;
}


@end
