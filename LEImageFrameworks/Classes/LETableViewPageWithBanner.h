//
//  LETableViewPageWithBanner.h
//  four23
//
//  Created by Larry Emerson on 15/9/8.
//  Copyright (c) 2015年 360cbs. All rights reserved.
//

#import "LEBaseTableView.h"
#import "LEBaseTableViewCell.h"
#import "LEBaseViewController.h"
#import "LE_HMBannerView.h"

#define LEDefaultBannerHeightRate 0.5
#define LEDefaultBannerSubviewHeight 80

typedef enum {
    BannerStayAtTheTop,
    BannerScrollWithCells
}LEBannerStyle;

@protocol LEBannerViewSelectionDelegate <NSObject>
-(void) leOnBannerSelectedWithIndex:(NSInteger) index;
@end
@protocol LEBannerSubviewFrameDelegate <NSObject>
-(void) leOnFrameResizedWithHeight:(int) height;
@end
@interface LEBannerSubview : UIView 
-(id) initWithDelegate:(id)delegate;
-(void) leSetData:(NSDictionary *) data;
-(void) leNotifyHeightChange;
@end
@interface LEBannerContainer : UIView<LE_HMBannerViewDelegate,LEBannerSubviewFrameDelegate>
-(id) initWithFrame:(CGRect) frame Delegate:(id) delegate SubviewClassName:(NSString *) subView BannerImageViewClassName:(NSString *) bannerImageView;
-(void) leSetBannerData:(NSArray *) bannerData SubviewData:(NSDictionary *) subview;
@end

@interface LEBannerCell : LEBaseTableViewCell<LE_HMBannerViewDelegate,LEBannerSubviewFrameDelegate>
-(id) initWithSelectionDelegate:(id<LETableViewCellSelectionDelegate>) delegate SubviewClassName:(NSString *) subview  BannerImageViewClassName:(NSString *) bannerImageView;
-(void) leSetBannerData:(NSArray *) data IndexPath:(NSIndexPath *)path SubviewData:(NSDictionary *) subview;
@end

@interface LEBannerTableView : LEBaseTableView 
- (id) initWithSettings:(LETableViewSettings *) settings BannerSubviewClassName:(NSString *) subView BannerStyle:(LEBannerStyle) style BannerImageViewClassName:(NSString *) bannerImageView;
-(void) leSetBannerData:(NSArray *)bannerData SubviewData:(NSDictionary *) subView;
@end

@interface LETableViewPageWithBanner: LEBaseViewController
-(id) initWithCellClassName:(NSString *) cellClassName EmptyCellClassName:(NSString *) emptyCellClassName BannerStyle:(LEBannerStyle) bannerStyle BannerImageViewClassName:(NSString *) bannerImageViewClassName BannerSubviewClassName:(NSString *) bannerSubviewClassName TabbarHeight:(int) tabbarHeight;
//
-(void) leOnSetBannerData:(NSArray *) bannerData SubviewData:(NSDictionary *) subviewData;
-(void) leOnBannerSelectedWithIndex:(NSInteger)index; 
-(void) leOnRefreshData;
-(void) leOnRefreshedWithData:(NSMutableArray *) data;
-(void) leOnLoadMore;
-(void) leOnLoadMoreLogic:(NSMutableArray *) data;
-(void) leSetTopRefresh:(BOOL) top BottomRefresh:(BOOL) bottom;
-(void) leOnTableViewCellSelectedWithInfo:(NSDictionary *)info;
@end