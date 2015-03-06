//
//  STDMessage.h
//  STKitDemo
//
//  Created by SunJiangting on 13-12-27.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STDImage, STDUser;

@interface STDMessage : NSManagedObject

@property (nonatomic, retain) NSString * chatViewRect;
@property (nonatomic, retain) NSString * content;
@property (nonatomic) float height;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * mid;
@property (nonatomic) int16_t type;
@property (nonatomic) NSTimeInterval time;
@property (nonatomic, retain) STDUser *from;
@property (nonatomic, retain) STDImage *image;
@property (nonatomic, retain) STDUser *target;

@end
