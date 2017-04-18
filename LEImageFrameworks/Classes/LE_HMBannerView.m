//
//  LE_HMBannerView.m
//  LE_HMBannerView
//  是对HMBannerView做了自定义的修改，处理了单张图片的循环及其他问题
//  HMBannerView 地址请移步：https://github.com/iunion/autoScrollBanner
//  Created by Dennis on 13-12-31.
//  Copyright (c) 2013年 Babytree. All rights reserved.
//
#import "LE_HMBannerView.h"
#define Banner_StartTag     1000
@implementation LE_HMBannerViewImageView
-(id) init{ 
    self=[super init];
    [self leExtraInits];
    return self;
}
-(void) leSetData:(NSDictionary *) data{
    NSString *url=[data objectForKey:@"img_url"];
    [self leSetImageWithUrlString:url];
}
@end

@interface LE_HMBannerView (){
    NSInteger totalCount;
}
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) BOOL enableRolling;
//
@property (nonatomic, weak  ) id <LE_HMBannerViewDelegate> delegate;
@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, assign) LEBannerViewScrollDirection scrollDirection;
@property (nonatomic, assign) NSTimeInterval rollingDelayTime;
//
- (void)refreshScrollView;
- (NSInteger)getPageIndex:(NSInteger)index;
- (NSArray *)getDisplayImagesWithPageIndex:(NSInteger)pageIndex;
@end

@implementation LE_HMBannerView{
    NSString *curImageViewClassName;
    LEBannerViewPageStyle curPageStyle;
    CGPoint curPageStyleOffset;
}
- (void) leSetDelegate:(id<LE_HMBannerViewDelegate>) dele{
    self.delegate=dele;
}
- (void) leSetScrollDirection:(LEBannerViewScrollDirection) direction{
    self.scrollDirection=direction;
}
- (void) leSetRollingDelayTime:(NSTimeInterval) time{
    self.rollingDelayTime=time;
}
- (void)dealloc {
    self.delegate = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
}

- (id)initWithFrame:(CGRect)frame scrollDirection:(LEBannerViewScrollDirection)direction images:(NSArray *)images  ImageViewClassName:(NSString *) className{
    curPageStyle=PageStyle_Left;
    curPageStyleOffset=CGPointZero;
    curImageViewClassName=className;
    if(!curImageViewClassName){
        curImageViewClassName=@"LE_HMBannerViewImageView";
    }
    self = [super initWithFrame:frame];
    [self setBackgroundColor:[UIColor colorWithRed:0.962 green:0.924 blue:0.955 alpha:1.000]];
    if(self){
        self.imagesArray = [[NSArray alloc] initWithArray:images];
        self.scrollDirection = direction;
        leTotalPage = self.imagesArray.count;
        totalCount = leTotalPage;
        // 显示的是图片数组里的第一张图片
        // 和数组是+1关系
        lePage = 1;
        leScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        leScrollView.backgroundColor = [UIColor clearColor];
        leScrollView.showsHorizontalScrollIndicator = NO;
        leScrollView.showsVerticalScrollIndicator = NO;
        leScrollView.pagingEnabled = YES;
        leScrollView.delegate = self;
        [self addSubview:leScrollView];
        // 在水平方向滚动
        if(self.scrollDirection == ScrollDirectionLandscape) {
            leScrollView.contentSize = CGSizeMake(leScrollView.frame.size.width * 3, leScrollView.frame.size.height);
        }else if(self.scrollDirection == ScrollDirectionPortait) {
            leScrollView.contentSize = CGSizeMake(leScrollView.frame.size.width, leScrollView.frame.size.height * 3);
        }
        for (NSInteger i = 0; i < 3; i++) {
            LE_HMBannerViewImageView *imageView =nil;
            imageView=(LE_HMBannerViewImageView *)[[curImageViewClassName leGetInstanceFromClassName] init];
            [imageView setFrame:leScrollView.bounds];
            imageView.userInteractionEnabled = YES;
            imageView.tag = Banner_StartTag+i;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [imageView addGestureRecognizer:singleTap];
            if(self.scrollDirection == ScrollDirectionLandscape) {
                imageView.frame = CGRectOffset(imageView.frame, leScrollView.frame.size.width * i, 0);
            }else if(self.scrollDirection == ScrollDirectionPortait) {
                imageView.frame = CGRectOffset(imageView.frame, 0, leScrollView.frame.size.height * i);
            }
            [leScrollView addSubview:imageView];
        }
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(LELayoutSideSpace, frame.size.height-LEHMBannerOffset, LEHMBannerWidth, LEHMBannerOffset)];
        self.pageControl.numberOfPages = self.imagesArray.count;
        [self.pageControl setUserInteractionEnabled:NO];
        [self addSubview:self.pageControl];
        
        self.pageControl.currentPage = 0;
        //[self refreshScrollView];
    }
    return self;
}
- (void)leReloadBannerWithData:(NSArray *)images{
    if (self.enableRolling) {
        [self leStopRolling];
    }
    self.imagesArray = [[NSArray alloc] initWithArray:images];
    leTotalPage = self.imagesArray.count;
    totalCount = leTotalPage;
    if(images.count==0){
        lePage = 1;
    }else if(lePage-1>=images.count){
        lePage=images.count;
    }
    self.pageControl.numberOfPages = leTotalPage;
    self.pageControl.currentPage = lePage-1;
    
    [self leSetPageControlStyle:curPageStyle];
    //    [self startDownloadImage];
}

