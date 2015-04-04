//
//  STDTransitionDelegate.m
//  STKitDemo
//
//  Created by SunJiangting on 15-4-3.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import "STDTransitionDelegate.h"

@implementation STDTransitionDelegate

static id _sharedDelegate;
+ (instancetype)sharedDelegate {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDelegate = [[self alloc] init];
    });
    return _sharedDelegate;
}

- (BOOL)navigationController:(STNavigationController *)navigationController
shouldBeginTransitionContext:(STNavigationControllerTransitionContext *)transitionContext {
    return NO;
}

- (void)navigationController:(STNavigationController *)navigationController
  willBeginTransitionContext:(STNavigationControllerTransitionContext *)transitionContext {
   
}

- (void)navigationController:(STNavigationController *)navigationController
       transitingWithContext:(STNavigationControllerTransitionContext *)transitionContext {

}

- (void)navigationController:(STNavigationController *)navigationController
     didEndTransitionContext:(STNavigationControllerTransitionContext *)transitionContext {

}

@end
