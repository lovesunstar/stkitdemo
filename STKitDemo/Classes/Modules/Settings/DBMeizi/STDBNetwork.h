//
//  STDBNetwork.h
//  STKitDemo
//
//  Created by SunJiangting on 14-9-25.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <STKit/STKit.h>

typedef void (^STDBNetworkHandler) (NSArray * feeds, BOOL hasMore, NSError * error);

@interface STDBNetwork : NSObject

+ (instancetype) sharedNetwork;

- (void) fetchDBFeedWithMethod:(NSString *) method
                parameters:(NSDictionary *) parameters
         completionHandler:(STDBNetworkHandler) completionHandler;

@end
