//
//  STTextView.h
//  STKit
//
//  Created by SunJiangting on 14-1-7.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <STKit/STLabel.h>
/// 提供了有placeHolder的文本输入框
@interface STTextView : UITextView

@property(STPROPERTYNONNULL nonatomic, strong, readonly) STLabel *placeholderLabel;
@property(STPROPERTYNULLABLE nonatomic, copy) NSString *placeholder;

@end
