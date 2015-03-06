//
//  STDSingleton.m
//  STKitDemo
//
//  Created by SunJiangting on 15-2-3.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import "STDSingleton.h"

@implementation STDSingleton

+ (void)test {
    [STDSingleton sharedInstance].globalName = @"Suen技术哥";
    [[STDSingleton sharedInstance] printMemoryAddress];
    [[STDSingleton sharedInstance] printMemoryAddress];
}

static STDSingleton *_sharedInstance;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (void)printMemoryAddress {
    NSLog(@"%p", self);
}

@end
