//
//  STDNavigationSettingViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 14-8-17.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDNavigationSettingViewController.h"
#import "STDLoadingView.h"

@interface STDNavigationSettingViewController () {
    NSInteger   _startY;
}

@property (weak, nonatomic) IBOutlet UISlider *edgeSettingSlider;
@property (weak, nonatomic) IBOutlet UISlider *offsetSettingSlider;

@property(strong, nonatomic) IBOutlet STDLoadingView *loadingView;

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
    CGFloat value = [[[STPersistence standardPersistence] valueForKey:@"STDNavigationDefaultEdgeOffset"] floatValue];
    self.edgeSettingSlider.value = value;
    
    CGFloat value1 = [[[STPersistence standardPersistence] valueForKey:@"STDNavigationDefaultOffset"] floatValue];
    self.offsetSettingSlider.maximumValue = self.view.width;
    self.offsetSettingSlider.value = value1;
    
    
    _startY = self.loadingView.top;
}

- (IBAction)navigationDistanceValueChanged:(UISlider *)sender {
    sender.value = (NSInteger) sender.value;
    [[STPersistence standardPersistence] setValue:@(sender.value) forKey:@"STDNavigationDefaultEdgeOffset"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"STDNavigationDefaultEdgeOffset" object:nil];
}

- (IBAction)navigationOffsetValueChanged:(UISlider *)sender {
    sender.value = (NSInteger)sender.value;
    [[STPersistence standardPersistence] setValue:@(sender.value) forKey:@"STDNavigationDefaultOffset"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"STDNavigationDefaultOffset" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)offsetValueChanged:(UISlider *)sender {
    CGFloat maximumValue = sender.maximumValue;
    CGFloat minimumValue = sender.minimumValue;
    CGFloat completion = sender.value/(maximumValue - minimumValue);
    self.loadingView.completion = completion;
    self.loadingView.top = (_startY + completion * 76);
}

@end
