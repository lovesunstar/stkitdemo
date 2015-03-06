//
//  STDBuilder.h
//  STKitDemo
//
//  Created by SunJiangting on 15-2-3.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STDesignPatterns.h"

@interface STDProduct : NSObject

@property (nonatomic) NSObject *partA, *partB, *partC, *partD;

@end
/// 建造者模式
@interface STDBuilder : NSObject <STDesignPatternsDelegate>
- (void)buildPartA;
- (void)buildPartB;
- (void)buildPartC;
- (void)buildPartD;
- (STDProduct *)product;
@end

@interface STDBuildDirector : NSObject
- (instancetype)initWithBuilder:(STDBuilder *)builder;
- (STDProduct *)construct;
- (STDProduct *)constructWithBuilder:(STDBuilder *)builder;
@end