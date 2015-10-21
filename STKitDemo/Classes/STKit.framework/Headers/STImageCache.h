//
//  STImageCache.h
//  STKit
//
//  Created by SunJiangting on 13-12-17.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef long long STIdentifier;

extern NSString *STImageCacheDirectory();

extern STIdentifier STImageCacheBeginContext();
extern void STImageCachePushContext(STIdentifier contextId);
extern void STImageCachePopContext(STIdentifier contextId);

@class UIImage;
@interface STImageCache : NSObject
/// 将图片缓存到文件
/**
 * @abstract 将图片缓存到文件，读取时需要通过key。图片会存储在Document下的某一目录
 *
 * @param     image     需要缓存的图片
 * @param     key       一般为图片的URL
 */
+ (void)cacheImage:(UIImage *)image forKey:(NSString *)key;
+ (void)removeCacheImageForKey:(NSString *)key;

+ (void)removeMemoryCacheForKey:(NSString *)key;
+ (BOOL)hasMemoryCacheForKey:(NSString *)key;


+ (void)removeCachedImagesSinceDate:(NSDate *)date
                  completionHandler:(void(^)())completionHandler;

/**
 * @abstract 得到该key的图片缓存目录
 */
+ (NSString *)cachedPathForKey:(NSString *)key;
/// 是否有缓存该图片
+ (BOOL)hasCachedImageForKey:(NSString *)key;
+ (UIImage *)cachedImageForKey:(NSString *)key;

+ (void)cacheData:(NSData *)data forKey:(NSString *)key;
+ (NSData *)cachedDataForKey:(NSString *)key;

+ (unsigned long long)cacheSize;
/// default backgroundQueue / DISPATCH_QUEUE_PRIORITY_BACKGROUND
+ (void)calculateCacheSizeWithCompletionHandler:(void(^)(CGFloat))completionHandler;
+ (void)calculateCacheSizeInQueue:(dispatch_queue_t)backgroundQueue completionHandler:(void(^)(CGFloat))completionHandler;

@end
