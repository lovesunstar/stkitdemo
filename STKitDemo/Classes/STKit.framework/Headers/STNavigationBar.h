//
//  STNavigationBar.h
//  STKit
//
//  Created by SunJiangting on 14-2-18.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import <UIKit/UIKit.h>
// UINavigationBar
@interface STNavigationBar : UIView

@property(nonatomic, copy) NSString           *title;
@property(nonatomic, strong) UIView           *leftBarView;
@property(nonatomic, strong) UIView           *titleView;
@property(nonatomic, strong) UIView           *rightBarView;

@property(nonatomic, strong, readonly) UIView *transitionView;
@property(nonatomic, strong) UIImage          *backgroundImage;

@property(nonatomic, strong, readonly) UIView *separatorView;

@property(nonatomic, strong) UIColor          *barTintColor;

@property(nonatomic, copy) NSDictionary       *titleTextAttributes;

@property(nonatomic,assign,getter=isTranslucent) BOOL translucent NS_AVAILABLE_IOS(3_0);

@end

typedef enum STBarButtonCustomItem {
    STBarButtonCustomItemBack,
    STBarButtonCustomItemDismiss,
    STBarButtonCustomItemMore,
} STBarButtonCustomItem;

@interface UIBarButtonItem (STKit)

+ (instancetype)backBarButtonItemWithTarget:(id)target action:(SEL)action;
- (instancetype)initWithBarButtonCustomItem:(STBarButtonCustomItem)customItem target:(id)target action:(SEL)action;

- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action;

- (instancetype)initWithTitle:(NSString *)title tintColor:(UIColor *)tintColor target:(id)target action:(SEL)action;

- (UIView *)st_customView;
@end

