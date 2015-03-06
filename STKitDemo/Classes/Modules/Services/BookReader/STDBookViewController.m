//
//  STDBookViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 13-12-31.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STDBookViewController.h"

#import "STRichView.h"

#import <STKit/STKit.h>

@interface STDBookViewController () {
}

@property(nonatomic, strong) STRichView *richView;

@property(nonatomic, strong) UIButton   *backButton;

@property(nonatomic, strong) UIButton   *touchedButton;

@end

@implementation STDBookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonCustomItem:STBarButtonCustomItemBack target:self action:@selector(backActionFired:)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:14.];
    titleLabel.textColor = [UIColor colorWithRGB:0xFF7300];
    titleLabel.text = [NSString stringWithFormat:@"第%ld页 共%ld页", (long)(self.page + 1), (long)self.total];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;

    self.navigationItem.rightBarButtonItem = nil;

    CGFloat delta = 0;
    if (STGetSystemVersion() >= 7) {
        delta = 20;
    }
    CGRect frame = self.view.bounds;
    frame.origin.y = delta;
    frame.size.height -= delta;

    self.richView = [[STRichView alloc] initWithFrame:frame];
    self.richView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.richView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.richView];
    self.richView.text = self.content;

    self.touchedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    self.touchedButton.frame = CGRectMake(40, 0, width - 80, CGRectGetHeight(self.view.bounds));
    self.touchedButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.touchedButton addTarget:self action:@selector(showNavigationViewFired:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.touchedButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.preferredNavigationBarHidden) {
        [self hideOverlayAnimated:NO];
    } else {
        [self showOverlayAnimated:NO];
    }
}

- (void)setContent:(NSString *)content {
    _content = content;
    if (self.isViewLoaded) {
        self.richView.text = content;
    }
}

- (void)showNavigationViewFired:(id)sender {
    [self performSelector:@selector(showOverlayIfNeeded) withObject:nil afterDelay:0.0f];
}

- (void)showOverlayAnimated:(BOOL)animated {
    [self setNavigationBarHidden:NO animated:animated];
}

- (void)hideOverlayAnimated:(BOOL)animated {
    [self setNavigationBarHidden:YES animated:animated];
}

- (void)showOverlayIfNeeded {
    BOOL visible = YES;
    if (!self.navigationBarHidden) {
        // 需要隐藏
        [self hideOverlayAnimated:YES];
        visible = NO;
    } else {
        // 需要显示
        [self showOverlayAnimated:YES];
        visible = YES;
    }

    if ([self.delegate respondsToSelector:@selector(navigationBarVisibleDidChangeTo:)]) {
        [self.delegate navigationBarVisibleDidChangeTo:visible];
    }
}

- (void)backActionFired:(id)sender {
    if ([self.delegate respondsToSelector:@selector(backViewController)]) {
        [self.delegate backViewController];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
