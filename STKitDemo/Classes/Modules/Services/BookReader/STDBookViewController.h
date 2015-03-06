//
//  STDBookViewController.h
//  STKitDemo
//
//  Created by SunJiangting on 13-12-31.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STDViewController.h"

@protocol STDBookViewControllerDelegate <NSObject>

- (void) backViewController;

- (void) navigationBarVisibleDidChangeTo:(BOOL) currentVisible;

@end

@interface STDBookViewController : STDViewController

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, assign) BOOL       preferredNavigationBarHidden;

@property (nonatomic, weak)   id<STDBookViewControllerDelegate> delegate;

@end
