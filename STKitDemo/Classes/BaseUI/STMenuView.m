//
//  STMenuView.m
//  STKitDemo
//
//  Created by SunJiangting on 14-3-24.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STMenuView.h"

#import <STKit/UIKit+STKit.h>
#import <STKit/STButton.h>

@implementation STMenuItem : NSObject

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage title:(NSString *)title {
    self = [super init];
    if (self) {
        self.title = title;
        self.image = image;
        self.highlightedImage = highlightedImage;
    }
    return self;
}

@end

@interface STMenuView () <UIGestureRecognizerDelegate>

@property(nonatomic, strong) UIImageView *blurView;

@property(nonatomic, strong) NSMutableArray *dataSource;

@property(nonatomic, strong) UIButton *dismissButton;

@property(nonatomic, strong) NSMutableArray *menuItemViews;
@end

@implementation STMenuView

- (void)dealloc {
    //    [self.hitTestButton removeObserver:self forKeyPath:@"highlighted"];
}

- (instancetype)initWithDelegate:(id<NSObject>)delegate menuItem:(STMenuItem *)menuItem0, ... {

    NSMutableArray *menuItems = [NSMutableArray arrayWithCapacity:1];

    STMenuItem *menuItem = nil;
    va_list args;
    if (menuItem0) {
        [menuItems addObject:menuItem0];
        va_start(args, menuItem0);
        while ((menuItem = va_arg(args, STMenuItem *))) {
            [menuItems addObject:menuItem];
        }
        va_end(args);
    }
    return [self initWithDelegate:delegate menuItems:menuItems];
}

- (instancetype)initWithDelegate:(id<NSObject>)delegate menuItems:(NSArray *)menuItems {
    self = [super initWithFrame:CGRectZero];
    if (self) {

        self.dataSource = [NSMutableArray arrayWithArray:menuItems];
        self.menuItemViews = [NSMutableArray arrayWithCapacity:menuItems.count];

        self.blurView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.blurView.userInteractionEnabled = YES;
        self.blurView.backgroundColor = [UIColor clearColor];
        self.blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.blurView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.blurView];

        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureActionFired:)];
        panGestureRecognizer.delegate = self;
        [self.blurView addGestureRecognizer:panGestureRecognizer];

        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureActionFired:)];
        tapGestureRecognizer.delegate = self;
        [self.blurView addGestureRecognizer:tapGestureRecognizer];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"aero_button"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(dismissAnimated:) forControlEvents:UIControlEventTouchUpInside];
        [self.blurView addSubview:button];
        [self reloadMenuItems];

        self.dismissButton = button;

        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
        slider.minimumValue = 50;
        slider.maximumValue = 100;
        slider.value = 100;
        [slider addTarget:self action:@selector(sliderValueActionFired:) forControlEvents:UIControlEventValueChanged];
        [self.blurView addSubview:slider];
    }
    return self;
}

- (void)sliderValueActionFired:(UISlider *)slider {
    self.blurView.alpha = slider.value / 100;
}

- (STMenuItem *)menuItemAtIndex:(NSUInteger)index {
    return [self.dataSource objectAtIndex:index];
}

- (void)reloadMenuItems {
    [self.menuItemViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) { [view removeFromSuperview]; }];
    [self.menuItemViews removeAllObjects];
    [self.dataSource enumerateObjectsUsingBlock:^(STMenuItem *menuItem, NSUInteger idx, BOOL *stop) {
        STButton *button = [STButton buttonWithType:UIButtonTypeCustom];
        button.usingSystemLayout = NO;
        button.imageView.image = menuItem.image;
        button.titleLabel.text = menuItem.title;

        [self.blurView addSubview:button];
        [self.menuItemViews addObject:button];
    }];
}

- (void)showInView:(UIView *)view animated:(BOOL)animated {
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    UIImage *snapView = [view st_snapshotImage];
    UIImage *image = [snapView st_blurImageWithStyle:STBlurEffectStyleLight];
    self.blurView.image = image;

    self.frame = view.bounds;
    [view addSubview:self];

    self.dismissButton.frame = CGRectMake(0, CGRectGetHeight(view.frame) - 49, CGRectGetWidth(view.frame), 49);
    [self layoutMenuItems];

    self.blurView.alpha = 0;

    void (^animation)(void) = ^{ self.blurView.alpha = 1.0; };

    void (^completion)(BOOL) = ^(BOOL finished) { self.blurView.alpha = 1.0; };
    [self riseAnimation];
    if (animated) {
        [UIView animateWithDuration:0.35 animations:animation completion:completion];
    } else {
        animation();
        completion(YES);
    }
}

