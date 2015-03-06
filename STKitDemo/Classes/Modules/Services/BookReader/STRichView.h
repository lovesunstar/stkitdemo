//
//  STRichView.h
//  STKitDemo
//
//  Created by SunJiangting on 13-6-5.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STRichView : UIView

@property (nonatomic, strong) UIColor * foregroundColor;
@property (nonatomic, strong) NSDictionary * attributes;

@property (nonatomic, copy)   NSString * text;
@end
