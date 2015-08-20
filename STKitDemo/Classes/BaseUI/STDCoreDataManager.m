//
//  STDCoreDataManager.m
//  STKitDemo
//
//  Created by SunJiangting on 15/8/11.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import "STDCoreDataManager.h"

@implementation STDCoreDataManager

static STCoreDataManager *_chatDataManager;
+ (STCoreDataManager *)chatDataManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *modelName = @"STDModel";
        NSString *path = [STDocumentDirectory() stringByAppendingFormat:@"%@.sqlite", modelName];
        _chatDataManager = [[STCoreDataManager alloc] initWithModelName:modelName dbFilePath:path];
    });
    return _chatDataManager;
}

@end
