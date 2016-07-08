//
//  LESingleImagePicker.h
//  LEImageFrameworks
//  https://github.com/LarryEmerson/LEImageFrameworks
//  Created by emerson larry on 16/3/15.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import "LEFrameworks.h"



@protocol LEImageCropperDelegate <NSObject>
- (void)onDoneCroppedWithImage:(UIImage *)image;
@optional
- (void)onCancelImageCropper;
@end

@interface LEImageCropper : LEBaseViewController
- (id)initWithImage:(UIImage *)image Aspect:(float) aspect  Delegate:(id<LEImageCropperDelegate>) delegate;
@end



@interface LESingleImagePicker : NSObject
+(void) onLESingleImagePickerWithSuperView:(UIView *) superView ViewController:(UIViewController *) viewController Title:(NSString *) title Aspect:(float) aspect Delegate:(id<LEImageCropperDelegate>) delegate;
@end