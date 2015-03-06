//
//  STDownloadViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 14-3-9.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDownloadViewController.h"
#import <STKit/STKit.h>
#import "STDAppDelegate.h"

#import "STAlertView.h"

@interface STDownloadViewController ()

@property (nonatomic, strong) UIImageView * imageView;

@property (nonatomic, strong) STRoundProgressView * roundProgressView;

@property (nonatomic, strong) NSString   * thumbURL;
@property (nonatomic, strong) NSString   * imageURL;

@end

@implementation STDownloadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        self.thumbURL = @"http://lovecard-photo.stor.sinaapp.com/D294D8DFA381405970FA52E579E8A7B2.jpg";
        self.imageURL = @"http://lovecard-photo.stor.sinaapp.com/735F748E2F2482591C1DFE1351E622E9.jpg";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"图片下载";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"弹框" target:self action:@selector(alertActionFired:)];
    
    UIView * containerView = [[UIView alloc] initWithFrame:CGRectMake(self.view.width / 2 - 120, 20, 240, 40)];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:containerView];
    
    self.edgesForExtendedLayout = (UIRectEdgeLeft | UIRectEdgeRight);
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 80, 40);
    [button addTarget:self action:@selector(downloadImage:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitle:@"点我下载" forState:UIControlStateNormal];
    [containerView addSubview:button];
    
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(160, 0, 80, 40);
    [button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button1 setTitle:@"清除缓存" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(cleanCache:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:button1];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width / 2 - 60, 80, 120, 120)];
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addTouchTarget:self action:@selector(seeBigImage:)];
    [self.view addSubview:self.imageView];
    
    
    self.roundProgressView = [[STRoundProgressView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    self.roundProgressView.center = self.imageView.center;
    self.roundProgressView.hidden = YES;
    [self.imageView addSubview:self.roundProgressView];
    
}

- (void)alertActionFired:(id)sender {
    STAlertView * alertView = [[STAlertView alloc] initWithMenuTitles:@"First", @"Second", @"Third", nil];
    NSInteger result = [alertView showInView:self.view animated:YES];
    NSLog(@"============%ld", (long)result);
}

- (void) cleanCache:(id) sender {
    [STImageCache removeCacheImageForKey:self.thumbURL];
    [STImageCache removeCacheImageForKey:self.imageURL];
    self.imageView.image = nil;
}

- (void) seeBigImage:(id) sender {
    if (self.imageView.image) {
        [STImagePresent presentImageView:self.imageView hdImageURL:self.imageURL];
    }
}

- (void) downloadImage:(id) sender {
    NSString * imageURL = self.thumbURL;
    if ([STImageCache hasCachedImageForKey:imageURL]) {
        __weak STDownloadViewController * weakSelf = self;
        [self.imageView setImageWithURLString:imageURL finishedHandler:^(UIImage *image, NSString * URLString, BOOL usingCache, NSError *error) {
            weakSelf.imageView.image = image;
        }];
        return;
    }
    
    __weak STDownloadViewController * weakSelf = self;
    self.roundProgressView.hidden = NO;
    self.roundProgressView.center = CGPointMake(self.imageView.bounds.size.width / 2, self.imageView.bounds.size.height / 2);
    [self.imageView setImageWithURLString:imageURL progressHandler:^(CGFloat completion) {
        weakSelf.roundProgressView.completion = completion;
    } finishedHandler:^(UIImage *image, NSString * URLString, BOOL usingCache, NSError *error) {
        weakSelf.roundProgressView.hidden = YES;
        weakSelf.imageView.image = image;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
