//
//  STDBeautyViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 14-9-26.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDBeautyViewController.h"
#import "STDBNetwork.h"

@implementation STDBeautyViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.automaticallyFetchRemoteData = NO;
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.collectionView.scrollsToTop = NO;
}

- (void) fetchDataFromRemote {
    [self.collectionView reloadData];
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(fetchDataIfNeeded) object:nil];
    [self performSelector:@selector(fetchDataIfNeeded) withObject:nil afterDelay:0.5];
}

- (void) fetchDataIfNeeded {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    if ((timeInterval - self.previousRequestTime >= 300 || self.feeds.count == 0) && !self.refreshControl.isRefreshing) {
        [self.refreshControl beginRefreshing];
    }
    self.collectionView.scrollsToTop = YES;
}

- (void) cancelFetchData {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(fetchDataIfNeeded) object:nil];
    self.collectionView.scrollsToTop = NO;
}

- (void) loadDataWithPage:(NSInteger)page size:(NSInteger)size completionHandler:(STDFeedLoadHandler)completionHandler {
    NSDictionary * parameters = @{@"p":@(page)};
    [[STDBNetwork sharedNetwork] fetchDBFeedWithMethod:self.method parameters:parameters completionHandler:^(NSArray *feeds, BOOL hasMore, NSError *error) {
        if (completionHandler) {
            completionHandler(feeds, hasMore, error);   
        }
    }];
}

- (NSString *) cacheIdentifier {
    return [NSString stringWithFormat:@"%@-%@", NSStringFromClass([self class]), self.method];
}

@end
