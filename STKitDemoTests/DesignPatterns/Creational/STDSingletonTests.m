//
//  STDSingletonTests.m
//  STKitDemo
//
//  Created by SunJiangting on 15-2-12.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "STDSingleton.h"

@interface STDSingletonTests : XCTestCase {
    NSString *_globalName;
    NSString *_memoryAddress;
}

@end

@implementation STDSingletonTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _globalName = @"Test";
    [STDSingleton sharedInstance].globalName = _globalName;
    _memoryAddress = [NSString stringWithFormat:@"%p", [STDSingleton sharedInstance]];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    _globalName = nil;
    _memoryAddress = nil;
    [super tearDown];
}

- (void)testSingletonProperty {
    // This is an example of a functional test case.
    XCTAssert([[STDSingleton sharedInstance].globalName isEqualToString:_globalName], @"Pass");
}

- (void)testSingletonMemoryAddress {
    NSString *currentAddress = [NSString stringWithFormat:@"%p", [STDSingleton sharedInstance]];
    XCTAssert([currentAddress isEqualToString:_memoryAddress], @"Pass");
}

@end
