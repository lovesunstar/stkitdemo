//
//  STDFactoryMethod.h
//  STKitDemo
//
//  Created by SunJiangting on 15-2-3.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STDesignPatterns.h"

/**
 * @abstract 工厂方法模式
 */
@interface STDFactoryMethod : NSObject <STDesignPatternsDelegate>

+ (id<STDAbstractProduct>)createProduct;

@end

@interface STDFactoryMethodProduct : NSObject <STDAbstractProduct>

@end

