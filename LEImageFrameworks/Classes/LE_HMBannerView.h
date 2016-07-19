//
//  LE_HMBannerView.h
//  LE_HMBannerView
//  是对HMBannerView做了自定义的修改，处理了单张图片的循环及其他问题
//  HMBannerView 地址请移步：https://github.com/iunion/autoScrollBanner
//  Created by Dennis on 13-12-31.
//  Copyright (c) 2013年 Babytree. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "LEUIFramework.h"
#import "LEImageCache.h"
#import "UIImage+GIF.h"

#define LEHMBannerWidth 30
#define LEHMBannerOffset 15
#define LEHMBannerSize 16
typedef NS_ENUM(NSInteger, LEBannerViewScrollDirection){
    ScrollDirectionLandscape,// 水平滚动
    ScrollDirectionPortait// 垂直滚动
};

typedef NS_ENUM(NSInteger, LEBannerViewPageStyle){
    PageStyle_None,
    PageStyle_Left,
    PageStyle_Right,
    PageStyle_Middle
};
@protocol LE_HMBannerViewDelegate;
@interface LE_HMBannerViewImageView : UIImageView
-(void) leSetData:(NSDictionary *) data;
@end

@interface LE_HMBannerView : UIView <UIScrollViewDelegate>{
    UIScrollView *leScrollView;
    UIButton *leBannerCloseButton;
    NSInteger leTotalPage;
    NSInteger lePage;
}
//
- (id)   initWithFrame:(CGRect)frame scrollDirection:(LEBannerViewScrollDirection)direction images:(NSArray *)images ImageViewClassName:(NSString *) className;
//SET
- (void) leSetDelegate:(id<LE_HMBannerViewDelegate>) delegate;
- (void) leSetScrollDirection:(LEBannerViewScrollDirection) direction;
- (void) leSetRollingDelayTime:(NSTimeInterval) time;
//
- (void) leReloadBannerWithData:(NSArray *)images;
- (void) leSetSquare:(NSInteger)asquare;
- (void) leSetPageControlOffset:(CGPoint) offset;
- (void) leSetPageControlStyle:(LEBannerViewPageStyle)pageStyle;
- (void) leShowClose:(BOOL)show;
- (void) leStartRolling;
- (void) leStopRolling;
@end

@protocol LE_HMBannerViewDelegate <NSObject>
@optional
- (void) leBannerView:(LE_HMBannerView *)bannerView didSelectImageView:(NSInteger)index withData:(NSDictionary *)bannerData;
- (void) leBannerViewdidClosed:(LE_HMBannerView *)bannerView;
@end
