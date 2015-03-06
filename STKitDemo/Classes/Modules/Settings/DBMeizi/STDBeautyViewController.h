//
//  STDBeautyViewController.h
//  STKitDemo
//
//  Created by SunJiangting on 14-9-26.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDFeedViewController.h"

@interface STDBeautyViewController : STDFeedViewController

@property (nonatomic, copy) NSString        * method;

- (void) fetchDataFromRemote;
- (void) cancelFetchData;

@end
