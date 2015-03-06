//
//  STARootViewController.m
//  STBasic
//
//  Created by SunJiangting on 13-11-2.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STARootViewController.h"
#import "STASortViewController.h"
#import "STAHanoiViewController.h"

#import <STKit/STKit.h>

@interface STARootViewController ()

@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, strong) NSArray * sortArray;
@property (nonatomic, strong) UILabel * numberOfHanoiDiskLabel;
@property (nonatomic, assign) NSInteger numberOfDisks;

@end

@implementation STARootViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        NSArray * array = @[@(20),@(6),@(2),@(8),@(9),@(12), @(2), @(4), @(3), @(4), @(7), @(11)];
        self.sortArray = array;
        
        NSMutableArray * dataSource = [NSMutableArray arrayWithCapacity:2];
        
        STDTableViewCellItem *item00 = [[STDTableViewCellItem alloc] initWithTitle:@"冒泡排序" target:self action:@selector(_bubbleSortActionFired)];
        STDTableViewCellItem *item01 = [[STDTableViewCellItem alloc] initWithTitle:@"选择排序" target:self action:@selector(_selectSortActionFired)];
        STDTableViewCellItem *item02 = [[STDTableViewCellItem alloc] initWithTitle:@"插入排序" target:self action:@selector(_insertSortActionFired)];
        STDTableViewCellItem *item03 = [[STDTableViewCellItem alloc] initWithTitle:@"快速排序" target:self action:@selector(_quickSortActionFired)];
        NSString * section0Title = [NSString stringWithFormat:@"几种常用的排序算法, 排序数据源\n%@", [self.sortArray componentsJoinedByString:@","]];
        STDTableViewSectionItem *section0 = [[STDTableViewSectionItem alloc] initWithSectionTitle:section0Title items:@[item00, item01, item02, item03]];
        [dataSource addObject:section0];
        
        
        STDTableViewCellItem *item10 = [[STDTableViewCellItem alloc] initWithTitle:@"汉诺塔算法" target:self action:@selector(_hanoiActionFired)];
        STDTableViewSectionItem *section1 = [[STDTableViewSectionItem alloc] initWithSectionTitle:@"经典的几种递归算法\n" items:@[item10]];
        [dataSource addObject:section1];
        self.dataSource = dataSource;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = YES;
    self.navigationItem.title = @"算法分析";
        
    UIView * tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 80, 30)];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"速度比例";
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    [tableHeaderView addSubview:label];
    
    id speed = [[NSUserDefaults standardUserDefaults] valueForKey:@"STMoveAnimationDuration"];
    if (!speed) {
        speed = @(0.5);
        [[NSUserDefaults standardUserDefaults] setValue:speed forKey:@"STMoveAnimationDuration"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    UISlider * slider = [[UISlider alloc] initWithFrame:CGRectMake(100, 10, 200, 30)];
    [tableHeaderView addSubview:slider];
    slider.minimumValue = 0.2;
    slider.maximumValue = 1.2;
    slider.value = [speed floatValue];
    slider.continuous = NO;
    [slider addTarget:self action:@selector(speedChanged:) forControlEvents:UIControlEventValueChanged];
    
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 80, 30)];
    label2.textAlignment = NSTextAlignmentLeft;
    label2.text = @"汉诺塔数";
    label2.backgroundColor = [UIColor clearColor];
    label2.textColor = [UIColor blackColor];
    [tableHeaderView addSubview:label2];
    
    id disks = [[NSUserDefaults standardUserDefaults] valueForKey:@"STNumberOfHanoiDisks"];
    if (!disks) {
        disks = @(4);
    }
    
    self.numberOfHanoiDiskLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 50, 30)];
    self.numberOfHanoiDiskLabel.textAlignment = NSTextAlignmentLeft;
    [self updateNumberOfDisks:[disks intValue]];
    self.numberOfHanoiDiskLabel.textColor = [UIColor blackColor];
    self.numberOfHanoiDiskLabel.backgroundColor = [UIColor clearColor];
    [tableHeaderView addSubview:self.numberOfHanoiDiskLabel];
    
    UIStepper * stepper = [[UIStepper alloc] initWithFrame:CGRectMake(150, 50, 200, 30)];
    stepper.minimumValue = 3;
    stepper.maximumValue = 10;
    stepper.value = [disks intValue];
    [stepper addTarget:self action:@selector(numberOfDiskChanged:) forControlEvents:UIControlEventValueChanged];
    [tableHeaderView addSubview:stepper];
    self.tableView.tableHeaderView = tableHeaderView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)speedChanged:(UISlider *) slider {
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:@(slider.value) forKey:@"STMoveAnimationDuration"];
    [userDefault synchronize];
}

- (void) updateNumberOfDisks:(NSInteger) numberOfDisks {
    self.numberOfDisks = numberOfDisks;
    self.numberOfHanoiDiskLabel.text = [NSString stringWithFormat:@"%ld", (long)numberOfDisks];
    [[NSUserDefaults standardUserDefaults] setValue:@(numberOfDisks) forKey:@"STNumberOfHanoiDisks"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) numberOfDiskChanged:(UIStepper *) sender {
    [self updateNumberOfDisks:sender.value];
}

- (void)_bubbleSortActionFired {
    STASortViewController * viewController = [[STASortViewController alloc] init];
    viewController.sortArray = self.sortArray;
    viewController.arraySortType = STArraySortTypeBubbleSort;
    [self.customNavigationController pushViewController:viewController animated:YES];
}

- (void)_selectSortActionFired {
    STASortViewController * viewController = [[STASortViewController alloc] init];
    viewController.sortArray = self.sortArray;
    viewController.arraySortType = STArraySortTypeSelectSort;
    [self.customNavigationController pushViewController:viewController animated:YES];
}

- (void)_insertSortActionFired {
    STASortViewController * viewController = [[STASortViewController alloc] init];
    viewController.sortArray = self.sortArray;
    viewController.arraySortType = STArraySortTypeInsertSort;
    [self.customNavigationController pushViewController:viewController animated:YES];
}

- (void)_quickSortActionFired {
    STASortViewController * viewController = [[STASortViewController alloc] init];
    viewController.sortArray = self.sortArray;
    viewController.arraySortType = STArraySortTypeQuickSort;
    [self.customNavigationController pushViewController:viewController animated:YES];
}

- (void)_hanoiActionFired {
    STAHanoiViewController * viewController = [[STAHanoiViewController alloc] init];
    viewController.numberOfHanois = self.numberOfDisks;
    [self.customNavigationController pushViewController:viewController animated:YES];
}

- (void)leftBarButtonItemAction:(id) sender {
    if (self.sideBarController.sideAppeared) {
        [self.sideBarController concealSideViewControllerAnimated:YES];
    } else {
        [self.sideBarController revealSideViewControllerAnimated:YES];
    }
}

@end
