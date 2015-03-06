//
//  STDStartViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 14-2-20.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDStartViewController.h"

#import "ZYQSphereView.h"
#import "STDAppDelegate.h"

@interface STDStartViewController ()

@property (nonatomic, strong) ZYQSphereView *sphereView;

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
    self.view.backgroundColor = [UIColor colorWithRGB:0x35495D];
    
    UILabel * topLabel = [[UILabel alloc] init];
    topLabel.numberOfLines = 0;
    topLabel.translatesAutoresizingMaskIntoConstraints = NO;
    topLabel.textColor = [UIColor whiteColor];
    topLabel.text = @"亲，目前STKit中包含了以下标签的实现。本着极客精神，标签会越来越多，你可以通过最下方的入口来查看Demo";
    topLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topLabel];
    
    NSArray *tags = @[@"导航", @"侧滑", @"标签", @"主题", @"列表", @"瀑布", @"图片", @"大图", @"链接", @"排版", @"菊花", @"音频", @"录音", @"音谱", @"存储", @"算法", @"相册", @"缓存", @"扩展", @"网络", @"下载", @"iOS7", @"手势", @"MVC"];
    
    self.sphereView = [[ZYQSphereView alloc] initWithFrame:CGRectMake(self.view.width * 0.5 - 150, self.view.height * 0.5 - 150, 300, 300)];
    self.sphereView.translatesAutoresizingMaskIntoConstraints = NO;

    NSMutableArray * items = [[NSMutableArray alloc] init];
    [tags enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *tagView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        tagView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100)/100. green:arc4random_uniform(100)/100. blue:arc4random_uniform(100)/100. alpha:1];
        [tagView setTitle:obj forState:UIControlStateNormal];
        tagView.layer.masksToBounds=YES;
        tagView.layer.cornerRadius=3;
        [tagView addTarget:self action:@selector(_tagButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [items addObject:tagView];
    }];
    [self.sphereView setItems:items];
	[self.view addSubview:self.sphereView];
    
    UIImage * image = [UIImage imageNamed:@"aero_button"];
    UIButton * tabBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
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
    
    NSDictionary * views = @{@"topLabel": topLabel , @"spereView":self.sphereView, @"tabBarButton":tabBarButton, @"sideBarButton":sideBarButton};

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[topLabel(>=300)]-10-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[spereView(==300)]" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[spereView(==300)]" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[topLabel(==70)]-(>=10)-[tabBarButton(==40)]-10-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[tabBarButton(==140)]-(>=10)-[sideBarButton(tabBarButton)]-15-|" options:0 metrics:nil views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tabBarButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:sideBarButton attribute:NSLayoutAttributeTop multiplier:1. constant:0.]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tabBarButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:sideBarButton attribute:NSLayoutAttributeHeight multiplier:1. constant:0.]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.sphereView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.sphereView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.sphereView timerStart];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIApplication * application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(setStatusBarStyle:)]) {
        application.statusBarStyle = UIStatusBarStyleLightContent;
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    UIApplication * application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(setStatusBarStyle:)]) {
        application.statusBarStyle = UIStatusBarStyleDefault;
    }
}

-(void)_tagButtonAction:(UIButton*)sender{
    BOOL isStart=[self.sphereView isTimerStart];
    [self.sphereView timerStop];
    [UIView animateWithDuration:0.3 animations:^{
        sender.transform=CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            sender.transform=CGAffineTransformMakeScale(1, 1);
            if (isStart) {
                [self.sphereView timerStart];
            }
        }];
    }];
}

- (void) enterTabBarControllerAction:(id) sender {
    [self.sphereView timerStop];
    STDAppDelegate * appDelegate = (STDAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate replaceRootViewController:[appDelegate tabBarController] animationOptions:UIViewAnimationOptionTransitionFlipFromLeft];
}

- (void) enterSideBarControllerAction:(id) sender {
    [self.sphereView timerStop];
    STDAppDelegate * appDelegate = (STDAppDelegate *)[UIApplication sharedApplication].delegate;
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
- (NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
