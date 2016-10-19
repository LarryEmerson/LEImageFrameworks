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
-(void) leSetCellType:(LESettingsCellType) type ;
-(LEBaseSettingsItem *) getItemWithType:(LESettingsCellType) type NS_REQUIRES_SUPER;
@end

@interface LEBaseSettingsItem : UIView
@property (nonatomic) LESettingsCellType itemType;
@property (nonatomic) LEBaseSettingsCell *settingsCell;
@property (nonatomic) id curDelegate;
-(id) initWithType:(LESettingsCellType) type SettingsCell:(LEBaseSettingsCell*) cell;
-(void) leSetData:(id)data;
@end

 