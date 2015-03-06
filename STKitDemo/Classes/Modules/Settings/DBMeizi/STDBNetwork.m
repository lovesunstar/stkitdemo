//
//  STDBNetwork.m
//  STKitDemo
//
//  Created by SunJiangting on 14-9-25.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDBNetwork.h"
#import "STDFeedItem.h"

@interface STDBNetwork ()

@property (nonatomic, strong) STHTTPNetwork * network;

@end

@implementation STDBNetwork

static STDBNetwork * _sharedNetwork;
+ (instancetype) sharedNetwork {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedNetwork = [[self alloc] init];
    });
    return _sharedNetwork;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        STNetworkConfiguration *configuration = [[STNetworkConfiguration sharedConfiguration] copy];
        STHTTPConfiguration *HTTPconfiguration = [[STHTTPConfiguration alloc] init];
        HTTPconfiguration.dataEncoding = NSUTF8StringEncoding;
        HTTPconfiguration.dataType = STHTTPResponseDataTypeTextHTML;
        configuration.HTTPConfiguration = HTTPconfiguration;
        self.network = [[STHTTPNetwork alloc] initWithConfiguration:configuration];
    }
    return self;
}


- (void) fetchDBFeedWithMethod:(NSString *) method
                    parameters:(NSDictionary *) parameters
             completionHandler:(STDBNetworkHandler) completionHandler {
    NSMutableString *URLString = [@"http://www.dbmeizi.com/" mutableCopy];
    [URLString appendString:method];
    STHTTPOperation *operation = [STHTTPOperation operationWithURLString:URLString parameters:parameters];
    [self.network sendHTTPOperation:operation completionHandler:^(STHTTPOperation *operation, id response, NSError *error) {
        if (error) {
            completionHandler(nil, NO, error);
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                BOOL hasMore;
                NSArray * result = [self parseHTMLToImageArray:response hasMore:&hasMore];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completionHandler) {
                        completionHandler(result, hasMore, nil);
                    }
                });
            });
        }
    }];
}


/**
 
 <img  src="http://pic.dbmeizi.com/pics/96781226/s_p18436209.jpg" data-width="500"  data-height="675" data-bigimg="http://pic.dbmeizi.com/pics/96781226/p18436209.jpg" data-id="117206" data-title="嗷呜" data-url="/topic/107933" data-userurl="http://www.douban.com/group/people/96781226/"/>
 */
- (NSArray *) parseHTMLToImageArray:(NSString *) HTMLString hasMore:(BOOL *) hasMore {
    NSString * responseString = HTMLString;
    NSMutableArray * result = [NSMutableArray arrayWithCapacity:5];
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:@"<img.*?>" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray * array = [regex matchesInString:responseString options:NSMatchingReportCompletion range:NSMakeRange(0, responseString.length)];
    [array enumerateObjectsUsingBlock:^(NSTextCheckingResult * checkingResult, NSUInteger idx, BOOL *stop) {
        if ([checkingResult numberOfRanges] > 0) {
            NSString * imageString = [responseString substringWithRange:[checkingResult rangeAtIndex:0]];
            imageString = [imageString stringByReplacingOccurrencesOfString:@"<img" withString:@""];
            imageString = [[[imageString stringByReplacingOccurrencesOfString:@">" withString:@""] stringByTrimingWhitespace] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSArray * array = [imageString componentsSeparatedByRegex:@"\\s+"];
            if (array.count > 2) {
                NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithCapacity:2];
                [array enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
                    NSArray * kv = [[obj stringByTrimingWhitespace] componentsSeparatedByString:@"="];
                    if (kv.count >= 2) {
                        NSString * key = kv[0], * value = kv[1];
                        if ([key isEqualToString:@"src"]) {
                            [dictionary setValue:kv[1] forKey:@"thumb"];
                        } else if ([key isEqualToString:@"data-width"]) {
                            [dictionary setValue:value forKey:@"width"];
                        } else if ([key isEqualToString:@"data-height"]) {
                            [dictionary setValue:value forKey:@"height"];
                        } else if ([key isEqualToString:@"data-title"]) {
                            [dictionary setValue:value forKey:@"title"];
                        } else if ([key isEqualToString:@"data-bigimg"]) {
                            [dictionary setValue:value forKey:@"photo"];
                        } else if ([key isEqualToString:@"data-src"]) {
                            [dictionary setValue:value forKey:@"thumb"];
                        }
                    }
                }];
                if (dictionary.count > 2) {
                    BOOL hasThumb = !![dictionary valueForKey:@"thumb"];
                    BOOL hasImage = !![dictionary valueForKey:@"photo"];
                    if (hasThumb && !hasImage) {
                        [dictionary setValue:[dictionary valueForKey:@"thumb"] forKey:@"photo"];
                    }
                    if (hasImage && !hasThumb) {
                        [dictionary setValue:[dictionary valueForKey:@"photo"] forKey:@"thumb"];
                    }
                    STDFeedItem * feedItem = [[STDFeedItem alloc] initWithDictinoary:dictionary];
                    [result addObject:feedItem];
                }
            }
        }
    }];
    NSRegularExpression * regex1= [NSRegularExpression regularExpressionWithPattern:@"<a\\s* href=\"#\">Next</a>" options:NSRegularExpressionCaseInsensitive error:nil];
    BOOL more = [regex1 matchesInString:HTMLString options:NSMatchingReportCompletion range:NSMakeRange(0, HTMLString.length)].count > 0;
    if (hasMore) {
        *hasMore = more;
    }
    return [result copy];
}

@end
