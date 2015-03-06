//
//  STDChat.m
//  STKitDemo
//
//  Created by SunJiangting on 13-12-19.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STDChat.h"

#import "STDImage.h"
#import "STDMessage.h"
#import "STDEntityDefines.h"

#import <STKit/STKit.h>

#import "STDTextChatCell.h"

#import "STDUser.h"

const CGSize STDChatConstraintSize = {229, 9999999.0f};
const CGSize STDChatActivitySize   = {266, 9999999.0f};

const CGFloat STDImageMaxWidth     = 244;
const CGFloat STDImageMinWidth     = 60;
const CGFloat STDImageMaxHeight    = 303;
const CGFloat STDImageMinHeight    = 60;
const CGFloat STDImageRatio        = 1.8;

@implementation STDChat

+ (const NSArray *) supportedTypeIdentifiers {
    const NSArray * identifiers = @[@"chat.text", @"chat.image"];
    return identifiers;
}

+ (const NSDictionary *) availableTypeIdentifiers {
    const NSDictionary * identifiers = @{@"0":@"chat.text", @"1":@"chat.image", @"2":@"chat.sound"};
    return identifiers;
}

+ (NSString *)     identifierForMessageType:(int) messageType {
    if ([[[self class] availableTypeIdentifiers] valueForKey:[NSString stringWithFormat:@"%d", messageType]]) {
        return [[[self class] availableTypeIdentifiers] valueForKey:[NSString stringWithFormat:@"%d", messageType]];
    }
    return nil;
}

#pragma mark - Height Methods

+ (CGRect) convertRect:(CGRect ) rect0
         fromDirection:(STDChatViewDirection) fromDirection
           toDirection:(STDChatViewDirection) toDirection {
    if (fromDirection == toDirection) {
        return rect0;
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    if (fromDirection == STDChatViewDirectionLeft) {
        CGFloat margin = rect0.origin.x;
        CGFloat sizeWidth = rect0.size.width;
        rect0.origin.x = width - margin - sizeWidth;
        return rect0;
    } else {
        CGFloat margin = width - CGRectGetMaxX(rect0);
        rect0.origin.x = margin;
        return rect0;
    }
}

+ (CGFloat) heightForMessageWithEntity:(STDMessage *) message
                            identifier:(NSString **) identifier
                          chatViewRect:(CGRect *) chatViewRect {
    BOOL mine = [message.from.uid isEqualToString:@"97676901"];
    STDMessageType messageType = message.type;
    
    NSString * suffix = mine ? @"right.identifier":@"left.identifier";
    NSString * ids = [[self class] identifierForMessageType:messageType];
    BOOL supportId = [[[self class] supportedTypeIdentifiers] containsObject:ids];
    if (!supportId) {
        ids = [[[self class] supportedTypeIdentifiers] objectAtIndex:0];
    }
    NSString * idstr = [NSString stringWithFormat:@"%@.%@", ids, suffix];
    if (identifier) {
        *identifier = idstr;
    }
    CGFloat height;
    CGRect rect0 = CGRectZero;
    CGSize textSize, imageSize;
    switch (messageType) {
        case STDMessageTypeSound:
            height = 30;
            break;
        case STDMessageTypeImage:
            imageSize = [[self class] imageSizeFromMessageObject:message];
            rect0 = CGRectMake(45, 0, imageSize.width + 16, imageSize.height + 10);
            height = rect0.size.height;
            break;
        case STDMessageTypeText:
        default:
            /// 文本类型的高度计算。
            textSize = [self chatTextSize:message.content constrainedToSize:STDChatConstraintSize];
            rect0 = CGRectMake(45, 0, textSize.width, textSize.height);
            height = CGRectGetMaxY(rect0);
            break;
    }
    if (mine) {
        // 如果是自己发送的，则x轴对称
        rect0 = [[self class] convertRect:rect0 fromDirection:STDChatViewDirectionLeft toDirection:STDChatViewDirectionRight];
    }
    if (chatViewRect) {
        *chatViewRect = rect0;
    }
    return height;
}

+ (CGSize) chatTextSize:(NSString *) text constrainedToSize:(CGSize) constrainedSize {
    UIFont * font = [[STThemeManager currentTheme] themeValueForKey:@"STDChatViewFont" whenContainedIn:[STDTextChatCell class]];
    CGSize textSize = [text sizeWithFont:font constrainedToSize:constrainedSize paragraphStyle:nil];
    if (textSize.width > constrainedSize.width) {
        textSize.width = constrainedSize.width;
    }
    textSize.width += 33;
    if (textSize.height < 30) {
        textSize.height = 48;
    } else {
        textSize.height = textSize.height + 28;
    }
    return textSize;
}

#pragma mark - ImageSizeScale

+ (CGSize) imageSizeFromMessageObject:(STDMessage *) message {
    STDImage * image = message.image;
    CGFloat width = image.width / 2, height = image.height / 2;
    if (width > STDImageMaxWidth || height > STDImageMaxHeight) {
        if (height >= width) {
            if (height <= width * STDImageRatio) {
                if (width > STDImageMaxWidth) {
                    height = height * STDImageMaxWidth / width;
                    width = STDImageMaxWidth;
                }
            } else {
                if (width < STDImageMinWidth) {
                    width = STDImageMinWidth;
                    height = (float) (STDImageRatio * width);
                } else if (width < STDImageMaxWidth / STDImageRatio) {
                    height = (float) (width * STDImageRatio);
                } else {
                    if (width > STDImageMaxWidth) {
                        width = STDImageMaxWidth;
                    }
                    height = (float) (STDImageRatio * width);
                }
            }
        } else {
            if (width <= height * STDImageRatio) {
                if (width > STDImageMaxWidth) {
                    height = height * STDImageMaxWidth / width;
                    width = STDImageMaxWidth;
                }
            } else {
                if (height < STDImageMinHeight) {
                    height = STDImageMinHeight;
                    width = (float) (STDImageRatio * height);
                } else if (height < STDImageMaxWidth / STDImageRatio) {
                    width = (float) (height * STDImageRatio);
                } else {
                    if (width > STDImageMaxWidth) {
                        width = STDImageMaxWidth;
                    }
                    height = (float) (width / STDImageRatio);
                }
            }
        }
    } else {
        if (width < STDImageMinWidth) {
            height = height * STDImageMinWidth / width;
            width = STDImageMinWidth;
        }
        if (height < STDImageMinHeight) {
            width = width * STDImageMinHeight / height;
            height = STDImageMinHeight;
        }
        if (width > STDImageMaxWidth) {
            width = STDImageMaxWidth;
        }
        if (height > STDImageMaxHeight) {
            height = STDImageMaxHeight;
        }
    }
    
    if (floor(width) <= 0 || floor(height) <= 0) {
        width = STDImageMaxWidth;
        height = STDImageMaxWidth;
    }
    return CGSizeMake(width, height);
}

@end
