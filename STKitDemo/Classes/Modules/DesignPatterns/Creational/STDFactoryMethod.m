//
//  STDFactoryMethod.m
//  STKitDemo
//
//  Created by SunJiangting on 15-2-3.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import "STDFactoryMethod.h"

@implementation STDFactoryMethod

+ (void)test {
    id<STDAbstractProduct> product = [STDFactoryMethod createProduct];
    [product printProductName];
}

+ (id<STDAbstractProduct>)createProduct {
    return STDFactoryMethodProduct.new;
}

- (void)printDesignPatternName {
    NSLog(@"工厂方法模式");
}

@end

@implementation STDFactoryMethodProduct

- (void)printProductName {
    NSLog(@"This is a product");
}

@end
