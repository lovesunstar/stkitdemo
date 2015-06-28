//
//  STDSideBarController.m
//  STKitDemo
//
//  Created by SunJiangting on 13-11-20.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STDSideBarController.h"
#import "STARootViewController.h"

#import "STDMoreViewController.h"
#import "STDMapViewController.h"
#import "STDemoViewController.h"
#import "STDServiceViewController.h"

@interface STDSideBarController ()

@end

@implementation STDSideBarController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {

        STDMapViewController *mapViewController = STDMapViewController.new;
        STNavigationController *mapNavigationController = [[STNavigationController alloc] initWithRootViewController:mapViewController];

        STDemoViewController *controlsViewController = [[STDemoViewController alloc] initWithStyle:UITableViewStyleGrouped];
        STNavigationController *controlsNavigationController = [[STNavigationController alloc] initWithRootViewController:controlsViewController];

        STDServiceViewController *serviceViewController = [[STDServiceViewController alloc] initWithStyle:UITableViewStyleGrouped];
        STNavigationController *serviceNavigationController = [[STNavigationController alloc] initWithRootViewController:serviceViewController];

        STDMoreViewController *moreViewController = [[STDMoreViewController alloc] initWithStyle:UITableViewStyleGrouped];
        STNavigationController *moreNavigationController = [[STNavigationController alloc] initWithRootViewController:moreViewController];

        self.viewControllers = @[mapNavigationController, controlsNavigationController, serviceNavigationController, moreNavigationController];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
