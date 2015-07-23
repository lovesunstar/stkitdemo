//
//  STDLeftViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 13-11-20.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STDLeftViewController.h"

#import "STDAboutViewController.h"

@interface STDLeftViewController () <UITableViewDataSource, UITableViewDelegate, STLinkLabelDelegate>

@property(nonatomic, weak) UITableView  *tableView;

@property(nonatomic, strong) NSArray    *dataSource;

@end

@implementation STDLeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataSource = @[
            @{ @"title" : @"地图",
               @"image" : @"SideBarNearby" },
            @{ @"title" : @"组件",
               @"image" : @"tab_receipt" },
            @{ @"title" : @"服务",
               @"image" : @"tab_service" },
            @{ @"title" : @"我的",
               @"image" : @"tab_profile" }
        ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    CGRect rect = self.view.bounds;

    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 87)];
    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    headerView.image = [UIImage imageNamed:@"left_account_header.png"];
    headerView.contentMode = UIViewContentModeLeft;
    [self.view addSubview:headerView];

    rect.origin.y += 37;
    rect.size.height -= 77;
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Identifier"];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.scrollsToTop = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;

    STLinkLabel *linkLabel = [[STLinkLabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(rect) + 10, CGRectGetWidth(rect) - 40, 30)];
    linkLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    linkLabel.backgroundColor = [UIColor clearColor];
    linkLabel.delegate = self;
    linkLabel.font = [UIFont systemFontOfSize:15];
    //    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    linkLabel.text = @"<link href=\"stkit://current/about\">关于STKit</link> Copyright 2014";
    [self.view addSubview:linkLabel];

    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 49.5)];
    nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    nameLabel.font = [UIFont boldSystemFontOfSize:18.];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = @"STKitDemo";
    [tableHeaderView addSubview:nameLabel];
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, CGRectGetWidth(tableView.frame), 0.5)];
    separatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    separatorView.backgroundColor = [UIColor lightGrayColor];
    [tableHeaderView addSubview:separatorView];

    tableView.tableHeaderView = tableHeaderView;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];

    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with
// dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    NSDictionary *information = [self.dataSource objectAtIndex:indexPath.row];
    NSString *title = [information valueForKey:@"title"];
    NSString *imageName = [information valueForKey:@"image"];
    cell.textLabel.text = title;
    cell.textLabel.textColor = [UIColor st_colorWithRGB:0xACACAC];
    cell.textLabel.highlightedTextColor = [UIColor st_colorWithRGB:0xFF7300];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal.png", imageName]];
    cell.imageView.highlightedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_highlighted.png", imageName]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.st_sideBarController.selectedIndex = indexPath.row;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - STLinkLabelDelegate
- (void)linkLabel:(STLinkLabel *)linkLabel didSelectLinkObject:(STLinkObject *)linkObject {
    if ([linkObject.URL.absoluteString hasSuffix:@"about"]) {
        STDAboutViewController *aboutViewController = [[STDAboutViewController alloc] init];
        aboutViewController.hidesBottomBarWhenPushed = YES;
        [self.st_sideBarController.st_navigationController pushViewController:aboutViewController animated:YES];
    }
}

@end