- (CGRect)frameForMenuAtIndex:(NSUInteger)index {
    NSUInteger columnCount = 3;
    NSUInteger columnIndex = index % columnCount;
    NSUInteger rowCount = self.menuItemViews.count / columnCount + (self.menuItemViews.count % columnCount > 0 ? 1 : 0);
    NSUInteger rowIndex = index / columnCount;
    CGFloat itemHeight = (STMenuItemImageSize.height + 20) * rowCount + (rowCount > 1 ? (rowCount - 1) * 10 : 0);
    CGFloat offsetY = (CGRectGetHeight(self.bounds) - itemHeight - CGRectGetHeight(self.dismissButton.bounds)) / 2.0;
    CGFloat verticalPadding = (CGRectGetWidth(self.bounds) - 10 * 2 - STMenuItemImageSize.height * 3) / 2.0;

    CGFloat offsetX = 10;
    offsetX += (STMenuItemImageSize.height + verticalPadding) * columnIndex;
    offsetY += (STMenuItemImageSize.height + 30) * rowIndex;
    return CGRectMake(offsetX, offsetY, STMenuItemImageSize.width, STMenuItemImageSize.width + 20);
}

- (void)layoutMenuItems {
    [self.menuItemViews enumerateObjectsUsingBlock:^(STButton *subview, NSUInteger idx, BOOL *stop) {
        subview.frame = [self frameForMenuAtIndex:idx];
        subview.imageView.frame = CGRectMake(0, 0, STMenuItemImageSize.width, STMenuItemImageSize.height);
        subview.titleLabel.frame = CGRectMake(0, STMenuItemImageSize.height, STMenuItemImageSize.width, 20);
    }];
}

- (void)dismissAnimated:(BOOL)animated {
    [self dropAnimation];
    self.blurView.alpha = 1.0;
    void (^animation)(void) = ^{ self.blurView.alpha = 0.0; };
    void (^completion)(BOOL) = ^(BOOL finished) {
        self.blurView.alpha = 0.0;
        self.blurView.image = nil;
        [self.menuItemViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) { [obj.layer removeAllAnimations]; }];
        [self removeFromSuperview];
    };
    if (animated) {
        [UIView animateWithDuration:0.35 animations:animation completion:completion];
    } else {
        animation();
        completion(YES);
    }
    [[NSURLCache sharedURLCache] setMemoryCapacity:1024];
}

- (void)hitButtonTouchUpInside:(UIButton *)sender {
    [self.dismissButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)riseAnimation {
    NSUInteger columnCount = 3;
    NSUInteger rowCount = self.menuItemViews.count / columnCount + (self.menuItemViews.count % columnCount > 0 ? 1 : 0);

    [self.menuItemViews enumerateObjectsUsingBlock:^(STButton *button, NSUInteger idx, BOOL *stop) {
        button.layer.opacity = 0;
        CGRect frame = [self frameForMenuAtIndex:idx];
        NSInteger rowIndex = idx / columnCount;
        NSInteger columnIndex = idx % columnCount;
        CGPoint fromPosition = CGPointMake(frame.origin.x + STMenuItemImageSize.width / 2.0,
                                           frame.origin.y + (rowCount - rowIndex + 2) * 200 + (STMenuItemImageSize.height + 20) / 2);
        CGPoint toPosition = CGPointMake(frame.origin.x + STMenuItemImageSize.width / 2, frame.origin.y + (STMenuItemImageSize.height + 20) / 2.);
        double delayInSeconds = rowIndex * columnCount * 0.07;

        if (!columnIndex) {
            delayInSeconds += 0.07;
        } else if (columnIndex == 2) {
            delayInSeconds += 0.07 * 2;
        }

        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:fromPosition];
        positionAnimation.toValue = [NSValue valueWithCGPoint:toPosition];
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.45f:0.6f:0.75f:1.0f];
        positionAnimation.duration = 0.35;
        positionAnimation.beginTime = [button.layer convertTime:CACurrentMediaTime() fromLayer:nil] + delayInSeconds;
        [positionAnimation setValue:[NSNumber numberWithUnsignedInteger:idx] forKey:@"STMenuPresentAnimationKey"];
        positionAnimation.delegate = self;

        [button.layer addAnimation:positionAnimation forKey:@"riseAnimation"];

    }];
}

