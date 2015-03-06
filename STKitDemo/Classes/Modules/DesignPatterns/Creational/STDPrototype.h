//
//  STDPrototype.h
//  STKitDemo
//
//  Created by SunJiangting on 15-2-3.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STDesignPatterns.h"

@interface STDPrototype : NSObject<NSCopying, NSMutableCopying, STDesignPatternsDelegate>
@property (nonatomic, strong) NSString  *propertyA;
@property (nonatomic, strong) NSDictionary  *propertyB;
@end
