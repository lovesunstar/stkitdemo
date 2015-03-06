//
//  STDPrototype.m
//  STKitDemo
//
//  Created by SunJiangting on 15-2-3.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import "STDPrototype.h"

@implementation STDPrototype

+ (void)test {
    STDPrototype *prototype = [[STDPrototype alloc] init];
    prototype.propertyA = @"abc";
    prototype.propertyB = @{@"key":@"value"};
    NSLog(@"Original%@", prototype);
    STDPrototype *prototype1 = [prototype copy];
    STDPrototype *prototype2 = [prototype mutableCopy];
    NSLog(@"Copy %@", prototype1);
    prototype1.propertyA = @"Modified";
    NSLog(@"Modified CopiedObject Origin%@ Copy%@ MutableCopy %@", prototype, prototype1, prototype2);
    prototype2.propertyA = @"MutableProperty";
    NSLog(@"Modified MutableCopiedObject Origin%@ Copy%@ MutableCopy %@", prototype, prototype1, prototype2);
}

- (instancetype)copyWithZone:(NSZone *)zone {
    STDPrototype *prototype = [[[self class] allocWithZone:zone] init];
    prototype.propertyA = [self.propertyA copy];
    prototype.propertyB = [self.propertyB copy];
    return prototype;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    STDPrototype *prototype = [[[self class] allocWithZone:zone] init];
    prototype.propertyA = [self.propertyA mutableCopy];
    prototype.propertyB = [self.propertyB mutableCopy];
    return prototype;
}

- (NSString *)description {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:2];
    [dictionary setValue:self.propertyA forKey:@"propertyA"];
    [dictionary setValue:self.propertyB forKey:@"propertyB"];
    return [dictionary description];
}

@end
