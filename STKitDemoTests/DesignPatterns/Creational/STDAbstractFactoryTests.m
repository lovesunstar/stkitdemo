//
//  STDAbstractFactoryTests.m
//  STKitDemo
//
//  Created by SunJiangting on 15-2-12.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "STDAbstractFactory.h"

@interface STDAbstractFactoryTests : XCTestCase

@end

@implementation STDAbstractFactoryTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateProductA {
    id<STDAbstractProduct> productA = [STDFactoryA createProduct];
    [productA printProductName];
    XCTAssertTrue([productA isKindOfClass:[STDProductA class]]);
}

- (void)testCreateProductB {
    id<STDAbstractProduct> productB = [STDFactoryB createProduct];
    [productB printProductName];
    XCTAssertTrue([productB isKindOfClass:[STDProductB class]]);
}

@end
