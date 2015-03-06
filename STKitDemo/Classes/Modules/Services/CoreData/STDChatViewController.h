//
//  STDChatViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 13-12-18.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

//#import "STDTableViewController.h"

#import <STKit/STKit.h>
#import <STDTableViewController.h>

extern NSString *const STDChatUserDefaultID;
extern NSString *const STDChatSystemDefaultID;

@interface STDChatViewController : STDTableViewController

- (id)initWithPageInfo:(NSDictionary *)pageInfo;

@end

@interface UITableView (STScrollToBottom)

- (void)scrollToBottomAnimated:(BOOL)animated;

@end