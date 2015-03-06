//
//  TodayViewController.m
//  STKitWidget
//
//  Created by SunJiangting on 14-10-9.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "TodayViewController.h"
#import <STKit/STKit.h>
#import <NotificationCenter/NotificationCenter.h>
#import "STDFeedItem.h"
#import "STDBNetwork.h"

@interface TodayViewController () <NCWidgetProviding>

@property (nonatomic, assign) UIEdgeInsets  edgeInsets;
@property (nonatomic, strong) NSArray       * feeds;
@property (nonatomic, strong) UIButton      * prevButton, *nextButton;
@property (nonatomic, strong) STLabel       * titleLabel;
@property (nonatomic, strong) UIImageView   * imageView;
@property (nonatomic, assign) NSUInteger      selectedIndex;

@property (nonatomic, assign) NSTimeInterval          previousRequestTime;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * cacheKey = [NSString stringWithFormat:@"%@-LastRequest", self.class].md5String;
    self.previousRequestTime = [[[STPersistence standardPersistence] valueForKey:cacheKey] doubleValue];
    
    self.edgeInsets = UIEdgeInsetsZero;

    CGFloat height = 120;
    CGSize size = self.preferredContentSize;
    size.height = height;
    self.preferredContentSize = size;
    // Do any additional setup after loading the view from its nib.
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    imageView.placeholderImage = [UIImage imageNamed:@"product_default"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    self.titleLabel = [[STLabel alloc] initWithFrame:CGRectMake(120, 10, self.view.width - 240, 100)];
    self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.titleLabel.verticalAlignment = STVerticalAlignmentTop;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:16.];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:self.titleLabel];
    
    UIButton * prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
    prevButton.frame = CGRectMake(self.view.width - 100, 30, 80, 20);
    [prevButton setTitle:@"上一张" forState:UIControlStateNormal];
    [prevButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [prevButton addTarget:self action:@selector(displayPreviousActionFired:) forControlEvents:UIControlEventTouchUpInside];
    prevButton.hidden = YES;
    [self.view addSubview:prevButton];
    self.prevButton = prevButton;
    
    UIButton * nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(self.view.width - 100, 70, 80, 20);
    [nextButton setTitle:@"下一张" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(displayNextActionFired:) forControlEvents:UIControlEventTouchUpInside];
    nextButton.hidden = YES;
    [self.view addSubview:nextButton];
    self.nextButton = nextButton;
    
    [self loadDataFromCache];
    
    const NSTimeInterval minimumTimeInterval = 5 * 60;
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    if ((timeInterval - self.previousRequestTime) >= minimumTimeInterval) {
        __weak TodayViewController * weakSelf = self;
        [[STDBNetwork sharedNetwork] fetchDBFeedWithMethod:@"category/2" parameters:nil completionHandler:^(NSArray *feeds, BOOL hasMore, NSError *error) {
            self.feeds = feeds;
            self.selectedIndex = 0;
            self.previousRequestTime = [[NSDate date] timeIntervalSince1970];
            NSString * cacheKey = [NSString stringWithFormat:@"%@-LastRequest", self.class].md5String;
            [[STPersistence standardPersistence] setValue:@(weakSelf.previousRequestTime) forKey:cacheKey];
            
            NSMutableArray * result = [NSMutableArray arrayWithCapacity:5];
            [feeds enumerateObjectsUsingBlock:^(STDFeedItem * obj, NSUInteger idx, BOOL *stop) {
                [result addObject:[obj toDictionary]];
            }];
            NSString * cacheFeedsKey = [NSString stringWithFormat:@"%@-CachedData", self.class].md5String;
            [[STPersistence documentPersistence] setValue:result forKey:cacheFeedsKey];
        }];
    }
}

- (void) loadDataFromCache {
    NSMutableArray * result = [NSMutableArray arrayWithCapacity:5];
    NSString * cacheKey = [NSString stringWithFormat:@"%@-CachedData", self.class].md5String;
    NSArray * cachedFeeds = [[STPersistence documentPersistence] valueForKey:cacheKey];
    if ([cachedFeeds isKindOfClass:[NSArray class]]) {
        [cachedFeeds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            STDFeedItem * feedItem = [[STDFeedItem alloc] initWithDictinoary:obj];
            [result addObject:feedItem];
        }];
        self.feeds = result;
        NSInteger selectedIndex = [[[STPersistence standardPersistence] valueForKey:@"CachedSelectedIndex"] integerValue];
        self.selectedIndex = selectedIndex;
    }
}

- (void) displayPreviousActionFired:(id) sender {
    self.selectedIndex --;
}

- (void) displayNextActionFired:(id) sender {
    self.selectedIndex ++;
}

- (void) setSelectedIndex:(NSUInteger)selectedIndex {
    if (selectedIndex >= self.feeds.count) {
        return;
    }
    STDFeedItem * feedItem = self.feeds[selectedIndex];
    [self.imageView setImageWithURLString:feedItem.thumbURLString];
    self.titleLabel.text = feedItem.title;
    self.prevButton.hidden = !(selectedIndex > 0);
    self.nextButton.hidden = !(selectedIndex < (self.feeds.count - 1));
    _selectedIndex = selectedIndex;
    [[STPersistence standardPersistence] setValue:@(selectedIndex) forKey:@"CachedSelectedIndex"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNoData);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    
    return self.edgeInsets;
}

@end
