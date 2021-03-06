//
//  LE_PZPhotoView.m 对PZPhotoView 做了需求性的精简
//  PhotoZoom
//
//  Created by Brennan Stehling on 10/27/12.
//  Copyright (c) 2012 SmallSharptools LLC. All rights reserved.
//

#import "LE_PZPhotoView.h"
#define kZoomStep 2

@interface LE_PZPhotoView  () <UIScrollViewDelegate,LEImageDownloadDelegate>
@property (nonatomic, readwrite) UIImageView *imageView;
@property (assign, nonatomic) id<LE_PZPhotoViewDelegate> photoViewDelegate;
@end
@implementation LE_PZPhotoView  {
    CGPoint  _pointToCenterAfterResize;
    CGFloat  _scaleToRestoreAfterResize;
    float curAspect;
    UIActivityIndicatorView *indicator;
}
-(void) leSetDelegate:(id<LE_PZPhotoViewDelegate>)delegate{
    self.photoViewDelegate=delegate;
}
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        indicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [indicator setLeAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideCenter Offset:CGPointZero CGSize:indicator.bounds.size]];
        [indicator leExecAutoLayout];
        self.imageView =[[UIImageView alloc]init];
        [self.imageView leSetImageDownloadDelegate:self];
        [self addSubview:self.imageView];
        [self.imageView setUserInteractionEnabled:YES]; 
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self.imageView addGestureRecognizer:singleTap];
    
        self.delegate = self;
//        self.showsVerticalScrollIndicator = NO;
//        self.showsHorizontalScrollIndicator = NO;
//        self.bouncesZoom = TRUE;
//        self.decelerationRate = UIScrollViewDecelerationRateFast;
    }
    return self;
}
-(void) leSetImageDownloadDelegate:(id<LEImageDownloadDelegate>) delegate{
    [self.imageView leSetImageDownloadDelegate:delegate];
}
-(void) leOnDownloadedImageWith:(UIImage *) image{
    [indicator stopAnimating];
    [indicator setHidden:YES];
    if(curAspect<=0){
        [self.imageView setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [self setMaxMinZoomScalesForCurrentBounds];
        [self leUpdateZoomScale:self.minimumZoomScale];
    }
}
- (void) leSetImage:(UIImage *) image AndAspect:(float) aspect{
    curAspect=aspect;
    [self.imageView setImage:image];
    [indicator stopAnimating];
    [indicator setHidden:YES];
    if(curAspect<=0){
        [self.imageView setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [self setMaxMinZoomScalesForCurrentBounds];
        [self leUpdateZoomScale:self.minimumZoomScale];
    }
}
-(void) leOnDownloadImageWithError:(NSError *)error{
    [indicator stopAnimating];
    [indicator setHidden:YES];
    [self leAddLocalNotification:@"图片下载失败"];
}
-(void) leSetImageURL:(NSString *) url AndAspect:(float) aspect{
    curAspect=aspect;
    if(aspect>0){
        [self.imageView setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width/aspect)];
    }
    [indicator setHidden:NO];
    [indicator startAnimating];
    [self.imageView leSetImageWithUrlString:url];
    self.contentSize = self.imageView.frame.size;
    [self setMaxMinZoomScalesForCurrentBounds];
    [self setZoomScale:self.minimumZoomScale animated:FALSE];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // center the zoom view as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.imageView.frame;
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    self.imageView.frame = frameToCenter;
    CGPoint contentOffset = self.contentOffset;
    // ensure horizontal offset is reasonable
    if (frameToCenter.origin.x != 0.0)
        contentOffset.x = 0.0;
    // ensure vertical offset is reasonable
    if (frameToCenter.origin.y != 0.0)
        contentOffset.y = 0.0;
    self.contentOffset = contentOffset;
    // ensure content insert is zeroed out using translucent navigation bars
    self.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}

- (void)setFrame:(CGRect)frame {
    BOOL sizeChanging = !CGSizeEqualToSize(frame.size, self.frame.size);
    if (sizeChanging) {
        [self prepareToResize];
    }
    [super setFrame:frame];
    if (sizeChanging) {
        [self recoverFromResizing];
    }
}
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    if (self.photoViewDelegate != nil&&[self.photoViewDelegate respondsToSelector:@selector(lePhotoViewDidSingleTap:)]) {
        [self.photoViewDelegate lePhotoViewDidSingleTap:self];
    }
}
- (CGPoint)adjustPointIntoImageView:(CGPoint)center {
    BOOL contains = CGRectContainsPoint(self.imageView.frame, center);
    if (!contains) {
        center.x = center.x / self.zoomScale;
        center.y = center.y / self.zoomScale;
        // adjust center with bounds and scale to be a point within the image view bounds
        CGRect imageViewBounds = self.imageView.bounds;
        center.x = MAX(center.x, imageViewBounds.origin.x);
        center.x = MIN(center.x, imageViewBounds.origin.x + imageViewBounds.size.height);
        center.y = MAX(center.y, imageViewBounds.origin.y);
        center.y = MIN(center.y, imageViewBounds.origin.y + imageViewBounds.size.width);
        return center;
    }
    return CGPointZero;
}

