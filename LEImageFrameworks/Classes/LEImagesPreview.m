//
//  LEImagesPreview.m
//  LEUIFrameworkDemo
//
//  Created by emerson larry on 16/7/8.
//  Copyright © 2016年 Larry Emerson. All rights reserved.
//

#import "LEImagesPreview.h"

@interface LEImagesPreviewPage : LEBaseView<UIScrollViewDelegate,LE_PZPhotoViewDelegate>

@end
@implementation LEImagesPreviewPage{
    NSArray *imageDataSource;
    NSInteger curIndex;
    UIScrollView *curScrollView;
    UIPageControl *curPageControl;
    NSMutableArray *arrayPhotos;
    int width;
    int height;
    NSString *curURLPrefix;
    BOOL qiniuImageView2;
}
-(id) initWithViewController:(LEBaseViewController *)vc ImageDataSource:(NSArray *) data Index:(NSInteger) index ImageUrlPrefix:(NSString *) prefix QiniuImageView2:(BOOL) qiniu{
    imageDataSource=data;
    curIndex=index;
    curURLPrefix=prefix;
    qiniuImageView2=qiniu;
    return [super initWithViewController:vc];
}
-(void) leExtraInits{
    arrayPhotos=[[NSMutableArray alloc] init];
    width=self.leCurrentFrameWidth;
    height=self.leCurrentFrameHight;
    curScrollView=[[UIScrollView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self.leViewContainer EdgeInsects:UIEdgeInsetsZero]];
    [curScrollView setContentSize:CGSizeMake(width*imageDataSource.count, height)];
    [curScrollView setPagingEnabled:YES];
    [curScrollView setDelegate:self];
    [curScrollView setShowsHorizontalScrollIndicator:NO];
    [curScrollView setShowsVerticalScrollIndicator:NO];
    [curScrollView setBackgroundColor:[LEUIFramework sharedInstance].leColorNavigationBar];
    //    [curScrollView setBounces:NO];
    curPageControl=[[UIPageControl alloc] init];
    [self.leViewContainer addSubview:curPageControl];
    [curPageControl setFrame:CGRectMake(width/2-curPageControl.bounds.size.width/2, height-LELayoutSideSpace27, curPageControl.bounds.size.width, curPageControl.bounds.size.height)];
    [curPageControl setNumberOfPages:imageDataSource.count];
    [curPageControl setHidesForSinglePage:YES];
    for (NSInteger i=0; i<imageDataSource.count; i++) {
        NSString *url=[curURLPrefix stringByAppendingString:[imageDataSource objectAtIndex:i]];
        if(qiniuImageView2){
            url=[NSString stringWithFormat:@"%@?imageView2/1/w/%d/h/%d",url, width*(int)LESCREEN_SCALE, width*(int)LESCREEN_SCALE];
        }
        LE_PZPhotoView  *view=[[LE_PZPhotoView  alloc] initWithFrame:CGRectMake(width*i, 0, width, height)];
        [view leSetImageURL:url AndAspect:1];
        [view leSetDelegate:self];
        [curScrollView addSubview:view];
        [arrayPhotos addObject:view];
    }
    [curScrollView scrollRectToVisible:CGRectMake(width*curIndex, 0, width, height) animated:YES];
    [curPageControl setCurrentPage:curIndex];
}
-(void) lePhotoViewDidSingleTap:(LE_PZPhotoView  *)photoView{
    [self.leCurrentViewController.navigationController popViewControllerAnimated:YES];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int current = scrollView.contentOffset.x/width;
    curPageControl.currentPage = current;
    int left=current-1;
    int right=current+1;
    if(left>=0){
        [[arrayPhotos objectAtIndex:left] leUpdateZoomScale:1];
    }
    if(right<arrayPhotos.count){
        [[arrayPhotos objectAtIndex:right] leUpdateZoomScale:1];
    }
}
@end

@implementation LEImagesPreview{
    NSArray *imageDataSource;
    NSInteger curIndex;
    LEImagesPreviewPage *page;
    UIStatusBarStyle lastStatusStyle;
    BOOL isBarHide;
}
-(void) viewDidLoad{
    [super viewDidLoad];
    isBarHide=self.navigationController.navigationBarHidden;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.view addSubview:page];
    lastStatusStyle=[[UIApplication sharedApplication] statusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}
-(id) initWithImageDataSource:(NSArray *) data CurrentIndex:(NSInteger) index ImageUrlPrefix:(NSString *) prefix QiniuImageView2:(BOOL) qiniu{
    imageDataSource=data;
    curIndex=index;
    self= [super init];
    page=[[LEImagesPreviewPage alloc] initWithViewController:self ImageDataSource:imageDataSource Index:curIndex ImageUrlPrefix:prefix QiniuImageView2:qiniu];
    return self;
}
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:lastStatusStyle animated:YES];
    [self.navigationController setNavigationBarHidden:isBarHide animated:YES];
}

@end
