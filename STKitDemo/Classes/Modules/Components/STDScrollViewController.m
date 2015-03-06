//
//  STDScrollViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 15-2-4.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import "STDScrollViewController.h"

@interface STDScrollView : UIView <UIGestureRecognizerDelegate>
@property (nonatomic) CGSize   contentSize;
@end

@implementation STDScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_panGestureActionFired:)];
        [self addGestureRecognizer:panGestureRecognizer];
        if (self.contentSize.width * self.contentSize.height == 0) {
            self.contentSize = frame.size;
        }
    }
    return self;
}


- (void)_panGestureActionFired:(UIPanGestureRecognizer *)panGestureRecognizer {
    static CGPoint panStartPoint;
    static CGRect  bounds;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        panStartPoint = [panGestureRecognizer locationInView:self];
        bounds = self.bounds;
    }
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint location = [panGestureRecognizer locationInView:self];
        CGPoint offset = CGPointMake(location.x - panStartPoint.x, location.y - panStartPoint.y);
        bounds.origin.x -= offset.x;
        bounds.origin.y -= offset.y;
        self.bounds = bounds;
    }
  
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint velocity = [gestureRecognizer velocityInView:self];
    return ABS(velocity.x) < ABS(velocity.y);
}

@end

@implementation STDScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    STDScrollView *scrollView = [[STDScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:scrollView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(0, 0, 320, 40);
    [scrollView addSubview:button];
    
}

@end
