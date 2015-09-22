//
//  STNavigationBar.h
//  STKit
//
//  Created by SunJiangting on 14-2-18.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <STKit/STDefines.h>

ST_ASSUME_NONNULL_BEGIN
@interface STNavigationBar : UIView

@property(STPROPERTYNULLABLE nonatomic, copy) NSString    *title;
@property(STPROPERTYNULLABLE nonatomic, strong) UIView    *leftBarView;
@property(STPROPERTYNULLABLE nonatomic, strong) UIView    *titleView;
@property(STPROPERTYNULLABLE nonatomic, strong) UIView    *rightBarView;

@property(nonatomic, strong, readonly) UIView *transitionView;
@property(STPROPERTYNULLABLE nonatomic, strong) UIImage          *backgroundImage;

@property(nonatomic, strong, readonly) UIView *separatorView;

@property(STPROPERTYNULLABLE nonatomic, strong) UIColor          *barTintColor;

@property(STPROPERTYNULLABLE nonatomic, copy) NSDictionary       *titleTextAttributes;

@property(nonatomic,assign,getter=isTranslucent) BOOL translucent;

@end
ST_ASSUME_NONNULL_END

typedef NS_ENUM(NSInteger, STBarButtonCustomItem) {
    STBarButtonCustomItemBack,
    STBarButtonCustomItemDismiss,
    STBarButtonCustomItemMore,
};

@interface UIBarButtonItem (STKit)

+ (STNULLABLE instancetype)backBarButtonItemWithTarget:(STNULLABLE id)target action:(STNULLABLE SEL)action;
- (STNULLABLE instancetype)initWithBarButtonCustomItem:(STBarButtonCustomItem)customItem target:(STNULLABLE id)target action:(STNULLABLE SEL)action;

- (STNULLABLE instancetype)initWithTitle:(STNULLABLE NSString *)title target:(STNULLABLE id)target action:(STNULLABLE SEL)action;

- (STNULLABLE instancetype)initWithTitle:(STNULLABLE NSString *)title tintColor:(STNULLABLE UIColor *)tintColor target:(STNULLABLE id)target action:(STNULLABLE SEL)action;

- (STNULLABLE UIView *)st_customView;
@end
