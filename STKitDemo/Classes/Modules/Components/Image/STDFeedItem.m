//
//  STDFeedItem.m
//  STKitDemo
//
//  Created by SunJiangting on 14-9-26.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDFeedItem.h"

@implementation STDFeedItem

+ (NSDictionary *) relationship {
    return @{@"thumbURLString":@"thumb", @"imageURLString":@"photo"};
}

- (STImageItem *) imageItem {
    STImageItem * imageItem = [[STImageItem alloc] init];
    imageItem.imageURLString = self.imageURLString;
    imageItem.thumbURLString = self.thumbURLString;
    return imageItem;
}
@end
