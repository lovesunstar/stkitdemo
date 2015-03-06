//
//  STASortView.h
//  STBasic
//
//  Created by SunJiangting on 13-11-2.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "STASortDefines.h"

@interface STASortView : UIView

/// default 5
@property (nonatomic, assign) NSInteger factor;

- (void) reloadSortDataSource:(NSArray *) dataSource;

/// 基线表示参考线，用于表示 循环走到了哪个节点
- (void) moveBaseline1ToIndex:(NSInteger) index
                     duration:(NSTimeInterval) duration
                   completion:(void(^)(BOOL finished)) completion;

- (void) moveBaseline2ToIndex:(NSInteger) index
                     duration:(NSTimeInterval) duration
                   completion:(void(^)(BOOL finished)) completion;

/// 将某个位置的元素移动到另一个位置 比如 array[toIndex] = array[index]
- (void) moveElementAtIndex:(NSInteger) index
                    toIndex:(NSInteger) toIndex
                   duration:(NSTimeInterval) duration
                 completion:(void (^)(BOOL finished)) completion;

/// 将某一个位置的元素移动到缓冲区，比如 int temp = array[index]
- (void) moveElementToCacheAtIndex:(NSInteger) index
                          duration:(NSTimeInterval) duration
                        completion:(void(^)(BOOL finished)) completion;

- (void) removeElementFromCacheWithDuration:(NSTimeInterval) duration
                                 completion:(void(^)(BOOL finished)) completion;

/// 交换其中两个元素的位置 比如 int temp = array[index1];array[index1] = array[index2];array[index2] = temp;
- (void) exchangeElementAtIndex:(NSInteger) index1
             withElementAtIndex:(NSInteger) index2
                       duration:(NSTimeInterval) duration
                     completion:(void(^)(BOOL finished)) completion;
@end
