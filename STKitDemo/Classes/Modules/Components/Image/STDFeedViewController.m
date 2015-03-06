//
//  STDFeedViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 14-9-26.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDFeedViewController.h"
#import "STDFeedCell.h"
#import "STDFeedImageView.h"

#import "STDAppDelegate.h"

@interface STDFeedViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, STImagePresentDelegate>

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, weak)   STRefreshControl      * refreshControl;
@property (nonatomic, strong) NSMutableArray        * feeds;
@property (nonatomic, assign) BOOL                    hasMore;
@property (nonatomic, assign) NSTimeInterval          previousRequestTime;

@property (nonatomic, strong) STScrollDirector      * collectionDirector;

@end

@implementation STDFeedViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.collectionDirector = [[STScrollDirector alloc] init];
        [self.collectionDirector setTitle:@"下拉可以刷新" forState:STScrollDirectorStateRefreshNormal];
        [self.collectionDirector setTitle:@"松手开始刷新" forState:STScrollDirectorStateRefreshReachedThreshold];
        [self.collectionDirector setTitle:@"正在刷新..." forState:STScrollDirectorStateRefreshLoading];
        [self.collectionDirector setTitle:@"加载更多" forState:STScrollDirectorStatePaginationNormal];
        [self.collectionDirector setTitle:@"正在加载更多" forState:STScrollDirectorStatePaginationLoading];
        [self.collectionDirector setTitle:@"重新加载" forState:STScrollDirectorStatePaginationFailed];
        [self.collectionDirector setTitle:@"没有更多了" forState:STScrollDirectorStatePaginationReachedEnd];
        
        self.feeds = [NSMutableArray arrayWithCapacity:5];
        self.automaticallyFetchRemoteData = YES;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self loadDataFromCacheWithHandler:^(NSArray *feeds, BOOL hasMore, NSError *error) {
        [self.feeds addObjectsFromArray:feeds];
    }];
    STCollectionViewFlowLayout * collectionViewFlowLayout = [[STCollectionViewFlowLayout alloc] init];
    collectionViewFlowLayout.minimumInteritemSpacing = 0;
    collectionViewFlowLayout.minimumLineSpacing = 0;
    collectionViewFlowLayout.numberOfColumns = [self preferredNumberOfColumnsWithWidth:CGRectGetWidth(self.view.frame)];
    
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:collectionViewFlowLayout];
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    collectionView.backgroundView = nil;
    collectionView.backgroundColor = [UIColor colorWithRGB:0xCCCCCC];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[STDFeedCell class] forCellWithReuseIdentifier:@"Identifier"];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    self.collectionDirector.scrollView = collectionView;
    [self.collectionDirector.refreshControl addTarget:self action:@selector(refreshControlActionFired:) forControlEvents:UIControlEventValueChanged];
    [self.collectionDirector.paginationControl addTarget:self action:@selector(paginationControlActionFired:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = self.collectionDirector.refreshControl;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    if (((timeInterval - self.previousRequestTime) > 300 || self.feeds.count == 0) && !self.refreshControl.isRefreshing && self.automaticallyFetchRemoteData) {
        [self.refreshControl beginRefreshing];
    }
}

- (void)GIFGeneratorActionFired:(id) sender {
    NSInteger maximumCount = 5;
    STGIFGenerator *generator = [[STGIFGenerator alloc] init];
    [self.feeds enumerateObjectsUsingBlock:^(STDFeedItem * obj, NSUInteger idx, BOOL *stop) {
        UIImage *image = [STImageCache cachedImageForKey:obj.thumbURLString];
        [generator appendImage:image duration:1];
        if (idx == maximumCount) {
            *stop = YES;
        }
    }];
    [generator startGeneratorWithPath:nil completionHandler:^(NSString *path) {
        NSLog(@"%@", path);
    }];
}

- (void) refreshControlActionFired:(id) sender {
    self.page = 0;
    __weak STDFeedViewController * weakSelf = self;
    [self loadDataWithPage:0 size:STDFeedLoadPageSize completionHandler:^(NSArray *feeds, BOOL hasMore, NSError *error) {
        if (!error) {
            [weakSelf.feeds removeAllObjects];
            [weakSelf.feeds addObjectsFromArray:feeds];
            weakSelf.hasMore = hasMore;
            [weakSelf reloadCollectionFooterView];
            weakSelf.previousRequestTime = [[NSDate date] timeIntervalSince1970];
            NSString * cacheKey = [NSString stringWithFormat:@"%@-LastRequest", [self cacheIdentifier]].md5String;
            [[STPersistence standardPersistence] setValue:@(weakSelf.previousRequestTime) forKey:cacheKey];
            [weakSelf.collectionView reloadData];
            [weakSelf saveDataToCache:feeds];
        }
        [weakSelf.collectionDirector.refreshControl endRefreshing];
    }];
}

- (void) saveDataToCache:(NSArray *) feeds {
    NSMutableArray * result = [NSMutableArray arrayWithCapacity:5];
    [feeds enumerateObjectsUsingBlock:^(STDFeedItem * obj, NSUInteger idx, BOOL *stop) {
        [result addObject:[obj toDictionary]];
    }];
    NSString * cacheKey = [NSString stringWithFormat:@"%@-CachedData", [self cacheIdentifier]].md5String;
    [[STPersistence cachePersistenceWithSubpath:@"FeedCache"] setValue:result forKey:cacheKey];
}

- (void) reloadCollectionFooterView {
    if (self.hasMore) {
        self.collectionDirector.paginationControl.paginationState = STPaginationControlStateNormal;
    } else {
        self.collectionDirector.paginationControl.paginationState = STPaginationControlStateReachedEnd;
    }
    self.collectionView.collectionFooterView = self.collectionDirector.paginationControl;
}

- (void) paginationControlActionFired:(id) sender {
    self.page ++;
    __weak STDFeedViewController * weakSelf = self;
    [self loadDataWithPage:self.page size:STDFeedLoadPageSize completionHandler:^(NSArray *feeds, BOOL hasMore, NSError *error) {
        if (!error) {
            [weakSelf.feeds addObjectsFromArray:feeds];
            weakSelf.hasMore = hasMore;
            [weakSelf reloadCollectionFooterView];
            [weakSelf.collectionView reloadData];
        }
    }];
}

- (void) loadDataFromCacheWithHandler:(STDFeedLoadHandler) completionHandler {
    NSMutableArray * result = [NSMutableArray arrayWithCapacity:5];
    NSString * cacheKey = [NSString stringWithFormat:@"%@-CachedData", [self cacheIdentifier]].md5String;
    NSArray * cachedData = [[STPersistence cachePersistenceWithSubpath:@"FeedCache"] valueForKey:cacheKey];
    if ([cachedData isKindOfClass:[NSArray class]]) {
        [cachedData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            STDFeedItem * feedItem = [[STDFeedItem alloc] initWithDictinoary:obj];
            [result addObject:feedItem];
        }];
    }
    if (completionHandler) {
        completionHandler(result, NO,nil);
    }
}
- (void) loadDataWithPage:(NSInteger) page
                     size:(NSInteger) size
        completionHandler:(STDFeedLoadHandler) completionHandler {
    completionHandler(nil, NO,nil);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.feeds.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    STDFeedCell * collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Identifier" forIndexPath:indexPath];
    collectionCell.feedItem = self.feeds[indexPath.row];
    return collectionCell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray * images = [NSMutableArray arrayWithCapacity:2];
    [self.feeds enumerateObjectsUsingBlock:^(STDFeedItem * obj, NSUInteger idx, BOOL *stop) {
        [images addObject:obj.imageItem];
    }];
    STImagePresent * imagePresent = [[STImagePresent alloc] initWithImages:images];
    imagePresent.delegate = self;
    [imagePresent presentImageAtIndex:indexPath.row animated:YES];
}

