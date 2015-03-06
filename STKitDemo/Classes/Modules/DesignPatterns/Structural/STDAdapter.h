//
//  STDAdapter.h
//  STKitDemo
//
//  Created by SunJiangting on 15-2-4.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import "STDesignPatterns.h"


@protocol STDAdapter <NSObject>

- (void)AFRequestWithURLString:(NSString *)URLString;

@end

@interface STDASINetwork : NSObject

- (void)ASIRequestWithURLString:(NSString *)URLString;

@end

@interface STDAFNetwork : NSObject

- (void)AFRequestWithURLString:(NSString *)URLString;

@end

/// 适配器模式
@interface STDAdapter : STDASINetwork <STDAdapter, STDesignPatternsDelegate>

- (instancetype)initWithAFNetwork:(STDAFNetwork *)AFNetwork;

- (void)AFRequestWithURLString:(NSString *)URLString;

@end
