//
//  ImagePicker.m
//  Letou
//
//  Created by emerson larry on 16/2/26.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import "LEImageCellGroupsWithPicker.h" 


@interface LEImagePickerPreviewPage : LEBaseView<UIScrollViewDelegate>
@property (nonatomic) NSMutableArray *curCells;
-(void) setPage:(NSInteger) index;
@end
@implementation LEImagePickerPreviewPage{
    UIScrollView *curScrollview;
    UIPageControl *curPageControl;
    int width;
    int height;
    NSMutableArray *arrayPhotos;
    NSInteger curIndex;
}
-(void) setExtraViewInits{
    arrayPhotos=[[NSMutableArray alloc] init];
    width=self.curFrameWidth;
    height=self.curFrameHight;
    curScrollview=[[UIScrollView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self.viewContainer EdgeInsects:UIEdgeInsetsZero]];
    
    [curScrollview setPagingEnabled:YES];
    [curScrollview setDelegate:self];
    [curScrollview setShowsHorizontalScrollIndicator:NO];
    [curScrollview setShowsVerticalScrollIndicator:NO];
    [curScrollview setBackgroundColor:[LEUIFramework sharedInstance].colorNavigationBar];
    
    curPageControl=[[UIPageControl alloc] init];
    [self.viewContainer addSubview:curPageControl];
    [curPageControl setFrame:CGRectMake(width/2-curPageControl.bounds.size.width/2, height-LayoutSideSpace27, curPageControl.bounds.size.width, curPageControl.bounds.size.height)];
    [curPageControl setHidesForSinglePage:YES];
    
}

-(void) setCurCells:(NSMutableArray *)curCells{
    _curCells=curCells;
    [self refreshPage];
}
-(void) refreshPage{
    NSInteger count=self.curCells.count-1;
    [curScrollview setContentSize:CGSizeMake(width*count, height)];
    [curPageControl setNumberOfPages:count];
    for (NSInteger i=0; i<count; i++) {
        UIImageView *view=[[UIImageView alloc] initWithFrame:CGRectMake(width*i, 0, width, height)];
        LEImagePickerCell *cell=[self.curCells objectAtIndex:i];
        [view setImage:cell.image];
        [view setContentMode:UIViewContentModeScaleAspectFit];
        [curScrollview addSubview:view];
        [arrayPhotos addObject:view];
    }
}
-(void) setPage:(NSInteger) index{
    curIndex=index;
    [curScrollview scrollRectToVisible:CGRectMake(width*index, 0, width, height) animated:YES];
    [curPageControl setCurrentPage:index];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    curIndex = scrollView.contentOffset.x/width;
    curPageControl.currentPage = curIndex;
}

-(void) onDelete{
    UIView *view=[arrayPhotos objectAtIndex:curIndex];
    [view setHidden:YES];
    [view removeFromSuperview];
    [arrayPhotos removeObjectAtIndex:curIndex];
    LEImagePickerCell *cell=[self.curCells objectAtIndex:curIndex];
    [cell removeFromSuperview];
    [self.curCells removeObjectAtIndex:curIndex];
    //
    [curScrollview setContentSize:CGSizeMake(width*arrayPhotos.count, height)];
    [curPageControl setNumberOfPages:arrayPhotos.count];
    for (int i=0; i<arrayPhotos.count; i++) {
        UIImageView *view=[arrayPhotos objectAtIndex:i];
        [view setFrame:CGRectMake(width*i, 0, width, height)];
        LEImagePickerCell *cell=[self.curCells objectAtIndex:i];
        [view setImage:cell.image];
    }
    //
    if(curIndex<self.curCells.count-1){
        [self setPage:curIndex];
    }else if(curIndex-1>=0){
        [self setPage:curIndex-1];
    }else{
        [self.curViewController.navigationController popViewControllerAnimated:YES];
    }
}
@end

@protocol LEImagePickerPreviewDelegate <NSObject>

-(void) onDonePickingImagesWith:(NSMutableArray *) array;

@end
@interface LEImagePickerPreview : LEBaseViewController
@property (nonatomic) id<LEImagePickerPreviewDelegate> delegate;
@end
@implementation LEImagePickerPreview{
    LEImagePickerPreviewPage *page;
    BOOL isBarHide;
    UIImage *curDeleteIcon;
}
-(id) initWithImagePickerCells:(NSMutableArray *) cells Index:(NSInteger) index DeleteIcon:(UIImage *) delete{
    curDeleteIcon=delete;
    self=[super init];
    page=[[LEImagePickerPreviewPage alloc] initWithViewController:self];
    [page setCurCells:cells];
    [page setPage:index];
    return self;
}
-(void) viewDidLoad{
    [super viewDidLoad];
    isBarHide=self.navigationController.navigationBarHidden;
    [self.navigationController setNavigationBarHidden:NO];
    [self.view addSubview:page];
    [self setLeftBarButtonAsBackWith:IMG_ArrowLeft];
    [self.navigationItem setTitle:@"图片编辑"];
    if(curDeleteIcon){
        [self setRightBarButtonWithImage:curDeleteIcon SEL:@selector(onRight)];
    }
}

-(void) onRight{
    [page onDelete];
}
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:isBarHide animated:YES];
    if(self.delegate){
        [self.delegate onDonePickingImagesWith:page.curCells];
    }
} 
@end

