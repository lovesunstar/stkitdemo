//
//  STASortViewController.h
//  STBasic
//
//  Created by SunJiangting on 13-11-1.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STASortDefines.h"

#import "STDViewController.h"

typedef enum STArraySortType {
    STArraySortTypeBubbleSort = 1,
    STArraySortTypeSelectSort = 2,
    STArraySortTypeInsertSort = 3,
    STArraySortTypeQuickSort  = 5,
    STArraySortTypeMergeSort  = 6,  // k-路归并排序
} STArraySortType;

@interface STASortViewController : STDViewController

@property (nonatomic, assign) STArraySortType arraySortType;
@property (nonatomic, strong) NSArray       * sortArray;

@end
