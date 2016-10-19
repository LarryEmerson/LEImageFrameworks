//
//  LEBaseConfigurableTableView.h
//  Pods
//
//  Created by emerson larry on 2016/10/19.
//
// 
#import "LEFrameworks.h" 
#import "LEImageCache.h"
/**
 *@brief L:left, R:right, M:middle, F:fullscreen, icon:图标, title:标题(黑), Textfield:输入文本(灰), Arrow:箭头， SectionSolid:实心分割(灰), Subtitle:副标题(灰)
 */
typedef enum {
    L_Icon_Title_R_Arrow=0,
    L_Title_R_Subtitle,
    L_Title_R_Icon_Arrow,
    L_Title_R_Arrow,
    M_Submit,
    F_SectionSolid,
    L_Title_R_Switch,
    L_Title_R_Subtitle_Arrow
}LESettingsCellType;

#define LEKeyOfSettingsCellFunction @"function"
#define LEKeyOfSettingsCellType @"itemtype"
#define LEKeyOfSettingsCellTitle @"title"
#define LEKeyOfSettingsCellImageURL @"image"
#define LEKeyOfSettingsCellImage @"image"
#define LEKeyOfSettingsCellLocalImage @"localimage"
#define LEKeyOfSettingsCellSubmit @"submit"
#define LEKeyOfSettingsCellSwitch @"switch"
#define LEKeyOfSettingsCellSubtitle @"subtitle"
#define LEKeyOfSettingsCellColor @"color"
#define LEKeyOfSettingsCellHeight @"height"
#define LEKeyOfSettingsCellImageCorner @"corner"
#define LEKeyOfSettingsCellLinespace @"linespace"
#define LEKeyOfSettingsCellIconPlaceHolder @"imageholder"

#define LEKeyOfSettingsCellRightEdgeKey @"rightedge"

#define LEKeyOfSettingsCellRightEdge    (LELayoutSideSpace+LELayoutSideSpace20)
#define LEKeyOfSettingsCellTitleFontsize LELayoutFontSize16
#define LEKeyOfSettingsCellSubTitleFontsize LELayoutFontSize13
#define LEKeyOfSettingsCellSubTitleColor LEColorTextGray
#define LEKeyOfSettingsCellSideSpace LELayoutSideSpace
#define LEKeyOfSettingsSubtitleWidth (LESCREEN_WIDTH-LEKeyOfSettingsCellRightEdge-6*LEKeyOfSettingsCellTitleFontsize)
#define LEKeyOfSettingsSubtitleOffsetY ((LEDefaultCellHeight-LEKeyOfSettingsCellSubTitleFontsize)*0.5)

@interface LEBaseConfigurableTableView : LEBaseTableViewV2
-(id) initWithSuperView:(UIView *) superView EmptyTableViewCell:(NSString *)emptyCell TableViewCellSelectionDelegate:(id<LETableViewCellSelectionDelegate>) selectionDelegate;
@end

@interface LEBaseConfigurableTableViewWithRefresh : LEBaseTableViewV2WithRefresh
-(id) initWithSuperView:(UIView *) superView EmptyTableViewCell:(NSString *)emptyCell GetDataDelegate:(id<LETableViewDataSourceDelegate>) dataDelegate TableViewCellSelectionDelegate:(id<LETableViewCellSelectionDelegate>) selectionDelegate;
@end

@interface LEBaseConfigurableTableViewCellItem : UIView
@property (nonatomic,readonly) LESettingsCellType leItemType; 
-(id) initWithSuperView:(UIView *) view Type:(LESettingsCellType) type Delegate:(id<LETableViewCellSelectionDelegate>) delegate Index:(NSIndexPath *) index;
-(void) leSetData:(id)data NS_REQUIRES_SUPER;
@end

@interface LEBaseConfigurableTableViewCell : LEBaseTableViewDisplayCell
@property (nonatomic,readonly) LESettingsCellType leCellType;
-(void) leSetType:(LESettingsCellType) type;
@end