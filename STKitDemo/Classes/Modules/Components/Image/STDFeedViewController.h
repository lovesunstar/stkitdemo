//
//  STDFeedViewController.h
//  STKitDemo
//
//  Created by SunJiangting on 14-9-26.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDViewController.h"
#import "STDFeedItem.h"

typedef void(^ STDFeedLoadHandler) (NSArray * feeds, BOOL hasMore, NSError * error);

@interface STDFeedViewController : STDViewController

@property (nonatomic, assign) BOOL      automaticallyFetchRemoteData;

@property (nonatomic, strong) UICollectionView      * collectionView;
@property (nonatomic, weak, readonly)   STRefreshControl      * refreshControl;
@property (nonatomic, strong, readonly) NSMutableArray        * feeds;
@property (nonatomic, assign, readonly) NSTimeInterval          previousRequestTime;
@property (nonatomic, assign, readonly) BOOL                    loading;

- (void) loadDataFromCacheWithHandler:(STDFeedLoadHandler) completionHandler;
- (void) loadDataWithPage:(NSInteger) page
                     size:(NSInteger) size
        completionHandler:(STDFeedLoadHandler) completionHandler;

- (void) saveDataToCache:(NSArray *) feeds;

- (NSString *) cacheIdentifier;
@end

extern NSInteger const STDFeedLoadPageSize;