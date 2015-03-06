//
//  STDAdapter.m
//  STKitDemo
//
//  Created by SunJiangting on 15-2-4.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import "STDAdapter.h"

@implementation STDASINetwork

- (void)ASIRequestWithURLString:(NSString *)URLString {
    NSLog(@"ASISendRequestWithURLString %@", URLString);
}

@end

@implementation STDAFNetwork

- (void)AFRequestWithURLString:(NSString *)URLString {
    NSLog(@"AFSendRequestWithURLString %@", URLString);
}


@end

@interface STDAdapter ()

@property (nonatomic, strong) STDAFNetwork *AFNetwork;

@end

@implementation STDAdapter

+ (void)test {
    STDAFNetwork *AFNetwork = [[STDAFNetwork alloc] init];
    STDAdapter<STDAdapter> *adapter = [[STDAdapter alloc] initWithAFNetwork:AFNetwork];
    [adapter AFRequestWithURLString:@"http://suenblog.duapp.com"];
    [adapter ASIRequestWithURLString:@"http://suenblog.duapp.com"];
}

- (instancetype)initWithAFNetwork:(STDAFNetwork *)AFNetwork {
    self = [super init];
    if (self) {
        self.AFNetwork = AFNetwork;
    }
    return self;
}

- (void)AFRequestWithURLString:(NSString *)URLString {
    [self.AFNetwork AFRequestWithURLString:URLString];
}
@end
