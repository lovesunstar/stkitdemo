//
//  STDSettingViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 15-2-15.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import "STDSettingViewController.h"
#import "STDNavigationSettingViewController.h"
#import "STDChatViewController.h"
#import "STDMessage.h"
#import "STDLocationPickerController.h"

@interface STDSettingViewController ()
@property(nonatomic, weak) STDTableViewCellItem *item20;
@property(nonatomic, weak) STDTableViewCellItem *item21;
@property(nonatomic, weak) STDTableViewCellItem *item22;

@end

@implementation STDSettingViewController

+ (BOOL)allowsCustomNavigationTransition {
    return [[[STPersistence standardPersistence] valueForKey:@"STDAllowsCustomNavigationTransition"] boolValue];
}

+ (BOOL)chatReceiveImage {
   return [[[STPersistence standardPersistence] valueForKey:@"STDChatAcceptImage"] boolValue];
}

+ (BOOL)reduceTransitionAnimation {
   return [[[STPersistence standardPersistence] valueForKey:@"STDReduceTransitionAnimation"] boolValue];
}

- (instancetype)initWithStyle:(UITableViewStyle)tableViewStyle {
    self = [super initWithStyle:tableViewStyle];
    if (self) {
        NSMutableArray * dataSource = [NSMutableArray arrayWithCapacity:5];
        STDTableViewCellItem * item00 = [[STDTableViewCellItem alloc] initWithTitle:@"还原设置" target:self action:@selector(_resetSettingActionFired)];
        STDTableViewCellItem * item01 = [[STDTableViewCellItem alloc] initWithTitle:@"模拟位置" target:self action:@selector(_fakeSettingActionFired)];
        STDTableViewSectionItem *section0 = [[STDTableViewSectionItem alloc] initWithSectionTitle:@"" items:@[item00, item01]];
        [dataSource addObject:section0];
        
        STDTableViewCellItem *item10 = [[STDTableViewCellItem alloc] initWithTitle:@"导航设置" target:self action:@selector(_navigationSettingActionFired)];
        STDTableViewSectionItem * section1 = [[STDTableViewSectionItem alloc] initWithSectionTitle:@"" items:@[item10]];
        [dataSource addObject:section1];
        
        STDTableViewCellItem *item20 = [[STDTableViewCellItem alloc] initWithTitle:@"允许自定义导航切换" target:self action:@selector(_navigationSettingActionFired:)];
        item20.switchStyle = YES;
        item20.checked = [[[STPersistence standardPersistence] valueForKey:@"STDAllowsCustomNavigationTransition"] boolValue];
        self.item20 = item20;
        
        STDTableViewCellItem *item21 = [[STDTableViewCellItem alloc] initWithTitle:@"聊天接收图片" target:self action:@selector(_chatSettingActionFired:)];
        item21.switchStyle = YES;
        item21.checked = [[[STPersistence standardPersistence] valueForKey:@"STDChatAcceptImage"] boolValue];
        self.item21 = item21;
        
        STDTableViewCellItem *item22 = [[STDTableViewCellItem alloc] initWithTitle:@"减少切换动画" target:self action:@selector(_reduceAnimationActionFired:)];
        item22.switchStyle = YES;
        item22.checked = [[[STPersistence standardPersistence] valueForKey:@"STDReduceTransitionAnimation"] boolValue];
        self.item22 = item22;
        
        STDTableViewSectionItem * section2 = [[STDTableViewSectionItem alloc] initWithSectionTitle:@"" items:@[item20, item21, item22]];
        [dataSource addObject:section2];
        
        
        STDTableViewCellItem *item30 = [[STDTableViewCellItem alloc] initWithTitle:@"清空聊天记录" target:self action:@selector(_deleteAllMessages)];
        STDTableViewCellItem *item31 = [[STDTableViewCellItem alloc] initWithTitle:@"清空本地缓存" target:self action:@selector(_cleanActionFired)];
        STDTableViewSectionItem * section3 = [[STDTableViewSectionItem alloc] initWithSectionTitle:@"" items:@[item30, item31]];
        [dataSource addObject:section3];
        self.dataSource = dataSource;
    }
    return self;
}

