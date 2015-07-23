//
//  STDropMenuView.m
//  STKitDemo
//
//  Created by SunJiangting on 14-8-14.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDropMenuView.h"

@interface _STDropMenuCell : UITableViewCell

@property(nonatomic, strong) UILabel    *titleLabel;
@property(nonatomic, strong) UIView     *separatorView;

@end

const CGFloat _STDropMenuCellHeight = 45;

@implementation _STDropMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, 320, _STDropMenuCellHeight);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 44)];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.titleLabel.textColor = [UIColor darkGrayColor];
        self.titleLabel.highlightedTextColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:17.];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];

        self.separatorView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.separatorView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.separatorView.frame = CGRectMake(0, CGRectGetHeight(frame) - STOnePixel(), CGRectGetWidth(frame), STOnePixel());
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.separatorView.backgroundColor = [UIColor st_colorWithRGB:0x999999];
}

@end

@interface STDropMenuView () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSMutableArray *dataSource;
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation STDropMenuView

- (instancetype)initWithMenuTitles:(NSString *)menuTitle, ... NS_REQUIRES_NIL_TERMINATION {
    NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:1];
    NSString *title = nil;
    va_list args;
    if (menuTitle) {
        [dataSource addObject:menuTitle];
        va_start(args, menuTitle);
        while ((title = va_arg(args, NSString *))) {
            [dataSource addObject:title];
        }
        va_end(args);
    }
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.dataSource = dataSource;
        self.contentOffset = CGPointMake(0, 64);
        self.direction = STPopoverViewDirectionDown;
        CGFloat maxHeight = 240;
        const CGFloat footerHeight = 1;
        CGFloat height = dataSource.count * _STDropMenuCellHeight + footerHeight;

        STTableView *tableView = [[STTableView alloc]
            initWithFrame:CGRectMake(0, STOnePixel(), CGRectGetWidth([UIScreen mainScreen].applicationFrame), MIN(height, maxHeight))
                    style:UITableViewStylePlain];
        tableView.scrollsToTop = NO;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.userInteractionEnabled = YES;
        [tableView registerClass:[_STDropMenuCell class] forCellReuseIdentifier:@"Identifier"];
        [self.contentView addSubview:tableView];
        self.tableView = tableView;

        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, footerHeight)];
        tableView.tableFooterView.backgroundColor = [UIColor st_colorWithRGB:0xFF7300];

        if (height > maxHeight) {
            tableView.scrollEnabled = YES;
        } else {
            tableView.scrollEnabled = NO;
        }
    }
    return self;
}

- (void)showInView:(UIView *)view animated:(BOOL)animated {
    [super showInView:view animated:YES];
    self.tableView.contentInset = UIEdgeInsetsZero;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _STDropMenuCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _STDropMenuCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    tableViewCell.titleLabel.text = self.dataSource[indexPath.row];
    return tableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissAnimated:YES];
    if (self.dismissHandler) {
        self.dismissHandler(self, indexPath.row);
    }
}

@end
