//
//  STDFeedImageView.m
//  STKitDemo
//
//  Created by SunJiangting on 14-9-26.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDFeedImageView.h"
#import <STKit/STKit.h>

@interface STDFeedImageView ()

@property (nonatomic, strong) UIView        * selectedView;

@end

@implementation STDFeedImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedView = [[UIView alloc] initWithFrame:self.bounds];
        self.selectedView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.selectedView.hidden = YES;
        self.selectedView.backgroundColor = [UIColor colorWithRGB:0x0 alpha:0.5];
        [self addSubview:self.selectedView];
    }
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.selectedView.hidden = NO;
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.selectedView.hidden = YES;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.selectedView.hidden = YES;
}

@end
