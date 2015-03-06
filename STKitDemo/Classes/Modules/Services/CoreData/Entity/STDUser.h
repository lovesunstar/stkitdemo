//
//  STDUser.h
//  STKitDemo
//
//  Created by SunJiangting on 13-12-27.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STDImage;

@interface STDUser : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * nick;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) STDImage *avatar;

@end
