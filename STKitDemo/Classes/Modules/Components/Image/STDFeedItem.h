//
//  STDFeedItem.h
//  STKitDemo
//
//  Created by SunJiangting on 14-9-26.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import <STKit/STKit.h>

@interface STDFeedItem : STObject

@property (nonatomic, copy)     NSString   *title;
@property (nonatomic, copy)     NSString   *thumbURLString;
@property (nonatomic, copy)     NSString   *imageURLString;
@property (nonatomic, assign)   CGFloat      width;
@property (nonatomic, assign)   CGFloat      height;
// 评分
@property (nonatomic, assign)   CGFloat      rate;

- (STImageItem *) imageItem;
@end
