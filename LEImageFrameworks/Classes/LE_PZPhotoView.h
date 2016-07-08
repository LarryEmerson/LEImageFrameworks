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
@property (assign, nonatomic) id<LE_PZPhotoViewDelegate> photoViewDelegate;
-(void) setImageURL:(NSString *) url AndAspect:(float) aspect;
-(void) setImageDownloadDelegate:(id<LEImageDownloadDelegate>) delegate;
- (void)updateZoomScale:(CGFloat)newScale;
- (void)updateZoomScale:(CGFloat)newScale withCenter:(CGPoint)center;
@end
@protocol LE_PZPhotoViewDelegate <NSObject>
@optional
- (void)photoViewDidSingleTap:(LE_PZPhotoView  *)photoView;
- (void)photoViewDidDoubleTap:(LE_PZPhotoView  *)photoView;
@end