//
//  STDScrollViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 15-4-7.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import "STDScrollViewController.h"

@interface STDScrollView ()

@end

@implementation STDScrollView


@end

@interface STDScrollViewController () <UIScrollViewDelegate>

@property(nonatomic, strong) UIView *headerView;

@property(nonatomic, strong) UIWebView *webView;

@end

@implementation STDScrollViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"WebViewHeaderView";
    
    self.headerView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.headerView.height = 200;
    self.headerView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.headerView];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.top = self.headerView.bottom;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.height = self.view.height - self.headerView.height;
    [self.view addSubview:self.webView];
    self.webView.scrollView.delegate = self;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://suenblog.duapp.com"]]];
    
    [self.view bringSubviewToFront:self.headerView];

    
    __weak STDScrollViewController *weakSelf = self;
    self.view.hitTestBlock = ^(CGPoint point, UIEvent *event, BOOL *returnSuper) {
        CGRect frame = weakSelf.headerView.frame;
        if (CGPointInRect(point, frame)) {
            point.y = weakSelf.webView.top + 1;
        }
        return [weakSelf.webView hitTest:[weakSelf.view convertPoint:point toView:weakSelf.webView] withEvent:event];
    };
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    self.webView.top = self.headerView.bottom;
    CGPoint contentOffset = scrollView.contentOffset;
    self.headerView.bottom = self.webView.top - contentOffset.y;
    if (contentOffset.y >= 0) {
        contentOffset.y = 0;
        self.webView.top = self.headerView.bottom;
        scrollView.contentOffset = contentOffset;
        self.webView.height = self.view.height - MAX(self.headerView.bottom, 0);
    } else {
        CGFloat targetY = self.webView.top - contentOffset.y;
        if (targetY <= 200) {
            self.webView.top = targetY;
            self.webView.height = self.view.height - MAX(0, targetY);
        }
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return YES;
}

@end
