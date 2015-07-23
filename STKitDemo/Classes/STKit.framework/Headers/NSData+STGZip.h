//
//  NSData+STGZip.h
//  STKit
//
//  Created by SunJiangting on 15-3-26.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import <Foundation/Foundation.h>

// 需要引入 zib
#define STKit_STDefines_GZip 0
#if STKit_STDefines_GZip
#import <zlib.h>
@interface NSData (STGZip)

- (NSData *)st_compressDataUsingGZip;
+ (NSData *)st_dataWithZipCompressedData:(NSData *)data;

@end
#endif
