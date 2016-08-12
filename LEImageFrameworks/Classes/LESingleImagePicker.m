//
//  LESingleImagePicker.m
//  LEImageFrameworks
//  https://github.com/LarryEmerson/LEImageFrameworks
//  Created by emerson larry on 16/3/15.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import "LESingleImagePicker.h"

@interface LEImageCropperPage : LEBaseView<UIScrollViewDelegate>
@end
@implementation LEImageCropperPage{
    UIImage *curImage;
    float curAspect;
    UIScrollView *scrollView;
    UIImageView *imageView;
    id<LEImageCropperDelegate> curDelegate;
}
-(id) initWithViewController:(LEBaseViewController *)vc Image:(UIImage *) image Aspect:(float) aspect  Delegate:(id<LEImageCropperDelegate>) delegate{
    curDelegate=delegate;
    curImage=image;
    curAspect=aspect;
    return [super initWithViewController:vc];
}
-(void) leExtraInits{
    [self.leViewContainer setBackgroundColor:[UIColor colorWithRed:0.412 green:0.396 blue:0.409 alpha:1.000]];
    scrollView=[[UIScrollView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self.leViewContainer Anchor:LEAnchorInsideCenter Offset:CGPointZero CGSize:CGSizeMake(self.leCurrentFrameWidth, self.leCurrentFrameWidth/curAspect)]];
    [scrollView setBackgroundColor:LEColorClear];
    [scrollView setDelegate:self];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setMaximumZoomScale:100];
    [self.leViewContainer addSubview:scrollView];
    float minWA=self.leCurrentFrameWidth*1.0/curImage.size.width;
    float minHA=self.leCurrentFrameWidth*1.0/curAspect/curImage.size.height;
    float miniAspect=minWA>minHA?minWA:minHA;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, curImage.size.width, curImage.size.height)];
    [imageView setImage:curImage];
    [scrollView setContentSize:[imageView frame].size];
    [scrollView setMinimumZoomScale:miniAspect];
    [scrollView setZoomScale:[scrollView minimumZoomScale]];
    [scrollView addSubview:imageView];
    
    [scrollView setMaximumZoomScale:2.5<miniAspect?miniAspect:2.5];
    [scrollView setClipsToBounds:NO];
    
    UIView *topCover=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.leCurrentFrameWidth, scrollView.frame.origin.y)];
    [topCover setBackgroundColor:LEColorMask5];
    [self.leViewContainer addSubview:topCover];
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, scrollView.frame.origin.y+scrollView.bounds.size.height, self.leCurrentFrameWidth, self.leCurrentFrameHight-scrollView.bounds.size.height)];
    [bottomView setBackgroundColor:LEColorMask5];
    [self.leViewContainer addSubview:bottomView];
}
- (void)cancelCropping {
    if(curDelegate&&[curDelegate respondsToSelector:@selector(leOnCancelImageCropper)]){
        [curDelegate leOnCancelImageCropper];
    }
}
-(UIImage*)captureView{
    UIGraphicsBeginImageContextWithOptions(self.leViewContainer.frame.size,NO,[[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.leViewContainer.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(scrollView.bounds.size,NO,[[UIScreen mainScreen] scale]);
    [img drawAtPoint:CGPointMake(0, -scrollView.frame.origin.y)];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
- (void)finishCropping {
    UIImage *image=[self captureView];
    if(curDelegate&&[curDelegate respondsToSelector:@selector(leOnDoneCroppedWithImage:)]){
        [curDelegate leOnDoneCroppedWithImage:image];
    }
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imageView;
}
@end

@implementation LEImageCropper{
    LEUIFramework *globalVar;
    LEImageCropperPage *page;
}

- (id)initWithImage:(UIImage *)image Aspect:(float) aspect  Delegate:(id<LEImageCropperDelegate>) delegate{
    self = [super init];
    if (self) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        page=[[LEImageCropperPage alloc] initWithViewController:self Image:image Aspect:aspect Delegate:delegate];
        [self.view addSubview:page];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancleCropping)] animated:YES];
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onFinishCropping)] animated:YES];
    }
    return self;
}
-(void) onCancleCropping{
    [page cancelCropping];
}
-(void) onFinishCropping{
    [page finishCropping];
}
-(void) leExtraInits{}
@end

