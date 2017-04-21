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
    NSMutableArray *arrayPhotos;
    int width;
    int height;
    NSString *curURLPrefix;
    BOOL qiniuImageView2;
    UILabel *curPage;
}
-(id) initWithViewController:(LEBaseViewController *)vc ImageDataSource:(NSArray *) data Index:(NSInteger) index ImageUrlPrefix:(NSString *) prefix QiniuImageView2:(BOOL) qiniu{
    imageDataSource=data;
    curIndex=index;
    curURLPrefix=prefix;
    qiniuImageView2=qiniu;
    return [super initWithViewController:vc];
}
-(void) leAdditionalInits{ 
    arrayPhotos=[[NSMutableArray alloc] init];
    width=self.leCurrentFrameWidth;
    height=self.leCurrentFrameHight;
    curScrollView=[[UIScrollView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self.leViewContainer EdgeInsects:UIEdgeInsetsZero]];
    [curScrollView setContentSize:CGSizeMake(width*imageDataSource.count, height)];
    [curScrollView setPagingEnabled:YES];
    [curScrollView setDelegate:self];
    [curScrollView setShowsHorizontalScrollIndicator:NO];
    [curScrollView setShowsVerticalScrollIndicator:NO];
    [curScrollView setBackgroundColor:LEColorBlack];
    //    [curScrollView setBounces:NO];
    UIView *top=[UIView new].leSuperView(self).leAnchor(LEAnchorInsideBottomCenter).leSize(CGSizeMake(LESCREEN_WIDTH, LENavigationBarHeight)).leAutoLayout;
    curPage=[UILabel new].leSuperView(top).leAnchor(LEAnchorInsideCenter).leAutoLayout.leType;
    [curPage.leColor(LEColorWhite).leFont(LEBoldFont(LELayoutFontSize14)).leAlignment(NSTextAlignmentCenter) leLabelLayout];
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
    [curPage leSetText:[NSString stringWithFormat:@"%d/%d",(int)(curIndex+1),(int)arrayPhotos.count]];
    [curPage setHidden:arrayPhotos.count<=1];
}
-(void) lePhotoViewDidSingleTap:(LE_PZPhotoView  *)photoView{
    [self.leCurrentViewController.navigationController popViewControllerAnimated:YES];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int current = scrollView.contentOffset.x/width;
    int left=current-1;
    int right=current+1;
    if(left>=0){
        [[arrayPhotos objectAtIndex:left] leUpdateZoomScale:1];
    }
    if(right<arrayPhotos.count){
        [[arrayPhotos objectAtIndex:right] leUpdateZoomScale:1];
    }
    curIndex=current;
    [curPage leSetText:[NSString stringWithFormat:@"%zd/%zd", curIndex+1, arrayPhotos.count]];
}
@end

@implementation LEImagesPreview{
    NSArray *imageDataSource;
    NSInteger curIndex;
    LEImagesPreviewPage *page;
}
-(id) initWithImageDataSource:(NSArray *) data CurrentIndex:(NSInteger) index ImageUrlPrefix:(NSString *) prefix QiniuImageView2:(BOOL) qiniu{
    imageDataSource=data;
    curIndex=index;
    self= [super init];
    page=[[LEImagesPreviewPage alloc] initWithViewController:self ImageDataSource:imageDataSource Index:curIndex ImageUrlPrefix:prefix QiniuImageView2:qiniu];
    return self;
}
-(void) leAdditionalInits{}
@end
