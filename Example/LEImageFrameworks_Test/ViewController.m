//
//  ViewController.m
//  LEImageFrameworks_Test
//
//  Created by emerson larry on 16/7/8.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import "ViewController.h"
#import "LEImageFrameworks.h" 


//DemoTableViewPageWithBannerImageView
@interface DemoTableViewPageWithBannerImageView : LE_HMBannerViewImageView
@end
@implementation DemoTableViewPageWithBannerImageView{
    UILabel *curLabel;
}
-(void) initUI{
    curLabel=[LEUIFramework leGetLabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideBottomRight Offset:CGPointMake(-LEStatusBarHeight/2, -LEStatusBarHeight/2) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:15 Font:nil Width:LESCREEN_WIDTH-LEStatusBarHeight Height:0 Color:LEColorBlack Line:0 Alignment:NSTextAlignmentRight]];
    [curLabel setBackgroundColor:LEColorMask2];
}
-(void) setData:(NSDictionary *)data{
    if([data objectForKey:@"text"]){
        [curLabel leSetText:[data objectForKey:@"text"]];
    }else{
        [curLabel leSetText:@""];
    }
    [super setData:data];
}
@end
//DemoTableViewPageWithBannerSubView
@interface DemoTableViewPageWithBannerSubView : LEBannerSubview
@end
@implementation DemoTableViewPageWithBannerSubView{
    UILabel *curText;
}
-(void) initUI{
    curText=[LEUIFramework leGetLabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideTopLeft Offset:CGPointMake(LENavigationBarHeight/4, LENavigationBarHeight/4) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:15 Font:nil Width:LESCREEN_WIDTH-LENavigationBarHeight/2 Height:0 Color:LEColorBlack Line:0 Alignment:NSTextAlignmentLeft]];
    [self setBackgroundColor:[UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.520]];
    [curText setBackgroundColor:[UIColor colorWithRed:0.503 green:0.780 blue:1.000 alpha:0.510]];
}
-(void) setData:(NSDictionary *) data{
    [curText leSetText:[data objectForKey:@"text"]];
    [self leSetSize:CGSizeMake(LESCREEN_WIDTH, LENavigationBarHeight/2+curText.bounds.size.height)];
    [self notifyHeightChange];
}
@end
//DemoTableViewPageWithBannerCell
@interface DemoTableViewPageWithBannerCell : LEBaseTableViewCell
@end
@implementation DemoTableViewPageWithBannerCell{
    UILabel *curLabel;
}
-(void) initUI{
    self.hasArrow=YES;
    self.hasBottomSplit=YES;
    int space=10;
    curLabel=[LEUIFramework leGetLabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideLeftCenter Offset:CGPointMake(space, 0) CGSize:CGSizeMake(LEDefaultCellHeight, LEDefaultCellHeight-space*2)] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:nil FontSize:LELayoutFontSize14 Font:nil Width:0 Height:0 Color:LEColorBlack Line:1 Alignment:NSTextAlignmentLeft]];
    [curLabel setBackgroundColor:[UIColor greenColor]];
}
-(void) setData:(NSDictionary *)data IndexPath:(NSIndexPath *)path{
    [super setData:data IndexPath:path];
    [curLabel leSetText:[[data objectForKey:KeyOfCellTitle] leStringValue]];
    [curLabel leSetSize:CGSizeMake(LEDefaultCellHeight+[[data objectForKey:KeyOfCellTitle] intValue], curLabel.bounds.size.height)];
}
@end

