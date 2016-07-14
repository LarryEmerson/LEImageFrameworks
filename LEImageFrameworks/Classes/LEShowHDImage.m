//
//  LEShowHDImage.m
//  ticket
//
//  Created by Larry Emerson on 14-8-14.
//  Copyright (c) 2014年 360CBS. All rights reserved.
//

#import "LEShowHDImage.h"

#import "LE_PZPhotoView.h"
#import "LELoadingAnimationView.h"


@interface LEShowHDImage ()<LEImageDownloadDelegate>

@end
@implementation LEShowHDImage{
    LEUIFramework *globalVar;
    LE_PZPhotoView  *pzView;
    LELoadingAnimationView *loading;
}
+(void) showHDImageWithUrl:(NSString *) url Aspect:(float) aspect{
    LEShowHDImage *view=[[LEShowHDImage alloc] initWithUrl:url AndAspect:aspect];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}
- (id)initWithUrl:(NSString *) url AndAspect:(float) aspect
{
    self = [super init];
    if (self) {
        [self setAlpha:0];
        globalVar = [LEUIFramework sharedInstance];
        [self setFrame:CGRectMake(0, 0, LESCREEN_WIDTH, LESCREEN_HEIGHT)];
        [self setBackgroundColor:[UIColor blackColor]];
        loading=[[LELoadingAnimationView alloc]init];
        
        [loading startAnimation];
        [loading setFrame:CGRectMake(LESCREEN_WIDTH/2-loading.viewWidth/2, LESCREEN_HEIGHT/2-loading.viewHeight/2, loading.viewWidth, loading.viewHeight)];
        //
        pzView=[[LE_PZPhotoView  alloc]initWithFrame:CGRectMake(0, 0, LESCREEN_WIDTH, LESCREEN_HEIGHT)];
        [pzView setPhotoViewDelegate:self];
        [loading startAnimation];
        [pzView setImageURL:url AndAspect:aspect];
        [pzView setImageDownloadDelegate:self];
        [self addSubview:pzView];
        [self addSubview:loading];
        //
        [UIView animateWithDuration:0.25 animations:^(void){
            [self setAlpha:1];
        } completion:^(BOOL isDone){
        }];
    }
    return self;
}
-(void) onDownloadImageWithError:(NSError *)error{
    [loading stopAnimation];
}
- (void)onDownloadedImageWith:(UIImage *)image{
    //    LELog(@"photoViewDidDownloadedImage");
    [loading stopAnimation];
}
- (void)photoViewDidSingleTap:(LE_PZPhotoView  *)photoView{
    [loading stopAnimation];
    [UIView animateWithDuration:0.25 animations:^(void) {
        [self setAlpha:0];
    } completion:^(BOOL isDone){
        [pzView setDelegate:nil];
        [self removeFromSuperview];
    }];
}
@end