- (void)reloadData {
    self.item20.checked = [[[STPersistence standardPersistence] valueForKey:@"STDAllowsCustomNavigationTransition"] boolValue];
    self.item21.checked = [[[STPersistence standardPersistence] valueForKey:@"STDChatAcceptImage"] boolValue];
    self.item22.checked = [[[STPersistence standardPersistence] valueForKey:@"STDReduceTransitionAnimation"] boolValue];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"设置";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_fakeSettingActionFired {
    STDLocationPickerController *pickerController = [[STDLocationPickerController alloc] init];
    pickerController.hidesBottomBarWhenPushed = YES;
    [self.customNavigationController pushViewController:pickerController animated:YES];
}

- (void)_navigationSettingActionFired:(UISwitch *)uiswitch {
    if ([uiswitch isKindOfClass:[UISwitch class]]) {
        [[STPersistence standardPersistence] setValue:@(uiswitch.on) forKey:@"STDAllowsCustomNavigationTransition"];
    }
}

- (void)_reduceAnimationActionFired:(UISwitch *)uiswitch {
    if ([uiswitch isKindOfClass:[UISwitch class]]) {
        [[STPersistence standardPersistence] setValue:@(uiswitch.on) forKey:@"STDReduceTransitionAnimation"];
        self.customTabBarController.animatedWhenTransition = !uiswitch.on;
    }
}

- (void)_chatSettingActionFired:(UISwitch *)uiswitch {
    if ([uiswitch isKindOfClass:[UISwitch class]]) {
        [[STPersistence standardPersistence] setValue:@(uiswitch.on) forKey:@"STDChatAcceptImage"];
    }
}
- (void)_resetSettingActionFired {
    [STPersistence resetStandardPersistence];
    STIndicatorView * indicatorView = [STIndicatorView showInView:self.view animated:YES];
    indicatorView.forceSquare = YES;
    indicatorView.indicatorType = STIndicatorTypeText;
    indicatorView.textLabel.text = @"还原完成";
    [indicatorView hideAnimated:YES afterDelay:0.5];
    indicatorView.blurEffectStyle = STBlurEffectStyleDark;
    [self reloadData];
}


- (void)_cleanActionFired {
    NSFileManager * manager = [NSFileManager defaultManager];
    NSString * imagePath = STImageCacheDirectory();
    if ([manager fileExistsAtPath:imagePath isDirectory:NULL]) {
        CGFloat size = [[[manager attributesOfItemAtPath:imagePath error:nil] valueForKey:NSFileSize] floatValue];
        [manager removeItemAtPath:imagePath error:nil];
        STIndicatorView * indicatorView = [STIndicatorView showInView:self.view animated:YES];
        indicatorView.forceSquare = YES;
        indicatorView.indicatorType = STIndicatorTypeText;
        indicatorView.textLabel.text = @"清理完毕";
        indicatorView.detailLabel.text = [NSString stringWithFormat:@"释放了%.2fM", size / 1024.f];
        [indicatorView hideAnimated:YES afterDelay:0.5];
        indicatorView.blurEffectStyle = STBlurEffectStyleDark;
    }
}

- (void)_deleteAllMessages {
    STIndicatorView * indicatorView = [STIndicatorView showInView:self.view animated:YES];
    indicatorView.textLabel.text = @"删除中";
    indicatorView.blurEffectStyle = STBlurEffectStyleDark;
    indicatorView.forceSquare = YES;
    [[STCoreDataManager defaultDataManager] performBlockOnMainThread:^(NSManagedObjectContext * context) {
        NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"STDMessage"];
        NSArray * messages = [context executeFetchRequest:fetchRequest error:nil];
        if (messages.count > 0) {
            [messages enumerateObjectsUsingBlock:^(STDMessage * obj, NSUInteger idx, BOOL *stop) {
                [context deleteObject:obj];
            }];
            [[STCoreDataManager defaultDataManager] saveManagedObjectContext:context error:nil];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            indicatorView.textLabel.text = @"已删除";
        });
        [indicatorView hideAnimated:YES afterDelay:1.5];
    } waitUntilDone:YES];
}

- (void)_navigationSettingActionFired {
    STDNavigationSettingViewController * settingViewController = [[STDNavigationSettingViewController alloc] initWithNibName:nil bundle:nil];
    [self.customNavigationController pushViewController:settingViewController animated:YES];
}

@end
