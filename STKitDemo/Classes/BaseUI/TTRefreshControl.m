//
//  TTRefreshControl.m
//  STKitDemo
//
//  Created by SunJiangting on 15-4-2.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import "TTRefreshControl.h"
#import "TTLoadingView.h"

@interface TTRefreshControl ()

@property(nonatomic, strong) TTLoadingView *loadingView;

@end

@implementation TTRefreshControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.loadingView = [[TTLoadingView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.loadingView];
        self.minimumLoadingDuration = 2.0;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.loadingView.frame = self.bounds;
}

- (void)scrollViewDidChangeContentOffset:(CGPoint)contentOffset {
    CGFloat contentOffsetY = contentOffset.y;
    if (contentOffset.y < 0) {
        self.loadingView.completion = MIN(ABS(contentOffsetY) / self.threshold, 1);
    }
}

- (void)refreshControlDidChangedToState:(STRefreshControlState)refreshControlState {
    if (refreshControlState == STRefreshControlStateNormal) {
        [self.loadingView stopAnimating];
        self.loadingView.completion = 0;
    } else if (refreshControlState == STRefreshControlStateLoading) {
        self.loadingView.completion = 1.0;
        [self.loadingView startAnimating];
    }
}

@end
