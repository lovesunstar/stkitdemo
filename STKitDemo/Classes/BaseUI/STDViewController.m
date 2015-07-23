//
//  STDViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 13-11-20.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STDViewController.h"

@interface STDViewController () <UIGestureRecognizerDelegate>

@property(nonatomic, strong) UIView *presentationView;

@end

@implementation STDViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.customizeEdgeOffset = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor st_colorWithRGB:0xF9F9F9];

    self.presentationView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.presentationView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //    [self.view addSubview:self.presentationView];

    UIPanGestureRecognizer *panGestureRecognizer =
        [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerActionFired:)];
    [self.presentationView addGestureRecognizer:panGestureRecognizer];

    __weak STDViewController *weakSelf = self;
    self.presentationView.hitTestBlock = ^(CGPoint point, UIEvent *event, BOOL *returnSuper) {
        if (ABS(CGRectGetWidth(weakSelf.view.frame) - point.x) < 20) {
            *returnSuper = YES;
            return (UIView *)nil;
        }
        return (UIView *)nil;
    };

    if (STGetSystemVersion() < 7) {
        self.st_navigationBar.backgroundImage = [UIImage imageNamed:@"header_bkg"];
    }

    CGFloat value = [[[STPersistence standardPersistence] valueForKey:@"STDNavigationDefaultEdgeOffset"] floatValue];
    if (value == 0) {
        value = 80;
        [[STPersistence standardPersistence] setValue:@(value) forKey:@"STDNavigationDefaultEdgeOffset"];
    }
    if (self.customizeEdgeOffset) {
        self.st_maximumInteractivePopEdgeDistance = value;
    }

    CGFloat value1 = [[[STPersistence standardPersistence] valueForKey:@"STDNavigationDefaultOffset"] floatValue];
    if (value1 == 0) {
        value1 = 80;
        [[STPersistence standardPersistence] setValue:@(value1) forKey:@"STDNavigationDefaultOffset"];
    }
    self.st_interactivePopTransitionOffset = value1;

    // Do any additional setup after loading the view, typically from a nib.

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(maximumInteractiveDistanceChanged:)
                                                 name:@"STDNavigationDefaultEdgeOffset"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(maximumInteractiveOffsetChanged:)
                                                 name:@"STDNavigationDefaultOffset"
                                               object:nil];
}

- (void)maximumInteractiveDistanceChanged:(id)sender {
    self.st_maximumInteractivePopEdgeDistance = [[[STPersistence standardPersistence] valueForKey:@"STDNavigationDefaultEdgeOffset"] floatValue];
}

- (void)maximumInteractiveOffsetChanged:(id)sender {
    if (self.customizeEdgeOffset) {
        self.st_interactivePopTransitionOffset = [[[STPersistence standardPersistence] valueForKey:@"STDNavigationDefaultOffset"] floatValue];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)panGestureRecognizerActionFired:(UIPanGestureRecognizer *)sender {
    switch (sender.state) {
    case UIGestureRecognizerStateBegan:
        [self panGestureDidBegan:sender];
        break;
    case UIGestureRecognizerStateChanged:
        [self panGestureDidChanged:sender];
        break;
    case UIGestureRecognizerStateCancelled:
    case UIGestureRecognizerStateEnded:
    case UIGestureRecognizerStateFailed:
        [self panGestureDidCancelled:sender];
        break;

    default:
        break;
    }
}

static UIView *_statusBarSuperview;
- (void)panGestureDidBegan:(UIPanGestureRecognizer *)sender {
    //    _statusBarSuperview = self.view.statusBarWindow.superview;
    //    [self.view.statusBarWindow removeFromSuperview];
    //    [self.view addSubview:self.view.statusBarWindow];
    //    self.view.layer.masksToBounds = NO;
    //    self.view.clipsToBounds = NO;
}

- (void)panGestureDidChanged:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    if (ABS(translation.x) < 160) {
        CGFloat maximumAngel = M_PI_2;
        CATransform3D transform = CATransform3DMakeRotation(maximumAngel * (ABS(translation.x) / 240.0), 0., 1.0, 0.0);
        self.view.layer.transform = transform;

        CGFloat percent = ABS(translation.x) / 160.0f;
        [self transformView:self.view offset:-5 percent:percent];
    }
}

- (void)transformView:(UIView *)view offset:(CGFloat)offset percent:(CGFloat)percent {
    [view.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [self transformView:obj offset:(offset - 5)percent:percent];
        CATransform3D transform1 = CATransform3DMakeTranslation(offset * 0.2 * percent, -offset * percent, 0);
        //        transform = CATransform3DRotate(transform, 85 * M_PI / 180, .0, 1.0, 0);
        CATransform3D transform2 = CATransform3DMakeRotation(M_PI * 0.2 * percent, 0.5, 1.0, .0);
        CATransform3D transform = CATransform3DConcat(transform1, transform2);
        transform.m34 = -1.0 / 250.0;
        obj.layer.transform = transform;
    }];
}

- (void)resetView:(UIView *)view {
    [view.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [self resetView:obj];
        obj.layer.transform = CATransform3DIdentity;
    }];
}

- (void)panGestureDidCancelled:(UIPanGestureRecognizer *)sender {
    [self resetView:self.view];
    self.view.layer.transform = CATransform3DIdentity;
    //    [self.view.statusBarWindow removeFromSuperview];
    //    [_statusBarSuperview addSubview:self.view.statusBarWindow];
}
@end