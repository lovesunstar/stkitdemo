//
//  STGIFGenerator.h
//  STKit
//
//  Created by SunJiangting on 14-11-8.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#import <STKit/STDefines.h>

typedef NS_ENUM(NSInteger, STGIFPropertyColorModel) {
    STGIFPropertyColorModelRGB,
    STGIFPropertyColorModelGray,
    STGIFPropertyColorModelCMYK,
    STGIFPropertyColorModelLab
};

ST_ASSUME_NONNULL_BEGIN
@interface STGIFProperty : NSObject
+ (STGIFProperty *)defaultGIFProperty;
/// default YES
@property(nonatomic, getter=hasGlobalColorMap) BOOL hasGlobalColorMap;
/// default STGIFPropertyColorModelRGB
@property(nonatomic) STGIFPropertyColorModel    colorModel;
/// default 8
@property(nonatomic) CGFloat   depth;
/// default 0
@property(nonatomic) NSInteger loopCount;

@end

@interface STGIFGenerator : NSObject

- (instancetype)initWithProperty:(STNULLABLE STGIFProperty *)property;

@property(nonatomic) CGSize    preferredImageSize;

- (void)appendImage:(UIImage *)image duration:(NSTimeInterval)duration;

- (void)startGeneratorWithPath:(STNULLABLE NSString *)path completionHandler:(void(^ ST_NULLABLE)(NSString *))completionHandler;
- (void)cancel;

@end
ST_ASSUME_NONNULL_END
