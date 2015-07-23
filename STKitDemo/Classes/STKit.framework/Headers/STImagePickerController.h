//
//  STImagePickerController.h
//  STKit
//
//  Created by SunJiangting on 14-1-3.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import <STKit/STKit.h>
#import <UIKit/UIKit.h>

@class STImagePickerController;

@protocol STImageProcessDelegate <NSObject>

@optional
- (NSData *)compressedOriginalImage:(UIImage *)originalImage;

- (void)saveImageData:(NSData *)imageData withIdentifier:(NSString *)identifier;

- (UIImage *)imageWithIdentifier:(NSString *)identifier;
@end

@protocol STImagePickerControllerDelegate <NSObject>

@optional
// The picker does not dismiss itself; the client dismisses it in these callbacks.
// The delegate will receive one or the other, but not both, depending whether the user
// confirms or cancels.
- (void)imagePickerController:(STImagePickerController *)picker didFinishPickingImageWithInfo:(NSDictionary *)info;
- (void)imagePickerControllerDidCancel:(STImagePickerController *)picker;

@end

@interface STImagePickerController : STNavigationController {
    //    UIImagePickerController
}

- (instancetype)init NS_DESIGNATED_INITIALIZER;

@property(nonatomic, copy) NSString *tips;

@property(nonatomic) BOOL allowsMultipleSelection;
/// 当相册load完之后，是否直接push进入第一个（全部照片）
@property(nonatomic) BOOL wantsEnterFirstAlbumWhenLoaded;
@property(nonatomic) NSInteger maximumNumberOfSelection; // default 20

@property(nonatomic) CGFloat maximumInteractivePopEdgeDistance; // default 13

@property(nonatomic, strong) UIButton    *backBarButton;

@property(nonatomic, strong) id userInfo;

@property(nonatomic, weak) id<STNavigationControllerDelegate, STImagePickerControllerDelegate> delegate;

@property(nonatomic, weak) id <STImageProcessDelegate> processDelegate;

+ (UIImage *)imageWithIdentifier:(NSString *)identifier;
@end

extern NSString *const STImagePickerControllerImageIdentifierKey; // a path of image in temp
extern NSString *const STImagePickerControllerThumbImageKey;
extern NSString *const STImagePickerControllerImageSizeKey;

extern UIImage *STExactImageWithPath();
