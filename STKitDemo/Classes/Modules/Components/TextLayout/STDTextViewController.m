//
//  STDTextViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 14-5-12.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDTextViewController.h"
#import <STkit/STKit.h>

@interface STDTextViewController ()

@property (nonatomic, strong) STLabel *linkLabel;

@end

@implementation STDTextViewController

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
    self.navigationItem.title = @"图文混排";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.linkLabel = [[STLabel alloc] initWithFrame:self.view.bounds];
    self.linkLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.linkLabel.numberOfLines = 0;
    self.linkLabel.backgroundColor = self.view.backgroundColor;
    self.linkLabel.verticalAlignment = STVerticalAlignmentTop;
    self.linkLabel.markedText = @"<mark color=ff0000 size=20>大家好</mark><mark color=000000 size=15>\t这里演示的是</mark><mark color=00ffff size=25>文字的排版。</mark><mark size=19>该段内容里面会包含</mark><mark size=20 color=ff2200 underline=single>下划线</mark><mark size=20 color=eeeeee>,</mark><mark size=20 color=999999 strikethrough=single>删除线</mark><mark size=20 color=000000>等等。</mark><mark size=22 color=ff7300>字体的颜色和大小也是可以随意调整的。</mark><mark size=18>这一期没有加入图片的排版</mark><mark color=ff0000 size=25>将会在下一期中加入。</mark>";
    self.linkLabel.contentInsets = UIEdgeInsetsMake(10, 5, 10, 10);
    [self.view addSubview:self.linkLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
