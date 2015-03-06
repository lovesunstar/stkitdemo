//
//  STDTextChatCell.m
//  STKitDemo
//
//  Created by SunJiangting on 13-12-18.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STDTextChatCell.h"
#import <STKit/STKit.h>
#import "STDMessage.h"

@interface STDTextChatCell () <STLinkLabelDelegate>

@end

@implementation STDTextChatCell


- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.chatView.frame =  CGRectMake(45, 0, 35, 43);
        
        NSString * bubbleImageName;
        CGRect contentFrame;
        if ([reuseIdentifier hasSuffix:@"left.identifier"]) {
            bubbleImageName = @"bubble_text_white.png";
            contentFrame = CGRectMake(20, 10, 2, 20);
        } else {
            bubbleImageName = @"bubble_text_green.png";
            contentFrame = CGRectMake(13, 10, 2, 20);
        }
        
        UIImage * bubbleImage = [[UIImage imageNamed:bubbleImageName] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 15, 10, 15) resizingMode:UIImageResizingModeStretch];
        [self.bubbleImageView setBackgroundImage:bubbleImage forState:UIControlStateNormal];
        [self.bubbleImageView addTarget:self action:@selector(bubbleImageViewTouchDown:) forControlEvents:UIControlEventTouchDown];
        [self.bubbleImageView addTarget:self action:@selector(bubbleImageViewTouchCancel:) forControlEvents:(UIControlEventTouchCancel | UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchDragExit | UIControlEventTouchDragOutside)];
        self.bubbleImageView.clipsToBounds = YES;
        
        STLinkLabel * linkLabel = [[STLinkLabel alloc] initWithFrame:contentFrame];
        linkLabel.font = [[STThemeManager currentTheme] themeValueForKey:@"STDChatViewFont" whenContainedIn:[STDTextChatCell class]];
        linkLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        linkLabel.backgroundColor = [UIColor clearColor];
        linkLabel.delegate = self;
        [self.chatView addSubview:linkLabel];
        self.chatContentView = linkLabel;
    }
    return self;
}


- (void) setMessage:(STDMessage *)message {
    [super setMessage:message];
    UILabel * chatTextView = (UILabel *) self.chatContentView;
    chatTextView.text = message.content;
}

- (void) bubbleImageViewTouchDown:(id) sender {
    [self performSelector:@selector(didClickText:) withObject:sender afterDelay:0.5];
}

- (void) bubbleImageViewTouchCancel:(id) sender {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(didClickText:) object:sender];
}

- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (BOOL) canPerformAction:(SEL)action withSender:(id)sender {
    if (![NSStringFromSelector(action) isEqualToString:@"copyMenuActionFired:"]) {
        return NO;
    }
    return YES;
}

- (void) copyMenuActionFired:(id) sender {
    UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.message.content;
}

- (void) didClickText:(id) sender {
    [self becomeFirstResponder];
    UIMenuItem * menuItem = [[UIMenuItem alloc] initWithTitle:@"拷贝" action:@selector(copyMenuActionFired:)];
    UIMenuController * menuController = [UIMenuController sharedMenuController];
    menuController.menuItems = @[menuItem];
    [menuController setTargetRect:self.bubbleImageView.frame inView:self.bubbleImageView.superview];
    [menuController setMenuVisible:YES animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
    });
    
}

@end
