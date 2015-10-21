//
//  UIKit+STKit.h
//  STKit
//
//  Created by SunJiangting on 13-10-5.
//  Copyright (c) 2013年 SunJiangting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <STKit/Foundation+STKit.h>
#import <CoreGraphics/CoreGraphics.h>

ST_EXTERN CGFloat STOnePixel();
ST_EXTERN CGFloat STGetScreenWidth();
ST_EXTERN CGFloat STGetScreenHeight();

ST_EXTERN CGAffineTransform STTransformMakeRotation(CGPoint center, CGPoint anchorPoint, CGFloat angle);

ST_EXTERN CGFloat STGetSystemVersion();
ST_EXTERN NSString * ST_NONNULL STGetSystemVersionString();

ST_EXTERN CGPoint STConvertPointBetweenSize(CGPoint point, CGSize fromSize, CGSize toSize);
ST_EXTERN CGRect STConvertFrameBetweenSize(CGRect frame, CGSize fromSize, CGSize toSize);

#pragma mark - UIColor Extension
ST_ASSUME_NONNULL_BEGIN
/// 给UIColor增加rgb的构造方法
@interface UIColor (STExtension)
/// 使用rgbValue构造UIColor [UIColor st_colorWithRGB:0xCB553B];
+ (UIColor *)st_colorWithRGB:(NSInteger)rgb;
/// 使用rgbValue构造UIColor [UIColor st_colorWithRGB:0xCB553B alpha:0.3];
+ (UIColor *)st_colorWithRGB:(NSInteger)rgb alpha:(CGFloat)alpha;
/// 使用rgb 16进制String构造UIColor [UIColor st_colorWithHexString:@"0xFFFFFF"];
+ (STNULLABLE UIColor *)st_colorWithHexString:(STNULLABLE NSString *)hexString;
+ (STNULLABLE UIColor *)st_colorWithHexString:(STNULLABLE NSString *)hexString alpha:(CGFloat)alpha;

@end
ST_ASSUME_NONNULL_END

#pragma mark - UIView Extension

@interface UIView (STKit)

#pragma mark - UIView Frame Accesser
/**
 * @abstract getter CGRectGetMinY(self.frame) setter frame.origin.y = top;
 */
@property(nonatomic) CGFloat top;
/**
 * @abstract getter CGRectGetMaxY(self.frame) setter frame.origin.y = bottom - height;
 */
@property(nonatomic) CGFloat bottom;
/**
 * @abstract getter CGRectGetMinX(self.frame) setter frame.origin.x = left;
 */
@property(nonatomic) CGFloat left;
/**
 * @abstract getter CGRectGetMaxX(self.frame) setter frame.origin.x = right - width;
 */
@property(nonatomic) CGFloat right;
/**
 * @abstract getter CGRectGetWidth(self.frame) setter frame.size.width = width;
 */
@property(nonatomic) CGFloat width;
/**
 * @abstract getter CGRectGetHeight(self.frame) setter frame.size.height = height;
 */
@property(nonatomic) CGFloat height;
/**
 * @abstract getter frame.origin setter frame.origin = origin;
 */
@property(nonatomic) CGPoint origin;
/**
 * @abstract getter frame.size setter frame.size = size;
 */
@property(nonatomic) CGSize size;
/**
 * @abstract getter self.center.x setter center.x = centerX;
 */
@property(nonatomic) CGFloat centerX;
/**
 * @abstract getter self.center.y setter center.y = centerY;
 */
@property(nonatomic) CGFloat centerY;
/**
 * @abstract getter CGRectGetWidth(frame) / 2
 */
@property(nonatomic, readonly) CGFloat inCenterX;
/**
 * @abstract getter CGRectGetHeight(frame) / 2
 */
@property(nonatomic, readonly) CGFloat inCenterY;
/**
 * @abstract getter (inCenterX, inCenterY)
 */
@property(nonatomic, readonly) CGPoint inCenter;
/**
 * @abstract location in screen
 */
@property(nonatomic, readonly) CGFloat screenX;
/**
 * @abstract location in screen
 */
@property(nonatomic, readonly) CGFloat screenY;
/**
 * @abstract removeAllSubviews
 */
- (void)removeAllSubviews;

/**
 * @abstract view's viewController if the view has one
 */
- (STNULLABLE UIViewController *)viewController;

/**
 * @abstract view的superview中，是否包含某一类的view
 *
 * @param viewClass  superview 的 class
 * @return           view是否被添加到 类型为viewClass的superview上面
 */
- (BOOL)st_isDescendantOfClass:(STNONNULL Class)viewClass;

/**
 * @abstract    递归查找view的superview，直到找到类型为viewClass的view
 *
 * @param viewClass  superview 的 class
 * @return           第一个满足类型为viewClass的superview
 */
- (STNULLABLE UIView *)st_superviewWithClass:(STNONNULL Class)viewClass;

/**
 * @abstract 递归遍历该view，找到该view中的所有subview类型为class的view
 *
 * @param viewClass  subview 的 class
 * @return           所有类型为class的subview
 */
