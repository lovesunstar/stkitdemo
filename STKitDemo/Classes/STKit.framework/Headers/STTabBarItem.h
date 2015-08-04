//
//  STTabBarItem.h
//  STKit
//
//  Created by SunJiangting on 14-2-13.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <STKit/STDefines.h>
#import <STKit/UIKit+STKit.h>

@interface STTabBarItem : NSObject

@property(STPROPERTYNULLABLE nonatomic, copy)  NSString *title;
@property(STPROPERTYNULLABLE nonatomic, strong) UIImage *image;
@property(STPROPERTYNULLABLE nonatomic, strong) UIImage *selectedImage;

@property(STPROPERTYNULLABLE nonatomic, strong) UIColor   *titleColor;
@property(STPROPERTYNULLABLE nonatomic, strong) UIColor   *selectedTitleColor;
@property(STPROPERTYNULLABLE nonatomic, strong) UIFont    *titleFont;

@property(STPROPERTYNULLABLE nonatomic, copy) NSString *badgeValue;

@property(nonatomic, assign) CGRect imageFrame;
@property(nonatomic, assign) CGRect titleFrame;

@property(STPROPERTYNULLABLE nonatomic, weak) UIView *itemView;
/// UITabBarItem
- (STNONNULL instancetype)initWithTitle:(STNULLABLE NSString *)title
                        image:(STNULLABLE UIImage *)image
                selectedImage:(STNULLABLE UIImage *)selectedImage;

@end
