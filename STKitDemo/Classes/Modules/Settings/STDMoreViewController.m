//
//  STDMoreViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 13-12-27.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STDMoreViewController.h"

#import <STKit/STKit.h>

#import "STDAboutViewController.h"
#import "STDRecordViewController.h"
#import "STDReaderViewController.h"
#import "STARootViewController.h"
#import "STDAppDelegate.h"
#import "STDBigViewController.h"
#import "STDSettingViewController.h"

@interface STDMoreViewController ()

@property (nonatomic, strong) NSArray    * dataSource;

@end

@implementation STDMoreViewController

- (instancetype) initWithStyle:(UITableViewStyle)tableViewStyle {
    self = [super initWithStyle:tableViewStyle];
    if (self) {
        NSMutableArray * dataSource = [NSMutableArray arrayWithCapacity:5];

        STDTableViewCellItem *item00 = [[STDTableViewCellItem alloc] initWithTitle:@"豆瓣妹子" target:self action:@selector(_dbMeiziActionFired)];
        STDTableViewSectionItem *section0 = [[STDTableViewSectionItem alloc] initWithSectionTitle:@"" items:@[item00]];
        [dataSource addObject:section0];
        
        STDTableViewCellItem *item30 = [[STDTableViewCellItem alloc] initWithTitle:@"开源组件许可" target:self action:@selector(_openSourceLicenseActionFired)];
        STDTableViewCellItem *item31 = [[STDTableViewCellItem alloc] initWithTitle:@"关于STKit" target:self action:@selector(_aboutActionFired)];
        STDTableViewSectionItem * section3 = [[STDTableViewSectionItem alloc] initWithSectionTitle:@"" items:@[item30, item31]];
        [dataSource addObject:section3];
        
        STDTableViewCellItem *item40 = [[STDTableViewCellItem alloc] initWithTitle:@"退出" target:self action:@selector(_logoutActionFired)];
        STDTableViewSectionItem *section4 = [[STDTableViewSectionItem alloc] initWithSectionTitle:@"" items:@[item40]];
        [dataSource addObject:section4];

        self.dataSource = dataSource;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"更多介绍";
    
    [[STPersistence standardPersistence] setValue:@(YES) forKey:@"STHasEnteredAboutViewController"];
    
    if (self.customTabBarController) {
        [self.customTabBarController setBadgeValue:nil forIndex:2];
    }
    
    if (self.sideBarController) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        button.frame = CGRectMake(0, 0, 60, 44);
        [button setImage:[UIImage imageNamed:@"nav_menu_normal.png"] forState:UIControlStateNormal];
        button.contentEdgeInsets = UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
        [button addTarget:self action:@selector(_leftBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" target:self action:@selector(_settingActionFired:)];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Identifier"];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_settingActionFired:(id)sender {
    STDSettingViewController *settingViewController = [[STDSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
    settingViewController.hidesBottomBarWhenPushed = YES;
    [self.customNavigationController pushViewController:settingViewController animated:YES];
}

- (void)_dbMeiziActionFired {
    STDBigViewController * viewController = [[STDBigViewController alloc] init];
    [self.customNavigationController pushViewController:viewController animated:YES];
}

- (void)_aboutActionFired {
    STDAboutViewController * aboutViewController = [[STDAboutViewController alloc] initWithNibName:nil bundle:nil];
    [self.customNavigationController pushViewController:aboutViewController animated:YES];
}

- (void)_openSourceLicenseActionFired {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"licenses" ofType:@"html"];
    STWebViewController *webViewController;
    if (path) {
        webViewController = [[STWebViewController alloc] initWithContentsOfFile:path];
    } else {
        webViewController = [[STWebViewController alloc] initWithURLString:@"http://xstore.duapp.com/stkitdemo/licenses/"];
    }
    webViewController.hidesBottomBarWhenPushed = YES;
    webViewController.webViewBarHidden = YES;
    [self.customNavigationController pushViewController:webViewController animated:YES];
    
}

- (void)_logoutActionFired {
    STDAppDelegate * appDelegate = (STDAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate replaceRootViewController:[appDelegate startViewController] animationOptions:UIViewAnimationOptionTransitionFlipFromRight];
}

- (void)_leftBarButtonItemAction:(id)sender {
    if (self.sideBarController.sideAppeared) {
        [self.sideBarController concealSideViewControllerAnimated:YES];
    } else {
        [self.sideBarController revealSideViewControllerAnimated:YES];
    }
}
@end
