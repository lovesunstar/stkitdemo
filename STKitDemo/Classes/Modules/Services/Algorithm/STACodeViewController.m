//
//  STACodeViewController.m
//  STBasic
//
//  Created by SunJiangting on 13-11-4.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import "STACodeViewController.h"

@interface STACodeViewController ()

@property (nonatomic, strong) UITextView * textView;

@end

@implementation STACodeViewController


- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
                self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"源码";
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 80, 320, 400)];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.editable = NO;
    [self.view addSubview:self.textView];
    
    NSString * insert = @"void insert(int[] a) {\n\tfor (int i = 1; i < a.length; i ++) {\n\t\tint ai = a[i], aj;\n\t\tint j = i;\n\t\twhile (j > 0 && (aj = a[j - 1]) > ai) {\n\t\t\ta[j] = aj;\n\t\t\tj --;\n\t\t}\n\t\ta[j] = ai;\n\t}\n}\n";
    
    NSString * bubble = @"void bubble(int[] a) {\n\tBOOL exchanged = YES;\n\tfor (int i = 0; i < a.length - 1 && exchanged; i ++) {\n\t\texchanged = NO;\n\t\tfor (int j = 0; j < (a.length - 1 - i); j ++) {\n\t\t\tint aj = a[j];\n\t\t\tint aj1 = a[j + 1];\n\t\t\tif (aj > aj1) {\n\t\t\t\texchanged = YES;\n\t\t\t\ta[j + 1] = aj;\n\t\t\t\ta[j] = aj1;\n\t\t\t}\n\t\t}\n\t}\n}\n";
    NSString * select = @"void select(int[] a) {\n\tfor(int i = 0; i < a.length;i ++) {\n\t\tfor(int j = i; j < a.length; j ++) {\n\t\tint ai = a[i];\n\t\tint aj = a[j];\n\t\tif(a[i] > a[j]) {\n\t\t\ta[i] = aj\n\t\t\ta[j] = ai;\n\t\t}\n\t}\n}";
    
    NSString * quick = @"void quick(int[] a, int left, int right){\tif (left < right) {\n\t\tint key = a[left];\n\t\tint low = left;\n\t\tint high = right;\n\t\twhile (low < high) {\n\t\t\twhile (low < high && a[high] >= key) {\n\t\t\t\thigh --;\n\t\t\t}\n\t\t\ta[low] = a[high];\n\t\t\twhile (low < high && a[low] <= key) {\n\t\t\t\tlow ++;\n\t\t\t}\n\t\t\ta[high] = a[low];\n\t\t}\n\t\ta[low] = key;\n\t\tquick(a, left, low - 1);\n\t\tquick(a, low + 1, right);\n\t}\n}\n";
    
    NSString * hanoi = @"void hanoi(int i , char A , char B , char C) {\n\tif(i == 1) {\n\t\tmove(i , A , C);\n\t} else {\t\n\t\thanoi(i - 1 , A , C , B);\n\t\tmove(i , A , C);\n\t\thanoi(i - 1 , B , A , C);\n\t}\n}\n\nvoid move(int i , char x , char y) {\n\tprintf(\"Move disk i from x to y\");\n}";
    
    switch (self.algorithmType) {
        case STAlgorithmTypeInsertSort:
            self.textView.text = insert;
            break;
        case STAlgorithmTypeBubbleSort:
            self.textView.text = bubble;
            break;
        case STAlgorithmTypeSelectSort:
            self.textView.text = select;
            break;
        case STAlgorithmTypeQuickSort:
            self.textView.text = quick;
            break;
        case STAlgorithmTypeHanoi:
            self.textView.text = hanoi;
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
