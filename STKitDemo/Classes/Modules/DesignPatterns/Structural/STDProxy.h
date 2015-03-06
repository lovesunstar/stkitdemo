//
//  STDProxy.h
//  STKitDemo
//
//  Created by SunJiangting on 15-2-5.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import "STDesignPatterns.h"

@protocol STDPObject <NSObject>

- (void)methodA;
- (void)methodB;

@end

@interface STDPObject : NSObject <STDPObject>

@end

@interface STDProxy : NSObject <STDesignPatternsDelegate, STDPObject>

- (instancetype)initWithObject:(id<STDPObject>)object;

@end
