//
//  LEBaseConfigurableTableView.h
//  Pods
//
//  Created by emerson larry on 2016/10/19.
//
//  
#import <LEFrameworks/LEFrameworks.h>
#import "LEImageCache.h"
/**
 可配置列表的管理器，目前用于定义右箭头和注册自定义的Item
 */
@interface LEConfigurableCellManager : NSObject
LESingleton_interface(LEConfigurableCellManager)
/**
 用于注册自定义的CellItem
 */
-(void) leRegisterItemWithClassName:(NSString *) className Type:(int) type;
/**
 用于自定义右箭头图片
 */
-(void) leSetArrowWith:(UIImage *) arrow;
@end

typedef enum {
    /** 可设定title:Title(标题)、TitleFontsize(标题字号)、Color(标题颜色) */
    L_Title_R_Arrow=0,
    /** 可设定title:Title(标题)、TitleFontsize(标题字号)、Color(标题颜色)，switch:Switch(是否打开) */
    L_Title_R_Switch,
    /** 可设定title:Title(标题)、TitleFontsize(标题字号)、Color(标题颜色)，subtitle:Subtitle(副标题)、SubTitleFontsize(副标题字号)、SubTitleColor(副标题颜色)、Linespace(副标题行间距)、RightEdgeKey(副标题右间距) */
    L_Title_R_Subtitle,
    /** 可设定title:Title(标题)、TitleFontsize(标题字号)、Color(标题颜色)，subtitle:Subtitle(副标题)、SubTitleFontsize(副标题字号)、SubTitleColor(副标题颜色) */
    L_Title_R_Subtitle_Arrow,
    /** 可设定icon：LocalImage(本地)、ImageURL(网络)、IconPlaceHolder(占位图)、ImageCorner(图片圆角)，title:Title(标题)、TitleFontsize(标题字号)、Color(标题颜色) */
    L_Icon_Title_R_Arrow,
    L_Title_R_Icon_Arrow,
    /** 可设定LocalImage(按钮背景图片)、TitleFontsize(按钮文字字号)、Color(按钮文字颜色)、ImageCorner(按钮圆角) */
    M_Submit,
    /** 可设定Color(分割线颜色)、Height(分割线高度) */
    F_SectionSolid,
}
/** 模板样式-L:left, R:right, M:middle, F:fullscreenwidth, icon:图标, title:标题(黑), Arrow:箭头, SectionSolid:实心分割(灰), Subtitle:副标题(灰)
 */
LEConfigurableCellType;

/**
 用于指定Cell对应的模板样式（LEConfigurableCellType）
 */
#define LEConfigurableCellKey_Type @"itemtype"

/**
 用于给Cell赋值点击后调用的方法名称（NSString）
 */
#define LEConfigurableCellKey_Function @"function"

/**
 用于给M_Submit赋值按钮文字以及其他Cell赋值Title（NSString），适用：L_Icon_Title_R_Arrow、L_Title_R_Subtitle、L_Title_R_Icon_Arrow、L_Title_R_Arrow、L_Title_R_Switch、L_Title_R_Subtitle_Arrow
 */
#define LEConfigurableCellKey_Title @"title"

/**
 用于给M_Submit赋值按钮文字字号以及其他Cell赋值Title的字号（NSNumber），适用：L_Icon_Title_R_Arrow、L_Title_R_Subtitle、L_Title_R_Icon_Arrow、L_Title_R_Arrow、L_Title_R_Switch、L_Title_R_Subtitle_Arrow
 */
#define LEConfigurableCellKey_TitleFontsize @"titlefontsize"

/**
 用于给Cell赋值网络图片的地址（NSString），适用：L_Icon_Title_R_Arrow、L_Title_R_Icon_Arrow
 */
#define LEConfigurableCellKey_ImageURL @"imageurl"

/**
 用于给M_Submit复制按钮背景图片以及其他Cell赋值icon为本地图片（UIImage），适用：L_Icon_Title_R_Arrow、L_Title_R_Icon_Arrow
 */
#define LEConfigurableCellKey_LocalImage @"localimage"

/**
 用于给Cell赋值图片的占位图（UIImage），适用：L_Icon_Title_R_Arrow、L_Title_R_Icon_Arrow
 */
