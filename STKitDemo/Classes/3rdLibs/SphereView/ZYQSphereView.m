//
//  ZYQSphereView.m
//  SphereViewSample
//
//  Created by Zhao Yiqi on 13-12-8.
//  Copyright (c) 2013年 Zhao Yiqi. All rights reserved.
//

#import "ZYQSphereView.h"
#import "PFGoldenSectionSpiral.h"
#import <QuartzCore/QuartzCore.h>

@interface ZYQSphereView(Private)
- (CGFloat)coordinateForNormalizedValue:(CGFloat)normalizedValue withinRangeOffset:(CGFloat)rangeOffset;
- (void)rotateSphereByAngle:(CGFloat)angle fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;
- (void)layoutViews;
- (void)layoutView:(UIView *)view withPoint:(PFPoint)point;
@end

@interface ZYQSphereView (){
    CGFloat intervalX;
    CGFloat intervalY;
}

@property(nonatomic,strong)NSTimer *timer;

@end

@implementation ZYQSphereView

-(BOOL)isTimerStart{
    return [_timer isValid];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
		panRecognizer.minimumNumberOfTouches = 1;
		[self addGestureRecognizer:panRecognizer];
		
		UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
		[self addGestureRecognizer:pinchRecognizer];
		
		UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationGesture:)];
		[self addGestureRecognizer:rotationRecognizer];
        
        intervalX = 1.0f;
    }
    return self;
}

-(void)changeView{
    CGPoint normalPoint=self.frame.origin;
    CGPoint movePoint=CGPointMake(self.frame.origin.x+intervalX, self.frame.origin.y+intervalY);
    
    [self rotateSphereByAngle:1.0f fromPoint:normalPoint toPoint:movePoint];
}

-(void)timerStart{
    if (_timer.isValid) {
        [_timer invalidate];
    }
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeView) userInfo:nil repeats:YES];
}

-(void)timerStop{
    if (_timer.isValid) {
        [_timer invalidate];
    }
}

- (void)setItems:(NSArray *)items {
	pointMap = [[NSMutableDictionary alloc] init];
	
	NSArray *spherePoints = [PFGoldenSectionSpiral sphere:items.count];
	for (NSInteger i=0; i<items.count; i++) {

		NSString *pointRep = [spherePoints objectAtIndex:i];
        PFPoint point = PFPointFromString(pointRep);
		UIView *view = items[i];
		view.tag = i;
		[self layoutView:view withPoint:point];
		[self addSubview:view];
				
		[pointMap setObject:pointRep forKey:@(i)];
	}
	
	[self rotateSphereByAngle:1.0f fromPoint:CGPointMake(0.f, 0.f) toPoint:CGPointMake(0.f, 1.0f)];
}

- (void)setFrame:(CGRect)pFrame {
	[super setFrame:pFrame];
	originalSphereViewBounds = self.bounds;
}



#pragma mark -
#pragma mark UIGestureRecognizer methods

- (void)handlePanGesture:(UIPanGestureRecognizer *)panRecognizer {
	switch (panRecognizer.state) {
		case UIGestureRecognizerStateBegan:
			originalLocationInView = [panRecognizer locationInView:self];
			previousLocationInView = originalLocationInView;
			break;
		case UIGestureRecognizerStateChanged: {
			CGPoint touchPoint = [panRecognizer locationInView:self];
			
			CGPoint normalizedTouchPoint = CGPointMakeNormalizedPoint(touchPoint, self.frame.size.width);
			CGPoint normalizedPreviousTouchPoint = CGPointMakeNormalizedPoint(previousLocationInView, self.frame.size.width);
			CGPoint normalizedOriginalTouchPoint = CGPointMakeNormalizedPoint(originalLocationInView, self.frame.size.width);
			
            // Touch direction handling
			PFAxisDirection xAxisDirection = PFDirectionMakeXAxisSensitive(normalizedPreviousTouchPoint, normalizedTouchPoint);
			if (xAxisDirection != lastXAxisDirection && xAxisDirection != PFAxisDirectionNone) {
				lastXAxisDirection = xAxisDirection;
				
				originalLocationInView = CGPointMake(touchPoint.x, previousLocationInView.y);
			}
			
			PFAxisDirection yAxisDirection = PFDirectionMakeYAxisSensitive(normalizedPreviousTouchPoint, normalizedTouchPoint);
			if (yAxisDirection != lastYAxisDirection && yAxisDirection != PFAxisDirectionNone) {
				lastYAxisDirection = yAxisDirection;
				originalLocationInView = CGPointMake(previousLocationInView.x, touchPoint.y);
			}
			
			previousLocationInView = touchPoint;
			
            intervalX=normalizedTouchPoint.x < normalizedOriginalTouchPoint.x ? -1.0f : 1.f;
            intervalY=normalizedTouchPoint.y < normalizedOriginalTouchPoint.y ? -1.0f : 1.f;

			// Sphere rotation
			[self rotateSphereByAngle:1.0f fromPoint:normalizedOriginalTouchPoint toPoint:normalizedTouchPoint];
		}
			
			break;
		default:
			break;
	}
    if (_isPanTimerStart) {
        [self timerStart];
    }

}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchRecognizer {
	static CGRect InitialSphereViewBounds;
	
	UIView *view = pinchRecognizer.view;
	
	if (pinchRecognizer.state == UIGestureRecognizerStateBegan){
		InitialSphereViewBounds = view.bounds;
	}
	
	CGFloat factor = pinchRecognizer.scale;
	
	CGAffineTransform scaleTransform = CGAffineTransformScale(CGAffineTransformIdentity, factor, factor);
	
	CGRect sphereFrame = CGRectApplyAffineTransform(InitialSphereViewBounds, scaleTransform);
	CGRect screenFrame = [UIScreen mainScreen].bounds;
	
	if ((sphereFrame.size.width > screenFrame.size.width 
		&& sphereFrame.size.height > screenFrame.size.height)
		|| (sphereFrame.size.width < originalSphereViewBounds.size.width 
			&& sphereFrame.size.height < originalSphereViewBounds.size.height)) {
		return;
	}
	
	view.bounds = sphereFrame;
	
    
	[self layoutViews];
}

