//
//  STHanoiViewController.m
//  STBasic
//
//  Created by SunJiangting on 13-11-3.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STAHanoiViewController.h"
#import "STAHanoiView.h"
#import "STAHanoiOperation.h"

#import "STACodeViewController.h"
#import <STKit/STKit.h>

@interface STAHanoiViewController ()

@property (nonatomic, strong) STAHanoiView * hanoiView;

@property (nonatomic, strong) NSOperationQueue * animationQueue;
@end

@implementation STAHanoiViewController

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.animationQueue = [[NSOperationQueue alloc] init];
        self.animationQueue.maxConcurrentOperationCount = 1;
        
        self.numberOfHanois = 4;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.animationQueue = [[NSOperationQueue alloc] init];
        self.animationQueue.maxConcurrentOperationCount = 1;
        
        self.numberOfHanois = 4;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"汉诺塔";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"源码" target:self action:@selector(viewSourceCode:)];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
    }
    
    self.hanoiView = STAHanoiView.new;
    self.hanoiView.translatesAutoresizingMaskIntoConstraints = NO;
    self.hanoiView.numberOfHanois = self.numberOfHanois;
    [self.view addSubview:self.hanoiView];
    
    [self.view removeConstraints:self.view.constraints];
    NSDictionary * dict = @{@"hanoiView" : self.hanoiView};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[hanoiView(>=200)]-|" options:0 metrics:nil views:dict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[hanoiView(>=100)]-(30)-|" options:0 metrics:nil views:dict]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.hanoiView reloadHanoiView];
    [self moveHanoiWithNumber:self.numberOfHanois - 1 position0:0 position1:1 position2:2];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.animationQueue cancelAllOperations];
}

- (void) moveHanoiWithNumber:(NSInteger) number
                   position0:(NSInteger) position0
                   position1:(NSInteger) position1
                   position2:(NSInteger) position2 {
    if (number == 0) {
        STAHanoiOperation * operation1 = [[STAHanoiOperation alloc] init];
        operation1.index = position0;
        operation1.toIndex = position2;
        operation1.hanoiView = self.hanoiView;
        [self.animationQueue addOperation:operation1];
    } else {
        [self moveHanoiWithNumber:number - 1 position0:position0 position1:position2 position2:position1];
        
        STAHanoiOperation * operation2 = [[STAHanoiOperation alloc] init];
        operation2.index = position0;
        operation2.toIndex = position2;
        operation2.hanoiView = self.hanoiView;
        [self.animationQueue addOperation:operation2];
        
        [self moveHanoiWithNumber:number - 1 position0:position1 position1:position0 position2:position2];
    }
}

- (void) viewSourceCode:(id) sender {
    STACodeViewController * viewController = [[STACodeViewController alloc] initWithNibName:nil bundle:nil];
    viewController.algorithmType = STAlgorithmTypeHanoi;
    [self.customNavigationController pushViewController:viewController animated:YES];
}

@end
