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

@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) UIImage *selectedImage;

@property(nonatomic, strong) UIColor   *titleColor;
@property(nonatomic, strong) UIColor   *selectedTitleColor;
@property(nonatomic, strong) UIFont    *titleFont;

@property(nonatomic, copy) NSString *badgeValue;

@property(nonatomic, assign) CGRect imageFrame;
@property(nonatomic, assign) CGRect titleFrame;

@property(nonatomic, weak) UIView *itemView;
/// UITabBarItem
- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage;

@end
