//
//  STTrashManager.h
//  STKit
//
//  Created by SunJiangting on 15/10/12.
//  Copyright © 2015年 SunJiangting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <STKit/STDefines.h>

@interface STTrashManager : NSObject

+ (instancetype)sharedManager;

@property(nonatomic) BOOL tryEmptyTrashWhenEnterBackground;
/// 移到废纸篓
- (BOOL)trashItemAtPath:(NSString *)path resultingItemPath:(NSString **)outResultingPath error:(NSError **)error;
/// 清空废纸篓
- (void)emptyTrashWithCompletionHandler:(void (^)(BOOL finished))completion;

/// caclulate all trash size synchronized, will block current thread
- (unsigned long long)trashSize;

- (void)calculateTrashSizeWithCompletionHandler:(void(^)(unsigned long long size))completionHandler;

- (BOOL)isEmptying;

- (void)cancel;

@end