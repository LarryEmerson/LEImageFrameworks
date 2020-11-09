//
//  LE_PZPhotoView .h 对PZPhotoView 做了需求性的精简
//  PhotoZoom
//
//  Created by Brennan Stehling on 10/27/12.
//  Copyright (c) 2012 SmallSharptools LLC. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "LEImageCache.h"
@protocol LE_PZPhotoViewDelegate;
@interface LE_PZPhotoView  : UIScrollView
@property (nonatomic, readonly) UIImageView *imageView;
//SET
- (void) leSetDelegate:(id<LE_PZPhotoViewDelegate>) delegate;
//
- (void) leSetImage:(UIImage *) image AndAspect:(float) aspect;
- (void) leSetImageURL:(NSString *) url AndAspect:(float) aspect;
- (void) leSetImageDownloadDelegate:(id<LEImageDownloadDelegate>) delegate;
- (void) leUpdateZoomScale:(CGFloat)newScale;
- (void) leUpdateZoomScale:(CGFloat)newScale withCenter:(CGPoint)center;
- (void) leRecoverFromResizing ;
@end
@protocol LE_PZPhotoViewDelegate <NSObject>
@optional
- (void) lePhotoViewDidSingleTap:(LE_PZPhotoView  *)photoView;
- (void) lePhotoViewDidDoubleTap:(LE_PZPhotoView  *)photoView;
@end
