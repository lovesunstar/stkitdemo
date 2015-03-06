//
//  STDLocationPickerController.m
//  STKitDemo
//
//  Created by SunJiangting on 15-2-27.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import "STDLocationPickerController.h"
#import <MapKit/MapKit.h>

@interface STAnnotation : NSObject <MKAnnotation>

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subtitle;

@end

@implementation STAnnotation
@synthesize coordinate = _coordinate;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    _coordinate = newCoordinate;
}

- (NSString *)title {
    return _title;
}

- (NSString *)subtitle {
    return _subtitle;
}

@end

@interface STDLocationPickerController () <MKMapViewDelegate>

@property(nonatomic, strong) MKMapView *mapView;

@end

@implementation STDLocationPickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"模拟当前位置";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除" target:self action:@selector(_clearFakeLocations:)];
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [[STLocationManager sharedManager] requestWhenInUseAuthorization];
    [self.view addSubview:self.mapView];
    
    UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_longPressGestureRecognizerActionFired:)];
    gestureRecognizer.minimumPressDuration = 0.5f;
    gestureRecognizer.delaysTouchesBegan = NO;
    [self.mapView addGestureRecognizer:gestureRecognizer];
    
    CLLocationCoordinate2D coordinate2D = [[self class] cachedFakeLocationCoordinate];
    if (coordinate2D.latitude * coordinate2D.longitude != 0) {
        [self _reloadLocateAnnotationWithCoordinate:coordinate2D];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_clearFakeLocations:(id)sender {
    CLLocationCoordinate2D coordinate2D = {0.0, 0.0};
    [[self class] setCachedFakeLocationCoordinate:coordinate2D];
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:1];
    [self.mapView.annotations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[STAnnotation class]]) {
            [annotations addObject:obj];
        }
    }];
    [self.mapView removeAnnotations:annotations];
}

- (void)_longPressGestureRecognizerActionFired:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    if (longPressGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [longPressGestureRecognizer locationInView:self.mapView];
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        longPressGestureRecognizer.enabled = NO;
        longPressGestureRecognizer.enabled = YES;
        [[self class] setCachedFakeLocationCoordinate:coordinate];
        [self _reloadLocateAnnotationWithCoordinate:coordinate];
    }
}

- (void)_reloadLocateAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate {
    STAnnotation *annotation = [[self.mapView annotations] firstObjectOfClass:[STAnnotation class]];
    if (!annotation) {
        annotation = [[STAnnotation alloc] init];
    } else {
        [self.mapView removeAnnotation:annotation];
    }
    annotation.title = [NSString stringWithFormat:@"%.8f, %.8f", coordinate.longitude, coordinate.latitude];
    annotation.coordinate = coordinate;
    [self.mapView addAnnotation:annotation];
}

+ (void)setCachedFakeLocationCoordinate:(CLLocationCoordinate2D)coordinate2D {
    NSDictionary *coordinate = @{@"longitude":@(coordinate2D.longitude), @"latitude":@(coordinate2D.latitude)};
    [[NSUserDefaults standardUserDefaults] setValue:coordinate forKey:STFakeLocationCoordinateCacheKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (CLLocationCoordinate2D)cachedFakeLocationCoordinate {
    NSDictionary *coordinate = [[NSUserDefaults standardUserDefaults] valueForKey:STFakeLocationCoordinateCacheKey];
    CLLocationCoordinate2D coordinate2D;
    coordinate2D.longitude = [coordinate[@"longitude"] doubleValue];
    coordinate2D.latitude = [coordinate[@"latitude"] doubleValue];
    return coordinate2D;
}
@end

NSString *const STFakeLocationCoordinateCacheKey = @"STFakeLocationCoordinateCacheKey";