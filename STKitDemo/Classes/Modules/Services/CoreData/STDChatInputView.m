//
//  STDChatInputView.m
//  STKitDemo
//
//  Created by SunJiangting on 13-12-24.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STDChatInputView.h"

#import <STKit/STKit.h>

@interface STDChatInputView ()

@property (nonatomic, strong) UIButton      * pickButton;
@property (nonatomic, strong) UIButton      * sendButton;
@property (nonatomic, strong) UITextView    * textView;

@end

CGFloat const STChatInputViewDefaultHeight = 45;
const CGFloat STChatInputViewHorizontalMargin = 10;
const CGFloat STChatInputViewSendButtonWidth  = 50;

@implementation STDChatInputView

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.textView removeObserver:self forKeyPath:@"contentSize"];
}

- (instancetype) initWithSuperView:(UIView *)superView {
    
    CGFloat originY = CGRectGetHeight(superView.bounds) - STChatInputViewDefaultHeight;
    self = [super initWithFrame:CGRectMake(0, originY, CGRectGetWidth(superView.bounds), STChatInputViewDefaultHeight)];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        self.backgroundColor = [UIColor lightGrayColor];
        self.parentView = superView;
        
        CGFloat textWidth = CGRectGetWidth(superView.bounds) - STChatInputViewHorizontalMargin * 3 - STChatInputViewSendButtonWidth;
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(STChatInputViewHorizontalMargin, 7, textWidth, 30)];
        self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.textView.scrollsToTop = NO;
        self.textView.showsVerticalScrollIndicator = NO;
        self.textView.keyboardType = UIKeyboardTypeDefault;
        self.textView.returnKeyType = UIReturnKeyNext;
        if ([self.textView respondsToSelector:@selector(layoutManager)]) {
            self.textView.layoutManager.allowsNonContiguousLayout = NO;
        }
        [self addSubview:self.textView];
        
        self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sendButton.titleLabel.font = [[STThemeManager currentTheme] themeValueForKey:@"STInputSendButton" whenContainedIn:[self class]];
        [self.sendButton setTitle:@"Send" forState:UIControlStateNormal];
        self.sendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        [self.sendButton setBackgroundImage:[UIImage imageNamed:@"chat_input_send_normal.png"] forState:UIControlStateNormal];
        [self.sendButton setBackgroundImage:[UIImage imageNamed:@"chat_input_send_highlighted.png"] forState:UIControlStateHighlighted];
        self.sendButton.frame = CGRectMake(self.bounds.size.width - 60.0f,7,50,30);
        [self addSubview:self.sendButton];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        
        [self.textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (NSString *) text {
    return self.textView.text;
}

- (void) setText:(NSString *)text {
    self.textView.text = text;
    [self sizeToFit];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textView.contentInset = UIEdgeInsetsZero;
}

- (void) sizeToFit {
    CGSize size = self.textView.size;
    CGSize contentSize = self.textView.contentSize;
    if (contentSize.height < 30) {
        return;
    }
    BOOL changed = NO;
    CGFloat offset = 0;
    contentSize.height = MIN(70, contentSize.height);
    if (contentSize.height <= 70) {
        offset = contentSize.height - size.height;
        size.height = contentSize.height;
        changed = YES;
    }
    if (!changed) {
        return;
    }
    CGRect frame = self.frame;
    frame.origin.y -= offset;
    frame.size.height += offset;
    self.frame = frame;
}

- (BOOL) becomeFirstResponder {
    return [self.textView becomeFirstResponder];
}

- (BOOL) resignFirstResponder {
    BOOL resignFirstResponder = [super resignFirstResponder];
    return [self.textView resignFirstResponder] && resignFirstResponder;
}


- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context {
    if (object == self.textView) {
        CGSize size = self.textView.size;
        CGSize contentSize = self.textView.contentSize;
        if (contentSize.height < 30) {
            return;
        }
        BOOL changed = NO;
        CGFloat offset = 0;
        contentSize.height = MIN(70, contentSize.height);
        if (contentSize.height <= 70) {
            offset = contentSize.height - size.height;
            size.height = contentSize.height;
            changed = YES;
        }
        if (!changed) {
            return;
        }
        CGRect frame = self.frame;
        frame.origin.y -= offset;
        frame.size.height += offset;
        self.frame = frame;
        
        NSMutableDictionary * notificationUserInfo = [NSMutableDictionary dictionaryWithCapacity:2];
        [notificationUserInfo setValue:@(0.25) forKey:STDChatInputViewAnimationDurationUserInfoKey];
        [notificationUserInfo setValue:@([self isFirstResponder]) forKey:STDChatInputViewKeyboardHiddenUserInfoKey];
        [notificationUserInfo setValue:[NSValue valueWithCGRect:frame] forKey:STDChatInputViewFrameUserInfoKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:STDChatInputViewDidChangeNotification object:self userInfo:notificationUserInfo];
    }
    
}

- (void) keyboardWillShow:(NSNotification *) notification {
    NSDictionary * userInfo = notification.userInfo;
    CGRect keyboardFrame = [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat keyboardWidth = keyboardFrame.size.width;
    if (UIInterfaceOrientationIsLandscape(self.parentView.viewController.interfaceOrientation)) {
        keyboardFrame.size.width = keyboardFrame.size.height;
        keyboardFrame.size.height = keyboardWidth;
    }
    
    CGRect rect = self.frame;
    
    rect.origin.y = CGRectGetHeight(self.parentView.frame) - CGRectGetHeight(keyboardFrame) - rect.size.height;
    NSTimeInterval duration = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    
    UIViewAnimationCurve animationCurve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
	UIViewAnimationOptions options = UIViewAnimationCurveEaseIn | UIViewAnimationCurveEaseOut | UIViewAnimationCurveLinear;
    
	switch (animationCurve) {
		case UIViewAnimationCurveEaseInOut:
			options = UIViewAnimationOptionCurveEaseInOut;
			break;
		case UIViewAnimationCurveEaseIn:
			options = UIViewAnimationOptionCurveEaseIn;
			break;
		case UIViewAnimationCurveEaseOut:
			options = UIViewAnimationOptionCurveEaseOut;
			break;
		case UIViewAnimationCurveLinear:
			options = UIViewAnimationOptionCurveLinear;
			break;
		default:
            options = animationCurve << 16;
			break;
	}

    
    NSMutableDictionary * notificationUserInfo = [NSMutableDictionary dictionaryWithCapacity:2];
    [notificationUserInfo setValue:@(duration) forKey:STDChatInputViewAnimationDurationUserInfoKey];
    [notificationUserInfo setValue:@(NO) forKey:STDChatInputViewKeyboardHiddenUserInfoKey];
    [notificationUserInfo setValue:[NSValue valueWithCGRect:rect] forKey:STDChatInputViewFrameUserInfoKey];
    [notificationUserInfo setValue:@(options) forKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:STDChatInputViewDidChangeNotification object:self userInfo:notificationUserInfo];

    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        self.frame = rect;
    } completion:NULL];
}

