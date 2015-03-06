//
//  STDFeedCell.m
//  STKitDemo
//
//  Created by SunJiangting on 14-9-26.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDFeedCell.h"
#import "STDFeedImageView.h"

@interface STDFeedHotView : UIView

@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UILabel     * textLabel;

@end

@implementation STDFeedHotView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 20)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.image = [UIImage imageNamed:@"feed_hot_icon"];
        [self addSubview:self.imageView];
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 4, 30, 16)];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor colorWithRGB: 0xFF7300];
        self.textLabel.font = [UIFont systemFontOfSize:14.];
        self.textLabel.text = @"Hot";
        [self addSubview:self.textLabel];
    }
    return self;
}

@end

const CGSize STDFeedCellDefaultSize = {50, 70};
const CGFloat    STDFeedCellAccessoryHeight = 30;
const UIEdgeInsets    STDFeedCellTitleContentInset = {5,5,10,5};

@interface STDFeedCell ()

@property (nonatomic, strong) UIImageView      * backgroundImageView;
@property (nonatomic, strong) UIView           * containerView;
@property (nonatomic, strong) UIView           * accessoryView;
@property (nonatomic, strong) STDFeedHotView   * hotView;

@end

@implementation STDFeedCell

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, STDFeedCellDefaultSize.width, STDFeedCellDefaultSize.height);
        self.contentView.frame = self.bounds;
        self.backgroundColor = [UIColor colorWithRGB:0xCCCCCC];
        
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(STDFeedCellContentInset.left, STDFeedCellContentInset.top, STDFeedCellDefaultSize.width - (STDFeedCellContentInset.left + STDFeedCellContentInset.right), STDFeedCellDefaultSize.height - (STDFeedCellContentInset.top + STDFeedCellContentInset.bottom))];
        self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundImageView.image = [[UIImage imageNamed:@"feed_cell_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 70, 20, 70) resizingMode:UIImageResizingModeStretch];
        self.backgroundImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.backgroundImageView];
        
        
        self.imageView = [[STDFeedImageView alloc] initWithFrame:CGRectZero];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        self.imageView.userInteractionEnabled = YES;
        self.imageView.placeholderImage = [UIImage imageNamed:@"product_default"];
        [self.backgroundImageView addSubview:self.imageView];
        
        self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
        self.containerView.backgroundColor = [UIColor clearColor];
        [self.backgroundImageView addSubview:self.containerView];
        
        self.titleLabel = [[STLabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.verticalAlignment = STVerticalAlignmentTop;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = [UIColor darkGrayColor];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.containerView addSubview:self.titleLabel];
        
        self.accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, STDFeedCellAccessoryHeight)];
        self.accessoryView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self.containerView addSubview:self.accessoryView];
        
        UIView * separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, STOnePixel())];
        separatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        separatorView.backgroundColor = [UIColor colorWithRGB:0xdddddd];
        [self.accessoryView addSubview:separatorView];
        
        self.hotView = [[STDFeedHotView alloc] initWithFrame:CGRectMake(5, 2, 60, STDFeedCellAccessoryHeight)];
        [self.accessoryView addSubview:self.hotView];
        
        UIImageView * coverView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 60)];
        coverView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        coverView.image = [[UIImage imageNamed:@"feed_cell_border"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15) resizingMode:UIImageResizingModeStretch];
        coverView.userInteractionEnabled = NO;
        [self.backgroundImageView addSubview:coverView];
    }
    return self;
}

- (void) setFeedItem:(STDFeedItem *)feedItem {
    if (_feedItem != feedItem) {
        [self.imageView setImageWithURLString:feedItem.thumbURLString];
        self.titleLabel.text = feedItem.title;
        _feedItem = feedItem;
    }
    [self reloadUI];
}

- (void) reloadUI {
    CGFloat width = CGRectGetWidth(self.frame) - STDFeedCellContentInset.left - STDFeedCellContentInset.right;
    CGFloat imageHeight = self.feedItem.height * width / self.feedItem.width;
    self.imageView.frame = CGRectMake(0, 0, width, imageHeight);
    self.containerView.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame), width, CGRectGetHeight(self.frame) - CGRectGetMaxY(self.imageView.frame));
    if (self.feedItem.title.length > 0) {
        self.titleLabel.frame = CGRectMake(STDFeedCellTitleContentInset.left, STDFeedCellTitleContentInset.top, CGRectGetWidth(self.containerView.frame) - STDFeedCellTitleContentInset.left - STDFeedCellTitleContentInset.right, CGRectGetHeight(self.containerView.frame) - STDFeedCellAccessoryHeight - STDFeedCellTitleContentInset.top - STDFeedCellTitleContentInset.bottom);
    }
}

+ (CGFloat) heightForCollectionCellWithFeedItem:(STDFeedItem *) feedItem constrainedToWidth:(CGFloat) _width {
    if (feedItem.width * feedItem.height == 0) {
        return 0;
    }
    CGFloat width = _width - STDFeedCellContentInset.left - STDFeedCellContentInset.right;
    CGFloat height = feedItem.height * width / feedItem.width + STDFeedCellContentInset.top + STDFeedCellContentInset.bottom;
    if (feedItem.title.length > 0) {
        CGFloat titleWidth = width - (STDFeedCellTitleContentInset.left + STDFeedCellTitleContentInset.right);
        CGFloat titleHeight = [feedItem.title heightWithFont:[UIFont systemFontOfSize:14] constrainedToWidth:titleWidth];
        height += (titleHeight + STDFeedCellTitleContentInset.top + STDFeedCellTitleContentInset.bottom);
    }
    height += STDFeedCellAccessoryHeight;
    return height;
}

@end

UIEdgeInsets const     STDFeedCellContentInset = {5, 5, 5, 5};