- (STNULLABLE NSArray *)st_viewWithClass:(STNONNULL Class)viewClass;

/**
 * @abstract 为该View添加轻拍手势
 *
 * @param target 接受手势通知的对象
 * @param action 回调方法
 */
- (void)st_addTouchTarget:(STNULLABLE id)target action:(STNULLABLE SEL)action;
- (void)st_removeTouchTarget:(STNULLABLE id)target action:(STNULLABLE SEL)action;

/**
 * Return the x coordinate on the screen, taking into account scroll views.
 */
@property(nonatomic, readonly) CGFloat screenViewX;

/**
 * Return the y coordinate on the screen, taking into account scroll views.
 */
@property(nonatomic, readonly) CGFloat screenViewY;

/**
 * Return the view frame on the screen, taking into account scroll views.
 */
@property(nonatomic, readonly) CGRect screenFrame;

/**
 * Return the width in portrait or the height in landscape.
 */
@property(nonatomic, readonly) CGFloat orientationWidth;

/**
 * Return the height in portrait or the width in landscape.
 */
@property(nonatomic, readonly) CGFloat orientationHeight;
/**
 * Calculates the offset of this view from another view in screen coordinates.
 *
 * otherView should be a parent view of this view.
 */
- (CGPoint)st_offsetFromView:(STNONNULL UIView *)otherView;

@property(nonatomic) CGPoint    anchorPoint;

@end

@interface UIScrollView (STKit)

@property(nonatomic) CGFloat contentOffsetX;
@property(nonatomic) CGFloat contentOffsetY;

@property(nonatomic) CGFloat contentWidth;
@property(nonatomic) CGFloat contentHeight;

@end

ST_ASSUME_NONNULL_BEGIN
typedef BOOL (^STPanGestureShouldBeginHandler)(UIScrollView *, UIPanGestureRecognizer *);
@interface UIScrollView (STGestureShouldBegin)
//
//(CollectionView, UIPanGestureRecognizer) -> Bool
@property(STPROPERTYNULLABLE nonatomic, strong, setter=st_setPanGestureShouldHandler:, getter=st_panGestureShouldHandler) STPanGestureShouldBeginHandler st_panGestureShouldHandler;

@end

ST_ASSUME_NONNULL_END

ST_ASSUME_NONNULL_BEGIN
@interface UIResponder (STResponder)

/**
 * @abstract 递归查找view的nextResponder，直到找到类型为class的Responder
 *
 * @param class  nextResponder 的 class
 * @return       第一个满足类型为class的UIResponder
 */
- (STNULLABLE UIResponder *)st_nextResponderWithClass:(Class)aClass;

/// 查找firstResponder
- (STNULLABLE UIResponder *)st_findFirstResponder;


@end
ST_ASSUME_NONNULL_END

ST_ASSUME_NONNULL_BEGIN

/**
 * @abstract hitTestBlock
 *
 * @param 其余参数 参考UIView hitTest:withEvent:
 * @param returnSuper 是否返回Super的值。如果*returnSuper=YES,则代表会返回 super hitTest:withEvent:, 否则则按照block的返回值(即使是nil)
 * 
 * @discussion 切记，千万不要在这个block中调用self hitTest:withPoint,否则则会造成递归调用。这个方法就是hitTest:withEvent的一个代替。
 */
typedef UIView * ST_NULLABLE (^STHitTestViewBlock)(CGPoint point, UIEvent *event, BOOL *returnSuper);
typedef BOOL (^STPointInsideBlock)(CGPoint point, UIEvent *event, BOOL *returnSuper);

@interface UIView (STHitTest)
/// althought this is strong ,but i deal it with copy
@property(STPROPERTYNULLABLE nonatomic, strong) STHitTestViewBlock hitTestBlock;
@property(STPROPERTYNULLABLE nonatomic, strong) STPointInsideBlock pointInsideBlock;

@end
ST_ASSUME_NONNULL_END

/// 是否弹起系统Menu菜单（选择/复制/拷贝等等）
@interface UITextField (STMenuController)

/// default YES.
@property(nonatomic, assign, getter=isMenuEnabled) BOOL menuEnabled;

@end

/// 是否弹起系统Menu菜单（选择/复制/拷贝等等）
@interface UITextView (STMenuController)

/// default YES.
@property(nonatomic, assign, getter=isMenuEnabled) BOOL menuEnabled;

@end

/**
 * @abstract 图片类型。
 *
 * @param  STImageDataTypeUnknown 未知类型
 */
typedef NS_ENUM(NSInteger, STImageDataType) {
    STImageDataTypeUnknown,
    STImageDataTypePCX,  // 文件头  共1字节  0A
    STImageDataTypeBMP,  // 文件头  共2字节  42 4d
    STImageDataTypeJPEG, // 文件头  共2字节  ff d8 文件尾 ff d9
    STImageDataTypePNG,  // 文件头  共8字节  89 50 4e 47 0d 0a 1a 0a
    STImageDataTypeGIF,  // 文件头  共6字节  47 49 46 38 39/37 61
    STImageDataTypeWebP,  // 文件头  共6字节  47 49 46 38 39/37 61
};

