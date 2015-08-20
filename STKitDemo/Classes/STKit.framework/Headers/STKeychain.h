//
//  STKeychain.h
//  STKit
//
//  Created by SunJiangting on 15/6/28.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <STKit/STDefines.h>

ST_ASSUME_NONNULL_BEGIN
@interface STKeychain : NSObject

- (id)initWithIdentifier:(STNULLABLE NSString *)identifier accessGroup:(STNULLABLE NSString *)accessGroup NS_DESIGNATED_INITIALIZER;

- (void)setValue:(STNULLABLE id)value forKey:(NSString *)key;
- (STNULLABLE id)valueForKey:(NSString *)key;

- (void)removeAllValues;

@end

@interface STKeychainManager : NSObject

+ (instancetype)sharedManager;

- (void)setValue:(STNULLABLE id)value forKey:(NSString *)key;
- (STNULLABLE id)valueForKey:(NSString *)key;

@end
ST_ASSUME_NONNULL_END