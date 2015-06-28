//
//  STPersistence.h
//  STKit
//
//  Created by SunJiangting on 13-12-8.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <STKit/Foundation+STKit.h>

typedef enum {
    STPersistenceDirectoryDocument,  // document 目录
    STPersistenceDirectoryLibiary,   // Libiary  目录
    STPersistenceDirectoryCache,     // Cache 目录
    STPersistenceDirectoryTemporary, // 临时目录
} STPersistenceDirectory;

extern NSString *STPersistDocumentDirectory();
extern NSString *STPersistLibiaryDirectory();
extern NSString *STPersistCacheDirectory();
extern NSString *STPersistTemporyDirectory();

@interface STPersistence : NSObject

- (instancetype)initWithDirectory:(STPersistenceDirectory)directory
                          subpath:(NSString *)subpath;

- (void)setValue:(id)value forKey:(NSString *)key;
- (id)valueForKey:(NSString *)key;

- (NSString *)cacheDirectory;

@end

/// 通过以下方法创建的都会都会根据name来创建name.plist.相同name会被存储到单独的文件中
@interface STPersistence (STFileBased)

+ (instancetype)standardPersistence;

+ (instancetype)persistenceNamed:(NSString *)name;

@end


@interface STPersistence (STPersistCreation)

+ (instancetype)documentPersistence;
+ (instancetype)libiaryPersistence;
+ (instancetype)tempoaryPersistence;
+ (instancetype)cachePersistence;

+ (instancetype)documentPersistenceWithSubpath:(NSString *)subpath;
+ (instancetype)libiaryPersistenceWithSubpath:(NSString *)subpath;
+ (instancetype)cachePersistenceWithSubpath:(NSString *)subpath;
+ (instancetype)tempoaryPersistenceWithSubpath:(NSString *)subpath;

@end

@interface STPersistence (STPersistenceClean)

/// 这个对 persistenceNamed的无效， persistenceNamed的需要使用reset/removeAllCachedValues来清空
- (void)removeCachedValuesSinceDate:(NSDate *)date;
/// 
- (void)removeAllCachedValues;

@end