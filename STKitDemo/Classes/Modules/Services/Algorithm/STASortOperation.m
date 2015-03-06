//
//  STASortOperation.m
//  STBasic
//
//  Created by SunJiangting on 13-11-2.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STASortOperation.h"
#import "STASortView.h"

@interface STASortOperation()

@property (atomic, assign) BOOL      complete;
@end

@implementation STASortOperation

- (instancetype) init {
    self = [super init];
    if (self) {
        id duration = [[NSUserDefaults standardUserDefaults] valueForKey:@"STMoveAnimationDuration"];
        self.duration = [duration doubleValue];
    }
    return self;
}

- (void) main {
    void (^completion)(BOOL finished) = ^(BOOL finished) {
        self.complete = YES;
    };
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (_operationType) {
            case STSortOperationTypeMoveBaseline1:
                [self.sortView moveBaseline1ToIndex:_index1 duration:self.duration completion:completion];
                break;
            case STSortOperationTypeMoveBaseline2:
                [self.sortView moveBaseline2ToIndex:_index2 duration:self.duration completion:completion];
                break;
            case STSortOperationTypeCacheUpElement:
                [self.sortView moveElementToCacheAtIndex:_index1 duration:self.duration completion:completion];
                break;
            case STSortOperationTypeCacheDownElement:
                [self.sortView removeElementFromCacheWithDuration:self.duration completion:completion];
                break;
            case STSortOperationTypeMoveElement:
                [self.sortView moveElementAtIndex:_index1 toIndex:_index2 duration:self.duration completion:completion];
                break;
            case STSortOperationTypeExchangeElement:
                [self.sortView exchangeElementAtIndex:_index1 withElementAtIndex:_index2 duration:self.duration completion:completion];
                break;
            default:
                break;
        }
    });
    while (!_complete) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
    }
}

@end