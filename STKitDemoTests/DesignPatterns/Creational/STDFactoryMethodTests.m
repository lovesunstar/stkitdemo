//
//  STDFactoryMethodTests.m
//  STKitDemo
//
//  Created by SunJiangting on 15-2-11.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "STDFactoryMethod.h"

@interface STDFactoryMethodTests : XCTestCase

@end

@implementation STDFactoryMethodTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateProduct {
    id<STDAbstractProduct> product = [STDFactoryMethod createProduct];
    [product printProductName];
    XCTAssertTrue([product isKindOfClass:[STDFactoryMethodProduct class]]);
    
}


@end
