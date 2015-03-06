//
//  STDReaderViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 13-12-31.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STDReaderViewController.h"

#import "STDBookViewController.h"
#import <STKit/STKit.h>

@interface STDReaderViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, STDBookViewControllerDelegate>

@property (nonatomic, strong) NSString * book;

@property (atomic, strong) NSArray  * pages;

@property (nonatomic, assign) long long offset;

@end

@implementation STDReaderViewController

- (instancetype)initWithContentsOfFile:(NSString *)path {
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        path = [[NSBundle mainBundle] pathForResource:@"book" ofType:@"txt"];;
    }
    NSString *book = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return [self initWithString:book];
}

- (instancetype)initWithString:(NSString *)string {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.book = string;
        self.navigationBarHidden = YES;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithContentsOfFile:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect frame = self.view.bounds;
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.view.backgroundColor = [UIColor clearColor];
    
    self.view.backgroundColor = [UIColor colorWithRGB:0x1C222D];
    self.pageViewController.view.frame = frame;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.pages.count == 0) {
        [self reloadBook];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if (![viewController isKindOfClass:[STNavigationController class]]) {
        return nil;
    }
    STNavigationController * oldNavigationController = (STNavigationController *)viewController;
    STDBookViewController * oldViewController = (STDBookViewController *) oldNavigationController.viewControllers[0];
    NSInteger page = oldViewController.page;
    if (page == 0) {
        UIGestureRecognizer * gestureRecognizer = self.customNavigationController.interactivePopGestureRecognizer;
        gestureRecognizer.enabled = YES;
        return nil;
    }
    NSRange prevRange = NSRangeFromString([self.pages objectAtIndex:page - 1]);
    NSString * content = [self.book substringWithRange:prevRange];
    self.offset = prevRange.location;
    
    STDBookViewController * previousViewController = STDBookViewController.new;
    STNavigationController * navigationController = [[STNavigationController alloc] initWithRootViewController:previousViewController];
    previousViewController.preferredNavigationBarHidden = YES;
    navigationController.interactivePopGestureRecognizer.enabled = NO;
    previousViewController.delegate = self;
    
    previousViewController.page = page - 1;
    previousViewController.total = self.pages.count;
    previousViewController.content = content;
    /// 往前翻的话，只有第0页支持左滑
    UIGestureRecognizer * gestureRecognizer = self.customNavigationController.interactivePopGestureRecognizer;
    if (page == 1) {
        gestureRecognizer.enabled = YES;
    } else {
        gestureRecognizer.enabled = NO;
    }
    
    return navigationController;
}

- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if (![viewController isKindOfClass:[STNavigationController class]]) {
        return nil;
    }
    STNavigationController * newerNavigationController = (STNavigationController *)viewController;
    STDBookViewController * newerViewController = (STDBookViewController *) newerNavigationController.viewControllers[0];
    NSInteger page = newerViewController.page;
    if (page == self.pages.count - 1 || page >= self.pages.count) {
        if (page == 0 && self.pages.count == 0) {
            UIGestureRecognizer * gestureRecognizer = self.customNavigationController.interactivePopGestureRecognizer;
            gestureRecognizer.enabled = YES;
        }
        return nil;
    }
    NSRange nextRange = NSRangeFromString([self.pages objectAtIndex:page + 1]);
    NSString * content = [self.book substringWithRange:nextRange];
    self.offset = nextRange.location;
    STDBookViewController * nextViewController = STDBookViewController.new;
    STNavigationController * navigationController = [[STNavigationController alloc] initWithRootViewController:nextViewController];
    navigationController.interactivePopGestureRecognizer.enabled = NO;
    nextViewController.preferredNavigationBarHidden = YES;
    nextViewController.delegate = self;
    nextViewController.page = page + 1;
    nextViewController.total = self.pages.count;
    nextViewController.content = content;
    /// 往后翻的话，都不支持左滑收拾
    UIGestureRecognizer * gestureRecognizer = self.customNavigationController.interactivePopGestureRecognizer;
    gestureRecognizer.enabled = NO;
    
    return navigationController;
}

#pragma mark - UIPageViewController delegate methods

/*
 - (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
 {
 
 }
 */

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    // Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
    return UIPageViewControllerSpineLocationMin;
}

#pragma mark - reloadBook

- (void) paginationBookCompletion:(void(^)(BOOL finished)) completion {
    NSDictionary * attributes = [[STThemeManager currentTheme] themeValueForKey:@"BookTextAttributes" whenContainedIn:NSClassFromString(@"STRichView")];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        CGSize size = self.pageViewController.view.bounds.size;
        CGFloat delta = (STGetSystemVersion() >= 7) ? 20 : 0;
        size.height -= delta;
        self.pages = [self.book paginationWithAttributes:attributes constrainedToSize:size];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.pages.count == 0) {
                completion(NO);
            } else {
                completion(YES);
            }
        });
    });
}

- (void) reloadBook {
    [STIndicatorView showInView:self.view animated:NO];
    [self paginationBookCompletion:^(BOOL finished) {
        if (finished) {
            NSUInteger page = [self pageOfOffset:self.offset];
            NSRange range = NSRangeFromString([self.pages objectAtIndex:page]);
            NSString * content = [self.book substringWithRange:range];
            STDBookViewController * bookViewController = STDBookViewController.new;
            STNavigationController * navigationController = [[STNavigationController alloc] initWithRootViewController:bookViewController];
            bookViewController.preferredNavigationBarHidden = NO;
            bookViewController.delegate = self;
            bookViewController.page = page;
            bookViewController.total = self.pages.count;
            bookViewController.content = content;
            self.pageViewController.delegate = self;
            self.pageViewController.dataSource = self;
            [self.pageViewController setViewControllers:@[navigationController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        }
        [STIndicatorView hideInView:self.view animated:YES];
    }];
}

- (NSUInteger) pageOfOffset:(long long) offset {
    __block NSUInteger pageIndex = 0;
    [self.pages enumerateObjectsUsingBlock:^(NSString * page, NSUInteger idx, BOOL *stop) {
        NSRange range = NSRangeFromString(page);
        if (range.location <= offset && (range.location + range.length > offset)) {
            pageIndex = idx;
            *stop = YES;
        }
    }];
    return pageIndex;
}

#pragma mark - Rotate 
- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self reloadBook];
}

#pragma mark - STDBookViewControllerDelegate

- (void) backViewController {
    [self.customNavigationController popViewControllerAnimated:YES];
}

- (void) navigationBarVisibleDidChangeTo:(BOOL)currentVisible {
    UIGestureRecognizer * gestureRecognizer = self.customNavigationController.interactivePopGestureRecognizer;
    NSArray * viewControllers = self.pageViewController.viewControllers;
    BOOL firstPage = NO;
    if (viewControllers.count > 0) {
        STNavigationController * navigationController = viewControllers[0];
        NSArray * array1 = navigationController.viewControllers;
        if (array1.count > 0) {
            STDBookViewController * bookViewController = navigationController.viewControllers[0];
            firstPage = bookViewController.page == 0;
        }
    }
    if (currentVisible || firstPage) {
        gestureRecognizer.enabled = YES;
    } else {
        gestureRecognizer.enabled = NO;
    }
}

@end
