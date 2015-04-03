//
//  STDLoadingView.h
//  STKitDemo
//
//  Created by SunJiangting on 15-4-2.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STDLoadingView : UIView

@property(nonatomic) CGFloat    completion;

- (void)startAnimating;
- (BOOL)isAnimating;
- (void)stopAnimating;
@end
