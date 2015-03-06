//
//  STDFeedCell.h
//  STKitDemo
//
//  Created by SunJiangting on 14-9-26.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STDFeedItem.h"

@interface STDFeedCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) STLabel     * titleLabel;

@property (nonatomic, strong) STDFeedItem  * feedItem;
- (void) reloadUI;

+ (CGFloat) heightForCollectionCellWithFeedItem:(STDFeedItem *) feedItem constrainedToWidth:(CGFloat) width;

@end

extern UIEdgeInsets const    STDFeedCellContentInset;