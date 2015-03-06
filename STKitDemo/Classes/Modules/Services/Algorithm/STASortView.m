//
//  STASortView.m
//  STBasic
//
//  Created by SunJiangting on 13-11-2.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STASortView.h"

const NSInteger kSTSortElementTagOffset = 100;

@interface STASortView ()

@property (nonatomic, strong) NSMutableArray * elementViewArray;

@property (nonatomic, strong) UIView * baseline1;
@property (nonatomic, strong) UIView * baseline2;

@property (nonatomic, assign) CGFloat  baseWidth;

@property (nonatomic, weak)   UIView * cacheView;

- (UIView *) viewAtIndex:(NSInteger) index;
- (CGFloat)  frameXAtIndex:(NSInteger) index;

@end

@implementation STASortView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.factor = 5;
        self.elementViewArray = [NSMutableArray arrayWithCapacity:5];
        
        self.baseline1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, CGRectGetHeight(frame))];
        self.baseline1.backgroundColor = [UIColor blueColor];
        [self addSubview:self.baseline1];
        
        self.baseline2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, CGRectGetHeight(frame))];
        self.baseline2.backgroundColor = [UIColor greenColor];
        [self addSubview:self.baseline2];
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    if (self.elementViewArray.count == 0) {
        return;
    }
    CGRect frame = self.frame;
    int width = CGRectGetWidth(self.bounds) / self.elementViewArray.count;
    self.baseWidth = width;
    self.baseline1.frame = CGRectMake(0, 0, 2, CGRectGetHeight(frame));
    self.baseline2.frame = CGRectMake(0, 0, 2, CGRectGetHeight(frame));

    
    [self.elementViewArray enumerateObjectsUsingBlock:^(UIView * subview, NSUInteger idx, BOOL *stop) {
        CGRect frame = subview.frame;
        frame.origin.x = (idx + 0.5) * width;
        frame.origin.y = CGRectGetHeight(self.bounds) - frame.size.height;
        frame.size.width = MIN(30, width - 10);
        subview.frame = frame;
    }];
}

- (void) reloadSortDataSource:(NSArray *) dataSource {
    [self.elementViewArray enumerateObjectsUsingBlock:^(UIView * subView, NSUInteger idx, BOOL *stop) {
        [subView removeFromSuperview];
    }];
    [self.elementViewArray removeAllObjects];
    
    int width = CGRectGetWidth(self.bounds) / dataSource.count;
    self.baseWidth = width;
    
    self.baseline1.frame = CGRectMake(0.5 * width, 0, 2, CGRectGetHeight(self.bounds));
    self.baseline2.frame = CGRectMake(0.5 * width, 0, 2, CGRectGetHeight(self.bounds));
    
    [dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat height = [obj intValue] * self.factor;
        CGRect frame = CGRectZero;
        frame.origin = CGPointMake((idx + 0.5) * width, CGRectGetHeight(self.bounds) - height);
        CGFloat w = MIN(30, width - 10);
        frame.size = CGSizeMake(w, height);
        
        UIView * view = [[UIView alloc] initWithFrame:frame];
        view.backgroundColor = [UIColor blackColor];
        view.tag = idx + kSTSortElementTagOffset;
        [self addSubview:view];
        
        [self.elementViewArray addObject:view];
    }];
}

/// 基线表示参考线，用于表示 循环走到了哪个节点
- (void) moveBaseline1ToIndex:(NSInteger) index
                     duration:(NSTimeInterval) duration
                   completion:(void(^)(BOOL finished)) completion {
    CGFloat left = [self frameXAtIndex:index];
    CGRect  frame = self.baseline1.frame;
    frame.origin.x = left;
    [UIView animateWithDuration:duration animations:^{
        self.baseline1.frame = frame;
    } completion:^(BOOL finished) {
        self.baseline1.frame = frame;
        if (completion) {
            completion(finished);
        }
    }];
}