/**
 * @abstract 根据Data内容，解析文件头。
 */
@interface NSData (STImage)
/// 根据data前8字节解析图片类型。@see STImageDataType
- (STImageDataType)imageType;

@end

/**
 * @abstract 根据Data内容，解析图片。
 */
@interface UIImage (STImage)
/// 判断图片类型，支持GIF解析
+ (STNULLABLE UIImage *)st_imageWithSTData:(STNULLABLE NSData *)data;

@end

/// imageNamed:.png/@2x.png/-568h@2x.png.
/// gif image must has suffix .gif, named:xxx.gif or xxx@2x.gif
@interface UIImage (STImageNamed)

@end

/**
 * @abstract!
 *
 * STBlurEffectStyleLight       比较淡色的毛玻璃效果，系统原生的NavigationBar毛玻璃效果
 * STBlurEffectStyleExtraLight  系统从最底部往上滑动的设置毛玻璃效果
 * STBlurEffectStyleDark        通知中心的毛玻璃效果
 */
typedef NS_ENUM(NSInteger, STBlurEffectStyle) {
    STBlurEffectStyleNone,
    STBlurEffectStyleExtraLight,
    STBlurEffectStyleLight,
    STBlurEffectStyleDark
};

ST_ASSUME_NONNULL_BEGIN
/// 给图片添加毛玻璃效果
@interface UIImage (STBlurImage)

- (UIImage *)st_blurImageWithStyle:(STBlurEffectStyle)style;

- (UIImage *)st_blurImageWithTintColor:(STNULLABLE UIColor *)tintColor;

- (UIImage *)st_blurImageWithRadius:(CGFloat)blurRadius
                          tintColor:(STNULLABLE UIColor *)tintColor
              saturationDeltaFactor:(CGFloat)saturationDeltaFactor;

- (UIImage *)st_blurImageWithRadius:(CGFloat)blurRadius
                          tintColor:(STNULLABLE UIColor *)tintColor
              saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                          maskImage:(STNULLABLE UIImage *)maskImage;

- (UIImage *)st_imageWithRenderingTintColor:(STNULLABLE UIColor *)tintColor;
@end
ST_ASSUME_NONNULL_END

ST_ASSUME_NONNULL_BEGIN
/// UIView 截图
@interface UIView (STSnapshot)
/// 截图后的image
- (UIImage *)st_snapshotImage;
/// 截取View中的某一小块
- (UIImage *)st_snapshotImageInRect:(CGRect)rect;
/// 把 UIView的transform也放进截图中
- (UIImage *)st_transformedSnapshotImage;

@end
ST_ASSUME_NONNULL_END

ST_ASSUME_NONNULL_BEGIN
@interface UIView (STBlur)

- (UIImage *)st_blurImage;

- (STNULLABLE UIView *)st_statusBarWindow;

@end
ST_ASSUME_NONNULL_END

ST_ASSUME_NONNULL_BEGIN
typedef void (^STInvokeHandler)(void);

@interface UICollectionView (STReloadData)
@property(STPROPERTYNULLABLE nonatomic, strong) STInvokeHandler willReloadData;
@property(STPROPERTYNULLABLE nonatomic, strong) STInvokeHandler didReloadData;

@end
ST_ASSUME_NONNULL_END

ST_ASSUME_NONNULL_BEGIN
@interface UITableView (STReloadData)
@property(STPROPERTYNULLABLE nonatomic, strong) STInvokeHandler willReloadData;
@property(STPROPERTYNULLABLE nonatomic, strong) STInvokeHandler didReloadData;
@end
ST_ASSUME_NONNULL_END

ST_ASSUME_NONNULL_BEGIN
@interface UIActionSheet (STKit)

- (instancetype)initWithTitle:(STNULLABLE NSString *)title
                     delegate:(STNULLABLE id<UIActionSheetDelegate>)delegate
            cancelButtonTitle:(STNULLABLE NSString *)cancelButtonTitle
       destructiveButtonTitle:(STNULLABLE NSString *)destructiveButtonTitle
        otherButtonTitleArray:(STNULLABLE NSArray *)otherButtonTitleArray;

@end
ST_ASSUME_NONNULL_END

ST_ASSUME_NONNULL_BEGIN
@interface UIImage (STSubimage)

- (UIImage *)st_fixedOrientationImage;

- (UIImage *)st_imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)st_imageRotatedByDegrees:(CGFloat)degrees;

+ (UIImage *)st_imageWithColor:(UIColor *)color;
+ (UIImage *)st_imageWithColor:(UIColor *)color size:(CGSize)size;
/// 某个rect下的子图像
- (UIImage *)st_subimageInRect:(CGRect)rect;

- (UIImage *)st_imageWithTransform:(CGAffineTransform)transform;

- (UIImage *)st_imageConstrainedToSize:(CGSize)size;
- (UIImage *)st_imageConstrainedToSize:(CGSize)size contentMode:(UIViewContentMode)contentMode;

@end
ST_ASSUME_NONNULL_END