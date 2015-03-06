//
//  STDChatInputView.h
//  STKitDemo
//
//  Created by SunJiangting on 13-12-24.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const STDChatInputViewDefaultHeight;

@interface STDChatInputView : UIView

@property (nonatomic, copy) NSString * text;
@property (nonatomic, weak) UIView * parentView;
@property (nonatomic, readonly, strong) UITextView * textView;

- (instancetype) initWithSuperView:(UIView *) superView;

@property (nonatomic, readonly, strong) UIButton * pickButton;
@property (nonatomic, readonly, strong) UIButton * sendButton;

- (NSString *) text;

- (void) sizeToFit;
@end

extern NSString * const STDChatInputViewDidChangeNotification;

extern NSString * const STDChatInputViewAnimationDurationUserInfoKey;
extern NSString * const STDChatInputViewKeyboardHiddenUserInfoKey;
extern NSString * const STDChatInputViewFrameUserInfoKey;