@protocol LEImagePickerCellDelegate <NSObject>
-(void) onImagePickerCellClickedWith:(LEImagePickerCell *) cell;
@end
@interface LEImagePickerCell ()
@end
@implementation LEImagePickerCell{
    
    UIButton *tapButton;
    NSArray *imageDataSource;
    int curIndex;
    id<LEImagePickerCellDelegate> curDelegate;
}
-(id) initWithFrame:(CGRect)frame Delegate:(id<LEImagePickerCellDelegate>) delegate{
    curDelegate=delegate;
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
    if(curDelegate&&[curDelegate respondsToSelector:@selector(onImagePickerCellClickedWith:)]){
        [curDelegate onImagePickerCellClickedWith:self];
    }
}
@end


@interface LEImageCellGroupsWithPicker () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,LEImagePickerPreviewDelegate,LEMultiImagePickerDelegate,LEImagePickerCellDelegate>

@end
@implementation LEImageCellGroupsWithPicker{
    int cellSpace;
    int cellCols;
    int cellMax;
    UIImagePickerController *imagePickerController;
    UIImagePickerControllerSourceType imagePickerSourceType;
    int cellWidth;
    UIViewController *curViewController;
    UIImage *curAddImage;
    UIImage *curDeleteImage;
}
-(id) initWithAutoLayoutSettings:(LEAutoLayoutSettings *)settings Space:(int) space Cols:(int) cols Max:(int) max AddImage:(UIImage *) add DeleteImage:(UIImage *) delete ViewController:(UIViewController *) viewController{
    curViewController=viewController;
    cellSpace=space;
    cellCols=cols;
    cellMax=max;
    curAddImage=add;
    curDeleteImage=delete;
    self= [super initWithAutoLayoutSettings:settings];
    [self initUI];
    return self;
}


#pragma mark - action sheet delegte
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user setBool:YES forKey:@"gesturepassword"];
    imagePickerSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                imagePickerSourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1: //相机
                imagePickerSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2: //相册
                return;
        }
    } else {
        if (buttonIndex == 0) {
            imagePickerSourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        } else {
            return;
        }
    }
    if(imagePickerSourceType == UIImagePickerControllerSourceTypeCamera){
        // 跳转到相机或相册页面
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = NO;
        imagePickerController.sourceType = imagePickerSourceType;
        [curViewController presentViewController:imagePickerController animated:YES completion:^(void){
        }];
    }else{
        LEMultiImagePicker *vc=[[LEMultiImagePicker alloc] initWithImagePickerDelegate:self];
        [curViewController.navigationController pushViewController:vc animated:YES];
    }
}
-(void) onMultiImagePickedWith:(NSArray *)images{
    for (int i=0; i<images.count; i++) {
        if(self.curCellCache.count<=cellMax){
            UIImage *oriImage = [images objectAtIndex:i];
            LEImagePickerCell *cell=[[LEImagePickerCell alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellWidth) Delegate:self];
            [cell setImage:oriImage];
            [self addSubview:cell];
            [self.curCellCache insertObject:cell atIndex:self.curCellCache.count-1];
        }
    }
    [self reLayoutCells];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user setBool:NO forKey:@"gesturepassword"];
    [picker dismissViewControllerAnimated:YES completion:^(void){
        
    }];
    UIImage *oriImage = [info objectForKeyedSubscript:@"UIImagePickerControllerOriginalImage"];
    LEImagePickerCell *cell=[[LEImagePickerCell alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellWidth)];
    [cell setImage:oriImage];
    [self addSubview:cell];
    [self.curCellCache insertObject:cell atIndex:self.curCellCache.count-1];
    [self reLayoutCells]; 
}
-(void) onImagePickerCellClickedWith:(LEImagePickerCell *)cell{ 
    NSInteger index=[self.curCellCache indexOfObject:cell];
    if(index==self.curCellCache.count-1){
        if(self.curCellCache.count<=cellMax){
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"图库", nil];
            [sheet showInView:self];
        }
    }else{
        LEImagePickerPreview *preview=[[LEImagePickerPreview alloc] initWithImagePickerCells:self.curCellCache Index:index DeleteIcon:curDeleteImage];
        [preview setDelegate:self];
        [curViewController.navigationController pushViewController:preview animated:YES];
    }
}
-(void) onDonePickingImagesWith:(NSMutableArray *)array{
    self.curCellCache =array;
    [self reLayoutCells];
}
-(void) initUI{
    //    if(cellSpace==0){
    //        cellSpace=LayoutSideSpace;
    //    }
    if(cellCols==0){
        cellCols=4;
    }
    cellWidth=(self.bounds.size.width-cellSpace*(cellCols-1))/cellCols;
    self.curCellCache=[[NSMutableArray alloc] init];
    LEImagePickerCell *cellAdd=[[LEImagePickerCell alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellWidth) Delegate:self];
    [cellAdd setImage:curAddImage];
    [self addSubview:cellAdd];
    [self.curCellCache addObject:cellAdd];
    [self reLayoutCells];
}
-(void) reLayoutCells{
    for (NSInteger i=0; i<self.curCellCache.count; i++) {
        LEImagePickerCell *cell=[self.curCellCache objectAtIndex:i];
        [cell setFrame:CGRectMake((i%cellCols)*(cellWidth+cellSpace), i/cellCols*cellWidth+(i/cellCols)*cellSpace, cellWidth, cellWidth)];
    }
    NSInteger row=self.curCellCache.count/cellCols+(self.curCellCache.count%cellCols>0?1:0);
    [self leSetSize:CGSizeMake(self.bounds.size.width, cellWidth*row+(row-1>0?(row-1)*cellSpace:0))];
    [[self.curCellCache objectAtIndex:self.curCellCache.count-1] setHidden:self.curCellCache.count-1==cellMax];
}

@end
