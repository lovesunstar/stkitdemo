//
//  STAHanoiView.h
//  STBasic
//
//  Created by SunJiangting on 13-11-3.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STASortDefines.h"


@interface STAHanoiView : UIView

@property (nonatomic, assign) NSInteger numberOfHanois;

- (void) reloadHanoiView;

- (void) moveDiskAtIndex:(NSInteger) index
                 toIndex:(NSInteger) toIndex
                duration:(NSTimeInterval) duration
              completion:(void(^)(BOOL finished)) completion;
@end
