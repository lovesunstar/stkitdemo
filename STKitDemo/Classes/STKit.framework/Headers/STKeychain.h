//
//  STKeychain.h
//  STKit
//
//  Created by SunJiangting on 15/6/28.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STKeychain : NSObject

- (id)initWithIdentifier:(NSString *)identifier accessGroup:(NSString *)accessGroup NS_DESIGNATED_INITIALIZER;

- (void)setValue:(id)value forKey:(NSString *)key;
- (id)valueForKey:(NSString *)key;

- (void)removeAllValues;

@end

@interface STKeychainManager : NSObject

+ (instancetype)sharedManager;

- (void)setValue:(id)value forKey:(NSString *)key;
- (id)valueForKey:(NSString *)key;

@end
