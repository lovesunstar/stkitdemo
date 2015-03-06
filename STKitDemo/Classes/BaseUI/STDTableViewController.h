//
//  STDTableViewController.h
//  STKitDemo
//
//  Created by SunJiangting on 13-12-27.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import <STKit/STKit.h>
#import "STDViewController.h"

@interface STDTableViewController : STModelViewController  <UITableViewDataSource, UITableViewDelegate>

- (instancetype)initWithStyle:(UITableViewStyle) tableViewStyle;

@property(nonatomic, readonly, strong) UITableView       *tableView;
@property(nonatomic, assign) BOOL clearsSelectionOnViewWillAppear;

@property(nonatomic, strong, readonly) STScrollDirector *scrollDirector;
@end
