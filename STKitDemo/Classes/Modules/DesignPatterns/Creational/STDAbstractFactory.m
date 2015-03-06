//
//  STDAbstractFactory.m
//  STKitDemo
//
//  Created by SunJiangting on 15-2-3.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import "STDAbstractFactory.h"


@implementation STDAbstractFactory

+ (void)test {
    id<STDAbstractProduct> productA = [STDFactoryA createProduct];
    [productA printProductName];
    
    id<STDAbstractProduct> productB = [STDFactoryB createProduct];
    [productB printProductName];
}

+ (id <STDAbstractProduct>)createProduct {
    return nil;
}

- (void)printDesignPatternName {
    NSLog(@"抽象工厂模式");
}

- (void)printAdvantages {
    
}

- (void)printDisadvantages {
    
}

@end

@implementation STDFactoryA

+ (id <STDAbstractProduct>)createProduct {
    return STDProductA.new;
}

@end

@implementation STDFactoryB

+ (id <STDAbstractProduct>)createProduct {
    return STDProductB.new;
}

@end

@implementation STDProductA

- (void)printProductName {
    NSLog(@"=========This is product a.");
}

@end

@implementation STDProductB

- (void)printProductName {
    NSLog(@"=========This is product b.");
}

@end