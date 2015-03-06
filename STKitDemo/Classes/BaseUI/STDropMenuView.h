//
//  STDropMenuView.h
//  STKitDemo
//
//  Created by SunJiangting on 14-8-14.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import <STKit/STKit.h>

@interface STDropMenuView : STPopoverView

- (instancetype) initWithMenuTitles:(NSString *) menuTitle, ... NS_REQUIRES_NIL_TERMINATION;

@property (nonatomic, strong) void (^ dismissHandler) (STDropMenuView * dropView, NSInteger index);

@end
