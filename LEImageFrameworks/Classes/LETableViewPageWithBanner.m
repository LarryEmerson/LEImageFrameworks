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
    bannerView=[[LE_HMBannerView alloc] initWithFrame:CGRectMake(0, 0, LESCREEN_WIDTH, LESCREEN_WIDTH*LEDefaultBannerHeightRate) scrollDirection:ScrollDirectionLandscape images:nil ImageViewClassName:bannerImageView];
    [bannerView leSetDelegate:self];
    [bannerView leSetRollingDelayTime:2];
    [bannerView leSetPageControlStyle:PageStyle_Middle];
    [self addSubview:bannerView];
    if(subView){
        LESuppressPerformSelectorLeakWarning(
                                             bannerSubview=[[subView leGetInstanceFromClassName] performSelector:NSSelectorFromString(@"initWithDelegate:") withObject:self];
                                             );
        [bannerSubview setFrame:CGRectMake(0, LESCREEN_WIDTH*LEDefaultBannerHeightRate, LESCREEN_WIDTH, LEDefaultBannerSubviewHeight)];
        [self addSubview:bannerSubview];
    }
    [self setFrame:CGRectMake(0, 0, LESCREEN_WIDTH, LESCREEN_WIDTH*LEDefaultBannerHeightRate+(bannerSubview?LEDefaultBannerSubviewHeight:0))];
    return self;
}
-(void) leSetBannerData:(NSArray *) bannerData SubviewData:(NSDictionary *)subview{
    if(bannerData){
        [bannerView leReloadBannerWithData:bannerData];
        [bannerView leStartRolling];
    }
    if(subview){
        [bannerSubview leSetData:subview];
    }
}
-(void) leOnFrameResizedWithHeight:(int)height{
    [bannerSubview setFrame:CGRectMake(0, bannerView.bounds.size.height, LESCREEN_WIDTH, height)];
    [self setFrame:CGRectMake(0, 0, LESCREEN_WIDTH, LESCREEN_WIDTH*LEDefaultBannerHeightRate+height)];
    if([bannerDelegate respondsToSelector:NSSelectorFromString(@"leOnFrameResizedWithHeight:")]){
        [bannerDelegate leOnFrameResizedWithHeight:self.bounds.size.height];
    }
} 
-(void) leBannerView:(LE_HMBannerView *)bannerView didSelectImageView:(NSInteger)index withData:(NSDictionary *)bannerData{
    if(bannerDelegate){
        [bannerDelegate leOnBannerSelectedWithIndex:index];
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
    bannerView=[[LE_HMBannerView alloc] initWithFrame:CGRectMake(0, 0, LESCREEN_WIDTH, LESCREEN_WIDTH*LEDefaultBannerHeightRate) scrollDirection:ScrollDirectionLandscape images:nil ImageViewClassName:bannerImageView];
    [self addSubview:bannerView];
    [bannerView leSetDelegate:self];
    [bannerView leSetRollingDelayTime:2];
    [bannerView leSetPageControlStyle:PageStyle_Middle];
    if(subview){
        LESuppressPerformSelectorLeakWarning(
                                             bannerSubview=[[subview leGetInstanceFromClassName] performSelector:NSSelectorFromString(@"initWithDelegate:") withObject:self];
                                             );
        [bannerSubview setFrame:CGRectMake(0, bannerView.bounds.size.height, LESCREEN_WIDTH, LEDefaultBannerSubviewHeight)];
        [self addSubview:bannerSubview];
    }
    
    [self leSetCellHeight:LESCREEN_WIDTH*LEDefaultBannerHeightRate+(subview?LEDefaultBannerSubviewHeight:0)];
    return self;
}
-(void) leOnFrameResizedWithHeight:(int)height{
    [bannerSubview setFrame:CGRectMake(0, bannerView.bounds.size.height, LESCREEN_WIDTH, height)];
    [self leSetCellHeight:LESCREEN_WIDTH*LEDefaultBannerHeightRate+height];
}
-(void) leSetBannerData:(NSArray *)data IndexPath:(NSIndexPath *)path SubviewData:(NSDictionary *) subview{
    self.leIndexPath=path;
    if(data){
        [bannerView leReloadBannerWithData:data];
        [bannerView leStartRolling];
    }
    if(subview&&bannerSubview){
        [bannerSubview leSetData:subview];
    }
}
-(void) leBannerView:(LE_HMBannerView *)bannerView didSelectImageView:(NSInteger)index withData:(NSDictionary *)bannerData{
    if(self.leSelectionDelegate){
        [self.leSelectionDelegate leOnTableViewCellSelectedWithInfo:@{LEKeyOfIndexPath:self.leIndexPath,LEKeyOfClickStatus:[NSNumber numberWithInteger:index]}];
    }
}
@end

@implementation LEBannerSubview{
    id<LEBannerSubviewFrameDelegate> frameDelegate;
}
-(id) initWithDelegate:(id)delegate{
    frameDelegate=delegate;
    self= [super init];
    [self leExtraInits];
    if(frameDelegate){
        [frameDelegate leOnFrameResizedWithHeight:self.frame.size.height];
    }
    return self;
}
-(void) leSetData:(NSDictionary *) data{
    //set your subview's contents here and reset subview's frame
    [self leNotifyHeightChange];
}
-(void) leNotifyHeightChange{
    if(frameDelegate){
        [frameDelegate leOnFrameResizedWithHeight:self.frame.size.height];
    }
}
@end
@implementation LEBannerTableView{
    LEBannerCell *bannerCell;
    NSArray *curBannerData;
    NSDictionary *curSubViewData;
    NSString *subViewClassName;
    LEBannerStyle bannerStyle;
    NSString * bannerImageViewClassName;
}

-(NSInteger) leNumberOfRowsInSection:(NSInteger) section{
    if(bannerStyle==BannerStayAtTheTop){
        return self.leItemsArray.count;
    }else{
        return self.leItemsArray.count+(curBannerData?1:0);
    }
}
-(void) leSetBannerData:(NSArray *)bannerData SubviewData:(NSDictionary *) subView{
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

-(UITableViewCell *) leCellForRowAtIndexPath:(NSIndexPath *) indexPath{
    if(bannerStyle==BannerStayAtTheTop){
        LEBaseTableViewCell *cell=[self dequeueReusableCellWithIdentifier:LEReuseableCellIdentifier];
        if(!cell){
            LESuppressPerformSelectorLeakWarning(
                                                 cell=[[self.leTableViewCellClassName leGetInstanceFromClassName] performSelector:NSSelectorFromString(@"initWithSettings:") withObject:[[LETableViewCellSettings alloc] initWithSelectionDelegate:self.leCellSelectionDelegate]];
                                                 );
        }
        if(cell&&indexPath.row<self.leItemsArray.count){
            [cell leSetData:[self.leItemsArray objectAtIndex:indexPath.row] IndexPath:indexPath];
        }
        return cell;
    }else{
        if(indexPath.section==0){
            if(indexPath.row==0&&curBannerData){
                if(!bannerCell){
                    bannerCell=[[LEBannerCell alloc] initWithSelectionDelegate:self.leCellSelectionDelegate SubviewClassName:subViewClassName BannerImageViewClassName:bannerImageViewClassName];
                }
                if(curBannerData){
                    [bannerCell leSetBannerData:curBannerData IndexPath:indexPath SubviewData:curSubViewData];
                }
                return bannerCell;
            }else{
                LEBaseTableViewCell *cell=[self dequeueReusableCellWithIdentifier:LEReuseableCellIdentifier];
                if(!cell){
                    LESuppressPerformSelectorLeakWarning(
                                                         cell=[[self.leTableViewCellClassName leGetInstanceFromClassName] performSelector:NSSelectorFromString(@"initWithSettings:") withObject:[[LETableViewCellSettings alloc] initWithSelectionDelegate:self.leCellSelectionDelegate]];
                                                         );
                }
                int index=(int)indexPath.row-(curBannerData?1:0);
                if(cell&&index<self.leItemsArray.count){
                    [cell leSetData:[self.leItemsArray objectAtIndex:index] IndexPath:indexPath];
                }
                return cell;
            }
        }
    }
    return nil;
}
- (id) initWithSettings:(LETableViewSettings *) settings BannerSubviewClassName:(NSString *) subView BannerStyle:(LEBannerStyle)style  BannerImageViewClassName:(NSString *) bannerImageView{
    subViewClassName=subView;
    bannerStyle=style;
    bannerImageViewClassName=bannerImageView;
    return [super initWithSettings:settings];
}
@end

@interface LETableViewPageWithBannerPage:LEBaseView<LETableViewDataSourceDelegate,LETableViewCellSelectionDelegate,LEBannerSubviewFrameDelegate,LEBannerViewSelectionDelegate,LETableViewDataSourceDelegate,LETableViewCellSelectionDelegate>
@end
@implementation LETableViewPageWithBannerPage{
    LEBannerTableView *curTableView;
    LEBannerContainer *bannerContainer;
    UIView *tableViewContainer;
    int curTabbarHeight;
    LEBannerStyle curBannerStyle;
    
    NSString *curCellClassName;
    NSString *curEmptyCellClassName;
    NSString *curBannerSubviewClassName;
    NSString *curBannerImageViewClassName;
    LETableViewPageWithBanner *curParent;
}
-(void) onSetParent:(LETableViewPageWithBanner *) parent{
    curParent=parent;
}
-(void) leSetTopRefresh:(BOOL) top BottomRefresh:(BOOL) bottom{
    [curTableView leSetTopRefresh:top];
    [curTableView leSetBottomRefresh:bottom];
}

-(void) leExtraInits{
    if(curBannerStyle==BannerStayAtTheTop){
        bannerContainer=[[LEBannerContainer alloc] initWithFrame:CGRectMake(0, 0, self.leCurrentFrameWidth, self.leCurrentFrameWidth*LEDefaultBannerHeightRate) Delegate:self SubviewClassName:curBannerSubviewClassName BannerImageViewClassName:curBannerImageViewClassName];
        [self.leViewContainer addSubview:bannerContainer];
        tableViewContainer=[[UIView alloc] initWithFrame:CGRectMake(0, bannerContainer.bounds.size.height, self.leCurrentFrameWidth, self.leViewContainer.bounds.size.height-bannerContainer.bounds.size.height-curTabbarHeight)];
        [self.leViewContainer addSubview:tableViewContainer];
        curTableView=[[LEBannerTableView alloc] initWithSettings:[[LETableViewSettings alloc] initWithSuperViewContainer:self.leSuperViewContainer ParentView:tableViewContainer TableViewCell:curCellClassName EmptyTableViewCell:curEmptyCellClassName GetDataDelegate:self TableViewCellSelectionDelegate:self] BannerSubviewClassName:curBannerSubviewClassName BannerStyle:curBannerStyle BannerImageViewClassName:curBannerImageViewClassName];
    }else{
        if(curTabbarHeight>0){
            tableViewContainer=[[UIView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self.leViewContainer Anchor:LEAnchorInsideTopCenter Offset:CGPointZero CGSize:CGSizeMake(self.leViewContainer.bounds.size.width, self.leViewContainer.bounds.size.height-curTabbarHeight)]];
        }
        curTableView=[[LEBannerTableView alloc] initWithSettings:[[LETableViewSettings alloc] initWithSuperViewContainer:self.leSuperViewContainer ParentView:tableViewContainer?:self.leViewContainer TableViewCell:curCellClassName EmptyTableViewCell:curEmptyCellClassName GetDataDelegate:self TableViewCellSelectionDelegate:self] BannerSubviewClassName:curBannerSubviewClassName BannerStyle:curBannerStyle BannerImageViewClassName:curBannerImageViewClassName];
    }
    [curTableView setAlpha:0];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^(void){
        [curTableView setAlpha:1];
    } completion:^(BOOL isDone){
        
    }];
}
//点击事件
-(void) leOnBannerSelectedWithIndex:(NSInteger)index{
    [curParent leOnBannerSelectedWithIndex:index];
    //    LELog(@"触发Banner点击事件，子类需要重写leOnBannerSelectedWithIndex方法。当前点击了第%@张Banner",[NSNumber numberWithInteger:index]);
}
-(void) leOnTableViewCellSelectedWithInfo:(NSDictionary *)info{
    [curParent leOnTableViewCellSelectedWithInfo:info];
    //    LELog(@"参数tableViewDelegate=nil, 调用父类leOnTableViewCellSelectedWithInfo。%@",info);
}
//数据请求
-(void) leOnRefreshData{
    [curParent leOnRefreshData];
    //    LELog(@"触发下拉刷新，子类需要重写leOnRefreshData方法，待获取到数据后需要执行leOnRefreshedWithData方法");
}
-(void) leOnLoadMore{
    [curParent leOnLoadMore];
    //    LELog(@"上拉获取更多，子类需要重写leOnLoadMore方法，待获取到数据后需要执行leOnLoadMoreLogic");
}
//高度变动通知
-(void) leOnFrameResizedWithHeight:(int)height{
    [bannerContainer setFrame:CGRectMake(0, 0, self.leCurrentFrameWidth, height)];
    [tableViewContainer setFrame:CGRectMake(0, bannerContainer.bounds.size.height, self.leCurrentFrameWidth, self.leCurrentFrameHight-height-curTabbarHeight)];
    [curTableView leSetFrame:tableViewContainer.bounds];
}
//Banner数据
-(void) leOnSetBannerData:(NSArray *) bannerData SubviewData:(NSDictionary *) subviewData{
    if(curBannerStyle==BannerStayAtTheTop){
        if(bannerContainer){
            [bannerContainer leSetBannerData:bannerData SubviewData:subviewData];
        }
    }else{
        if(curTableView){
            [curTableView leSetBannerData:bannerData SubviewData:subviewData];
        }
    }
}
//数据
-(void) leOnRefreshedWithData:(NSMutableArray *) data{
    if(curTableView){
        [curTableView leOnRefreshedWithData:data];
    }
}
-(void) leOnLoadMoreLogic:(NSMutableArray *) data{
    if(curTableView){
        [curTableView leOnLoadedMoreWithData:data];
    }
}
-(id) initWithViewController:(LEBaseViewController *)vc CellClassName:(NSString *) cellClassName EmptyCellClassName:(NSString *) emptyCellClassName BannerStyle:(LEBannerStyle) bannerStyle BannerImageViewClassName:(NSString *) bannerImageViewClassName BannerSubviewClassName:(NSString *) bannerSubviewClassName TabbarHeight:(int) tabbarHeight{
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
-(id) initWithCellClassName:(NSString *) cellClassName EmptyCellClassName:(NSString *) emptyCellClassName BannerStyle:(LEBannerStyle) bannerStyle BannerImageViewClassName:(NSString *) bannerImageViewClassName BannerSubviewClassName:(NSString *) bannerSubviewClassName TabbarHeight:(int) tabbarHeight{
    self=[super init];
    page=[[LETableViewPageWithBannerPage alloc] initWithViewController:self CellClassName:cellClassName EmptyCellClassName:emptyCellClassName BannerStyle:bannerStyle BannerImageViewClassName:bannerImageViewClassName BannerSubviewClassName:bannerSubviewClassName TabbarHeight:tabbarHeight];
    [page onSetParent:self];
    [self leExtraInits];
    return self;
}
-(void) leOnSetBannerData:(NSArray *) bannerData SubviewData:(NSDictionary *) subviewData{
    [page leOnSetBannerData:bannerData SubviewData:subviewData];
}
-(void) leOnBannerSelectedWithIndex:(NSInteger)index{
} 
-(void) leOnRefreshData{
}
-(void) leOnLoadMore{
}
-(void) leOnRefreshedWithData:(NSMutableArray *) data{
    [page leOnRefreshedWithData:data];
}
-(void) leOnLoadMoreLogic:(NSMutableArray *) data{
    [page leOnLoadMoreLogic:data];
}
-(void) leSetTopRefresh:(BOOL) top BottomRefresh:(BOOL) bottom{
    [page leSetTopRefresh:top BottomRefresh:bottom];
}
-(void) leOnTableViewCellSelectedWithInfo:(NSDictionary *)info{
    LELogObject(info);
}
-(void) leExtraInits{}
@end
