//
//  UIImageView+STImageLoader.h
//  STKit
//
//  Created by SunJiangting on 13-11-26.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import <STKit/STDefines.h>
#import <UIKit/UIKit.h>

#import "STImageLoader.h"

typedef NS_ENUM(NSInteger, STImageState) {
    STImageStateInitialized,
    STImageStateDownloading,
    STImageStateDownloadFinished,
    STImageStateDownloadFailed,
};
/// 图片加载
@interface UIImageView (STImageLoader)

@property(nonatomic, readonly, getter=st_isFinished) BOOL st_finished;

@property(nonatomic, strong, setter=st_setPlaceholderImage:, getter=st_placeholderImage) UIImage *st_placeholderImage;

@property(nonatomic, assign, readonly) STImageState st_state;

- (void)st_setImageWithURLString:(NSString *)URLString;

- (void)st_setImageWithURLString:(NSString *)URLString
                 finishedHandler:(STImageLoaderHandler)finishedHandler;

- (void)st_setImageWithURLString:(NSString *)URLString
                 progressHandler:(STImageProgressHandler)progressHandler
                 finishedHandler:(STImageLoaderHandler)finishedHandler;

- (void)st_cancelLoadImageWithURLString:(NSString *)URLString;

@end
