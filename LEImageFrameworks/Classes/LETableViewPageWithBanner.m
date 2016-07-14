//
//  LETableViewPageWithBanner.m
//  four23
//
//  Created by Larry Emerson on 15/9/8.
//  Copyright (c) 2015年 360cbs. All rights reserved.
//

#import "LETableViewPageWithBanner.h"


@implementation LEBannerContainer{
    LEUIFramework *globalVar;
    id bannerDelegate;
    LE_HMBannerView *bannerView;
    LEBannerSubview *bannerSubview;
}
-(id) initWithFrame:(CGRect) frame Delegate:(id) delegate SubviewClassName:(NSString *) subView BannerImageViewClassName:(NSString *) bannerImageView{
    globalVar=[LEUIFramework sharedInstance];
    self=[super initWithFrame:frame];
    bannerDelegate=delegate;
    bannerView=[[LE_HMBannerView alloc] initWithFrame:CGRectMake(0, 0, LESCREEN_WIDTH, LESCREEN_WIDTH*DefaultBannerHeightRate) scrollDirection:ScrollDirectionLandscape images:nil ImageViewClassName:bannerImageView];
    [bannerView setDelegate:self];
    [bannerView setRollingDelayTime:2];
    [bannerView setPageControlStyle:PageStyle_Middle]; 
    [self addSubview:bannerView];
    if(subView){
      LESuppressPerformSelectorLeakWarning(
                                           bannerSubview=[[subView leGetInstanceFromClassName] performSelector:NSSelectorFromString(@"initWithDelegate:") withObject:self];
                                           );
        [bannerSubview setFrame:CGRectMake(0, LESCREEN_WIDTH*DefaultBannerHeightRate, LESCREEN_WIDTH, DefaultBannerSubviewHeight)];
        [self addSubview:bannerSubview];
    }
    [self setFrame:CGRectMake(0, 0, LESCREEN_WIDTH, LESCREEN_WIDTH*DefaultBannerHeightRate+(bannerSubview?DefaultBannerSubviewHeight:0))];
    return self;
}
-(void) setBannerData:(NSArray *) bannerData SubviewData:(NSDictionary *)subview{
    if(bannerData){
        [bannerView reloadBannerWithData:bannerData];
        [bannerView startRolling];
    }
    if(subview){
        [bannerSubview setData:subview];
    }
}
-(void) onFrameResizedWithHeight:(int)height{
    [bannerSubview setFrame:CGRectMake(0, bannerView.bounds.size.height, LESCREEN_WIDTH, height)];
    [self setFrame:CGRectMake(0, 0, LESCREEN_WIDTH, LESCREEN_WIDTH*DefaultBannerHeightRate+height)];
    if([bannerDelegate respondsToSelector:NSSelectorFromString(@"onFrameResizedWithHeight:")]){
        [bannerDelegate onFrameResizedWithHeight:self.bounds.size.height];
    }
} 
-(void) bannerView:(LE_HMBannerView *)bannerView didSelectImageView:(NSInteger)index withData:(NSDictionary *)bannerData{
    if(bannerDelegate){
        [bannerDelegate onBannerSelectedWithIndex:index];
    }
}
@end

@implementation LEBannerCell{
    LE_HMBannerView *bannerView;
    LEBannerSubview *bannerSubview;
}
-(id) initWithSelectionDelegate:(id<LETableViewCellSelectionDelegate>) delegate SubviewClassName:(NSString *) subview BannerImageViewClassName:(NSString *) bannerImageView{
    LETableViewCellSettings *settings=[[LETableViewCellSettings alloc] initWithSelectionDelegate:delegate TableViewCellStyle:UITableViewCellStyleDefault reuseIdentifier:@"Banner" EnableGesture:NO];
    self=[super initWithSettings:settings];
    bannerView=[[LE_HMBannerView alloc] initWithFrame:CGRectMake(0, 0, LESCREEN_WIDTH, LESCREEN_WIDTH*DefaultBannerHeightRate) scrollDirection:ScrollDirectionLandscape images:nil ImageViewClassName:bannerImageView];
    [self addSubview:bannerView];
    [bannerView setDelegate:self];
    [bannerView setRollingDelayTime:2];
    [bannerView setPageControlStyle:PageStyle_Middle];
    if(subview){
      LESuppressPerformSelectorLeakWarning(
                                           bannerSubview=[[subview leGetInstanceFromClassName] performSelector:NSSelectorFromString(@"initWithDelegate:") withObject:self];
                                           );
        [bannerSubview setFrame:CGRectMake(0, bannerView.bounds.size.height, LESCREEN_WIDTH, DefaultBannerSubviewHeight)];
        [self addSubview:bannerSubview];
    }
    
    [self setCellHeight:LESCREEN_WIDTH*DefaultBannerHeightRate+(subview?DefaultBannerSubviewHeight:0)];
    return self;
}
-(void) onFrameResizedWithHeight:(int)height{
    [bannerSubview setFrame:CGRectMake(0, bannerView.bounds.size.height, LESCREEN_WIDTH, height)];
    [self setCellHeight:LESCREEN_WIDTH*DefaultBannerHeightRate+height];
}
-(void) setBannerData:(NSArray *)data IndexPath:(NSIndexPath *)path SubviewData:(NSDictionary *) subview{
    self.curIndexPath=path;
    if(data){
        [bannerView reloadBannerWithData:data];
        [bannerView startRolling];
    }
    if(subview&&bannerSubview){
        [bannerSubview setData:subview];
    }
}
-(void) bannerView:(LE_HMBannerView *)bannerView didSelectImageView:(NSInteger)index withData:(NSDictionary *)bannerData{
    if(self.selectionDelegate){
        [self.selectionDelegate onTableViewCellSelectedWithInfo:@{KeyOfCellIndexPath:self.curIndexPath,KeyOfCellClickStatus:[NSNumber numberWithInteger:index]}];
    }
}
@end

