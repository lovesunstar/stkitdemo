//
//  STDesignPatterns.h
//  STKitDemo
//
//  Created by SunJiangting on 15-2-3.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STDesignPatternsDelegate <NSObject>

+ (void)test;

@optional
- (void)printDesignPatternName;
- (void)printAdvantages;
- (void)printDisadvantages;

@end

/// 工厂部分
/// 抽象产品，提供一个制造的接口
@protocol STDAbstractProduct <NSObject>

- (void)printProductName;

@end
