//
//  STDNavigationTestViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 14-8-25.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDNavigationTestViewController.h"
#import "STDSettingViewController.h"

@interface STDNavigationTestViewController () <STNavigationControllerDelegate>

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation STDNavigationTestViewController

- (void)dealloc {
    
}

- (instancetype) initWithStyle:(UITableViewStyle)tableViewStyle {
    self = [super initWithStyle:tableViewStyle];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:2];
        
        STDTableViewCellItem *item00 = [[STDTableViewCellItem alloc] initWithTitle:@"Push一个有导航栏的" target:self action:@selector(_pushNHNBHSActionFired)];
        
        STDTableViewCellItem *item01 = [[STDTableViewCellItem alloc] initWithTitle:@"Push一个没有导航栏的" target:self action:@selector(_pushNHYBHSActionFired)];
        
        STDTableViewCellItem *item02 = [[STDTableViewCellItem alloc] initWithTitle:@"Push一个有TabBar的" target:self action:@selector(_pushNHSBHNActionFired)];
        
        STDTableViewCellItem *item03 = [[STDTableViewCellItem alloc] initWithTitle:@"Push一个没有TabBar的" target:self action:@selector(_pushNHSBHYActionFired)];
        STDTableViewSectionItem *section0 = [[STDTableViewSectionItem alloc] initWithSectionTitle:@"从屏幕最左侧右滑拖动可以返回，支持iOS6。"
                                                                                            items:@[item00, item01, item02, item03]];
        [dataSource addObject:section0];
        
        STDTableViewCellItem *item10 = [[STDTableViewCellItem alloc] initWithTitle:@"PopViewController" target:self action:@selector(_popViewControllerActionFired)];
        STDTableViewCellItem *item11 = [[STDTableViewCellItem alloc] initWithTitle:@"PopToRootViewController" target:self action:@selector(_popToRootViewControllerActionFired)];
        STDTableViewSectionItem *section1 = [[STDTableViewSectionItem alloc] initWithSectionTitle:@"PopViewController" items:@[ item10, item11]];
        [dataSource addObject:section1];

        self.dataSource = dataSource;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"测试导航";
    self.scrollDirector.refreshControl.enabled = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Identifier"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_popViewControllerActionFired {
    [self.customNavigationController popViewControllerAnimated:YES];
}

- (void)_popToRootViewControllerActionFired {
    [self.customNavigationController popToRootViewControllerAnimated:YES];
}

- (void)_pushNHNBHSActionFired {
    STDNavigationTestViewController * viewController = [[STDNavigationTestViewController alloc] initWithStyle:UITableViewStyleGrouped];
    viewController.navigationBarHidden = NO;
    viewController.hidesBottomBarWhenPushed = self.hidesBottomBarWhenPushed;
    [self.customNavigationController pushViewController:viewController animated:YES];
}

- (void)_pushNHYBHSActionFired {
    STDNavigationTestViewController * viewController = [[STDNavigationTestViewController alloc] initWithStyle:UITableViewStyleGrouped];
    viewController.navigationBarHidden = YES;
    viewController.hidesBottomBarWhenPushed = self.hidesBottomBarWhenPushed;
    [self.customNavigationController pushViewController:viewController animated:YES];
}

- (void)_pushNHSBHNActionFired {
    STDNavigationTestViewController * viewController = [[STDNavigationTestViewController alloc] initWithStyle:UITableViewStyleGrouped];
    viewController.navigationBarHidden = self.navigationBarHidden;
    viewController.hidesBottomBarWhenPushed = NO;
    [self.customNavigationController pushViewController:viewController animated:YES];
}

- (void)_pushNHSBHYActionFired {
    STDNavigationTestViewController * viewController = [[STDNavigationTestViewController alloc] initWithStyle:UITableViewStyleGrouped];
    viewController.navigationBarHidden = self.navigationBarHidden;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.customNavigationController pushViewController:viewController animated:YES];
}
@end
