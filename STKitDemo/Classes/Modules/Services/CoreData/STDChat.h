//
//  STDChat.h
//  STKitDemo
//
//  Created by SunJiangting on 13-12-19.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum STDChatViewDirection {
    STDChatViewDirectionDefault  = 1,
    STDChatViewDirectionLeft     = STDChatViewDirectionDefault,
    STDChatViewDirectionRight    = 2
} STDChatViewDirection;

@class STDMessage;
@interface STDChat : NSObject

+ (NSDictionary *) availableTypeIdentifiers;
+ (NSString *)     identifierForMessageType:(int) messageType;

+ (CGRect) convertRect:(CGRect ) rect0
         fromDirection:(STDChatViewDirection) fromDirection
           toDirection:(STDChatViewDirection) toDirection;

+ (CGFloat) heightForMessageWithEntity:(STDMessage *) messageEntity
                            identifier:(NSString **) identifier
                          chatViewRect:(CGRect *) chatViewRect;

@end
