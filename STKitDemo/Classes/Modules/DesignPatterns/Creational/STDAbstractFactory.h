//
//  STDAbstractFactory.h
//  STKitDemo
//
//  Created by SunJiangting on 15-2-3.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STDesignPatterns.h"

@protocol STDAbstractProduct;
/**
 * @abstract 抽象工厂模式
 * 
 * 抽象工厂中有四个角色，抽象工厂，工厂，抽象产品，产品
 */
@interface STDAbstractFactory : NSObject <STDesignPatternsDelegate>

+ (id <STDAbstractProduct>)createProduct;

@end

@interface STDFactoryA : STDAbstractFactory

@end

@interface STDFactoryB : STDAbstractFactory

@end

// ...
/* 如果需要扩展，就在这里扩展一个工厂
@interface STDFactoryC : STDAbstractFactory

@end
 */

@interface STDProductA : NSObject <STDAbstractProduct>

@end

@interface STDProductB : NSObject <STDAbstractProduct>

@end

// ...