#pragma mark - Support Methods
- (void)leRecoverFromResizing {
    [self recoverFromResizing];
}
- (void)leUpdateZoomScale:(CGFloat)newScale {
    CGPoint center = CGPointMake(self.imageView.bounds.size.width/ 2.0, self.imageView.bounds.size.height / 2.0);
    [self leUpdateZoomScale:newScale withCenter:center];
}

- (void)leUpdateZoomScaleWithGesture:(UIGestureRecognizer *)gestureRecognizer newScale:(CGFloat)newScale {
    CGPoint center = [gestureRecognizer locationInView:gestureRecognizer.view];
    [self leUpdateZoomScale:newScale withCenter:center];
}

- (void)leUpdateZoomScale:(CGFloat)newScale withCenter:(CGPoint)center {
//    assert(newScale >= self.minimumZoomScale);
//    assert(newScale <= self.maximumZoomScale);
    
    if (self.zoomScale != newScale) {
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:center];
        [self zoomToRect:zoomRect animated:YES];
    }
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
//    assert(scale >= self.minimumZoomScale);
//    assert(scale <= self.maximumZoomScale);
    CGRect zoomRect;
    // the zoom rect is in the content view's coordinates.
    zoomRect.size.width = self.frame.size.width / scale;
    zoomRect.size.height = self.frame.size.height / scale;
    // choose an origin so as to get the right center.
    zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}

- (void)setMaxMinZoomScalesForCurrentBounds {
    // calculate minimum scale to perfectly fit image width, and begin at that scale
    CGSize boundsSize = self.bounds.size;
    CGFloat minScale = 0.25;
    if (self.imageView.bounds.size.width > 0.0 && self.imageView.bounds.size.height > 0.0) {
        // calculate min/max zoomscale
        CGFloat xScale = boundsSize.width  / self.imageView.bounds.size.width;    // the scale needed to perfectly fit the image width-wise
        CGFloat yScale = boundsSize.height / self.imageView.bounds.size.height;   // the scale needed to perfectly fit the image height-wise
        //        xScale = MIN(1, xScale);
        //        yScale = MIN(1, yScale);
        minScale = MIN(xScale, yScale);
    }
    CGFloat maxScale = minScale * (kZoomStep * 2);
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
}

- (void)prepareToResize {
    CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _pointToCenterAfterResize = [self convertPoint:boundsCenter toView:self.imageView];
    _scaleToRestoreAfterResize = self.zoomScale;
    // If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum
    // allowable scale when the scale is restored.
    if (_scaleToRestoreAfterResize <= self.minimumZoomScale + FLT_EPSILON)
        _scaleToRestoreAfterResize = 0;
}

- (void)recoverFromResizing {
    [self setMaxMinZoomScalesForCurrentBounds];
    // Step 1: restore zoom scale, first making sure it is within the allowable range.
    CGFloat maxZoomScale = MAX(self.minimumZoomScale, _scaleToRestoreAfterResize);
    self.zoomScale = MIN(self.maximumZoomScale, maxZoomScale);
    // Step 2: restore center point, first making sure it is within the allowable range.
    // 2a: convert our desired center point back to our own coordinate space
    CGPoint boundsCenter = [self convertPoint:_pointToCenterAfterResize fromView:self.imageView];
    // 2b: calculate the content offset that would yield that center point
    CGPoint offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0,
                                 boundsCenter.y - self.bounds.size.height / 2.0);
    // 2c: restore offset, adjusted to be within the allowable range
    CGPoint maxOffset = [self maximumContentOffset];
    CGPoint minOffset = [self minimumContentOffset];
    CGFloat realMaxOffset = MIN(maxOffset.x, offset.x);
    offset.x = MAX(minOffset.x, realMaxOffset);
    realMaxOffset = MIN(maxOffset.y, offset.y);
    offset.y = MAX(minOffset.y, realMaxOffset);
    self.contentOffset = offset;
}

- (CGPoint)maximumContentOffset {
    CGSize contentSize = self.contentSize;
    CGSize boundsSize = self.bounds.size;
    return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
}
- (CGPoint)minimumContentOffset {
    return CGPointZero;
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}
 @end
