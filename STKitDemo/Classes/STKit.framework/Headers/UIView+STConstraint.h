//
//  UIView+STConstraint.h
//  STKit
//
//  Created by SunJiangting on 15-1-21.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <STKit/STDefines.h>

@interface UIView (STConstraint)

- (STNULLABLE NSArray *)st_constraintsWithFirstItem:(STNULLABLE UIView *)firstItem;
- (STNULLABLE NSArray *)st_constraintsWithFirstItem:(STNULLABLE UIView *)firstItem
                          firstAttribute:(NSLayoutAttribute)attribute;

@end
