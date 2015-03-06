//
//  STDMapViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 14-3-9.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDMapViewController.h"
#import <STKit/STKit.h>

@interface STDMapViewController ()

@end

@implementation STDMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"测试测试";
    self.customNavigationController.sideInteractionArea = STSideInteractiveAreaNavigationBar;
    self.edgesForExtendedLayout = (UIRectEdgeLeft | UIRectEdgeRight);
    if (self.sideBarController) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        button.frame = CGRectMake(0, 0, 60, 44);
        [button setImage:[UIImage imageNamed:@"nav_menu_normal.png"] forState:UIControlStateNormal];
        button.contentEdgeInsets = UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
        [button addTarget:self action:@selector(leftBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [[STLocationManager sharedManager] requestAlwaysAuthorization];

}


- (void) leftBarButtonItemAction:(id) sender {
    if (self.sideBarController.sideAppeared) {
        [self.sideBarController concealSideViewControllerAnimated:YES];
    } else {
        [self.sideBarController revealSideViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