- (void)leSetSquare:(NSInteger)asquare{
    if (leScrollView){
        leScrollView.layer.cornerRadius = asquare;
        if (asquare == 0){
            leScrollView.layer.masksToBounds = NO;
        }else{
            leScrollView.layer.masksToBounds = YES;
        }
    }
}
-(void)leSetPageControlOffset:(CGPoint) offset{
    curPageStyleOffset=offset;
    [self leSetPageControlStyle:curPageStyle];
}
- (void)leSetPageControlStyle:(LEBannerViewPageStyle)pageStyle{
    curPageStyle=pageStyle;
    int width=(int)self.imagesArray.count*LEHMBannerSize;
    if(width<LEHMBannerSize){
        width=LEHMBannerSize;
    }
    if (pageStyle == PageStyle_Left){
        [self.pageControl setFrame:CGRectMake(LELayoutSideSpace+curPageStyleOffset.x, self.bounds.size.height-LEHMBannerOffset+curPageStyleOffset.y, width, LEHMBannerOffset)];
    }else if (pageStyle == PageStyle_Right){
        [self.pageControl setFrame:CGRectMake(self.bounds.size.width-LELayoutSideSpace-width+curPageStyleOffset.x, self.bounds.size.height-LEHMBannerOffset+curPageStyleOffset.y, width, LEHMBannerOffset)];
    }else if (pageStyle == PageStyle_Middle){
        [self.pageControl setFrame:CGRectMake((self.bounds.size.width-width)/2+curPageStyleOffset.x, self.bounds.size.height-LEHMBannerOffset-self.pageControl.bounds.size.height+curPageStyleOffset.y, width, LEHMBannerOffset)];
    }else if (pageStyle == PageStyle_None){
        [self.pageControl setHidden:YES];
    }
    [self.pageControl setHidden:pageStyle == PageStyle_None||self.imagesArray.count==1];
    
}

