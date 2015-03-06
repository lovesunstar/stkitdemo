//
//  STDNavigationSettingViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 14-8-17.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDNavigationSettingViewController.h"

@interface STDNavigationSettingViewController ()
@property (weak, nonatomic) IBOutlet UISlider *edgeSettingSlider;
@property (weak, nonatomic) IBOutlet UISlider *offsetSettingSlider;

@end

@implementation STDNavigationSettingViewController

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
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"导航设置";
    
    self.edgeSettingSlider.maximumValue = self.view.width;
    CGFloat value = [[[NSUserDefaults standardUserDefaults] valueForKey:@"STDNavigationDefaultEdgeOffset"] floatValue];
    self.edgeSettingSlider.value = value;
    
    CGFloat value1 = [[[NSUserDefaults standardUserDefaults] valueForKey:@"STDNavigationDefaultOffset"] floatValue];
    self.offsetSettingSlider.maximumValue = self.view.width;
    self.offsetSettingSlider.value = value1;
}

- (IBAction)navigationDistanceValueChanged:(UISlider *)sender {
    sender.value = (NSInteger) sender.value;
    [[NSUserDefaults standardUserDefaults] setValue:@(sender.value) forKey:@"STDNavigationDefaultEdgeOffset"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"STDNavigationDefaultEdgeOffset" object:nil];
}

- (IBAction)navigationOffsetValueChanged:(UISlider *)sender {
    sender.value = (NSInteger) sender.value;
    [[NSUserDefaults standardUserDefaults] setValue:@(sender.value) forKey:@"STDNavigationDefaultOffset"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"STDNavigationDefaultOffset" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
