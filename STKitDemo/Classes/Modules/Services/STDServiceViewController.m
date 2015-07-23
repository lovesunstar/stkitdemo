//
//  STDServiceViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 14-3-8.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDServiceViewController.h"

#import "STDRecordViewController.h"
#import "STDReaderViewController.h"
#import "STARootViewController.h"
#import "STDChatViewController.h"

@interface STDServiceViewController () <UISearchBarDelegate, UISearchDisplayDelegate>

@property(nonatomic, strong) NSArray *dataSource;

@end

@implementation STDServiceViewController

@dynamic dataSource;

- (instancetype)initWithStyle:(UITableViewStyle)tableViewStyle {
    self = [super initWithStyle:tableViewStyle];
    if (self) {
        NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:5];

        STDTableViewCellItem *item00 = [[STDTableViewCellItem alloc] initWithTitle:@"在线聊天" target:self action:@selector(chatActionFired)];
        STDTableViewSectionItem *section0 = [[STDTableViewSectionItem alloc] initWithSectionTitle:@"使用CoreData对聊天内容进行存储，并且封装了一些常用的气泡。PS:里面包含一个截图的功能，可以截长图哦～～" items:@[item00]];
        [dataSource addObject:section0];

        STDTableViewCellItem *item10 = [[STDTableViewCellItem alloc] initWithTitle:@"音频测试" target:self action:@selector(recordActionFired)];
        STDTableViewSectionItem *section1 =
            [[STDTableViewSectionItem alloc] initWithSectionTitle:@"使用AudioQueue封装了音频的录音，播放等功能，可以用于实时通话中。并且实现了音频的可视化分析，使用OpenGLES对可视化的效果进行展示" items:@[item10]];
        [dataSource addObject:section1];

        STDTableViewCellItem *item20 = [[STDTableViewCellItem alloc] initWithTitle:@"算法演示" target:self action:@selector(avcActionFired)];
        STDTableViewSectionItem *section2 =
            [[STDTableViewSectionItem alloc] initWithSectionTitle:@"由于本人算法实在太差，所以在学习算法的过程中，用了一种可视化，可理解的方式进行了学习。当然重点还是iOS方面动画序列的处理" items:@[ item20 ]];
        [dataSource addObject:section2];

        STDTableViewCellItem *item30 = [[STDTableViewCellItem alloc] initWithTitle:@"电子小说" target:self action:@selector(readerActionFired)];
        STDTableViewSectionItem *section3 = [[STDTableViewSectionItem alloc] initWithSectionTitle:@"使用CoreText+UIPageViewController完成的一个简易电子阅读器，封装了对文字的分页(每页显示多少文字)，做过电子书的你懂的。" items:@[ item30 ]];
        [dataSource addObject:section3];

        self.dataSource = dataSource;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"常用模块";

    if (self.st_sideBarController) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        button.frame = CGRectMake(0, 0, 60, 44);
        [button setImage:[UIImage imageNamed:@"nav_menu_normal.png"] forState:UIControlStateNormal];
        button.contentEdgeInsets = UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
        [button addTarget:self action:@selector(leftBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Identifier"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)chatActionFired {
    STDChatViewController *chatViewController = [[STDChatViewController alloc] initWithPageInfo:nil];
    chatViewController.hidesBottomBarWhenPushed = YES;
    [self.st_navigationController pushViewController:chatViewController animated:YES];
}

- (void)recordActionFired {
    STDRecordViewController *recordViewController = STDRecordViewController.new;
    [self.st_navigationController pushViewController:recordViewController animated:YES];
}

- (void)avcActionFired {
    STARootViewController *avc = [[STARootViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.st_navigationController pushViewController:avc animated:YES];
}

- (void)readerActionFired {
    STDReaderViewController *readerViewController = STDReaderViewController.new;
    [self.st_navigationController pushViewController:readerViewController animated:YES];
}

- (void)leftBarButtonItemAction:(id)sender {
    if (self.st_sideBarController.sideAppeared) {
        [self.st_sideBarController concealSideViewControllerAnimated:YES];
    } else {
        [self.st_sideBarController revealSideViewControllerAnimated:YES];
    }
}
@end
