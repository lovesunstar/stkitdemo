//
//  STDTextTableViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 14-10-12.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDTextTableViewController.h"

@interface STDTextStyleCell : UITableViewCell

@property(nonatomic, strong) UISwitch *switchView;
@property(nonatomic, strong) STDTableViewCellItem *cellItem;

@end

@implementation STDTextStyleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.switchView = [[UISwitch alloc] init];
        self.accessoryView = self.switchView;
        [self.switchView addTarget:self action:@selector(_switchActionFired:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setCellItem:(STDTableViewCellItem *)cellItem {
    self.accessoryView = cellItem.switchStyle ? self.switchView : nil;
    self.selectionStyle = cellItem.switchStyle ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
    self.switchView.on = cellItem.checked;
    _cellItem = cellItem;
}

- (void)_switchActionFired:(UISwitch *)uiswitch {
    [self.cellItem.target st_performSelector:_cellItem.action withObjects:uiswitch, nil];
    self.cellItem.checked = uiswitch.on;
}

@end

@implementation STDTableViewCellItem

- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    self = [super init];
    if (self) {
        self.title = title;
        self.target = target;
        self.action = action;
    }
    return self;
}

@end

@implementation STDTableViewSectionItem

- (instancetype)initWithSectionTitle:(NSString *)title items:(NSArray *)items {
    self = [super init];
    if (self) {
        self.title = title;
        self.items = items;
    }
    return self;
}

@end

@interface STDTextTableViewController ()

@end

@implementation STDTextTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollDirector.refreshControl.enabled = NO;
    self.tableView.backgroundColor = [UIColor colorWithRGB:0xF5F5F5];
    [self.tableView registerClass:[STDTextStyleCell class] forCellReuseIdentifier:@"Identifier"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    STDTableViewSectionItem *sectionItem = [self.dataSource objectAtIndex:section];
    if ([sectionItem isKindOfClass:[STDTableViewSectionItem class]]) {
        return sectionItem.title;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    STDTableViewSectionItem *sectionItem = [self.dataSource objectAtIndex:section];
    if ([sectionItem isKindOfClass:[STDTableViewSectionItem class]]) {
        return sectionItem.items.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    STDTextStyleCell *tableViewCell = (STDTextStyleCell *)[tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    STDTableViewSectionItem *sectionItem = [self.dataSource objectAtIndex:indexPath.section];
    STDTableViewCellItem *item = sectionItem.items[indexPath.row];
    if ([item isKindOfClass:[STDTableViewCellItem class]]) {
        tableViewCell.textLabel.text = item.title;
        if ([tableViewCell isKindOfClass:[STDTextStyleCell class]]) {
            tableViewCell.cellItem = item;
        }
    } else {
        tableViewCell.textLabel.text = @"配置出现问题";
    }
    return tableViewCell;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (![view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        return;
    }
    UILabel *textLabel = ((UITableViewHeaderFooterView *)view).textLabel;
    STDTableViewSectionItem *sectionItem = [self.dataSource objectAtIndex:section];
    if ([sectionItem isKindOfClass:[STDTableViewSectionItem class]]) {
        textLabel.text = sectionItem.title;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    STDTableViewSectionItem *sectionItem = [self.dataSource objectAtIndex:indexPath.section];
    STDTableViewCellItem *item = sectionItem.items[indexPath.row];
    if ([item isKindOfClass:[STDTableViewCellItem class]] && [item.target respondsToSelector:item.action]) {
        [item.target st_performSelector:item.action withObjects:nil, nil];
    }
}

@end