- (void) moveBaseline2ToIndex:(NSInteger) index
                     duration:(NSTimeInterval) duration
                   completion:(void(^)(BOOL finished)) completion {
    CGFloat left = [self frameXAtIndex:index];
    CGRect  frame = self.baseline2.frame;
    frame.origin.x = left;
    [UIView animateWithDuration:duration animations:^{
        self.baseline2.frame = frame;
    } completion:^(BOOL finished) {
        self.baseline2.frame = frame;
        if (completion) {
            completion(finished);
        }
    }];
}

/// 将某个位置的元素移动到另一个位置 比如 array[toIndex] = array[index]
- (void) moveElementAtIndex:(NSInteger) index
                    toIndex:(NSInteger) toIndex
                   duration:(NSTimeInterval) duration
                 completion:(void (^)(BOOL finished)) completion {
    
    UIView * subview = [self viewAtIndex:index];
    CGFloat left = [self frameXAtIndex:toIndex];
    CGRect frame = subview.frame;
    frame.origin.x = left;
    frame.origin.y = CGRectGetHeight(self.bounds) - CGRectGetHeight(subview.bounds);
    
    subview.tag = toIndex + kSTSortElementTagOffset;

    self.cacheView.tag = index + kSTSortElementTagOffset;
    
    [UIView animateWithDuration:duration animations:^{
        subview.frame = frame;
    } completion:^(BOOL finished) {
        subview.frame = frame;
        if (completion) {
            completion(finished);
        }
    }];
}

/// 将某一个位置的元素移动到缓冲区，比如 int temp = array[index]
- (void) moveElementToCacheAtIndex:(NSInteger) index
                          duration:(NSTimeInterval) duration
                        completion:(void(^)(BOOL finished)) completion {
    UIView * subview = [self viewAtIndex:index];
    CGRect frame = subview.frame;
    frame.origin.y = 0;
    
    [UIView animateWithDuration:duration animations:^{
        subview.frame = frame;
    } completion:^(BOOL finished) {
        subview.frame = frame;
        if (completion) {
             completion(finished);
        }
    }];
    self.cacheView = subview;
}

- (void) removeElementFromCacheWithDuration:(NSTimeInterval) duration
                                 completion:(void(^)(BOOL finished)) completion {
    CGRect frame = self.cacheView.frame;
    frame.origin.y = CGRectGetHeight(self.bounds) - CGRectGetHeight(self.cacheView.frame);
    frame.origin.x = [self frameXAtIndex:(self.cacheView.tag - kSTSortElementTagOffset)];
    [UIView animateWithDuration:duration animations:^{
        self.cacheView.frame = frame;
    } completion:^(BOOL finished) {
        self.cacheView.frame = frame;
        completion(finished);
    }];
    self.cacheView = nil;
    
}

/// 交换其中两个元素的位置 比如 int temp = array[index1];array[index1] = array[index2];array[index2] = temp;
- (void) exchangeElementAtIndex:(NSInteger) index1
             withElementAtIndex:(NSInteger) index2
                       duration:(NSTimeInterval) duration
                     completion:(void(^)(BOOL finished)) completion {
    
    UIView * subview1 = [self viewAtIndex:index1];
    UIView * subview2 = [self viewAtIndex:index2];
    
    CGRect frame1 = subview1.frame;
    CGRect frame2 = subview2.frame;
    
    frame1.origin.x = [self frameXAtIndex:index2];
    frame2.origin.x = [self frameXAtIndex:index1];
    
    subview1.tag = index2 + kSTSortElementTagOffset;
    subview2.tag = index1 + kSTSortElementTagOffset;
    
    [UIView animateWithDuration:duration animations:^{
        subview1.frame = frame1;
        subview2.frame = frame2;
    } completion:^(BOOL finished) {
        subview1.frame = frame1;
        subview2.frame = frame2;
        if (completion) {
            completion(finished);
        }
    }];
}

- (UIView *) viewAtIndex:(NSInteger) index {
    return [self viewWithTag:(index + kSTSortElementTagOffset)];
}

- (CGFloat)  frameXAtIndex:(NSInteger) index {
    return (index + 0.5) * self.baseWidth;
}
@end
