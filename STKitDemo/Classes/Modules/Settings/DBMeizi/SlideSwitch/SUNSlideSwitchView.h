//
//  SUNSlideSwitchView.h
//  SUNCommonComponent
//
//  Created by 麦志泉 on 13-9-4.
//  Copyright (c) 2013年 中山市新联医疗科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SUNSlideSwitchViewDelegate;
@interface SUNSlideSwitchView : UIView<UIScrollViewDelegate>
{
    UIScrollView *_rootScrollView;                  //主视图
    UIScrollView *_topScrollView;                   //顶部页签视图
    
    CGFloat _userContentOffsetX;
    BOOL _isLeftScroll;                             //是否左滑动
    BOOL _isRootScroll;                             //是否主视图滑动
    BOOL _isBuildUI;                                //是否建立了ui
    
    NSInteger _userSelectedChannelID;               //点击按钮选择名字ID
    
    UIImageView *_shadowImageView;
    UIImage *_shadowImage;
    
    UIColor *_tabItemNormalColor;                   //正常时tab文字颜色
    UIColor *_tabItemSelectedColor;                 //选中时tab文字颜色
    UIImage *_tabItemNormalBackgroundImage;         //正常时tab的背景
    UIImage *_tabItemSelectedBackgroundImage;       //选中时tab的背景
    NSMutableArray *_viewArray;                     //主视图的子视图数组
    
    UIButton *_rigthSideButton;                     //右侧按钮
    
    __weak id<SUNSlideSwitchViewDelegate> _slideSwitchViewDelegate;
}

@property (nonatomic, strong) IBOutlet UIScrollView *rootScrollView;
@property (nonatomic, strong) IBOutlet UIScrollView *topScrollView;
@property (nonatomic, assign) CGFloat userContentOffsetX;
@property (nonatomic, assign) NSInteger userSelectedChannelID;
@property (nonatomic, assign) NSInteger scrollViewSelectedChannelID;
@property (nonatomic, weak) id<SUNSlideSwitchViewDelegate> slideSwitchViewDelegate;
@property (nonatomic, strong) UIColor *tabItemNormalColor;
@property (nonatomic, strong) UIColor *tabItemSelectedColor;
@property (nonatomic, strong) UIImage *tabItemNormalBackgroundImage;
@property (nonatomic, strong) UIImage *tabItemSelectedBackgroundImage;
@property (nonatomic, strong) UIImage *shadowImage;
@property (nonatomic, strong) NSMutableArray *viewArray;
@property (nonatomic, strong) IBOutlet UIButton *rigthSideButton;

/*!
 * @method 创建子视图UI
 * @abstract
 * @discussion
 * @param
 * @result
 */
- (void)buildUI;

@end

@protocol SUNSlideSwitchViewDelegate <NSObject>

@required

/*!
 * @method 顶部tab个数
 * @abstract
 * @discussion
 * @param 本控件
 * @result tab个数
 */
- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view;

/*!
 * @method 每个tab所属的viewController
 * @abstract
 * @discussion
 * @param tab索引
 * @result viewController
 */
- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number;

@optional

/*!
 * @method 滑动左边界时传递手势
 * @abstract
 * @discussion
 * @param   手势
 * @result 
 */
- (void)slideSwitchView:(SUNSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer*) panParam;

/*!
 * @method 滑动右边界时传递手势
 * @abstract
 * @discussion
 * @param   手势
 * @result
 */
- (void)slideSwitchView:(SUNSlideSwitchView *)view panRightEdge:(UIPanGestureRecognizer*) panParam;

/*!
 * @method 点击tab
 * @abstract
 * @discussion
 * @param tab索引
 * @result 
 */
- (void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number;

@end
