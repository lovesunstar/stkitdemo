//
//  STShadow.h
//  STKit
//
//  Created by SunJiangting on 15/8/27.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <STKit/STDefines.h>

ST_ASSUME_NONNULL_BEGIN

@interface STShadow : NSObject

@property(nonatomic, copy) UIColor *shadowColor;

/* The opacity of the shadow. Defaults to 0. Specifying a value outside the
 * [0,1] range will give undefined results. Animatable. */

@property(nonatomic) CGFloat shadowOpacity;

/* The shadow offset. Defaults to (0, -3). Animatable. */

@property(nonatomic) CGSize shadowOffset;

/* The blur radius used to create the shadow. Defaults to 3. Animatable. */

@property(nonatomic) CGFloat shadowRadius;

@end
ST_ASSUME_NONNULL_END