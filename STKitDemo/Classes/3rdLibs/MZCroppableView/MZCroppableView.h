//
//  MZCroppableView.h
//  MZCroppableView
//
//  Created by macbook on 30/10/2013.
//  Copyright (c) 2013 macbook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZCroppableView : UIView
{
    
}
@property(nonatomic, strong) UIBezierPath *croppingPath;
@property(nonatomic, strong) UIColor *lineColor;
@property(nonatomic, assign) float lineWidth;

- (id)initWithImageView:(UIImageView *)imageView;
+ (CGPoint)convertCGPoint:(CGPoint)point1 fromRect1:(CGSize)rect1 toRect2:(CGSize)rect2;
+ (CGPoint)convertPoint:(CGPoint)point1 fromRect1:(CGSize)rect1 toRect2:(CGSize)rect2;
+ (CGRect)scaleRespectAspectFromRect1:(CGRect)rect1 toRect2:(CGRect)rect2;

- (UIImage *)deleteBackgroundOfImage:(UIImageView *)image;
@end