@implementation LEBannerSubview{
    id<LEBannerSubviewFrameDelegate> frameDelegate;
}
-(id) initWithDelegate:(id)delegate{
    frameDelegate=delegate;
    self.globalVar=[LEUIFramework sharedInstance];
    self= [super init];
    [self initUI];
    if(frameDelegate){
        [frameDelegate onFrameResizedWithHeight:self.frame.size.height];
    }
    return self;
}
-(void) setData:(NSDictionary *) data{
    //set your subview's contents here and reset subview's frame
    [self notifyHeightChange];
}
-(void) initUI{
    
}
-(void) notifyHeightChange{
    if(frameDelegate){
        [frameDelegate onFrameResizedWithHeight:self.frame.size.height];
    }
}
@end
@implementation LEBannerTableView{
    LEBannerCell *bannerCell;
    NSArray *curBannerData;
    NSDictionary *curSubViewData;
    NSString *subViewClassName;
    TableViewBannerStyle bannerStyle;
    NSString * bannerImageViewClassName;
}

-(NSInteger) _numberOfRowsInSection:(NSInteger) section{
    if(bannerStyle==BannerStayAtTheTop){
        return self.itemsArray.count;
    }else{
        return self.itemsArray.count+(curBannerData?1:0);
    }
}
-(void) setBannerData:(NSArray *)bannerData SubviewData:(NSDictionary *) subView{
    if(bannerData){
        curBannerData=bannerData;
    }
    if(subView){
        curSubViewData=subView;
    }
    if(bannerData||subView){
        [self reloadData];
    }
}

-(UITableViewCell *) _cellForRowAtIndexPath:(NSIndexPath *) indexPath{
    if(bannerStyle==BannerStayAtTheTop){
        LEBaseTableViewCell *cell=[self dequeueReusableCellWithIdentifier:CommonTableViewReuseableCellIdentifier];
        if(!cell){
          LESuppressPerformSelectorLeakWarning(
                                               cell=[[self.tableViewCellClassName leGetInstanceFromClassName] performSelector:NSSelectorFromString(@"initWithSettings:") withObject:[[LETableViewCellSettings alloc] initWithSelectionDelegate:self.cellSelectionDelegate]];
                                               );
        }
        if(cell&&indexPath.row<self.itemsArray.count){
            [cell setData:[self.itemsArray objectAtIndex:indexPath.row] IndexPath:indexPath];
        }
        return cell;
    }else{
        if(indexPath.section==0){
            if(indexPath.row==0&&curBannerData){
                if(!bannerCell){
                    bannerCell=[[LEBannerCell alloc] initWithSelectionDelegate:self.cellSelectionDelegate SubviewClassName:subViewClassName BannerImageViewClassName:bannerImageViewClassName];
                }
                if(curBannerData){
                    [bannerCell setBannerData:curBannerData IndexPath:indexPath SubviewData:curSubViewData];
                }
                return bannerCell;
            }else{
                LEBaseTableViewCell *cell=[self dequeueReusableCellWithIdentifier:CommonTableViewReuseableCellIdentifier];
                if(!cell){
                  LESuppressPerformSelectorLeakWarning(
                                                       cell=[[self.tableViewCellClassName leGetInstanceFromClassName] performSelector:NSSelectorFromString(@"initWithSettings:") withObject:[[LETableViewCellSettings alloc] initWithSelectionDelegate:self.cellSelectionDelegate]];
                                                       );
                }
                int index=(int)indexPath.row-(curBannerData?1:0);
                if(cell&&index<self.itemsArray.count){
                    [cell setData:[self.itemsArray objectAtIndex:index] IndexPath:indexPath];
                }
                return cell;
            }
        }
    }
    return nil;
}
- (id) initWithSettings:(LETableViewSettings *) settings BannerSubviewClassName:(NSString *) subView BannerStyle:(TableViewBannerStyle)style  BannerImageViewClassName:(NSString *) bannerImageView{
    subViewClassName=subView;
    bannerStyle=style;
    bannerImageViewClassName=bannerImageView;
    return [super initWithSettings:settings];
}
@end

