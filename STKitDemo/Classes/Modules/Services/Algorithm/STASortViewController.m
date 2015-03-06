//
//  STASortViewController.m
//  STBasic
//
//  Created by SunJiangting on 13-11-1.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STASortViewController.h"

#import "STASortOperation.h"
#import "STASortView.h"

#import "STACodeViewController.h"
#import <STKit/UIKit+STKit.h>

@interface STASortViewController ()

@property (nonatomic, strong) STASortView * sortView;

@property (nonatomic, strong) NSOperationQueue * animationQueue;

@property (nonatomic, strong) NSMutableArray * sortMutableArray;

@end

@implementation STASortViewController


- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.animationQueue = [[NSOperationQueue alloc] init];
        self.animationQueue.maxConcurrentOperationCount = 1;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.animationQueue = [[NSOperationQueue alloc] init];
        self.animationQueue.maxConcurrentOperationCount = 1;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"源码" target:self action:@selector(viewSourceCode:)];
    
    
    [self.view removeConstraints:self.view.constraints];
    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
    
    STASortView * sortView = STASortView.new;
    sortView.translatesAutoresizingMaskIntoConstraints = NO;
    [sortView reloadSortDataSource:self.sortArray];
    [self.view addSubview:sortView];
    self.sortView = sortView;
    
    NSDictionary * dict = @{@"sortView":self.sortView};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[sortView]|" options:0 metrics:nil views:dict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[sortView]|" options:0 metrics:nil views:dict]];

    switch (self.arraySortType) {
       
        case STArraySortTypeBubbleSort:
            self.navigationItem.title = @"冒泡排序";
            break;
        case STArraySortTypeSelectSort:
            self.navigationItem.title = @"选择排序";
            break;
        case STArraySortTypeInsertSort:
            self.navigationItem.title = @"插入排序";
            break;
        case STArraySortTypeQuickSort:
            self.navigationItem.title = @"快速排序";
            break;
        default:
            break;
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.sortView reloadSortDataSource:self.sortArray];
    switch (self.arraySortType) {
        case STArraySortTypeBubbleSort:
            [self sortUsingBubbleTypeWithArray:self.sortArray];
            break;
        case STArraySortTypeSelectSort:
            [self sortUsingSelectTypeWithArray:self.sortMutableArray];
            break;
        case STArraySortTypeInsertSort:
            [self sortUsingInsertTypeWithArray:self.sortMutableArray];
            break;
        case STArraySortTypeQuickSort:
            [self sortUsingQuickTypeWithArray:self.sortMutableArray leftOffset:0 rightOffset:self.sortArray.count - 1];
            break;
        default:
            break;
    }
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.animationQueue cancelAllOperations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                 duration:(NSTimeInterval)duration {
    
}

#pragma mark - 插入排序
- (void) sortUsingInsertTypeWithArray:(NSMutableArray *) array {
    NSInteger count = array.count;
    for (int i = 1; i < count; i ++) {
        
        STASortOperation * operation1 = [[STASortOperation alloc] init];
        operation1.operationType = STSortOperationTypeMoveBaseline1;
        operation1.index1 = i;
        operation1.sortView = self.sortView;
        [self.animationQueue addOperation:operation1];
        
        id objI = [array objectAtIndex:i], objJ;
        int j = i;
        STASortOperation * operation2 = [[STASortOperation alloc] init];
        operation2.operationType = STSortOperationTypeMoveBaseline2;
        operation2.index2 = j;
        operation2.sortView = self.sortView;
        [self.animationQueue addOperation:operation2];
        
        
        STASortOperation * operation3 = [[STASortOperation alloc] init];
        operation3.operationType = STSortOperationTypeCacheUpElement;
        operation3.index1 = j;
        operation3.sortView = self.sortView;
        [self.animationQueue addOperation:operation3];
        
        while (j > 0 && [(objJ = [array objectAtIndex:j - 1]) intValue] > [objI intValue]) {

            [array replaceObjectAtIndex:j withObject:objJ];
            
            STASortOperation * operation4 = [[STASortOperation alloc] init];
            operation4.operationType = STSortOperationTypeMoveElement;
            operation4.index1 = j - 1;
            operation4.index2 = j;
            operation4.sortView = self.sortView;
            [self.animationQueue addOperation:operation4];
            
            j --;
            STASortOperation * operation5 = [[STASortOperation alloc] init];
            operation5.operationType = STSortOperationTypeMoveBaseline2;
            operation5.index2 = j;
            operation5.sortView = self.sortView;
            [self.animationQueue addOperation:operation5];
        }
        [array replaceObjectAtIndex:j withObject:objI];
        STASortOperation * operation6 = [[STASortOperation alloc] init];
        operation6.operationType = STSortOperationTypeCacheDownElement;
        operation6.sortView = self.sortView;
        [self.animationQueue addOperation:operation6];
    }
}

