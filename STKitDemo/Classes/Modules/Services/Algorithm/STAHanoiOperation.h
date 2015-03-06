//
//  STAHanoiOperation.h
//  STBasic
//
//  Created by SunJiangting on 13-11-3.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STASortDefines.h"

@class STAHanoiView;
@interface STAHanoiOperation : NSOperation

@property (nonatomic, assign) NSInteger         index;
@property (nonatomic, assign) NSInteger         toIndex;
@property (nonatomic, weak)   STAHanoiView *    hanoiView;
@end