@interface LETableViewPageWithBannerPage:LEBaseView<LEGetDataDelegate,LETableViewCellSelectionDelegate,LEBannerSubviewFrameDelegate,LEBannerViewSelectionDelegate,LEGetDataDelegate,LETableViewCellSelectionDelegate>
@end
@implementation LETableViewPageWithBannerPage{
    LEBannerTableView *curTableView;
    LEBannerContainer *bannerContainer;
    UIView *tableViewContainer;
    int curTabbarHeight;
    TableViewBannerStyle curBannerStyle;
    
    NSString *curCellClassName;
    NSString *curEmptyCellClassName;
    NSString *curBannerSubviewClassName;
    NSString *curBannerImageViewClassName;
    LETableViewPageWithBanner *curParent;
}
-(void) onSetParent:(LETableViewPageWithBanner *) parent{
    curParent=parent;
}
-(void) setTopRefresh:(BOOL) top BottomRefresh:(BOOL) bottom{
    [curTableView setTopRefresh:top];
    [curTableView setBottomRefresh:bottom];
}

-(void) setExtraViewInits{
    if(curBannerStyle==BannerStayAtTheTop){
        bannerContainer=[[LEBannerContainer alloc] initWithFrame:CGRectMake(0, 0, self.curFrameWidth, self.curFrameWidth*DefaultBannerHeightRate) Delegate:self SubviewClassName:curBannerSubviewClassName BannerImageViewClassName:curBannerImageViewClassName];
        [self.viewContainer addSubview:bannerContainer];
        tableViewContainer=[[UIView alloc] initWithFrame:CGRectMake(0, bannerContainer.bounds.size.height, self.curFrameWidth, self.viewContainer.bounds.size.height-bannerContainer.bounds.size.height-curTabbarHeight)];
        [self.viewContainer addSubview:tableViewContainer];
        curTableView=[[LEBannerTableView alloc] initWithSettings:[[LETableViewSettings alloc] initWithSuperViewContainer:self.superViewContainer ParentView:tableViewContainer TableViewCell:curCellClassName EmptyTableViewCell:curEmptyCellClassName GetDataDelegate:self TableViewCellSelectionDelegate:self] BannerSubviewClassName:curBannerSubviewClassName BannerStyle:curBannerStyle BannerImageViewClassName:curBannerImageViewClassName];
    }else{
        if(curTabbarHeight>0){
            tableViewContainer=[[UIView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self.viewContainer Anchor:LEAnchorInsideTopCenter Offset:CGPointZero CGSize:CGSizeMake(self.viewContainer.bounds.size.width, self.viewContainer.bounds.size.height-curTabbarHeight)]];
        }
        curTableView=[[LEBannerTableView alloc] initWithSettings:[[LETableViewSettings alloc] initWithSuperViewContainer:self.superViewContainer ParentView:tableViewContainer?:self.viewContainer TableViewCell:curCellClassName EmptyTableViewCell:curEmptyCellClassName GetDataDelegate:self TableViewCellSelectionDelegate:self] BannerSubviewClassName:curBannerSubviewClassName BannerStyle:curBannerStyle BannerImageViewClassName:curBannerImageViewClassName];
    }
    [curTableView setAlpha:0];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^(void){
        [curTableView setAlpha:1];
    } completion:^(BOOL isDone){
        
    }];
}
//点击事件
-(void) onBannerSelectedWithIndex:(NSInteger)index{
    [curParent onBannerSelectedWithIndex:index];
    //    LELog(@"触发Banner点击事件，子类需要重写onBannerSelectedWithIndex方法。当前点击了第%@张Banner",[NSNumber numberWithInteger:index]);
}
-(void) onTableViewCellSelectedWithInfo:(NSDictionary *)info{
    [curParent onTableViewCellSelectedWithInfo:info];
    //    LELog(@"参数tableViewDelegate=nil, 调用父类onTableViewCellSelectedWithInfo。%@",info);
}
//数据请求
-(void) onRefreshData{
    [curParent onRefreshData];
    //    LELog(@"触发下拉刷新，子类需要重写onRefreshData方法，待获取到数据后需要执行onFreshDataLogic方法");
}
-(void) onLoadMore{
    [curParent onLoadMore];
    //    LELog(@"上拉获取更多，子类需要重写onLoadMore方法，待获取到数据后需要执行onLoadMoreLogic");
}
//高度变动通知
-(void) onFrameResizedWithHeight:(int)height{
    [bannerContainer setFrame:CGRectMake(0, 0, self.curFrameWidth, height)];
    [tableViewContainer setFrame:CGRectMake(0, bannerContainer.bounds.size.height, self.curFrameWidth, self.curFrameHight-height-curTabbarHeight)];
    [curTableView leSetFrame:tableViewContainer.bounds];
}
//Banner数据
-(void) onSetBannerData:(NSArray *) bannerData SubviewData:(NSDictionary *) subviewData{
    if(curBannerStyle==BannerStayAtTheTop){
        if(bannerContainer){
            [bannerContainer setBannerData:bannerData SubviewData:subviewData];
        }
    }else{
        if(curTableView){
            [curTableView setBannerData:bannerData SubviewData:subviewData];
        }
    }
}
//数据
-(void) onFreshDataLogic:(NSMutableArray *) data{
    if(curTableView){
        [curTableView onRefreshedWithData:data];
    }
}
-(void) onLoadMoreLogic:(NSMutableArray *) data{
    if(curTableView){
        [curTableView onLoadedMoreWithData:data];
    }
}
-(id) initWithViewController:(LEBaseViewController *)vc CellClassName:(NSString *) cellClassName EmptyCellClassName:(NSString *) emptyCellClassName BannerStyle:(TableViewBannerStyle) bannerStyle BannerImageViewClassName:(NSString *) bannerImageViewClassName BannerSubviewClassName:(NSString *) bannerSubviewClassName TabbarHeight:(int) tabbarHeight{
    curTabbarHeight=tabbarHeight;
    curBannerStyle=bannerStyle;
    
    if(!cellClassName||cellClassName.length==0){
        curCellClassName=@"LEBaseTableViewCell";
    }else{
        curCellClassName=cellClassName;
    }
    if(!emptyCellClassName||emptyCellClassName.length==0){
        curEmptyCellClassName=@"LEBaseEmptyTableViewCell";
    }else {
        curEmptyCellClassName=emptyCellClassName;
    }
    if(!bannerImageViewClassName||bannerImageViewClassName.length==0){
        curBannerImageViewClassName=@"LE_HMBannerViewImageView";
    }else{
        curBannerImageViewClassName=bannerImageViewClassName;
    }
    if(bannerSubviewClassName&&bannerSubviewClassName.length==0){
        curBannerSubviewClassName=nil;
    }else{
        curBannerSubviewClassName=bannerSubviewClassName;
    }
    self=[super initWithViewController:vc];
    return self;
}
@end
@implementation LETableViewPageWithBanner{
    LETableViewPageWithBannerPage *page;
}
-(id) initWithCellClassName:(NSString *) cellClassName EmptyCellClassName:(NSString *) emptyCellClassName BannerStyle:(TableViewBannerStyle) bannerStyle BannerImageViewClassName:(NSString *) bannerImageViewClassName BannerSubviewClassName:(NSString *) bannerSubviewClassName TabbarHeight:(int) tabbarHeight{
    self=[super init];
    page=[[LETableViewPageWithBannerPage alloc] initWithViewController:self CellClassName:cellClassName EmptyCellClassName:emptyCellClassName BannerStyle:bannerStyle BannerImageViewClassName:bannerImageViewClassName BannerSubviewClassName:bannerSubviewClassName TabbarHeight:tabbarHeight];
    [page onSetParent:self];
    [self onExtraInits];
    return self;
}
-(void) onExtraInits{
    
}
-(void) onSetBannerData:(NSArray *) bannerData SubviewData:(NSDictionary *) subviewData{
    [page onSetBannerData:bannerData SubviewData:subviewData];
}
-(void) onBannerSelectedWithIndex:(NSInteger)index{
}
-(void) onTableViewCellSelectedWithInfo:(NSDictionary *)info{
}
-(void) onRefreshData{
}
-(void) onLoadMore{
}
-(void) onFreshDataLogic:(NSMutableArray *) data{
    [page onFreshDataLogic:data];
}
-(void) onLoadMoreLogic:(NSMutableArray *) data{
    [page onLoadMoreLogic:data];
}
-(void) setTopRefresh:(BOOL) top BottomRefresh:(BOOL) bottom{
    [page setTopRefresh:top BottomRefresh:bottom];
}
@end