#pragma mark - 选择排序
- (void) sortUsingSelectTypeWithArray:(NSMutableArray *) array {
    NSInteger count = array.count;
    for (int i = 0; i < count; i ++) {
        STASortOperation * operation1 = [[STASortOperation alloc] init];
        operation1.operationType = STSortOperationTypeMoveBaseline1;
        operation1.index1 = i;
        operation1.sortView = self.sortView;
        [self.animationQueue addOperation:operation1];
        
        for (int j = i; j < count; j ++) {
            STASortOperation * operation2 = [[STASortOperation alloc] init];
            operation2.operationType = STSortOperationTypeMoveBaseline2;
            operation2.index2 = j;
            operation2.sortView = self.sortView;
            [self.animationQueue addOperation:operation2];
            id objI = [array objectAtIndex:i];
            id objJ = [array objectAtIndex:j];
            if ([objI intValue] > [objJ intValue]) {
                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
                STASortOperation * operation3 = [[STASortOperation alloc] init];
                operation3.operationType = STSortOperationTypeExchangeElement;
                operation3.index1 = i;
                operation3.index2 = j;
                operation3.sortView = self.sortView;
                [self.animationQueue addOperation:operation3];
            }
        }
    }
}

#pragma mark - 快速排序
- (void) sortUsingQuickTypeWithArray:(NSMutableArray *) array
                          leftOffset:(NSInteger) left
                         rightOffset:(NSInteger) right {
    if (left < right) {
        
        id key = [array objectAtIndex:left];
        
        STASortOperation * operation0 = [[STASortOperation alloc] init];
        operation0.operationType = STSortOperationTypeCacheUpElement;
        operation0.index1 = left;
        operation0.sortView = self.sortView;
        [self.animationQueue addOperation:operation0];
        
        
        NSInteger low = left;
        NSInteger high = right;
        
        STASortOperation * operation1 = [[STASortOperation alloc] init];
        operation1.operationType = STSortOperationTypeMoveBaseline1;
        operation1.index1 = low;
        operation1.sortView = self.sortView;
        [self.animationQueue addOperation:operation1];
        
        STASortOperation * operation2 = [[STASortOperation alloc] init];
        operation2.operationType = STSortOperationTypeMoveBaseline2;
        operation2.index2 = high;
        operation2.sortView = self.sortView;
        [self.animationQueue addOperation:operation2];
        
        while (low < high) {
            while (low < high && [[array objectAtIndex:high] intValue] >= [key intValue]) {
                high --;                
                STASortOperation * operation3 = [[STASortOperation alloc] init];
                operation3.operationType = STSortOperationTypeMoveBaseline2;
                operation3.index2 = high;
                operation3.sortView = self.sortView;
                [self.animationQueue addOperation:operation3];
            }
            [array replaceObjectAtIndex:low withObject:[array objectAtIndex:high]];

            STASortOperation * operation5 = [[STASortOperation alloc] init];
            operation5.operationType = STSortOperationTypeMoveElement;
            operation5.index1 = high;
            operation5.index2 = low;
            operation5.sortView = self.sortView;
            [self.animationQueue addOperation:operation5];
        
            
            while (low < high && [[array objectAtIndex:low] intValue] <= [key intValue]) {
                low ++;
                STASortOperation * operation6 = [[STASortOperation alloc] init];
                operation6.operationType = STSortOperationTypeMoveBaseline1;
                operation6.index1 = low;
                operation6.sortView = self.sortView;
                [self.animationQueue addOperation:operation6];
            }
            [array replaceObjectAtIndex:high withObject:[array objectAtIndex:low]];

            STASortOperation * operation8 = [[STASortOperation alloc] init];
            operation8.operationType = STSortOperationTypeMoveElement;
            operation8.index1 = low;
            operation8.index2 = high;
            operation8.sortView = self.sortView;
            [self.animationQueue addOperation:operation8];
        }
        [array replaceObjectAtIndex:low withObject:key];
        STASortOperation * operation9 = [[STASortOperation alloc] init];
        operation9.operationType = STSortOperationTypeCacheDownElement;
        operation9.index1 = left;
        operation9.index2 = low;
        operation9.sortView = self.sortView;
        [self.animationQueue addOperation:operation9];
        
        [self sortUsingQuickTypeWithArray:array leftOffset:left rightOffset:low - 1];
        [self sortUsingQuickTypeWithArray:array leftOffset:low + 1 rightOffset:right];
    }
}