#define LEConfigurableCellKey_IconPlaceHolder @"imageholder"

/**
 用于给Cell赋值Subtitle的文字（NSString），适用：L_Title_R_Subtitle、L_Title_R_Subtitle_Arrow
 */
#define LEConfigurableCellKey_Subtitle @"subtitle"

/**
 用于给Cell赋值Subtitle的字号（NSNumber），适用：L_Title_R_Subtitle、L_Title_R_Subtitle_Arrow
 */
#define LEConfigurableCellKey_SubTitleFontsize @"subtitlefontsize"

/**
 用于给Cell赋值Subtitle的文字颜色（UIColor），适用：L_Title_R_Subtitle、L_Title_R_Subtitle_Arrow
 */
#define LEConfigurableCellKey_SubTitleColor @"subtitlecolor"

/**
 用于给F_SectionSolid指定背景色、M_Submit指定按钮文字正常状态的颜色、用于给Title指定文字颜色（UIColor）
 */
#define LEConfigurableCellKey_Color @"color"

/**
 用于给Cell的Image进行圆角处理（NSNumber-int），适用：L_Icon_Title_R_Arrow、L_Title_R_Icon_Arrow
 */
#define LEConfigurableCellKey_ImageCorner @"corner"


#pragma mark 仅适用
/**
 用于给Cell添加switch控件（@YES @NO），仅适用于：L_Title_R_Switch
 */
#define LEConfigurableCellKey_Switch @"switch"
/**
 用于给Cell的Subtitle指定行间距（NSNumber-int），仅适用于：LEItem_L_Title_R_Subtitle
 */
#define LEConfigurableCellKey_Linespace @"linespace"

/**
 用于给Cell的Subtitle指定右侧间距（NSNumber-int），仅适用于：LEItem_L_Title_R_Subtitle
 */
#define LEConfigurableCellKey_RightEdgeKey @"rightedge"

/**
 仅用于给F_SectionSolid定义高度，第一版因为CollectionView机制是用于cell的height
 */
#define LEConfigurableCellKey_Height @"height"

/**
 无下拉刷新版
 */
@interface LEBaseConfigurableTableView : LEBaseTableViewV2
-(id) initWithSuperView:(UIView *) superView EmptyTableViewCell:(NSString *)emptyCell TableViewCellSelectionDelegate:(id<LETableViewCellSelectionDelegate>) selectionDelegate;
@end
/**
 下拉刷新版
 */
@interface LEBaseConfigurableTableViewWithRefresh : LEBaseTableViewV2WithRefresh
-(id) initWithSuperView:(UIView *) superView EmptyTableViewCell:(NSString *)emptyCell GetDataDelegate:(id<LETableViewDataSourceDelegate>) dataDelegate TableViewCellSelectionDelegate:(id<LETableViewCellSelectionDelegate>) selectionDelegate;
@end

@interface LEBaseConfigurableTableViewCellItem : UIView
@property (nonatomic,readonly) LEConfigurableCellType leItemType; 
-(id) initWithSuperView:(UIView *) view Type:(LEConfigurableCellType) type Delegate:(id<LETableViewCellSelectionDelegate>) delegate Index:(NSIndexPath *) index;
/**
 自定义子类时，重写此方法处理数据，刷新UI
 */
-(void) leSetData:(id)data NS_REQUIRES_SUPER;
/**
 自定义子类时，用于leSetData处理data结束后，调整item的高度，适用于多行内容不定高的情况
 */
-(void) leSetHeight:(float) height;
/**
 自定义子类时，设置是否启用点击事件
 */
-(void) leEnableTap:(BOOL) enable;
/**
 自定义子类时，用于触发点击事件（添加checkbox，其他按钮）
 */
-(void) onTapped;
@end

@interface LEBaseConfigurableTableViewCell : LEBaseTableViewDisplayCell
@property (nonatomic,readonly) LEConfigurableCellType leCellType;
-(LEBaseConfigurableTableViewCellItem *) getItemWithType:(LEConfigurableCellType) type NS_REQUIRES_SUPER;
-(void) leSetType:(LEConfigurableCellType) type;
@end

//





