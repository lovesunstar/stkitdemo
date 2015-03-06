//
//  STDReaderViewController.h
//  STKitDemo
//
//  Created by SunJiangting on 13-12-31.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STDViewController.h"

@interface STDReaderViewController : STDViewController

- (instancetype)initWithContentsOfFile:(NSString *)path;
- (instancetype)initWithString:(NSString *)string;
@property (nonatomic, strong) UIPageViewController *pageViewController;

@end
