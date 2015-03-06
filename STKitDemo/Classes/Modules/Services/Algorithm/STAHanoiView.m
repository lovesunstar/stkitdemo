//
//  STAHanoiView.m
//  STBasic
//
//  Created by SunJiangting on 13-11-3.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STAHanoiView.h"

#import <UIKit/UIKit.h>

@interface STAHanoiView ()

@property (nonatomic, strong) UIView * columnView1;
@property (nonatomic, strong) UIView * columnView2;
@property (nonatomic, strong) UIView * columnView3;

@property (nonatomic, assign) CGFloat  baseWidth;
@property (nonatomic, assign) CGFloat  baseHeight;

@property (nonatomic, strong) NSMutableArray * hanoiViewArray;

@property (nonatomic, strong) NSMutableArray * columnHanoi1;
@property (nonatomic, strong) NSMutableArray * columnHanoi2;
@property (nonatomic, strong) NSMutableArray * columnHanoi3;

@property (nonatomic, assign) CGFloat hanoiHeight;
@property (nonatomic, assign) CGFloat verticalMargin;
@end

const NSInteger kSTDiskTagOffset = 100;

@implementation STAHanoiView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.baseWidth = CGRectGetWidth(frame) / 3;
        self.baseHeight = CGRectGetHeight(frame) * 2 / 3;
        
        self.columnView1 = [[UIView alloc] initWithFrame:CGRectMake( self.baseWidth * 0.5 - 3, CGRectGetHeight(frame) - self.baseHeight, 6, self.baseHeight)];
        self.columnView1.backgroundColor = [UIColor blackColor];
        [self addSubview:self.columnView1];
        
        self.columnView2 = [[UIView alloc] initWithFrame:CGRectMake( self.baseWidth * 1.5 - 3, CGRectGetHeight(frame) - self.baseHeight, 6,  self.baseHeight)];
        self.columnView2.backgroundColor = [UIColor blackColor];
        [self addSubview:self.columnView2];
        
        self.columnView3 = [[UIView alloc] initWithFrame:CGRectMake( self.baseWidth * 2.5 - 3, CGRectGetHeight(frame) - self.baseHeight, 6, self.baseHeight)];
        self.columnView3.backgroundColor = [UIColor blackColor];
        [self addSubview:self.columnView3];
        
        self.hanoiViewArray = [NSMutableArray arrayWithCapacity:3];
        
        self.columnHanoi1 = [NSMutableArray arrayWithCapacity:3];
        self.columnHanoi2 = [NSMutableArray arrayWithCapacity:3];
        self.columnHanoi3 = [NSMutableArray arrayWithCapacity:3];
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.frame;
    self.baseWidth = CGRectGetWidth(frame) / 3;
    self.baseHeight = CGRectGetHeight(frame) * 2 / 3;
    self.columnView1.frame = CGRectMake( self.baseWidth * 0.5 - 3, CGRectGetHeight(frame) - self.baseHeight, 6, self.baseHeight);
    self.columnView2.frame = CGRectMake( self.baseWidth * 1.5 - 3, CGRectGetHeight(frame) - self.baseHeight, 6,  self.baseHeight);
    self.columnView3.frame = CGRectMake(self.baseWidth * 2.5 - 3, CGRectGetHeight(frame) - self.baseHeight, 6, self.baseHeight);
    
    CGFloat height = MIN(self.baseHeight / _numberOfHanois, 15);
    self.hanoiHeight = height;
    CGFloat increment = MIN(30, (self.baseWidth - 20) / _numberOfHanois);
    [self.hanoiViewArray enumerateObjectsUsingBlock:^(UIView * subview, NSUInteger idx, BOOL *stop) {
        CGRect frame = subview.frame;
        frame.size.width = self.baseWidth - idx * increment;
        subview.frame = frame;
    }];
    
    [self.columnHanoi1 enumerateObjectsUsingBlock:^(UIView * subview, NSUInteger idx, BOOL *stop) {
        CGPoint center = subview.center;
        center.x = self.baseWidth * (0 + 0.5);
        CGFloat centerY = CGRectGetHeight(self.bounds) - idx * self.hanoiHeight - (self.hanoiHeight + 5) / 2 + 5;
        center.y = centerY;
        subview.center = center;
    }];
    
    [self.columnHanoi2 enumerateObjectsUsingBlock:^(UIView * subview, NSUInteger idx, BOOL *stop) {
        CGPoint center = subview.center;
        center.x = self.baseWidth * (1 + 0.5);
        CGFloat centerY = CGRectGetHeight(self.bounds) - idx * self.hanoiHeight - (self.hanoiHeight + 5) / 2 + 5;
        center.y = centerY;
        subview.center = center;
    }];
    
    [self.columnHanoi3 enumerateObjectsUsingBlock:^(UIView * subview, NSUInteger idx, BOOL *stop) {
        CGPoint center = subview.center;
        center.x = self.baseWidth * (2 + 0.5);
        CGFloat centerY = CGRectGetHeight(self.bounds) - idx * self.hanoiHeight - (self.hanoiHeight + 5) / 2 + 5;
        center.y = centerY;
        subview.center = center;
    }];
}

