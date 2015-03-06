//
//  STDCardViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 14-9-26.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDCardViewController.h"
#import "STDAppDelegate.h"

@interface STDCardViewController ()

@property (nonatomic, strong) STHTTPNetwork * network;

@end

@implementation STDCardViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.network = [[STHTTPNetwork alloc] init];
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"明信片";
}

- (void) loadDataWithPage:(NSInteger)page size:(NSInteger)size completionHandler:(STDFeedLoadHandler)completionHandler {
    NSDictionary * parameters = @{@"page":@(page), @"size":@(size)};
    NSString *URLString = @"http://www.lovecard.sinaapp.com/open/photo/list/";
    STHTTPOperation *operation = [STHTTPOperation operationWithURLString:URLString parameters:parameters];
    [self.network sendHTTPOperation:operation completionHandler:^(STHTTPOperation *operation, id response, NSError *error) {
        if (!error) {
            NSMutableArray * result = [NSMutableArray arrayWithCapacity:2];
            NSArray * array = [response objectForKey:@"photos"];
            BOOL hasMore = [[response objectForKey:@"more"] boolValue] && array.count > 0;
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                STDFeedItem * feedItem = [[STDFeedItem alloc] initWithDictinoary:obj];
                [result addObject:feedItem];
            }];
            if (completionHandler) {
                completionHandler([result copy], hasMore, nil);
            }
        } else {
            if (completionHandler) {
                completionHandler(nil, NO, error);
            }
        }
    }];
}

@end
