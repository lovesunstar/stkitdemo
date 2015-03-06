//
//  STDAboutAudioViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 14-5-10.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDAboutAudioViewController.h"
#import <STKit/STLinkLabel.h>

@interface STDAboutAudioViewController ()

@property (nonatomic, strong) STLinkLabel       * linkLabel;

@end

@implementation STDAboutAudioViewController

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
    self.navigationItem.title = @"关于音频";
    self.edgesForExtendedLayout = (UIRectEdgeLeft | UIRectEdgeRight);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    self.linkLabel = [[STLinkLabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), height)];
    self.linkLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.linkLabel.text = @"\n关于音频说明如下:\n\t本Demo只提供了录音的音频分析，音频播放部分正在建设中，会在以后的版本中提供。\n\t音频方面STKit是使用AudioQueue进行录制和播放的";
    [self.view addSubview:self.linkLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