- (void) reloadHanoiView {
    [self.hanoiViewArray enumerateObjectsUsingBlock:^(UIView * subview, NSUInteger idx, BOOL *stop) {
        [subview removeFromSuperview];
    }];
    [self.hanoiViewArray removeAllObjects];
    [self.columnHanoi1 removeAllObjects];
    [self.columnHanoi2 removeAllObjects];
    [self.columnHanoi3 removeAllObjects];
    
    CGFloat height = MIN(self.baseHeight / _numberOfHanois, 15);
    self.hanoiHeight = height;
    CGFloat increment = MIN(30, (self.baseWidth - 20) / _numberOfHanois);
    for (int i = 0; i < _numberOfHanois; i ++) {
        CGFloat width = self.baseWidth - i * increment;
        CGFloat left = (self.baseWidth - width) / 2;
        CGFloat top = CGRectGetHeight(self.bounds) - (i + 1) * height + 5;
        UIView * hanoi = [[UIView alloc] initWithFrame:CGRectMake(left, top, width, height - 5)];
        hanoi.backgroundColor = [UIColor orangeColor];
        [self addSubview:hanoi];
        
        [self.hanoiViewArray addObject:hanoi];
        [self.columnHanoi1 addObject:hanoi];
    }
}

- (void) moveDiskAtIndex:(NSInteger) index
                toIndex:(NSInteger)  toIndex
                duration:(NSTimeInterval) duration
              completion:(void(^)(BOOL finished)) completion {
    NSMutableArray * array1, * array2 = nil;
    switch (index) {
        case 0:
            array1 = self.columnHanoi1;
            break;
        case 1:
            array1 = self.columnHanoi2;
            break;
        case 2:
            array1 = self.columnHanoi3;
            break;
        default:
            break;
    }
    switch (toIndex) {
        case 0:
            array2 = self.columnHanoi1;
            break;
        case 1:
            array2 = self.columnHanoi2;
            break;
        case 2:
            array2 = self.columnHanoi3;
            break;
        default:
            break;
    }
    UIView * view = [array1 lastObject];
    [array1 removeObject:view];
    CGPoint center = [self centerForHanoiAtColumn:toIndex];
    if (view) {
        [array2 addObject:view];   
    }
    
    [UIView animateWithDuration:duration animations:^{
        view.center = center;
    } completion:^(BOOL finished) {
        view.center = center;
        completion(finished);
    }];
}

- (void) setNumberOfHanois:(NSInteger)numberOfHanois {
    _numberOfHanois = numberOfHanois;
    [self reloadHanoiView];
}

- (CGPoint) centerForHanoiAtColumn:(NSInteger) column {
    NSArray * array = nil;
    switch (column) {
        case 0:
            array = self.columnHanoi1;
            break;
        case 1:
            array = self.columnHanoi2;
            break;
        case 2:
            array = self.columnHanoi3;
            break;
        default:
            break;
    }
    NSInteger count = array.count;
    CGFloat centerX = self.baseWidth * (column + 0.5);
    CGFloat centerY = CGRectGetHeight(self.bounds) - count * self.hanoiHeight - (self.hanoiHeight + 5) / 2 + 5;
    return CGPointMake(centerX, centerY);
}
@end
