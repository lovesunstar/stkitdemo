//
//  STAlertView.m
//  STKitDemo
//
//  Created by SunJiangting on 14-8-28.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STAlertView.h"
#import <STKit/STKit.h>

@interface _STAlertViewCell : UITableViewCell

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIView *separatorView;

@end

const CGFloat _STAlertViewCellHeight = 45;

@implementation _STAlertViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, 320, _STAlertViewCellHeight);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 44)];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.titleLabel.textColor = [UIColor darkGrayColor];
        self.titleLabel.highlightedTextColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:17.];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];

        self.separatorView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.separatorView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.separatorView.frame = CGRectMake(0, CGRectGetHeight(frame) - STOnePixel(), CGRectGetWidth(frame), STOnePixel());
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.separatorView.backgroundColor = [UIColor colorWithRed:0x99/255. green:0x99/255. blue:0x99/255. alpha:1.0];
}

@end

@interface STAlertView () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate> {
    BOOL _shouldContinue;
    NSInteger _dismissedIndex;
}

@property(nonatomic, strong) NSMutableArray *dataSource;

@property(nonatomic, weak) UITableView *tableView;
@property(nonatomic, weak) UIView *backgroundView;
@property(nonatomic, weak) UIView *contentView;

@property(nonatomic, strong) UIView *hitTestView;

@end

@implementation STAlertView

- (instancetype)initWithMenuTitles:(NSString *)menuTitle, ... NS_REQUIRES_NIL_TERMINATION {
    NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:1];
    NSString *title = nil;
    va_list args;
    if (menuTitle) {
        [dataSource addObject:menuTitle];
        va_start(args, menuTitle);
        while ((title = va_arg(args, NSString *))) {
            [dataSource addObject:title];
        }
        va_end(args);
    }
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.dataSource = dataSource;
        CGFloat maxHeight = 240;
        const CGFloat footerHeight = 1;
        CGFloat height = dataSource.count * _STAlertViewCellHeight + footerHeight;

        UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        backgroundView.backgroundColor = [UIColor blackColor];
        [self addSubview:backgroundView];
        self.backgroundView = backgroundView;

        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, STOnePixel(), 0, MIN(height, maxHeight))];
        contentView.clipsToBounds = YES;
        [self addSubview:contentView];
        self.contentView = contentView;

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissActionFired:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.delegate = self;
        [self.backgroundView addGestureRecognizer:tapGesture];

        UITableView *tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[_STAlertViewCell class] forCellReuseIdentifier:@"Identifier"];
        [self.contentView addSubview:tableView];
        self.tableView = tableView;

        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, footerHeight)];
        tableView.tableFooterView.backgroundColor = [UIColor colorWithRed:0xFF/255. green:0x73/255. blue:0 alpha:1.0];

        if (height > maxHeight) {
            tableView.scrollEnabled = YES;
        } else {
            tableView.scrollEnabled = NO;
        }
        
        __weak STAlertView *weakSelf = self;
        self.hitTestView = [[UIView alloc] init];
        self.hitTestView.hitTestBlock = ^(CGPoint point, UIEvent *event, BOOL *returnSuper) {
            CGRect contentRect = [weakSelf.superview convertRect:weakSelf.frame toView:nil];
            if (!CGPointInRect(point, contentRect)){
                [weakSelf dismissActionFired:nil];
               *returnSuper = YES;
            }
            return (UIView *)nil;
        };
        self.hitTestView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (NSInteger)showInView:(UIView *)view animated:(BOOL)animated {
    self.hitTestView.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].delegate.window addSubview:self.hitTestView];
    //
    {
        self.tableView.contentInset = UIEdgeInsetsZero;
        if (!view) {
            view = [UIApplication sharedApplication].keyWindow;
        }
        [view addSubview:self];
        self.frame = view.bounds;
        CGRect frame = self.contentView.frame;
        frame.size.width = CGRectGetWidth(view.bounds);
        
        self.backgroundView.alpha = 0.0;
        CGRect fromRect = frame, targetRect = frame;
        fromRect.size.height = 0;
        self.contentView.frame = fromRect;
        void (^animation)(void) = ^(void) {
            self.backgroundView.alpha = 0.5;
            self.contentView.frame = targetRect;
        };
        void (^completion)(BOOL) = ^(BOOL finished) {

        };
        if (animated) {
            [UIView animateWithDuration:0.35 animations:animation completion:completion];
        }
    }
    while (!_shouldContinue) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return _dismissedIndex;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _STAlertViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _STAlertViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    tableViewCell.titleLabel.text = self.dataSource[indexPath.row];
    return tableViewCell;
}

- (void)dismissAnimated:(BOOL)animated {
    [self _dismissAnimated:animated completion:^(BOOL finished){}];
}

#pragma mark - PrivateMethod
- (void)dismissActionFired:(UITapGestureRecognizer *)sender {
    _dismissedIndex = -1;
    [self _dismissAnimated:YES completion:^(BOOL finished){}];
}

- (void)_dismissAnimated:(BOOL)animated completion:(void (^)(BOOL))_completion {
    self.backgroundView.alpha = 0.5;
    CGRect fromRect = self.contentView.frame, targetRect = self.contentView.frame;
    self.contentView.frame = fromRect;
    targetRect.size.height = 0;

    void (^animation)(void) = ^(void) {
        self.backgroundView.alpha = 0.0;
        self.contentView.frame = targetRect;
    };
    void (^completion)(BOOL) = ^(BOOL finished) {
        _shouldContinue = YES;
        if (_completion) {
            _completion(finished);
        }
        [self removeFromSuperview];
        [self.hitTestView removeFromSuperview];
    };
    if (animated) {
        [UIView animateWithDuration:0.35 animations:animation completion:completion];
    } else {
        animation();
        completion(YES);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _dismissedIndex = indexPath.row;
    [self dismissAnimated:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint touchedPoint = [gestureRecognizer locationInView:self];
    if (touchedPoint.y < CGRectGetMaxY(self.contentView.frame) && touchedPoint.y > CGRectGetMinX(self.contentView.frame)) {
        return NO;
    }
    return YES;
}

@end