//
//  STDSingleton.h
//  STKitDemo
//
//  Created by SunJiangting on 15-2-3.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STDesignPatterns.h"

@interface STDSingleton : NSObject <STDesignPatternsDelegate>

+ (instancetype)sharedInstance;

@property (nonatomic, copy)NSString *globalName;

- (void)printMemoryAddress;

@end
