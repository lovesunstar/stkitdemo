//
//  STDScrollViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 15-4-7.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import "STDScrollViewController.h"
#import "STDRefreshControl.h"
#import <objc/runtime.h>

@interface UIView (STDWebViewHeader)

@property(nonatomic) CGFloat    headerOffset;

@end

@implementation UIView (STDWebViewHeader)

static NSString *const STDViewHeaderOffsetKey = @"STDViewHeaderOffsetKey";
- (void)setHeaderOffset:(CGFloat)headerOffset {
    objc_setAssociatedObject(self, (__bridge const void *)(STDViewHeaderOffsetKey), @(headerOffset), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)headerOffset {
    NSNumber *value = objc_getAssociatedObject(self, (__bridge const void *)(STDViewHeaderOffsetKey));
    return [value floatValue];
}
@end

@interface STDWebView : UIWebView

@property(nonatomic, strong) UIView *webHeaderView;

@end

@implementation STDWebView

- (void)setWebHeaderView:(UIView *)webHeaderView {
    if (_webHeaderView) {
        [_webHeaderView removeFromSuperview];
    }
    _webHeaderView = webHeaderView;
    [self.scrollView addSubview:webHeaderView];
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        if (subview != webHeaderView) {
            subview.top += (webHeaderView.height - subview.headerOffset);
            subview.headerOffset = webHeaderView.height;
        }
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
}
@end

@interface STDScrollViewController () <UIWebViewDelegate, UIScrollViewDelegate>

@property(nonatomic, strong) UIView *headerView;

@property(nonatomic, strong) STDWebView *webView;
@property(nonatomic, strong) STScrollDirector *scrollDirector;

@end

@implementation STDScrollViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.scrollDirector = [[STScrollDirector alloc] init];
        STDRefreshControl *refreshControl = [[STDRefreshControl alloc] initWithFrame:CGRectMake(0, 0, 200, 76)];
        refreshControl.threshold = 76;
        self.scrollDirector.refreshControl = refreshControl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"WebViewHeaderView";
    
    self.headerView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.headerView.height = 200;
    self.headerView.backgroundColor = [UIColor redColor];
    
    self.webView = [[STDWebView alloc] initWithFrame:self.view.bounds];
                    
//                    CGRectMake(0, self.headerView.bottom, self.view.width, self.view.height - self.headerView.bottom)];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.webHeaderView = self.headerView;
//    [self.webView.scrollView.panGestureRecognizer addTarget:self action:@selector(_webScrollViewPanActionFired:)];
//    self.webView.delegate = self;
    [self.webView.scrollView addSubview:self.headerView];
    self.webView.scrollView.delegate = self;
    
    
    [self.view addSubview:self.webView];
//    [self.view addSubview:self.headerView];

//    self.scrollDirector.scrollView = self.webView.scrollView;
//    [self.scrollDirector.refreshControl addTarget:self.webView action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://suenblog.duapp.com"]]];
}

- (void)_webScrollViewPanActionFired:(UIPanGestureRecognizer *)panGestureRecognizer {
    if (panGestureRecognizer.state != UIGestureRecognizerStateChanged) {
        return;
    }
    UIScrollView *scrollView = self.webView.scrollView;
    CGPoint contentOffset = scrollView.contentOffset;
    CGFloat offsetY = contentOffset.y;
    if (offsetY <= 0) {
        self.webView.top = - offsetY + self.headerView.height;
        self.headerView.top = - offsetY;
    } else if (offsetY >= self.headerView.height) {
        self.webView.top = 0;
        self.webView.height = self.view.height;
        self.headerView.top = - offsetY;
        contentOffset.y = offsetY - self.headerView.height;
        
    } else {
        self.webView.top = self.headerView.height - offsetY;
        self.headerView.top = - offsetY;
        self.webView.height = self.view.height - self.headerView.bottom;
        contentOffset.y = 0;
    }
    scrollView.contentOffset = contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    return;
    CGPoint contentOffset = scrollView.contentOffset;
    CGFloat offsetY = contentOffset.y;
    if (offsetY <= 0) {
        self.webView.top = - offsetY + self.headerView.height;
        self.headerView.top = - 2 * offsetY;
//        contentOffset.y = 0;
    } else if (offsetY >= self.headerView.height) {
        self.webView.top = 0;
        self.webView.height = self.view.height;
        self.headerView.top = - offsetY;
        
    } else {
        self.webView.top = self.headerView.height - offsetY;
        self.headerView.top = - 2 * offsetY;
        self.webView.height = self.view.height - self.headerView.bottom;
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.scrollDirector.refreshControl endRefreshing];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.scrollDirector.refreshControl endRefreshing];
}

@end
