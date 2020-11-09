//
//  LEBaseSettingsCell.h
//  guguxinge
//
//  Created by emerson larry on 16/7/29.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import "LEBaseConfigurableTableView.h"


@class LEBaseSettingsItem;
@interface LEBaseSettingsCell : LEBaseCollectionViewCell
-(void) leSetCellType:(LEConfigurableCellType) type ;
-(LEBaseSettingsItem *) getItemWithType:(LEConfigurableCellType) type NS_REQUIRES_SUPER;
@end

@interface LEBaseSettingsItem : UIView
@property (nonatomic) LEConfigurableCellType itemType;
@property (nonatomic) LEBaseSettingsCell *settingsCell;
@property (nonatomic) id curDelegate;
-(id) initWithType:(LEConfigurableCellType) type SettingsCell:(LEBaseSettingsCell*) cell;
-(void) leSetData:(id)data;
@end


#define LEKeyOfSettingsCellFunction @"function"
#define LEKeyOfSettingsCellType @"itemtype"
#define LEKeyOfSettingsCellTitle @"title"
#define LEKeyOfSettingsCellImage @"image"
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