//DemoTableViewPageWithBanner
@interface DemoTableViewPageWithBanner : LETableViewPageWithBanner
@end
@implementation DemoTableViewPageWithBanner{
    NSString *subviewString;
}
-(void) onExtraInits{
    subviewString=@"这一句可以写一句很长的句子，然后测试一下看看是否自动换行";
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onRefreshData) userInfo:nil repeats:NO];
}
-(void) onBannerSelectedWithIndex:(NSInteger)index{
    LELogObject([NSNumber numberWithInteger:index]);
    subviewString=[NSString stringWithFormat:@"%@ Banner At %d", subviewString, (int)index];
    [self onSetBannerData:nil SubviewData:@{@"text":subviewString}];
}
-(void) onTableViewCellSelectedWithInfo:(NSDictionary *)info{
    LELogObject(info);
    NSIndexPath *path=[info objectForKey:@"cellindex"];
    //    int status=[[info objectForKey:@"cellstatus"] intValue];
    subviewString=[NSString stringWithFormat:@"%@ Cell At %d", subviewString, (int)path.row];
    [self onSetBannerData:nil SubviewData:@{@"text":subviewString}];
}
-(void) onRefreshData{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *bannerDic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superplus/img/logo_white_ee663702.png", @"img_url", nil];
    [bannerDic1  setValue:@"这是第一段测试语句 这是第一段测试语句 这是第一段测试语句" forKey:@"text"];
    [dataArray addObject:bannerDic1];
    NSMutableDictionary *bannerDic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"http://cdn.cocimg.com/assets/images/logo.png?15018", @"img_url", nil];
    [bannerDic2  setValue:@"这是第二段段测试语句" forKey:@"text"];
    [dataArray addObject:bannerDic2];
    //
    [self onFreshDataLogic:[@[@{KeyOfCellTitle: @"50"},@{KeyOfCellTitle:@"100"},@{KeyOfCellTitle:@"150"}]mutableCopy]];
    [self onSetBannerData:dataArray SubviewData:@{@"text":subviewString}];
}
-(void) onLoadMore{
    [self onLoadMoreLogic:[@[@{KeyOfCellTitle:@"40"},@{KeyOfCellTitle:@"100"},@{KeyOfCellTitle:@"200"}]mutableCopy]];
}
@end

@interface TestCell : LEBaseTableViewCell
@end
@implementation TestCell{
    UILabel *label;
}
-(void) initUI{
    label=[LEUIFramework leGetLabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideLeftCenter Offset:CGPointMake(LELayoutSideSpace, 0) CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:@"" FontSize:14 Font:nil Width:0 Height:0 Color:LEColorBlack Line:1 Alignment:NSTextAlignmentLeft]];
}
-(void) setData:(id)data IndexPath:(NSIndexPath *)path{
    [super setData:data IndexPath:path];
    [label leSetText:data];
}
@end

@interface TestCellGroupsWithPicker : LEBaseViewController
@end
@implementation TestCellGroupsWithPicker

-(void) viewDidLoad{
    [super viewDidLoad];
    [self leSetNavigationTitle:@"LEImageCellGroupsWithPicker"];
    LEBaseView *view=[[LEBaseView alloc] initWithViewController:self];
    LEImageCellGroupsWithPicker *picker=[[LEImageCellGroupsWithPicker alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:view.viewContainer Anchor:LEAnchorInsideCenter Offset:CGPointZero CGSize:CGSizeMake(view.curFrameWidth,view.curFrameWidth)] Space:2 Cols:4 Max:9 AddImage:[LEColorBlue leImageStrechedFromSizeOne] DeleteImage:[LEColorTest leImageWithSize:CGSizeMake(20, 40)] ViewController:self];
    [picker setBackgroundColor:LEColorGrayLight];
}
@end

@interface TestGridWithPreview : LEBaseViewController
@end
@implementation TestGridWithPreview

-(void) viewDidLoad{
    [super viewDidLoad];
    [self leSetNavigationTitle:@"LEImagesGridWithPreview"];
    [self leSetLeftBarButtonAsBackWith:LEIMG_ArrowLeft];
    LEBaseView *view=[[LEBaseView alloc] initWithViewController:self];
    LEImagesGrid *grid=[[LEImagesGrid alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:view.viewContainer Anchor:LEAnchorInsideCenter Offset:CGPointZero CGSize:CGSizeMake(view.curFrameWidth, view.curFrameWidth)] Space:10 Cols:3 Max:15 ImageUrlPrefix:nil QiniuImageView2:NO ViewController:self];
    [grid setBackgroundColor:LEColorGrayLight];
    [grid setImageDataSource:@[@"https://www.baidu.com/img/bd_logo1.png",@"http://cdn.cocimg.com/assets/images/logo.png?15018"]];
}
@end