@interface LESingleImagePicker ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,LEImageCropperDelegate>

@end
@implementation LESingleImagePicker{
    id<LEImageCropperDelegate> curDelegate;
    UIViewController *curViewController;
    float curAspect;
    UIImagePickerController *imagePickerController;
    UIImagePickerControllerSourceType imagePickerSourceType;
    LEImageCropper *cropper;
    BOOL isBarHidden;
    
}
static LESingleImagePicker *curLESingleImagePicker;
-(id) initWithSuperView:(UIView *) superView ViewController:(UIViewController *) viewController Title:(NSString *) title Aspect:(float) aspect Delegate:(id<LEImageCropperDelegate>) delegate{
    isBarHidden=viewController.navigationController.navigationBarHidden;
    curDelegate=delegate;
    curViewController=viewController;
    curAspect=aspect;
    if(!title){
        title=@"选中图片来源";
    }
    self=[super init];
    if(superView){
        UIActionSheet *sheet=nil;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            sheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"本地相册", nil];
        } else {
            sheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"本地相册", nil];
        }
        [sheet showInView:superView];
    }else{
        BOOL isSim=[[[UIDevice currentDevice].name lowercaseString] rangeOfString:@"simulator"].location !=NSNotFound;
        if(isSim||[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            if(isSim){
                imagePickerSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }else{
                imagePickerSourceType = UIImagePickerControllerSourceTypeCamera;
            }
            imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = NO;
            imagePickerController.sourceType = imagePickerSourceType;
            [curViewController presentViewController:imagePickerController animated:YES completion:^(void){
            }];
        }else{
            curDelegate=nil;
            [viewController.view leAddLocalNotification:@"摄像头打开失败，请检查是否被禁用"];
        }
    }
    return self;
}
+(void) leOnSingleImagePickerWithSuperView:(UIView *) superView ViewController:(UIViewController *) viewController Title:(NSString *) title Aspect:(float) aspect Delegate:(id<LEImageCropperDelegate>) delegate{
    curLESingleImagePicker=[[LESingleImagePicker alloc] initWithSuperView:superView ViewController:viewController Title:title Aspect:aspect Delegate:delegate];
}
#pragma mark - action sheet delegte
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    imagePickerSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                imagePickerSourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1: //相机
                imagePickerSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2: //相册
                curLESingleImagePicker=nil;
                return;
        }
    } else {
        if (buttonIndex == 0) {
            imagePickerSourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        } else {
            curLESingleImagePicker=nil;
            return;
        }
    }
    // 跳转到相机或相册页面
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    imagePickerController.sourceType = imagePickerSourceType;
    [curViewController presentViewController:imagePickerController animated:YES completion:^(void){
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *oriImage = [info objectForKeyedSubscript:@"UIImagePickerControllerOriginalImage"];
    if(curAspect==-1){
        [imagePickerController dismissViewControllerAnimated:YES completion:^(void){
            NSData *imageData = UIImageJPEGRepresentation(oriImage, 1);
            UIImage *compressedImage = [UIImage imageWithData:imageData];
            if(curDelegate){
                [curDelegate leOnDoneCroppedWithImage:compressedImage];
            }
            curDelegate=nil;
            [curViewController.navigationController setNavigationBarHidden:isBarHidden animated:YES];
        }];
    }else{
        [picker dismissViewControllerAnimated:YES completion:^{
            cropper = [[LEImageCropper alloc] initWithImage:oriImage Aspect:curAspect Delegate:self];
            [curViewController.navigationController pushViewController:cropper animated:YES];
            curLESingleImagePicker=nil;
            [curViewController.navigationController setNavigationBarHidden:NO animated:YES];
        }];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        curLESingleImagePicker=nil;
        [curViewController.navigationController setNavigationBarHidden:isBarHidden animated:YES];
    }];
}
-(void) leOnCancelImageCropper{
    //    LELogFunc;
    [cropper.navigationController popViewControllerAnimated:YES];
}
-(void) leOnDoneCroppedWithImage:(UIImage *)image{
    //    LELogFunc;
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    if(curDelegate){
        [curDelegate leOnDoneCroppedWithImage:compressedImage];
    }
    curDelegate=nil;
    [cropper.navigationController popViewControllerAnimated:YES];
}
@end
