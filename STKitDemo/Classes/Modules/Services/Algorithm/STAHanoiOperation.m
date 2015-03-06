//
//  STAHanoiOperation.m
//  STBasic
//
//  Created by SunJiangting on 13-11-3.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STAHanoiOperation.h"
#import "STAHanoiView.h"

@interface STAHanoiOperation ()

@property (nonatomic, assign) NSTimeInterval duration;

@property (atomic, assign)    BOOL complete;

@end

@implementation STAHanoiOperation

- (instancetype) init {
    self = [super init];
    if (self) {
        self.duration = [[[NSUserDefaults standardUserDefaults] valueForKey:@"STMoveAnimationDuration"] doubleValue];
    }
    return self;
}

- (void) main {

    void (^completion)(BOOL finished) = ^(BOOL finished){
        self.complete = YES;
    };
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hanoiView moveDiskAtIndex:_index toIndex:_toIndex duration:_duration completion:completion];
    });
    while (!self.complete) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
    }
}

@end
