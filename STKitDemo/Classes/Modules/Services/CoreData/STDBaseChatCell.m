//
//  STDBaseChatCell.m
//  STKitDemo
//
//  Created by SunJiangting on 13-12-18.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STDBaseChatCell.h"

#import <QuartzCore/QuartzCore.h>
#import "STDMessage.h"
#import <STKit/STKit.h>

@implementation STDBaseChatCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, 320, 0);
        
        UIView * bkgView = UIView.new;
        self.backgroundView = bkgView;
        self.backgroundColor = [UIColor clearColor];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.selectedBackgroundView = UIView.new;
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        
        self.multipleSelectionBackgroundView = UIView.new;
        self.multipleSelectionBackgroundView.backgroundColor = [UIColor clearColor];
        
        self.chatView = [[UIView alloc] initWithFrame:CGRectZero];
        if ([reuseIdentifier hasSuffix:@"right.identifier"] || [reuseIdentifier hasSuffix:@"left.identifier"]) {
            self.avatarView = [[UIImageView alloc] initWithFrame:CGRectZero];
            CGRect avatarRect = CGRectMake(5, 2, 38, 38);
            if ([reuseIdentifier hasSuffix:@"right.identifier"]) {
                avatarRect = CGRectMake(CGRectGetWidth(self.bounds) - 43, 2, 38, 38);
                self.avatarView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                [self addSubview:self.avatarView];
                [self addSubview:self.chatView];
            } else {
                [self.contentView addSubview:self.avatarView];
                [self.contentView addSubview:self.chatView];
            }
            self.avatarView.frame = avatarRect;
        }
        
        
        self.bubbleImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bubbleImageView.frame = self.chatView.bounds;
        self.bubbleImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.bubbleImageView addTarget:self action:@selector(bubbleImageViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.chatView addSubview:self.bubbleImageView];
    }
    return self;
}

- (void) bubbleImageViewClicked:(id) sender {
    
}
- (void) setMessage:(STDMessage *)message {
    self.avatarView.image = [UIImage imageNamed:@"avatar72.png"];
    CGRect chatViewRect = CGRectFromString(message.chatViewRect);
    if (!CGRectIsEmpty(chatViewRect)) {
        if ((self.width - CGRectGetMaxX(chatViewRect) > 100 )&& [message.identifier hasSuffix:@"right.identifier"]) {
            chatViewRect.origin.x += ABS([UIScreen mainScreen].bounds.size.width - [UIScreen mainScreen].bounds.size.height);
        }
        self.chatView.frame = chatViewRect;
    }
    _message = message;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    self.avatarView.userInteractionEnabled = !editing;
    self.chatView.userInteractionEnabled = !editing;
    [super setEditing:editing animated:animated];
}


@end

NSString * const NXChatCellTextActivityIdentifier = @"chat.text.activity.identifier";

NSString * const NXChatCellTextLeftIdentifier = @"chat.text.left.identifier";
NSString * const NXChatCellTextRightIdentifier = @"chat.text.right.identifier";

NSString * const NXChatCellImageLeftIdentifier = @"chat.image.left.identifier";
NSString * const NXChatCellImageRightIdentifier = @"chat.image.right.identifier";

NSString * const NXChatCellQuoteLeftIdentifier = @"chat.quote.left.identifier";
NSString * const NXChatCellQuoteRightIdentifier = @"chat.quote.right.identifier";
