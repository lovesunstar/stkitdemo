//
//  STMenuView.h
//  STKitDemo
//
//  Created by SunJiangting on 14-3-24.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STMenuItem : NSObject

@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) UIImage *highlightedImage;
@property(nonatomic, strong) NSString *title;

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage title:(NSString *)title;
@end

@class STMenuView;

typedef void (^STMenuDismissHandler)(STMenuView *menuView, int dismissIndex);

@interface STMenuView : UIView

@property(nonatomic, strong) STMenuDismissHandler dismissHandler;
/// default initializer
- (instancetype)initWithDelegate:(id<NSObject>)delegate menuItem:(STMenuItem *)menuItem, ... NS_REQUIRES_NIL_TERMINATION;

- (instancetype)initWithDelegate:(id<NSObject>)delegate menuItems:(NSArray *)menuItems;

/// if view==nil, view = keyWindow
- (void)showInView:(UIView *)view animated:(BOOL)animated;
- (void)dismissAnimated:(BOOL)animated;

- (STMenuItem *)menuItemAtIndex:(NSUInteger)index;

@end

extern const CGSize STMenuItemImageSize;