- (void) keyboardWillHide:(NSNotification *) notification {
    NSDictionary * userInfo = notification.userInfo;
    
    UIViewAnimationCurve animationCurve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    
	UIViewAnimationOptions options = UIViewAnimationCurveEaseIn | UIViewAnimationCurveEaseOut | UIViewAnimationCurveLinear;
	switch (animationCurve) {
		case UIViewAnimationCurveEaseInOut:
			options = UIViewAnimationOptionCurveEaseInOut;
			break;
		case UIViewAnimationCurveEaseIn:
			options = UIViewAnimationOptionCurveEaseIn;
			break;
		case UIViewAnimationCurveEaseOut:
			options = UIViewAnimationOptionCurveEaseOut;
			break;
		case UIViewAnimationCurveLinear:
			options = UIViewAnimationOptionCurveLinear;
			break;
		default:
            options = animationCurve << 16;
			break;
	}
    
    CGRect rect = self.bounds;
    rect.origin.y = CGRectGetHeight(self.parentView.frame) - rect.size.height;
    NSTimeInterval duration = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    NSMutableDictionary * notificationUserInfo = [NSMutableDictionary dictionaryWithCapacity:2];
    [notificationUserInfo setValue:@(duration) forKey:STDChatInputViewAnimationDurationUserInfoKey];
    [notificationUserInfo setValue:@(YES) forKey:STDChatInputViewKeyboardHiddenUserInfoKey];
    [notificationUserInfo setValue:[NSValue valueWithCGRect:rect] forKey:STDChatInputViewFrameUserInfoKey];
    [notificationUserInfo setValue:@(options) forKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:STDChatInputViewDidChangeNotification object:self userInfo:notificationUserInfo];
  
    
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        self.frame = rect;
    } completion:NULL];
}

@end

NSString * const STDChatInputViewDidChangeNotification = @"STDChatInputViewDidChangeNotification";

NSString * const STDChatInputViewAnimationDurationUserInfoKey = @"STDChatInputViewAnimationDurationUserInfoKey";
NSString * const STDChatInputViewKeyboardHiddenUserInfoKey = @"STDChatInputViewKeyboardHiddenUserInfoKey";
NSString * const STDChatInputViewFrameUserInfoKey = @"STDChatInputViewFrameUserInfoKey";
