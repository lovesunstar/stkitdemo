//
//  STDImage.h
//  STKitDemo
//
//  Created by SunJiangting on 13-12-27.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface STDImage : NSManagedObject

@property (nonatomic) float height;
@property (nonatomic, retain) NSString * imageId;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic) float width;

@end
