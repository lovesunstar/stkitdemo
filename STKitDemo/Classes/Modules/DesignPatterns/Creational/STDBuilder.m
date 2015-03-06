//
//  STDBuilder.m
//  STKitDemo
//
//  Created by SunJiangting on 15-2-3.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import "STDBuilder.h"

@implementation STDProduct

- (NSString *)description {
    NSMutableString *description = [NSMutableString string];
    if (self.partA) {
        [description appendFormat:@"\n%@", self.partA];
    }
    if (self.partB) {
        [description appendFormat:@"\n%@", self.partB];
    }
    if (self.partC) {
        [description appendFormat:@"\n%@", self.partC];
    }
    if (self.partD) {
        [description appendFormat:@"\n%@", self.partD];
    }
    return [description copy];
}

@end


@interface STDBuilder ()

@property (nonatomic)STDProduct *product;

@end

@implementation STDBuilder

+ (void)test {
    STDBuilder *builder = STDBuilder.new;
    STDBuildDirector *director = [[STDBuildDirector alloc] initWithBuilder:builder];
    STDProduct *product = [director construct];
    NSLog(@"%@", product);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.product = STDProduct.new;
    }
    return self;
}

- (void)buildPartA {
    self.product.partA = @"I have part a.";
}

- (void)buildPartB {
    self.product.partB = @"I have part b.";
}

- (void)buildPartC {
    self.product.partC = @"I have part c.";
}

- (void)buildPartD {
    self.product.partD = @"I have part d.";
}

- (STDProduct *)product {
    return self.product;
}

@end


@interface STDBuildDirector ()

@property (nonatomic)STDBuilder *builder;

@end
@implementation STDBuildDirector

- (instancetype)initWithBuilder:(STDBuilder *)builder {
    self = [super init];
    if (self) {
        self.builder = builder;
    }
    return self;
}

- (STDProduct *)construct {
    return [self constructWithBuilder:self.builder];
}

- (STDProduct *)constructWithBuilder:(STDBuilder *)builder {
    [builder buildPartA];
    [builder buildPartB];
    [builder buildPartC];
    [builder buildPartD];
    return self.builder.product;
}
@end