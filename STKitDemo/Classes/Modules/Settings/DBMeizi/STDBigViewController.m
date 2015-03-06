//
//  STDBigViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 14-8-19.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDBigViewController.h"
#import "SUNSlideSwitchView.h"
#import "STDBeautyViewController.h"

@interface STDBigViewController () <SUNSlideSwitchViewDelegate>

@property (nonatomic, strong) IBOutlet SUNSlideSwitchView *slideSwitchView;

@property (nonatomic, strong) NSArray * dataSource;

@end

@implementation STDBigViewController

- (void) dealloc {
    
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSArray * configs = @[
                              @{@"title":@"所有", @"method":@"category/10"},
                              @{@"title":@"性感", @"method":@"category/1"},
                              @{@"title":@"有沟", @"method":@"category/2"},
                              @{@"title":@"美腿", @"method":@"category/3"},
                              @{@"title":@"小清新", @"method":@"category/11"},
                              @{@"title":@"文艺", @"method":@"category/12"},
                              @{@"title":@"美臀", @"method":@"category/14"},
                              ];
        NSMutableArray * dataSource = [NSMutableArray arrayWithCapacity:5];
        [configs enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
            STDBeautyViewController * viewController = [[STDBeautyViewController alloc] init];
            viewController.title = [obj valueForKey:@"title"];
            viewController.method = [obj valueForKey:@"method"];
            [dataSource addObject:viewController];
        }];
        self.dataSource = dataSource;
        self.hidesBottomBarWhenPushed = YES;
        self.customizeEdgeOffset = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"豆瓣妹子";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.slideSwitchView = [[SUNSlideSwitchView alloc] initWithFrame:self.view.bounds];
    self.slideSwitchView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.slideSwitchView.tabItemNormalColor = [UIColor colorWithRGB:0x868686];
    self.slideSwitchView.tabItemSelectedColor = [UIColor colorWithRGB:0xbb0b15];
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"red_line_and_shadow.png"]
                                        stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    self.slideSwitchView.slideSwitchViewDelegate = self;
    [self.slideSwitchView buildUI];
    [self.view addSubview:self.slideSwitchView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view {
    return self.dataSource.count;
}

- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number {
    if (number >= self.dataSource.count) {
        return nil;
    }
    return self.dataSource[number];
}

static STDBeautyViewController * previousViewController;
- (void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number {
    if (number >= self.dataSource.count) {
        return;
    }
    [previousViewController cancelFetchData];
    STDBeautyViewController * beautyViewController = self.dataSource[number];
    [beautyViewController fetchDataFromRemote];
    previousViewController = beautyViewController;

}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.dataSource enumerateObjectsUsingBlock:^(UIViewController * obj, NSUInteger idx, BOOL *stop) {
        if (obj.isViewLoaded) {
            [obj didRotateFromInterfaceOrientation:fromInterfaceOrientation];
        }
    }];
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [previousViewController viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.dataSource enumerateObjectsUsingBlock:^(UIViewController * obj, NSUInteger idx, BOOL *stop) {
        if (obj.isViewLoaded) {
            [obj viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
        }
    }];
}


@end