@interface ViewController ()<LETableViewCellSelectionDelegate,LEImageCropperDelegate,LEMultiImagePickerDelegate>

@end

@implementation ViewController{
    UIImageView *curImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setExtendedLayoutIncludesOpaqueBars:NO];
    [self setEdgesForExtendedLayout:UIRectEdgeLeft&UIRectEdgeRight&UIRectEdgeBottom];
    [self leSetNavigationTitle:@"LEImageFrameworks 测试"];
    LEBaseTableView *tb=[[LEBaseTableView alloc] initWithSettings:[[LETableViewSettings alloc] initWithSuperViewContainer:self.view ParentView:self.view TableViewCell:@"TestCell" EmptyTableViewCell:nil GetDataDelegate:nil TableViewCellSelectionDelegate:self]];
    [tb onRefreshedWithData:[@[@"LE_HMBannerView BannerStayAtTheTop", @"LE_HMBannerView BannerScrollWithCells" ,@"LEImageCellGroupsWithPicker",@"LEImagesGridWithPreview",@"LESingleImagePicker",@"LEMultiImagePicker"]mutableCopy]];
    [tb setTopRefresh:NO];
    [tb setBottomRefresh:NO];
    curImage=[LEUIFramework leGetImageViewWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self.view Anchor:LEAnchorInsideBottomCenter Offset:CGPointMake(0, -LENavigationBarHeight-LEStatusBarHeight) CGSize:CGSizeMake(200, 100)] Image:nil];
    [curImage setAnimationDuration:1];
    [curImage setAlpha:0.6];
    [curImage setContentMode:UIViewContentModeCenter];
    [curImage setAnimationRepeatCount:0];
}
-(void) onTableViewCellSelectedWithInfo:(NSDictionary *)info{
    NSIndexPath *index=[info objectForKey:KeyOfCellIndexPath];
    switch (index.row) {
        case 0:
        {
            DemoTableViewPageWithBanner *vc=[[DemoTableViewPageWithBanner alloc] initWithCellClassName:@"DemoTableViewPageWithBannerCell" EmptyCellClassName:nil BannerStyle:BannerStayAtTheTop BannerImageViewClassName:@"DemoTableViewPageWithBannerImageView" BannerSubviewClassName:@"DemoTableViewPageWithBannerSubView" TabbarHeight:0];
            [self.navigationController pushViewController:vc animated:YES];
            [vc leSetNavigationTitle:@"测试Banner停靠在最上方的情况"];
        }
            break;
        case 1:
        {
            DemoTableViewPageWithBanner *vc=[[DemoTableViewPageWithBanner alloc] initWithCellClassName:@"DemoTableViewPageWithBannerCell" EmptyCellClassName:nil BannerStyle:BannerScrollWithCells BannerImageViewClassName:@"DemoTableViewPageWithBannerImageView" BannerSubviewClassName:@"DemoTableViewPageWithBannerSubView" TabbarHeight:0];
            [self.navigationController pushViewController:vc animated:YES];
            [vc leSetNavigationTitle:@"测试Banner跟随列表滚动的情况"];
        }
            break;
        case 2:
        {
            TestCellGroupsWithPicker *vc=[[TestCellGroupsWithPicker alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            TestGridWithPreview *vc=[[TestGridWithPreview alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            [LESingleImagePicker onLESingleImagePickerWithSuperView:self.view ViewController:self Title:@"LESingleImagePicker" Aspect:2 Delegate:self];
        }
            break;
        case 5:
        {
            LEMultiImagePicker *vc=[[LEMultiImagePicker alloc] initWithImagePickerDelegate:self];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
-(void) onDoneCroppedWithImage:(UIImage *)image{
    [self onShowImages:@[image]];
}
-(void) onMultiImagePickedWith:(NSArray *)images{
    [self onShowImages:images];
}
-(void) onShowImages:(NSArray *) array{
    [curImage setAnimationImages:array];
    [curImage startAnimating];
}
@end
