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

#define HMBannerWidth 30
#define HMBannerOffset 15
#define HMBannerSize 16
typedef NS_ENUM(NSInteger, BannerViewScrollDirection){
    ScrollDirectionLandscape,// 水平滚动
    ScrollDirectionPortait// 垂直滚动
};

typedef NS_ENUM(NSInteger, BannerViewPageStyle){
    PageStyle_None,
    PageStyle_Left,
    PageStyle_Right,
    PageStyle_Middle
};
@protocol LE_HMBannerViewDelegate;
@interface LE_HMBannerViewImageView : UIImageView
@property (nonatomic) LEUIFramework *globalVar;
-(void) initUI;
-(void) setData:(NSDictionary *) data;
@end

@interface LE_HMBannerView : UIView <UIScrollViewDelegate>{
    UIScrollView *scrollView;
    UIButton *BannerCloseButton;
    NSInteger totalPage;
    NSInteger curPage;
}

@property (nonatomic, assign) id <LE_HMBannerViewDelegate> delegate;
@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, assign) BannerViewScrollDirection scrollDirection;
@property (nonatomic, assign) NSTimeInterval rollingDelayTime;
- (id)initWithFrame:(CGRect)frame scrollDirection:(BannerViewScrollDirection)direction images:(NSArray *)images ImageViewClassName:(NSString *) className;
- (void)reloadBannerWithData:(NSArray *)images;
- (void)setSquare:(NSInteger)asquare;
- (void)setPageControlOffset:(CGPoint) offset;
- (void)setPageControlStyle:(BannerViewPageStyle)pageStyle;
- (void)showClose:(BOOL)show;
- (void)startRolling;
- (void)stopRolling;
@end

@protocol LE_HMBannerViewDelegate <NSObject>
@optional
- (void)bannerView:(LE_HMBannerView *)bannerView didSelectImageView:(NSInteger)index withData:(NSDictionary *)bannerData;
- (void)bannerViewdidClosed:(LE_HMBannerView *)bannerView;
@end
