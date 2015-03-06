//
//  STAlertView.h
//  STKitDemo
//
//  Created by SunJiangting on 14-8-28.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STAlertView : UIView

- (instancetype)initWithMenuTitles:(NSString *)menuTitle, ... NS_REQUIRES_NIL_TERMINATION;

- (NSInteger)showInView:(UIView *)view animated:(BOOL)animated;

@end