#pragma mark - 冒泡排序
- (void) sortUsingBubbleTypeWithArray:(NSArray *) array {
    NSMutableArray * sortArray = [NSMutableArray arrayWithArray:array];
    BOOL exchanged = YES;
    NSInteger count = sortArray.count;
    for (int i = 0; i < count - 1 && exchanged; i ++) {
        exchanged = NO;
        STASortOperation * operation0 = [[STASortOperation alloc] init];
        operation0.operationType = STSortOperationTypeMoveBaseline1;
        operation0.index1 = i;
        operation0.sortView = self.sortView;
        [self.animationQueue addOperation:operation0];

        for (int j = 0; j < (count - 1 - i); j ++) {
            STASortOperation * operation1 = [[STASortOperation alloc] init];
            operation1.operationType = STSortOperationTypeMoveBaseline2;
            operation1.index2 = j;
            operation1.sortView = self.sortView;
            [self.animationQueue addOperation:operation1];
            
            id obj0 = [sortArray objectAtIndex:j];
            id obj1 = [sortArray objectAtIndex:j + 1];
            if ([obj0 intValue] > [obj1 intValue]) {
                exchanged = YES;
                /// 需要交换 obj0,obj1
                [sortArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                STASortOperation * operation3 = [[STASortOperation alloc] init];
                operation3.operationType = STSortOperationTypeExchangeElement;
                operation3.index1 = j;
                operation3.index2 = j + 1;
                operation3.sortView = self.sortView;
                [self.animationQueue addOperation:operation3];
            }
        }
    }
}


#pragma mark - 归并排序
- (void) sortUsingMergeTypeWithArray:(NSArray *) array {
    
}

- (void) mergeArray:(NSArray *) array
     withStartIndex:(NSInteger) left
           midIndex:(NSInteger) mid
           endIndex:(NSInteger) right
      toResultArray:(NSMutableArray *) results {
}


- (void) setSortArray:(NSArray *)sortArray {
    self.sortMutableArray = [NSMutableArray arrayWithArray:sortArray];
    _sortArray = sortArray;
}

- (void) viewSourceCode:(id) sender {
    STACodeViewController * viewController = [[STACodeViewController alloc] initWithNibName:nil bundle:nil];
    viewController.algorithmType = (STAlgorithmType) self.arraySortType;
    [self.customNavigationController pushViewController:viewController animated:YES];
}

- (void) logArray:(NSArray *) array {
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        printf("%d ", [obj intValue]);
    }];
    printf("\n");
}
@end
