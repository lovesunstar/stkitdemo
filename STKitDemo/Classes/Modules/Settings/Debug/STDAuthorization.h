//
//  STDAuthorization.h
//  STKitDemo
//
//  Created by SunJiangting on 13-11-28.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import <STKit/STDefines.h>
#import <Foundation/Foundation.h>

/**
 * @abstract 认证之后的操作
 */
typedef enum {
    STAuthorizationOperationNone,            // 认证失败之后不进行任何操作
    STAuthorizationOperationAlert  = 1 << 0,// 认证之后进行弹框提示
    STAuthorizationOperationBanner = 1 << 1,// 认证之后进行横幅提示
} STAuthorizationOperation;

/**
 * @abstract 自动认证的时机
 */
typedef enum {
    STAutomicAuthorizationNever,              // 从不进行自动认证
    STAutomicAuthorizationDidFinishLaunch,    // 应用每次启动的时候认证
    STAutomicAuthorizationDidEnterForeground, // 应用每次进入前台之后认证
} STAutomicAuthorizationTime;

@interface STDAuthorization : NSObject

+ (instancetype)standardAuthorization;

+ (void)setAuthorizationKey:(NSString *)authorizationKey;
+ (NSString *)authorizationKey;

+ (void)authorizationWithKey:(NSString *)key authorizationTime:(STAutomicAuthorizationTime)authorizationTime;

@end