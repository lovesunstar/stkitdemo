//
//  STDStartViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 14-2-20.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDStartViewController.h"
#import "STDAppDelegate.h"

@interface STDStartViewController ()

@end

@implementation STDStartViewController

- (void) dealloc {
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor st_colorWithRGB:0x35495D];
    
       UIImage *image = [UIImage imageNamed:@"aero_button"];
    UIButton *tabBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tabBarButton.translatesAutoresizingMaskIntoConstraints = NO;
    [tabBarButton setBackgroundImage:image forState:UIControlStateNormal];
    [tabBarButton setTitle:@"STTabBarController" forState:UIControlStateNormal];
    [tabBarButton addTarget:self action:@selector(enterTabBarControllerAction:) forControlEvents:UIControlEventTouchUpInside];
    tabBarButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:tabBarButton];
    
    UIButton * sideBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sideBarButton.translatesAutoresizingMaskIntoConstraints = NO;
    [sideBarButton setBackgroundImage:image forState:UIControlStateNormal];
    [sideBarButton setTitle:@"STSideBarController" forState:UIControlStateNormal];
    [sideBarButton addTarget:self action:@selector(enterSideBarControllerAction:) forControlEvents:UIControlEventTouchUpInside];
    sideBarButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:sideBarButton];
    
    NSDictionary *views = @{@"tabBarButton":tabBarButton, @"sideBarButton":sideBarButton};

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=10)-[tabBarButton(==40)]-10-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[tabBarButton(==140)]-(>=10)-[sideBarButton(tabBarButton)]-15-|" options:0 metrics:nil views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tabBarButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:sideBarButton attribute:NSLayoutAttributeTop multiplier:1. constant:0.]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tabBarButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:sideBarButton attribute:NSLayoutAttributeHeight multiplier:1. constant:0.]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(setStatusBarStyle:)]) {
        application.statusBarStyle = UIStatusBarStyleLightContent;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(setStatusBarStyle:)]) {
        application.statusBarStyle = UIStatusBarStyleDefault;
    }
}

- (void)enterTabBarControllerAction:(id) sender {
    STDAppDelegate *appDelegate = (STDAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate replaceRootViewController:[appDelegate tabBarController] animationOptions:UIViewAnimationOptionTransitionFlipFromLeft];
}

- (void)enterSideBarControllerAction:(id) sender {
    STDAppDelegate *appDelegate = (STDAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate replaceRootViewController:[appDelegate sideBarController] animationOptions:UIViewAnimationOptionTransitionFlipFromLeft];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end
