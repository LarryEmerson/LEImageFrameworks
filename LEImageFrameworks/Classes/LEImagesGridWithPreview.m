//
//  LEImagesGridWithPreview.m
//  Letou
//
//  Created by emerson larry on 16/2/25.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import "LEImagesGridWithPreview.h" 


@protocol LEImagesGridCellDelegate <NSObject>
-(void) onImagesGridCellClickedWithIndex:(NSInteger) index;
@end
@interface LEImagePreviewCell : UIImageView
@end
@implementation LEImagePreviewCell{
    UIButton *tapButton;
    NSArray *imageDataSource;
    NSInteger curIndex;
    id<LEImagesGridCellDelegate> curDelegate;
    NSString *curURLPrefix;
    BOOL qiniuImageView2;
}
-(id) initWithFrame:(CGRect)frame Delegate:(id<LEImagesGridCellDelegate>) delegate ImageUrlPrefix:(NSString *) prefix QiniuImageView2:(BOOL) qiniu{
    curDelegate=delegate;
    curURLPrefix=prefix;
    qiniuImageView2=qiniu;
    self=[super initWithFrame:frame];
    [self initUI];
    return self;
}

-(void) initUI{
    [self setUserInteractionEnabled:YES];
    tapButton=[LEUIFramework getUIButtonWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self EdgeInsects:UIEdgeInsetsZero] ButtonSettings:[[LEAutoLayoutUIButtonSettings alloc] initWithTitle:nil FontSize:0 Font:nil Image:nil BackgroundImage:nil Color:nil SelectedColor:nil MaxWidth:0 SEL:@selector(onClick) Target:self]];
    [tapButton setBackgroundImage:[ColorMask2 imageStrechedFromSizeOne] forState:UIControlStateHighlighted];
}
-(void) onClick{
    if(curDelegate&&[curDelegate respondsToSelector:@selector(onImagesGridCellClickedWithIndex:)]){
        [curDelegate onImagesGridCellClickedWithIndex:curIndex];
    }
}
-(void) setImageDataSource:(NSArray *) data Index:(NSInteger) index{
    imageDataSource=data;
    curIndex=index;
    NSString *url=[curURLPrefix stringByAppendingString:[imageDataSource objectAtIndex:curIndex]];
    if(qiniuImageView2){
        url=[NSString stringWithFormat:@"%@?imageView2/1/w/%d/h/%d",url, (int)self.bounds.size.width*[LEUIFramework sharedInstance].curScreenScale, (int)self.bounds.size.height*[LEUIFramework sharedInstance].curScreenScale];
    }
    [self setImageWithUrlString:url];
}
@end


@interface LEImagesGrid ()<LEImagesGridCellDelegate>
@end
@implementation LEImagesGrid{
    NSArray *imageDataSource;
    NSMutableArray *cellsCache;
    int cellSpace;
    int cellCols;
    int cellMax;
    UIViewController *curViewController;
    NSString *curURLPrefix;
    BOOL qiniuImageView2;
}
-(void) onImagesGridCellClickedWithIndex:(NSInteger) index{
    LEImagesPreview *preview=[[LEImagesPreview alloc] initWithImageDataSource:imageDataSource CurrentIndex:index ImageUrlPrefix:curURLPrefix QiniuImageView2:qiniuImageView2];
    [curViewController.navigationController pushViewController:preview animated:YES];
}
-(id) initWithAutoLayoutSettings:(LEAutoLayoutSettings *)settings Space:(int) space Cols:(int) cols Max:(int) max ImageUrlPrefix:(NSString *) prefix QiniuImageView2:(BOOL) qiniu ViewController:vc{
    curViewController=vc;
    curURLPrefix=prefix;
    if(!curURLPrefix)curURLPrefix=@"";
    qiniuImageView2=qiniu;
    cellSpace=space;
    cellCols=cols;
    if(cellCols==0){
        cellCols=3;
    }
    cellMax=max;
    self= [super initWithAutoLayoutSettings:settings];
    //    if(cellSpace==0){
    //        cellSpace=LayoutSideSpace;
    //    }
    cellsCache=[[NSMutableArray alloc] init];
    return self;
}
-(void) setImageDataSource:(NSArray *) data{
    imageDataSource=data;
    int width=self.bounds.size.width;
    int cellWidth=(width-cellSpace*(cellCols-1))/cellCols;
    int count=data.count;
    int cacheCount=cellsCache.count;
    int row=count/cellCols+(count%cellCols>0?1:0);
    [self leSetSize:CGSizeMake(width, cellWidth*row+(row-1>0?(row-1)*cellSpace:0))];
    
    int max=MAX(count, cellsCache.count);
    max=MAX(max, cellMax);
    LEImagePreviewCell *cell=nil;
    for (int i=0; i<max; i++) {
        if(i<count){
            if(i<cacheCount){
                cell=[cellsCache objectAtIndex:i];
                [cell setHidden:NO];
            }else{
                cell=[[LEImagePreviewCell alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellWidth) Delegate:self ImageUrlPrefix:curURLPrefix QiniuImageView2:qiniuImageView2];
                [cellsCache addObject:cell];
                [self addSubview:cell];
            }
            [cell setFrame:CGRectMake((i%cellCols)*(cellWidth+cellSpace), i/cellCols*cellWidth+(i/cellCols)*cellSpace, cellWidth, cellWidth)];
            
            [cell setImageDataSource:imageDataSource Index:i];
        }else if(i<cacheCount){
            [[cellsCache objectAtIndex:i] setHidden:YES];
        }
    }
}
@end