#pragma mark - STCollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(STCollectionViewFlowLayout *) collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    STDFeedItem * feedItem = self.feeds[indexPath.row];
    NSInteger numberOfColumns = collectionViewLayout.numberOfColumns;
    if (numberOfColumns * feedItem.width * feedItem.height == 0) {
        return CGSizeZero;
    }
    CGFloat width = CGRectGetWidth(collectionView.bounds) / numberOfColumns;
    CGFloat height = [STDFeedCell heightForCollectionCellWithFeedItem:feedItem constrainedToWidth:width];
    return CGSizeMake(width, height);
}

#pragma mark - STImagePresent

- (void) imagePresent:(STImagePresent *) imagePresent didPresentImageAtIndex:(NSInteger) index {
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    if (![self.collectionView cellForItemAtIndexPath:indexPath]) {
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    }
}

- (UIImageView *) imagePresent:(STImagePresent *) imagePresent imageViewForImageAtIndex:(NSInteger) index {
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    STDFeedCell * collectionViewCell = (STDFeedCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return collectionViewCell.imageView;
}

#pragma mark - Private
- (void) reloadCollectionFooterView:(UIView *) footerView {
    self.collectionView.collectionFooterView = footerView;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    STCollectionViewFlowLayout * flowLayout = (STCollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    flowLayout.numberOfColumns = [self preferredNumberOfColumnsWithWidth:CGRectGetWidth(self.view.frame)];
    [self.collectionView reloadData];
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    STCollectionViewFlowLayout * flowLayout = (STCollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    flowLayout.numberOfColumns = [self preferredNumberOfColumnsWithWidth:size.width];
    [self.collectionView reloadData];
}


- (NSInteger)preferredNumberOfColumnsWithWidth:(CGFloat) width {
    if (width == 320) {
        return 2;
    }
    if (width == 375) {
        return 3;
    }
    return width / 160;
}

- (NSString *)cacheIdentifier {
    return NSStringFromClass([self class]);
}

- (NSTimeInterval)previousRequestTime {
    if (_previousRequestTime == 0) {
        NSString * cacheKey = [NSString stringWithFormat:@"%@-LastRequest", [self cacheIdentifier]].md5String;
        _previousRequestTime = [[[STPersistence standardPersistence] valueForKey:cacheKey] doubleValue];
    }
    return _previousRequestTime;
}
@end

NSInteger const STDFeedLoadPageSize = 50;