- (void)handleRotationGesture:(UIRotationGestureRecognizer *)rotationRecognizer {
	static CGFloat LastSphereRotationAngle;
	
	if (rotationRecognizer.state == UIGestureRecognizerStateEnded) {
		LastSphereRotationAngle = 0;
		return;
	}
	
	PFAxisDirection rotationDirection;
	
	CGFloat rotation = rotationRecognizer.rotation;
	
	if (rotation > LastSphereRotationAngle) {
		rotationDirection = PFAxisDirectionPositive;
	} else {
		rotationDirection = PFAxisDirectionNegative;
        
	}
		
	rotation = fabs(rotation) * rotationDirection;
	
	NSArray *subviews = self.subviews;
	for (NSInteger i = 0; i<subviews.count; i++) {
		UIView *view = [subviews objectAtIndex:i];
		
		NSNumber *key = @(i);
		
		PFPoint point = PFPointFromString([pointMap objectForKey:key]);
		
		PFPoint aroundPoint = PFPointMake(0.0f, 0.0f, 0.0f);
		PFMatrix coordinate = PFMatrixTransform3DMakeFromPFPoint(point);

		PFMatrix transform = PFMatrixTransform3DMakeZRotationOnPoint(aroundPoint, rotation);
		
		point = PFPointMakeFromMatrix(PFMatrixMultiply(coordinate, transform)); 
		
        [pointMap setObject:NSStringFromPFPoint(point) forKey:key];
		[self layoutView:view withPoint:point];
	}
	
	LastSphereRotationAngle = rotationRecognizer.rotation;
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapRecognizer {
    if ([self isTimerStart]) {
        [self timerStop];
    } else{
        [self timerStart];
    }
}


#pragma mark -
#pragma mark Animation methods

- (void)rotateSphereByAngle:(CGFloat)angle fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
	NSArray *subviews = self.subviews;
	for (NSInteger i = 0; i < subviews.count; i++) {
		UIView *view = [subviews objectAtIndex:i];
		NSNumber *key = @(i);
        PFPoint point = PFPointFromString([pointMap objectForKey:key]);
		
		PFPoint aroundPoint = PFPointMake(0.0f, 0.0f, 0.0f);
		PFMatrix coordinate = PFMatrixTransform3DMakeFromPFPoint(point);
		
		PFMatrix transform = PFMatrixMakeIdentity(4, 4);
		PFAxisDirection xAxisDirection = PFDirectionMakeXAxis(fromPoint, toPoint);
		if (xAxisDirection != PFAxisDirectionNone) {
			transform = PFMatrixMultiply(transform, PFMatrixTransform3DMakeYRotationOnPoint(aroundPoint, xAxisDirection * -angle));
		}
		
		PFAxisDirection yAxisDirection = PFDirectionMakeYAxis(fromPoint, toPoint);
		if (yAxisDirection != PFAxisDirectionNone) {
			transform = PFMatrixMultiply(transform, PFMatrixTransform3DMakeXRotationOnPoint(aroundPoint, yAxisDirection * angle));
		}
		
		point = PFPointMakeFromMatrix(PFMatrixMultiply(coordinate, transform));
        [pointMap setObject:NSStringFromPFPoint(point) forKey:key];
		[self layoutView:view withPoint:point];
	}
}

- (CGFloat)coordinateForNormalizedValue:(CGFloat)normalizedValue withinRangeOffset:(CGFloat)rangeOffset {
	CGFloat half = rangeOffset / 2.f;
	CGFloat coordinate = fabs(normalizedValue) * half;
	if (normalizedValue > 0) {
		coordinate += half;
	} else {
		coordinate = half - coordinate;
	}
	return coordinate;
}

- (void)layoutView:(UIView *)view withPoint:(PFPoint)point {
	CGFloat viewSize = CGRectGetWidth(view.frame);
	CGFloat width = CGRectGetWidth(self.frame) - viewSize * 2.0f;
	CGFloat x = [self coordinateForNormalizedValue:point.x withinRangeOffset:width];
	CGFloat y = [self coordinateForNormalizedValue:point.y withinRangeOffset:width];
	view.center = CGPointMake(x + viewSize, y + viewSize);
	
	CGFloat z = [self coordinateForNormalizedValue:point.z withinRangeOffset:1.0f];
	
	view.transform = CGAffineTransformScale(CGAffineTransformIdentity, z, z);
	view.layer.zPosition = z;
}

- (void)layoutViews {
	NSArray *subviews = self.subviews;
	for (NSInteger i = 0; i < subviews.count; i ++) {
		UIView *view = [subviews objectAtIndex:i];
		NSNumber *key = @(i);
        PFPoint point = PFPointFromString([pointMap objectForKey:key]);
		[self layoutView:view withPoint:point];
	}		
}

- (void)dealloc {
    if ([_timer isValid]) {
        [_timer invalidate];
    }
}

@end
