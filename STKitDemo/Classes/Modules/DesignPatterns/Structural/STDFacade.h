//
//  STDFacade.h
//  STKitDemo
//
//  Created by SunJiangting on 15-2-5.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import "STDesignPatterns.h"

@interface STDFObjectA : NSObject

- (void)methodA;

@end

@interface STDFObjectB : NSObject
- (void)methodB;
@end

@interface STDFObjectC : NSObject
- (void)methodC;
@end

@interface STDFObjectD : NSObject
- (void)methodD;
@end

@interface STDFacade : NSObject <STDesignPatternsDelegate>

- (void)unifiedMethodA;
- (void)unifiedMethodB;
- (void)unifiedMethodC;

@end
