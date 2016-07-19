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
+(void) leShowHDImageWithUrl:(NSString *) url Aspect:(float) aspect{
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
        
        [loading leStartAnimation];
        [loading setFrame:CGRectMake(LESCREEN_WIDTH/2-loading.leViewWidth/2, LESCREEN_HEIGHT/2-loading.leViewHeight/2, loading.leViewWidth, loading.leViewHeight)];
        //
        pzView=[[LE_PZPhotoView  alloc]initWithFrame:CGRectMake(0, 0, LESCREEN_WIDTH, LESCREEN_HEIGHT)];
        [pzView leSetDelegate:self];
        [loading leStartAnimation];
        [pzView leSetImageURL:url AndAspect:aspect];
        [pzView leSetImageDownloadDelegate:self];
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
-(void) leOnDownloadImageWithError:(NSError *)error{
    [loading leStopAnimation];
}
- (void)leOnDownloadedImageWith:(UIImage *)image{
    //    LELog(@"lePhotoViewDidDownloadedImage");
    [loading leStopAnimation];
}
- (void)lePhotoViewDidSingleTap:(LE_PZPhotoView  *)photoView{
    [loading leStopAnimation];
    [UIView animateWithDuration:0.25 animations:^(void) {
        [self setAlpha:0];
    } completion:^(BOOL isDone){
        [pzView setDelegate:nil];
        [self removeFromSuperview];
    }];
}
@end
