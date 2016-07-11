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

#define DefaultBannerHeightRate 0.5
#define DefaultBannerSubviewHeight 80

typedef enum {
    BannerStayAtTheTop,
    BannerScrollWithCells
}TableViewBannerStyle;

@protocol LEBannerViewSelectionDelegate <NSObject>
-(void) onBannerSelectedWithIndex:(NSInteger) index;
@end
@protocol LEBannerSubviewFrameDelegate <NSObject>
-(void) onFrameResizedWithHeight:(int) height;
@end
@interface LEBannerSubview : UIView
@property (nonatomic) LEUIFramework *globalVar;
-(id) initWithDelegate:(id)delegate;
-(void) setData:(NSDictionary *) data;
-(void) initUI;
-(void) notifyHeightChange;
@end
@interface LEBannerContainer : UIView<LE_HMBannerViewDelegate,LEBannerSubviewFrameDelegate>
-(id) initWithFrame:(CGRect) frame Delegate:(id) delegate SubviewClassName:(NSString *) subView BannerImageViewClassName:(NSString *) bannerImageView;
-(void) setBannerData:(NSArray *) bannerData SubviewData:(NSDictionary *) subview;
@end

@interface LEBannerCell : LEBaseTableViewCell<LE_HMBannerViewDelegate,LEBannerSubviewFrameDelegate>
-(id) initWithSelectionDelegate:(id<LETableViewCellSelectionDelegate>) delegate SubviewClassName:(NSString *) subview  BannerImageViewClassName:(NSString *) bannerImageView;
-(void) setBannerData:(NSArray *) data IndexPath:(NSIndexPath *)path SubviewData:(NSDictionary *) subview;
@end

@interface LEBannerTableView : LEBaseTableView 
- (id) initWithSettings:(LETableViewSettings *) settings BannerSubviewClassName:(NSString *) subView BannerStyle:(TableViewBannerStyle) style BannerImageViewClassName:(NSString *) bannerImageView;
-(void) setBannerData:(NSArray *)bannerData SubviewData:(NSDictionary *) subView;
@end

@interface LETableViewPageWithBanner: LEBaseViewController
-(id) initWithCellClassName:(NSString *) cellClassName EmptyCellClassName:(NSString *) emptyCellClassName BannerStyle:(TableViewBannerStyle) bannerStyle BannerImageViewClassName:(NSString *) bannerImageViewClassName BannerSubviewClassName:(NSString *) bannerSubviewClassName TabbarHeight:(int) tabbarHeight;
//
-(void) onExtraInits;
-(void) onSetBannerData:(NSArray *) bannerData SubviewData:(NSDictionary *) subviewData;
-(void) onBannerSelectedWithIndex:(NSInteger)index;
-(void) onTableViewCellSelectedWithInfo:(NSDictionary *)info;
-(void) onRefreshData;
-(void) onLoadMore;
-(void) onFreshDataLogic:(NSMutableArray *) data;
-(void) onLoadMoreLogic:(NSMutableArray *) data;
-(void) setTopRefresh:(BOOL) top BottomRefresh:(BOOL) bottom;
@end