//
//  STDLocationPickerController.h
//  STKitDemo
//
//  Created by SunJiangting on 15-2-27.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import "STDViewController.h"

@interface STDLocationPickerController : STDViewController

+ (CLLocationCoordinate2D)cachedFakeLocationCoordinate;
@end

extern NSString *const STFakeLocationCoordinateCacheKey;