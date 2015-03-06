//
//  STDSettingViewController.h
//  STKitDemo
//
//  Created by SunJiangting on 15-2-15.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import "STDViewController.h"
#import "STDTextTableViewController.h"

@interface STDSettingViewController : STDTextTableViewController

+ (BOOL)allowsCustomNavigationTransition;
+ (BOOL)chatReceiveImage;
+ (BOOL)reduceTransitionAnimation;
@end
