//
//  STDTextTableViewController.h
//  STKitDemo
//
//  Created by SunJiangting on 14-10-12.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDTableViewController.h"

@interface STDTableViewCellItem : STObject

- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@property(nonatomic, copy) NSString *title;
//// Cell 点击时的响应事件
@property(nonatomic, weak) id target;
/// action Must have zero argument like someRowClicked {}
@property(nonatomic, assign) SEL action;

@property(nonatomic, strong) id contextInfo;

@property(nonatomic) BOOL switchStyle;
@property(nonatomic) BOOL checked;

@end

@interface STDTableViewSectionItem : STObject

- (instancetype)initWithSectionTitle:(NSString *)title items:(NSArray *)items;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSArray *items;

@end

/// 内容都为文本，不做任何定制化的tableView
@interface STDTextTableViewController : STDTableViewController

/// 默认的dataSource， @see STDTableViewSectionItem
@property(nonatomic, copy) NSArray *dataSource;

@end