- (void)leShowClose:(BOOL)show{
    if (show){
        if (!leBannerCloseButton){
            leBannerCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [leBannerCloseButton setFrame:CGRectMake(self.bounds.size.width-40, 0, 40, 40)];
            [leBannerCloseButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
            [leBannerCloseButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            [leBannerCloseButton addTarget:self action:@selector(leCloseBanner) forControlEvents:UIControlEventTouchUpInside];
            [leBannerCloseButton setImage:[[LEUIFramework sharedInstance] leGetImageFromLEFrameworksWithName:@"banner_close"] forState:UIControlStateNormal];
            leBannerCloseButton.exclusiveTouch = YES;
            [self addSubview:leBannerCloseButton];
        }
        leBannerCloseButton.hidden = NO;
    }else{
        if (leBannerCloseButton){
            leBannerCloseButton.hidden = YES;
        }
    }
}
- (void)leCloseBanner{
    [self leStopRolling];
    if ([self.delegate respondsToSelector:@selector(leBannerViewdidClosed:)]){
        [self.delegate leBannerViewdidClosed:self];
    }
}
//- (void)startDownloadImage{
//    if (self.enableRolling){
//        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
//    }
//    for (NSInteger i=0; i<self.imagesArray.count; ++i){
//        NSDictionary *dic = [self.imagesArray objectAtIndex:i];
//        NSString *url = [dic objectForKey:@"img_url"];
//        if ([url isNotEmpty]){
//            [[EGOImageLoader sharedImageLoader] loadImageForURL:[NSURL URLWithString:url] observer:nil];
//        }
//    }
//}
- (void)refreshScrollView{
    NSArray *curimageUrls = [self getDisplayImagesWithPageIndex:lePage];
    for (NSInteger i = 0; i < 3&&i<curimageUrls.count; i++){
        LE_HMBannerViewImageView *imageView = (LE_HMBannerViewImageView *)[leScrollView viewWithTag:Banner_StartTag+i];
        NSDictionary *dic = [curimageUrls objectAtIndex:i];
        //        NSString *url = [dic objectForKey:@"img_url"];
        if (imageView && [imageView isKindOfClass:[LE_HMBannerViewImageView class]] /*&& [url isNotEmpty]*/){
            [imageView leSetData:dic];
        }
    }
    if (self.scrollDirection == ScrollDirectionLandscape){
        leScrollView.contentOffset = CGPointMake(leScrollView.frame.size.width, 0);
    }else if (self.scrollDirection == ScrollDirectionPortait){
        leScrollView.contentOffset = CGPointMake(0, leScrollView.frame.size.height);
    }
    self.pageControl.currentPage = lePage-1;
}

- (NSArray *)getDisplayImagesWithPageIndex:(NSInteger)page{
    NSInteger pre = [self getPageIndex:lePage-1];
    NSInteger last = [self getPageIndex:lePage+1];
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:0];
    if(self.imagesArray.count>pre-1){
        [images addObject:[self.imagesArray objectAtIndex:pre-1]];
    }
    if(self.imagesArray.count>lePage-1){
        [images addObject:[self.imagesArray objectAtIndex:lePage-1]];
    }
    if(self.imagesArray.count>last-1){
        [images addObject:[self.imagesArray objectAtIndex:last-1]];
    }
    return images;
}

- (NSInteger)getPageIndex:(NSInteger)index{
    // value＝1为第一张，value = 0为前面一张
    if (index == 0){
        index = leTotalPage;
    }
    if (index == leTotalPage + 1){
        index = 1;
    }
    return index;
}
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView{
    NSInteger x = aScrollView.contentOffset.x;
    NSInteger y = aScrollView.contentOffset.y;
    //取消已加入的延迟线程
    if (self.enableRolling){
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
    }
    // 水平滚动
    if(self.scrollDirection == ScrollDirectionLandscape){
        // 往下翻一张
        if (x >= 2 * leScrollView.frame.size.width){
            lePage = [self getPageIndex:lePage+1];
            [self refreshScrollView];
        }
        if (x <= 0){
            lePage = [self getPageIndex:lePage-1];
            [self refreshScrollView];
        }
    }else if(self.scrollDirection == ScrollDirectionPortait){
        // 往下翻一张
        if (y >= 2 * leScrollView.frame.size.height){
            lePage = [self getPageIndex:lePage+1];
            [self refreshScrollView];
        }
        if (y <= 0){
            lePage = [self getPageIndex:lePage-1];
            [self refreshScrollView];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView{
    if (self.scrollDirection == ScrollDirectionLandscape){
        leScrollView.contentOffset = CGPointMake(leScrollView.frame.size.width, 0);
    }else if (self.scrollDirection == ScrollDirectionPortait){
        leScrollView.contentOffset = CGPointMake(0, leScrollView.frame.size.height);
    }
    if (self.enableRolling){
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
        [self performSelector:@selector(rollingScrollAction) withObject:nil afterDelay:self.rollingDelayTime inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}
- (void)leStartRolling{
    if (!self.imagesArray||self.imagesArray.count==0){
        return;
    }
    [self leStopRolling];
    if(self.imagesArray.count==1){
        [self refreshScrollView];
    }else{
        self.enableRolling = YES;
        [self refreshScrollView];
        [self performSelector:@selector(rollingScrollAction) withObject:nil afterDelay:self.rollingDelayTime];
    }
}
- (void)leStopRolling{
    self.enableRolling = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
}
- (void)rollingScrollAction{
    [UIView animateWithDuration:0.25 animations:^{
        if(self.scrollDirection == ScrollDirectionLandscape){
            leScrollView.contentOffset = CGPointMake(1.99*leScrollView.frame.size.width, 0);
        }else if(self.scrollDirection == ScrollDirectionPortait){
            leScrollView.contentOffset = CGPointMake(0, 1.99*leScrollView.frame.size.height);
        }
    } completion:^(BOOL finished) {
        if (finished){
            lePage = [self getPageIndex:lePage+1];
            [self refreshScrollView];
            if (self.enableRolling){
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
                [self performSelector:@selector(rollingScrollAction) withObject:nil afterDelay:self.rollingDelayTime inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
            }
        }
    }];
}
- (void)handleTap:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(leBannerView:didSelectImageView:withData:)]){
        if(self.imagesArray.count>lePage-1){
            [self.delegate leBannerView:self didSelectImageView:lePage-1 withData:[self.imagesArray objectAtIndex:lePage-1]];
        }
    }
}
@end
