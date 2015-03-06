//
//  STDFacade.m
//  STKitDemo
//
//  Created by SunJiangting on 15-2-5.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import "STDFacade.h"

@implementation STDFObjectA

- (void)methodA {
    NSLog(@"%@Method", [self class]);
}

@end

@implementation STDFObjectB

- (void)methodB {
    NSLog(@"%@Method", [self class]);
}

@end

@implementation STDFObjectC

- (void)methodC {
    NSLog(@"%@Method", [self class]);
}

@end

@implementation STDFObjectD

- (void)methodD {
    NSLog(@"%@Method", [self class]);
}

@end


@interface STDFacade ()
@property (nonatomic, strong) STDFObjectA *objectA;
@property (nonatomic, strong) STDFObjectB *objectB;
@property (nonatomic, strong) STDFObjectC *objectC;
@property (nonatomic, strong) STDFObjectD *objectD;
@end

@implementation STDFacade

+ (void)test {
    STDFacade *facade = [[STDFacade alloc] init];
    [facade unifiedMethodA];
    [facade unifiedMethodB];
    [facade unifiedMethodC];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.objectA = [STDFObjectA new];
        self.objectB = [STDFObjectB new];
        self.objectC = [STDFObjectC new];
        self.objectD = [STDFObjectD new];
    }
    return self;
}

- (void)unifiedMethodA {
    [self.objectA methodA];
    [self.objectB methodB];
    [self.objectC methodC];
}

- (void)unifiedMethodB {
    [self.objectD methodD];
    [self.objectB methodB];
    [self.objectC methodC];
}

- (void)unifiedMethodC {
    [self.objectA methodA];
    [self.objectB methodB];
    [self.objectD methodD];
}

@end
