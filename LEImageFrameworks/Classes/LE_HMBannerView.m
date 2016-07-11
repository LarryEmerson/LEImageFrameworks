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
    self.globalVar=[LEUIFramework sharedInstance];
    self=[super init];
    [self initUI];
    return self;
}
-(void) setData:(NSDictionary *) data{
    NSString *url=[data objectForKey:@"img_url"];
    [self setImageWithUrlString:url];
}
-(void) initUI{}
@end

@interface LE_HMBannerView (){
    NSInteger totalCount;
}
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) BOOL enableRolling;
- (void)refreshScrollView;
- (NSInteger)getPageIndex:(NSInteger)index;
- (NSArray *)getDisplayImagesWithPageIndex:(NSInteger)pageIndex;
@end

@implementation LE_HMBannerView{
    NSString *curImageViewClassName;
    BannerViewPageStyle curPageStyle;
    CGPoint curPageStyleOffset;
}
@synthesize delegate;
@synthesize imagesArray;
@synthesize scrollDirection;
@synthesize pageControl;
- (void)dealloc {
    delegate = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
}

- (id)initWithFrame:(CGRect)frame scrollDirection:(BannerViewScrollDirection)direction images:(NSArray *)images  ImageViewClassName:(NSString *) className{
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
        totalPage = imagesArray.count;
        totalCount = totalPage;
        // 显示的是图片数组里的第一张图片
        // 和数组是+1关系
        curPage = 1;
        scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        // 在水平方向滚动
        if(scrollDirection == ScrollDirectionLandscape) {
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 3, scrollView.frame.size.height);
        }else if(scrollDirection == ScrollDirectionPortait) {
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height * 3);
        }
        for (NSInteger i = 0; i < 3; i++) {
            LE_HMBannerViewImageView *imageView =nil;
            SuppressPerformSelectorLeakWarning(
                                               imageView=[[curImageViewClassName getInstanceFromClassName] performSelector:NSSelectorFromString(@"init")];
                                               );
            [imageView setFrame:scrollView.bounds];
            imageView.userInteractionEnabled = YES;
            imageView.tag = Banner_StartTag+i;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [imageView addGestureRecognizer:singleTap];
            if(scrollDirection == ScrollDirectionLandscape) {
                imageView.frame = CGRectOffset(imageView.frame, scrollView.frame.size.width * i, 0);
            }else if(scrollDirection == ScrollDirectionPortait) {
                imageView.frame = CGRectOffset(imageView.frame, 0, scrollView.frame.size.height * i);
            }
            [scrollView addSubview:imageView];
        }
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(LayoutSideSpace, frame.size.height-HMBannerOffset, HMBannerWidth, HMBannerOffset)];
        self.pageControl.numberOfPages = self.imagesArray.count;
        [self.pageControl setUserInteractionEnabled:NO];
        [self addSubview:self.pageControl];
        
        self.pageControl.currentPage = 0;
        //[self refreshScrollView];
    }
    return self;
}
- (void)reloadBannerWithData:(NSArray *)images{
    if (self.enableRolling) {
        [self stopRolling];
    }
    self.imagesArray = [[NSArray alloc] initWithArray:images];
    totalPage = imagesArray.count;
    totalCount = totalPage;
    if(images.count==0){
        curPage = 1;
    }else if(curPage-1>=images.count){
        curPage=images.count;
    }
    self.pageControl.numberOfPages = totalPage;
    self.pageControl.currentPage = curPage-1;
    
    [self setPageControlStyle:curPageStyle];
    //    [self startDownloadImage];
}

- (void)setSquare:(NSInteger)asquare{
    if (scrollView){
        scrollView.layer.cornerRadius = asquare;
        if (asquare == 0){
            scrollView.layer.masksToBounds = NO;
        }else{
            scrollView.layer.masksToBounds = YES;
        }
    }
}
-(void)setPageControlOffset:(CGPoint) offset{
    curPageStyleOffset=offset;
    [self setPageControlStyle:curPageStyle];
}
- (void)setPageControlStyle:(BannerViewPageStyle)pageStyle{
    curPageStyle=pageStyle;
    int width=(int)self.imagesArray.count*HMBannerSize;
    if(width<HMBannerSize){
        width=HMBannerSize;
    }
    if (pageStyle == PageStyle_Left){
        [self.pageControl setFrame:CGRectMake(LayoutSideSpace+curPageStyleOffset.x, self.bounds.size.height-HMBannerOffset+curPageStyleOffset.y, width, HMBannerOffset)];
    }else if (pageStyle == PageStyle_Right){
        [self.pageControl setFrame:CGRectMake(self.bounds.size.width-LayoutSideSpace-width+curPageStyleOffset.x, self.bounds.size.height-HMBannerOffset+curPageStyleOffset.y, width, HMBannerOffset)];
    }else if (pageStyle == PageStyle_Middle){
        [self.pageControl setFrame:CGRectMake((self.bounds.size.width-width)/2+curPageStyleOffset.x, self.bounds.size.height-HMBannerOffset-self.pageControl.bounds.size.height+curPageStyleOffset.y, width, HMBannerOffset)];
    }else if (pageStyle == PageStyle_None){
        [self.pageControl setHidden:YES];
    }
}

