//
//  STDProxy.m
//  STKitDemo
//
//  Created by SunJiangting on 15-2-5.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import "STDProxy.h"

@implementation STDPObject

- (void)methodA {
    NSLog(@"%@ methodA", [self class]);
}

- (void)methodB {
    NSLog(@"%@ methodB", [self class]);
}

@end

@interface STDProxy ()

@property (nonatomic, strong) NSObject<STDPObject> *object;
@property (nonatomic, getter=hasPermission) BOOL  hasPermission;

@end

@implementation STDProxy

+ (void)test {
    STDPObject *object = [[STDPObject alloc] init];
    STDProxy *proxy = [[STDProxy alloc] initWithObject:object];
    proxy.hasPermission = YES;
    [proxy methodA];
    [proxy methodB];
    proxy.hasPermission = NO;
    [proxy methodA];
    [proxy methodB];
}

- (instancetype)initWithObject:(id<STDPObject>)object {
    self = [super init];
    if (self) {
        self.object = object;
    }
    return self;
}

- (void)methodA {
    if (self.hasPermission) {
        [self.object methodA];
    } else {
        NSLog(@"===您没有权利调用Method方法");
    }
}

- (void)methodB {
    [self.object methodB];
}

@end