- (void)dropAnimation {
    NSUInteger columnCount = 3;
    __block double delayInSeconds;
    [self.menuItemViews enumerateObjectsUsingBlock:^(UIView *button, NSUInteger idx, BOOL *stop) {
        button.layer.opacity = 1.0;
        CGRect frame = [self frameForMenuAtIndex:idx];
        NSInteger rowIndex = idx / columnCount;
        NSInteger columnIndex = idx % columnCount;
        CGPoint fromPosition =
            CGPointMake(frame.origin.x + STMenuItemImageSize.width / 2.0, frame.origin.y + (STMenuItemImageSize.height + 20) / 2.0);
        CGPoint toPosition = CGPointMake(frame.origin.x + STMenuItemImageSize.width / 2.0,
                                         frame.origin.y - (rowIndex + 2) * 200 + (STMenuItemImageSize.height + 20) / 2.0);
        delayInSeconds = rowIndex * columnCount * 0.07;

        if (!columnIndex) {
            delayInSeconds += 0.07;
        } else if (columnIndex == 2) {
            delayInSeconds += 0.07 * 2;
        }

        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:fromPosition];
        positionAnimation.toValue = [NSValue valueWithCGPoint:toPosition];
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.3:0.5f:1.0f:1.0f];
        positionAnimation.duration = 0.35;
        positionAnimation.beginTime = [button.layer convertTime:CACurrentMediaTime() fromLayer:nil] + delayInSeconds;
        [positionAnimation setValue:[NSNumber numberWithUnsignedInteger:idx] forKey:@"STMenuDismissAnimationKey"];
        positionAnimation.delegate = self;
        [button.layer addAnimation:positionAnimation forKey:@"riseAnimation"];
    }];
}

- (void)animationDidStart:(CAAnimation *)animation {
    NSUInteger columnCount = 3;
    if ([animation valueForKey:@"STMenuPresentAnimationKey"]) {
        NSUInteger index = [[animation valueForKey:@"STMenuPresentAnimationKey"] unsignedIntegerValue];
        UIView *view = self.menuItemViews[index];
        CGRect frame = [self frameForMenuAtIndex:index];
        CGPoint toPosition = CGPointMake(frame.origin.x + STMenuItemImageSize.width / 2.0, frame.origin.y + (STMenuItemImageSize.height + 20) / 2.0);
        CGFloat toAlpha = 1.0;

        view.layer.position = toPosition;
        view.layer.opacity = toAlpha;
    } else if ([animation valueForKey:@"STMenuDismissAnimationKey"]) {
        NSUInteger index = [[animation valueForKey:@"STMenuDismissAnimationKey"] unsignedIntegerValue];
        NSUInteger rowIndex = index / columnCount;
        UIView *view = self.menuItemViews[index];
        CGRect frame = [self frameForMenuAtIndex:index];
        CGPoint toPosition = CGPointMake(frame.origin.x + STMenuItemImageSize.width / 2.0,
                                         frame.origin.y - (rowIndex + 2) * 200 + (STMenuItemImageSize.height + 20) / 2.0);
        view.layer.position = toPosition;
    }
}

- (void)panGestureActionFired:(UIPanGestureRecognizer *)sender {
    static BOOL effected = NO;
    switch (sender.state) {
    case UIGestureRecognizerStateBegan:
        effected = YES;
        self.dismissButton.highlighted = YES;
        break;
    case UIGestureRecognizerStateChanged:
        if (ABS([sender translationInView:self.blurView].x) > 50 || ABS([sender translationInView:self.blurView].y) > 50) {
            effected = NO;
            self.dismissButton.highlighted = NO;
        } else {
            self.dismissButton.highlighted = YES;
            effected = YES;
        }
        break;
    case UIGestureRecognizerStateFailed:
    case UIGestureRecognizerStateEnded:
    case UIGestureRecognizerStateCancelled:
        if (effected) {
            [self.dismissButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        self.dismissButton.highlighted = NO;
        break;
    default:
        break;
    }
}

- (void)tapGestureActionFired:(UITapGestureRecognizer *)sender {
    switch (sender.state) {
    case UIGestureRecognizerStateBegan:
        self.dismissButton.highlighted = YES;
        break;
    case UIGestureRecognizerStateChanged:
        break;
    case UIGestureRecognizerStateFailed:
    case UIGestureRecognizerStateEnded:
    case UIGestureRecognizerStateCancelled:
        [self.dismissButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        self.dismissButton.highlighted = NO;
        break;
    default:
        break;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == self.blurView) {
        self.dismissButton.highlighted = YES;
        return YES;
    }
    return NO;
}
@end

const CGSize STMenuItemImageSize = {75, 75};