- (void)showClose:(BOOL)show{
    if (show){
        if (!BannerCloseButton){
            BannerCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [BannerCloseButton setFrame:CGRectMake(self.bounds.size.width-40, 0, 40, 40)];
            [BannerCloseButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
            [BannerCloseButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            [BannerCloseButton addTarget:self action:@selector(closeBanner) forControlEvents:UIControlEventTouchUpInside];
            [BannerCloseButton setImage:[[LEUIFramework sharedInstance] getImageFromLEFrameworksWithName:@"banner_close"] forState:UIControlStateNormal];
            BannerCloseButton.exclusiveTouch = YES;
            [self addSubview:BannerCloseButton];
        }
        BannerCloseButton.hidden = NO;
    }else{
        if (BannerCloseButton){
            BannerCloseButton.hidden = YES;
        }
    }
}
- (void)closeBanner{
    [self stopRolling];
    if ([self.delegate respondsToSelector:@selector(bannerViewdidClosed:)]){
        [self.delegate bannerViewdidClosed:self];
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
    NSArray *curimageUrls = [self getDisplayImagesWithPageIndex:curPage];
    for (NSInteger i = 0; i < 3&&i<curimageUrls.count; i++){
        LE_HMBannerViewImageView *imageView = (LE_HMBannerViewImageView *)[scrollView viewWithTag:Banner_StartTag+i];
        NSDictionary *dic = [curimageUrls objectAtIndex:i];
        //        NSString *url = [dic objectForKey:@"img_url"];
        if (imageView && [imageView isKindOfClass:[LE_HMBannerViewImageView class]] /*&& [url isNotEmpty]*/){
            [imageView setData:dic];
        }
    }
    if (scrollDirection == ScrollDirectionLandscape){
        scrollView.contentOffset = CGPointMake(scrollView.frame.size.width, 0);
    }else if (scrollDirection == ScrollDirectionPortait){
        scrollView.contentOffset = CGPointMake(0, scrollView.frame.size.height);
    }
    self.pageControl.currentPage = curPage-1;
}

- (NSArray *)getDisplayImagesWithPageIndex:(NSInteger)page{
    NSInteger pre = [self getPageIndex:curPage-1];
    NSInteger last = [self getPageIndex:curPage+1];
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:0];
    if(imagesArray.count>pre-1){
        [images addObject:[imagesArray objectAtIndex:pre-1]];
    }
    if(imagesArray.count>curPage-1){
        [images addObject:[imagesArray objectAtIndex:curPage-1]];
    }
    if(imagesArray.count>last-1){
        [images addObject:[imagesArray objectAtIndex:last-1]];
    }
    return images;
}

- (NSInteger)getPageIndex:(NSInteger)index{
    // value＝1为第一张，value = 0为前面一张
    if (index == 0){
        index = totalPage;
    }
    if (index == totalPage + 1){
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
    if(scrollDirection == ScrollDirectionLandscape){
        // 往下翻一张
        if (x >= 2 * scrollView.frame.size.width){
            curPage = [self getPageIndex:curPage+1];
            [self refreshScrollView];
        }
        if (x <= 0){
            curPage = [self getPageIndex:curPage-1];
            [self refreshScrollView];
        }
    }else if(scrollDirection == ScrollDirectionPortait){
        // 往下翻一张
        if (y >= 2 * scrollView.frame.size.height){
            curPage = [self getPageIndex:curPage+1];
            [self refreshScrollView];
        }
        if (y <= 0){
            curPage = [self getPageIndex:curPage-1];
            [self refreshScrollView];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView{
    if (scrollDirection == ScrollDirectionLandscape){
        scrollView.contentOffset = CGPointMake(scrollView.frame.size.width, 0);
    }else if (scrollDirection == ScrollDirectionPortait){
        scrollView.contentOffset = CGPointMake(0, scrollView.frame.size.height);
    }
    if (self.enableRolling){
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
        [self performSelector:@selector(rollingScrollAction) withObject:nil afterDelay:self.rollingDelayTime inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}
- (void)startRolling{
    if (!self.imagesArray||self.imagesArray.count==0){
        return;
    }
    [self stopRolling];
    self.enableRolling = YES;
    [self refreshScrollView];
    [self performSelector:@selector(rollingScrollAction) withObject:nil afterDelay:self.rollingDelayTime];
}
- (void)stopRolling{
    self.enableRolling = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
}
- (void)rollingScrollAction{
    [UIView animateWithDuration:0.25 animations:^{
        if(scrollDirection == ScrollDirectionLandscape){
            scrollView.contentOffset = CGPointMake(1.99*scrollView.frame.size.width, 0);
        }else if(scrollDirection == ScrollDirectionPortait){
            scrollView.contentOffset = CGPointMake(0, 1.99*scrollView.frame.size.height);
        }
    } completion:^(BOOL finished) {
        if (finished){
            curPage = [self getPageIndex:curPage+1];
            [self refreshScrollView];
            if (self.enableRolling){
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rollingScrollAction) object:nil];
                [self performSelector:@selector(rollingScrollAction) withObject:nil afterDelay:self.rollingDelayTime inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
            }
        }
    }];
}
- (void)handleTap:(UITapGestureRecognizer *)tap{
    if ([delegate respondsToSelector:@selector(bannerView:didSelectImageView:withData:)]){
        if(imagesArray.count>curPage-1){
            [delegate bannerView:self didSelectImageView:curPage-1 withData:[self.imagesArray objectAtIndex:curPage-1]];
        }
    }
}
@end
