//
//  STPersistence.h
//  STKit
//
//  Created by SunJiangting on 13-12-8.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <STKit/Foundation+STKit.h>

typedef NS_ENUM(NSInteger, STPersistenceDirectory) {
    STPersistenceDirectoryDocument,  // document 目录
    STPersistenceDirectoryLibiary,   // Libiary  目录
    STPersistenceDirectoryCache,     // Cache 目录
    STPersistenceDirectoryTemporary, // 临时目录
};

ST_ASSUME_NONNULL_BEGIN

extern NSString *STPersistDocumentDirectory();
extern NSString *STPersistLibiaryDirectory();
extern NSString *STPersistCacheDirectory();
extern NSString *STPersistTemporyDirectory();

@interface STPersistence : NSObject

- (instancetype)initWithDirectory:(STPersistenceDirectory)directory
                          subpath:(STNULLABLE NSString *)subpath;

- (void)setValue:(STNULLABLE id)value forKey:(NSString *)key;

- (STNULLABLE id)valueForKey:(NSString *)key;
- (BOOL)containsValueForKey:(NSString *)key;

- (STNONNULL NSString *)cacheDirectory;
- (NSString *)cachedPathForKey:(NSString *)key;

@end

/// 通过以下方法创建的都会都会根据name来创建name.plist.相同name会被存储到单独的文件中
@interface STPersistence (STFileBased)

+ (instancetype)standardPersistence;

+ (instancetype)persistenceNamed:(STNULLABLE NSString *)name;

@end


@interface STPersistence (STPersistCreation)

+ (instancetype)documentPersistence;
+ (instancetype)libiaryPersistence;
+ (instancetype)tempoaryPersistence;
+ (instancetype)cachePersistence;

+ (instancetype)documentPersistenceWithSubpath:(STNULLABLE NSString *)subpath;
+ (instancetype)libiaryPersistenceWithSubpath:(STNULLABLE NSString *)subpath;
+ (instancetype)cachePersistenceWithSubpath:(STNULLABLE NSString *)subpath;
+ (instancetype)tempoaryPersistenceWithSubpath:(STNULLABLE NSString *)subpath;

@end

@interface STPersistence (STPersistenceClean)
- (unsigned long long)cachedSize;
- (void)calculateCacheSizeWithCompletionHandler:(void(^)(unsigned long long))completionHandler;
- (void)calculateCacheSizeInQueue:(STNULLABLE dispatch_queue_t)backgroundQueue completionHandler:(void(^)(unsigned long long))completionHandler;
/// 这个对 persistenceNamed的无效， persistenceNamed的需要使用reset/removeAllCachedValues来清空
- (void)removeCachedValuesSinceDate:(STNULLABLE NSDate *)date;
/// 
- (void)removeAllCachedValues;

@end
ST_ASSUME_NONNULL_END