//
//  STDBaseChatCell.h
//  STKitDemo
//
//  Created by SunJiangting on 13-12-18.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STDMessage;

@interface STDBaseChatCell : UITableViewCell

@property (nonatomic, strong) UIImageView       * avatarView;
@property (nonatomic, strong) UIView            * chatView;
@property (nonatomic, strong) UIButton          * bubbleImageView;

/// This is abstract . subview must override this. default nil
@property (nonatomic, assign) UIView            * chatContentView;

@property (nonatomic, weak)   STDMessage        * message;

@end


extern NSString * const NXChatCellTextActivityIdentifier;

extern NSString * const NXChatCellTextLeftIdentifier;
extern NSString * const NXChatCellTextRightIdentifier;

extern NSString * const NXChatCellImageLeftIdentifier;
extern NSString * const NXChatCellImageRightIdentifier;

extern NSString * const NXChatCellQuoteLeftIdentifier;
extern NSString * const NXChatCellQuoteRightIdentifier;
