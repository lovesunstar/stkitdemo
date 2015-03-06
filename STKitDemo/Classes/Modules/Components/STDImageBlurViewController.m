//
//  STDImageBlurViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 14-10-12.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDImageBlurViewController.h"
#import "MZCroppableView.h"
#import "UIBezierPath-Points.h"
#import <CoreImage/CoreImage.h>

@interface STDImageBlurViewController ()

@property(nonatomic, strong) UIView *containerView;
@property(nonatomic, strong) UIImageView *backgroundImageView;
@property(nonatomic, strong) MZCroppableView *croppableView;
@property(nonatomic, strong) UIImageView *coverImageView;

@end

@implementation STDImageBlurViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.interactivePopTransitionOffset = 15;
        self.customizeEdgeOffset = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"图片裁剪";

    UIView *containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:containerView];
    self.containerView = containerView;

    UIImage *backgroundImage = [UIImage imageNamed:@"LaunchImage"];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:containerView.bounds];
    backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    backgroundImageView.image = backgroundImage;
    [containerView addSubview:backgroundImageView];
    self.backgroundImageView = backgroundImageView;

    self.coverImageView = [[UIImageView alloc] initWithFrame:backgroundImageView.frame];
    self.coverImageView.autoresizingMask = backgroundImageView.autoresizingMask;
    [containerView addSubview:self.coverImageView];
    self.coverImageView.backgroundColor = [UIColor clearColor];
    self.coverImageView.hidden = YES;

    MZCroppableView *croppableView = [[MZCroppableView alloc] initWithImageView:backgroundImageView];
    croppableView.frame = containerView.bounds;
    croppableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [containerView addSubview:croppableView];
    self.croppableView = croppableView;

    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.height - 44, self.view.width, 44)];
    UIBarButtonItem *resetItem =
        [[UIBarButtonItem alloc] initWithTitle:@"重置" style:UIBarButtonItemStylePlain target:self action:@selector(resetActionFired:)];
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    UIBarButtonItem *finishItem =
        [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishActionFired:)];
    toolbar.items = @[ resetItem, flexibleItem, finishItem ];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:toolbar];

    containerView.bottom = toolbar.top;
}

- (void)resetActionFired:(id)sender {
    [self.croppableView removeFromSuperview];
    MZCroppableView *croppableView = [[MZCroppableView alloc] initWithImageView:self.backgroundImageView];
    croppableView.frame = self.containerView.bounds;
    croppableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.containerView addSubview:croppableView];
    self.croppableView = croppableView;
    self.coverImageView.hidden = YES;
}

- (void)finishActionFired:(id)sender {
    CGSize imageViewSize = self.backgroundImageView.size;
    CGSize imageSize = self.backgroundImageView.image.size;
    NSArray *points = [self.croppableView.croppingPath points];
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    {
        // Set the starting point of the shape.
        CGPoint p1 = [MZCroppableView convertCGPoint:[points[0] CGPointValue] fromRect1:imageViewSize toRect2:imageSize];
        [aPath moveToPoint:p1];
        for (uint i = 1; i < points.count; i++) {
            CGPoint p = [MZCroppableView convertCGPoint:[points[i] CGPointValue] fromRect1:imageViewSize toRect2:imageSize];
            [aPath addLineToPoint:p];
        }
        [aPath closePath];
    }
    UIImage *blurImage = [self.backgroundImageView.image blurImageWithRadius:20. tintColor:nil saturationDeltaFactor:1.3];
    UIGraphicsBeginImageContextWithOptions(blurImage.size, NO, [UIScreen mainScreen].scale);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(0, blurImage.size.width, blurImage.size.height, 8, blurImage.size.width * 4, colorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    UIGraphicsPushContext(context);
    CGContextDrawImage(context, CGRectMake(0, 0, blurImage.size.width, blurImage.size.height), blurImage.CGImage);
    CGContextSetBlendMode(context, (CGBlendMode)kCGBlendModeClear);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor);
    CGContextAddPath(context, aPath.CGPath);
    CGContextFillPath(context);
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIGraphicsEndImageContext();
    UIGraphicsPopContext();

    [self.croppableView removeFromSuperview];
    self.coverImageView.hidden = NO;
    self.coverImageView.image = [UIImage imageWithCGImage:cgImage];

    CFRelease(cgImage);
    CFRelease(context);
    CFRelease(colorSpace);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
