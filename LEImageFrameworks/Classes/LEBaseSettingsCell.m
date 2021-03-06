//
//  LEBaseSettingsCell.m
//  guguxinge
//
//  Created by emerson larry on 16/7/29.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import "LEBaseSettingsCell.h"
@protocol LEBaseSettingsCellTapDelegate <NSObject>
-(void) onTapEvent;
-(void) onTapEventWith:(id) event;
@end

@implementation LEBaseSettingsItem
-(id) initWithType:(LEConfigurableCellType) type SettingsCell:(LEBaseSettingsCell*) cell{
    self=[super initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:cell EdgeInsects:UIEdgeInsetsZero]];
    self.itemType=type;
    self.settingsCell=cell;
    self.curDelegate=cell;
    [self leAdditionalInits];
    [self leAddBottomSplitWithColor:LEColorSplit Offset:CGPointZero Width:LESCREEN_WIDTH];
    return self;
}
-(void) leSetData:(id)data {}
-(void) dealloc{
    self.curDelegate=nil;
}
-(void) onTapped{
    if(self.curDelegate&&[self.curDelegate respondsToSelector:@selector(onTapEvent)]){
        [self.curDelegate onTapEvent];
    }
}
@end
@interface Item_L_Title_R_Arrow : LEBaseSettingsItem
@end
@implementation Item_L_Title_R_Arrow{
    UILabel *label;
    UIImageView *arrow;
}
-(void)leAdditionalInits{
    label=[UILabel new].leSuperView(self).leAnchor(LEAnchorInsideLeftCenter).leOffset(CGPointMake(LELayoutSideSpace, 0)).leAutoLayout.leType;
    arrow=[UIImageView new].leSuperView(self).leAnchor(LEAnchorInsideRightCenter).leOffset(CGPointMake(-LELayoutSideSpace, 0)).leSize(LESquareSize((LELayoutSideSpace+LELayoutSideSpace20)-LELayoutSideSpace)).leAutoLayout.leType;
    [arrow setContentMode:UIViewContentModeCenter]; 
    [arrow leSetImage:[UIImage imageNamed:@"common_arrow_gray"]];
    [label.leWidth(LESCREEN_WIDTH-LELayoutSideSpace-(LELayoutSideSpace+LELayoutSideSpace20)).leFont(LEFont(LELayoutFontSize16)).leLine(1) leLabelLayout];
}
-(void) leSetData:(id) data{
    [label leSetText:[data objectForKey:LEKeyOfSettingsCellTitle]];
}
@end
@interface Item_L_Title_R_Switch : LEBaseSettingsItem
@end
@implementation Item_L_Title_R_Switch{
    UISwitch *curSwitch;
    UILabel *label;
}
-(void)leAdditionalInits{
    label=[UILabel new].leSuperView(self).leAnchor(LEAnchorInsideLeftCenter).leOffset(CGPointMake(LELayoutSideSpace, 0)).leAutoLayout.leType;
    curSwitch=[UISwitch new];
    [curSwitch.leSuperView(self).leAnchor(LEAnchorInsideRightCenter).leOffset(CGPointMake(-LELayoutSideSpace, 0)).leSize(curSwitch.bounds.size) leExecAutoLayout];
    [label.leWidth(LESCREEN_WIDTH-LELayoutSideSpace*3-curSwitch.bounds.size.width).leFont(LEFont(LELayoutFontSize16)).leLine(1) leLabelLayout];
    [curSwitch addTarget:self action:@selector(onTapped) forControlEvents:UIControlEventTouchUpInside];
}
-(void) leSetData:(id) data{
    [label leSetText:[data objectForKey:LEKeyOfSettingsCellTitle]];
    [curSwitch setOn:[[data objectForKey:LEKeyOfSettingsCellSwitch] boolValue]];
}
@end
//
@interface Item_L_Title_R_Subtitle : LEBaseSettingsItem
@end
@implementation Item_L_Title_R_Subtitle{
    UILabel *label;
    UILabel *labelSub;
}
-(void)leAdditionalInits{
    UIView *anchor=[UIView new].leSuperView(self).leSize(CGSizeMake(1, LEDefaultCellHeight)).leAutoLayout;
    label=[UILabel new].leSuperView(self).leRelativeView(anchor).leAnchor(LEAnchorOutsideRightCenter).leOffset(CGPointMake(LELayoutSideSpace-1, 0)).leAutoLayout.leType;
    [label.leFont(LEFont(LELayoutFontSize16)).leLine(1).leText(@" ") leLabelLayout];
    labelSub=[UILabel new].leSuperView(self).leAnchor(LEAnchorInsideTopRight).leOffset(CGPointMake(-LELayoutSideSpace, ((LEDefaultCellHeight-LELayoutFontSize13)*0.5))).leAutoLayout.leType;
    [labelSub.leFont(LEFont(LELayoutFontSize13)).leColor(LEColorTextGray).leAlignment(NSTextAlignmentRight).leLine(0).leWidth((LESCREEN_WIDTH-LELayoutSideSpace+LELayoutSideSpace20-6*LELayoutFontSize16)) leLabelLayout];
}
-(void) leSetData:(id) data{
    [label leSetText:[data objectForKey:LEKeyOfSettingsCellTitle]];
    NSString *edge=[data objectForKey:LEKeyOfSettingsCellRightEdgeKey];
    if(edge){
        [labelSub leSetOffset:CGPointMake(-abs([edge intValue]), ((LEDefaultCellHeight-LELayoutFontSize13)*0.5))];
    }
    [labelSub.leText([data objectForKey:LEKeyOfSettingsCellSubtitle]) leLabelLayout];
    if([data objectForKey:LEKeyOfSettingsCellLinespace]){
        [labelSub leSetLineSpace:[[data objectForKey:LEKeyOfSettingsCellLinespace] intValue]];
    }
    CGSize size=CGSizeMake(self.bounds.size.width, MAX(((LEDefaultCellHeight-LELayoutFontSize13)*0.5)+(int)labelSub.bounds.size.height+((LEDefaultCellHeight-LELayoutFontSize13)*0.5), LEDefaultCellHeight));
    [self leSetSize:size];
}
@end
@interface Item_L_Title_R_Subtitle_Arrow : LEBaseSettingsItem
@end
@implementation Item_L_Title_R_Subtitle_Arrow{
    UILabel *label;
    UILabel *subtitle;
    UIImageView *arrow;
}
-(void) leAdditionalInits{
    label=[UILabel new].leSuperView(self).leAnchor(LEAnchorInsideLeftCenter).leOffset(CGPointMake(LELayoutSideSpace, 0)).leAutoLayout.leType;
    [label.leFont(LEFont(LELayoutFontSize16)).leLine(1) leLabelLayout];
    arrow= [UIImageView new].leSuperView(self).leAnchor(LEAnchorInsideRightCenter).leOffset(CGPointMake(-LELayoutSideSpace, 0)).leSize(LESquareSize((LELayoutSideSpace+LELayoutSideSpace20)-LELayoutSideSpace)).leAutoLayout.leType;
    [arrow setContentMode:UIViewContentModeCenter];
    [arrow leSetImage:[UIImage imageNamed:@"common_arrow_gray"]];
    subtitle=[UILabel new].leSuperView(self).leAnchor(LEAnchorInsideRightCenter).leOffset(CGPointMake(-(LELayoutSideSpace+LELayoutSideSpace20), 0)).leAutoLayout.leType;
    [subtitle.leFont(LEFont(LELayoutFontSize13)).leColor(LEColorTextGray).leLine(1).leAlignment(NSTextAlignmentRight) leLabelLayout];
}
-(void) leSetData:(id) data{
    [label leSetText:[data objectForKey:LEKeyOfSettingsCellTitle]];
    [subtitle.leWidth(LESCREEN_WIDTH-(LELayoutSideSpace+LELayoutSideSpace20)-LELayoutSideSpace-label.bounds.size.width-LELayoutSideSpace).leText([data objectForKey:LEKeyOfSettingsCellSubtitle]) leLabelLayout];
    //    if([data objectForKey:LEKeyOfSettingsCellLinespace]){
    //        [subtitle leSetLineSpace:[[data objectForKey:LEKeyOfSettingsCellLinespace] intValue]];
    //    }
    //    [self leSetSize:CGSizeMake(self.bounds.size.width, MAX(LELayoutSideSpace*2+subtitle.bounds.size.height, LEDefaultCellHeight))];
}
@end
//
@interface Item_L_Icon_Title_R_Arrow : LEBaseSettingsItem
@end
@implementation Item_L_Icon_Title_R_Arrow{
    UIImageView *icon;
    UILabel *label;
}
-(void) leAdditionalInits{
    icon=[UIImageView new].leSuperView(self).leAnchor(LEAnchorInsideLeftCenter).leOffset(CGPointMake(LELayoutSideSpace, 0)).leSize(CGSizeMake(LELayoutAvatarSize, LELayoutAvatarSize)).leRoundCorner(LELayoutAvatarSize/2).leAutoLayout.leType;
    label=[UILabel new].leSuperView(self).leRelativeView(icon).leAnchor(LEAnchorOutsideRightCenter).leOffset(CGPointMake(LELayoutSideSpace, 0)).leAutoLayout.leType;
    UIImageView *arrow= [UIImageView new].leSuperView(self).leAnchor(LEAnchorInsideRightCenter).leOffset(CGPointMake(-LELayoutSideSpace, 0)).leSize(LESquareSize((LELayoutSideSpace+LELayoutSideSpace20)-LELayoutSideSpace)).leAutoLayout.leType;
    [arrow leSetImage:[UIImage imageNamed:@"common_arrow_gray"]];
    [arrow setContentMode:UIViewContentModeCenter];
    [label.leFont(LEFont(LELayoutFontSize16)).leLine(1).leWidth((LESCREEN_WIDTH-LELayoutSideSpace+LELayoutSideSpace20-6*LELayoutFontSize16)) leLabelLayout];
}
-(void) leSetData:(id) data{
    [icon leSetImageWithUrlString:[data objectForKey:LEKeyOfSettingsCellImage]];
    [label leSetText:[data objectForKey:LEKeyOfSettingsCellTitle]];
}
@end
@interface Item_L_Title_R_Icon_Arrow : LEBaseSettingsItem
@end
@implementation Item_L_Title_R_Icon_Arrow{
    UIImageView *icon;
    UILabel *label;
}
-(void) leAdditionalInits{
    label=[UILabel new].leSuperView(self).leAnchor(LEAnchorInsideLeftCenter).leOffset(CGPointMake(LELayoutSideSpace, 0)).leAutoLayout.leType;
    UIImageView *arrow= [UIImageView new].leSuperView(self).leAnchor(LEAnchorInsideRightCenter).leOffset(CGPointMake(-LELayoutSideSpace, 0)).leSize(LESquareSize((LELayoutSideSpace+LELayoutSideSpace20)-LELayoutSideSpace)).leAutoLayout.leType;
    [arrow leSetImage:[UIImage imageNamed:@"common_arrow_gray"]];
    [arrow setContentMode:UIViewContentModeCenter];
    icon=[UIImageView new].leSuperView(self).leAnchor(LEAnchorInsideRightCenter).leOffset(CGPointMake(-(LELayoutSideSpace+LELayoutSideSpace20), 0)).leSize(CGSizeMake(LELayoutAvatarSize, LELayoutAvatarSize)).leRoundCorner(LELayoutAvatarSize/2).leAutoLayout.leType;
    [label.leFont(LEFont(LELayoutFontSize16)).leLine(1).leWidth(LESCREEN_WIDTH-LELayoutSideSpace-(LELayoutSideSpace+LELayoutSideSpace20)-LELayoutAvatarSize) leLabelLayout];
}
-(void) leSetData:(id) data{
    UIImage *placeHolder=[data objectForKey:LEKeyOfSettingsCellIconPlaceHolder];
    if(placeHolder){
        [icon leSetPlaceholder:placeHolder];
    }
    [icon leSetCornerRadius:[[data objectForKey:LEKeyOfSettingsCellImageCorner] intValue]];
    [icon leSetImageForQiniuWithUrlString:[data objectForKey:LEKeyOfSettingsCellImage] Width:LELayoutAvatarSize Height:LELayoutAvatarSize];
    [label leSetText:[data objectForKey:LEKeyOfSettingsCellTitle]];
}

@end
@interface Item_M_Submit : LEBaseSettingsItem
@end
@implementation Item_M_Submit{
    UIButton *btn;
}
-(void) leAdditionalInits{
    [self setBackgroundColor:[LEUIFramework sharedInstance].leColorViewContainer];
    btn=[UIButton new].leSuperView(self).leEdgeInsects(UIEdgeInsetsMake(LELayoutSideSpace, LELayoutSideSpace, LELayoutSideSpace, LELayoutSideSpace)).leAutoLayout.leType;
    [btn.leButtonSize(btn.bounds.size).leFont(LEFont(LELayoutFontSize14)).leTapEvent(@selector(onTapped),self) leButtonLayout];
}
-(void) leSetData:(id) data{
    UIImage *img=[data objectForKey:LEKeyOfSettingsCellImage];
    if(img){
        [btn.leBackgroundImage([img leMiddleStrechedImage]) leButtonLayout];
    }
    [btn.leText([data objectForKey:LEKeyOfSettingsCellTitle]) leButtonLayout];
    UIColor *color=[data objectForKey:LEKeyOfSettingsCellColor];
    if(color){
        [btn.leNormalColor(color) leButtonLayout];
    }
} 
@end
@interface Item_F_SectionSolid : LEBaseSettingsItem
@end
@implementation Item_F_SectionSolid
-(void) leSetData:(id) data{
    [self setBackgroundColor:[data objectForKey:LEKeyOfSettingsCellColor]];
}
@end

@implementation LEBaseSettingsCell{
    
    LEConfigurableCellType curType;
    LEBaseSettingsItem *curItem;
}
-(void) leAdditionalInits{
    [self setBackgroundColor:LEColorWhite];
    self.selectedBackgroundView=[LEUIFramework leGetImageViewWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self EdgeInsects:UIEdgeInsetsZero] Image:[LEColorMask leImageStrechedFromSizeOne]];
}
-(void) leSetCellType:(LEConfigurableCellType) type{
    curType=type;
    if(!curItem||curItem.itemType!=type){
        if(curItem){
            [curItem removeFromSuperview];
        }
        curItem=[self getItemWithType:type];
    }
}
-(LEBaseSettingsItem *) getItemWithType:(LEConfigurableCellType) type{
    LEBaseSettingsItem *item=nil;
    switch (type) {
        case L_Title_R_Arrow:
            item=[[Item_L_Title_R_Arrow alloc] initWithType:type SettingsCell:self];
            break;
        case L_Title_R_Switch:
            item=[[Item_L_Title_R_Switch alloc] initWithType:type SettingsCell:self];
            break;
        case L_Title_R_Subtitle:
            item=[[Item_L_Title_R_Subtitle alloc] initWithType:type SettingsCell:self];
            break;
        case L_Icon_Title_R_Arrow:
            item=[[Item_L_Icon_Title_R_Arrow alloc] initWithType:type SettingsCell:self];
            break;
        case L_Title_R_Icon_Arrow:
            item=[[Item_L_Title_R_Icon_Arrow alloc] initWithType:type SettingsCell:self];
            break;
        case L_Title_R_Subtitle_Arrow:
            item=[[Item_L_Title_R_Subtitle_Arrow alloc] initWithType:type SettingsCell:self];
            break;
        case M_Submit:
            item=[[Item_M_Submit alloc] initWithType:type SettingsCell:self];
            break;
        case F_SectionSolid:
            item=[[Item_F_SectionSolid alloc] initWithType:type SettingsCell:self];
            break;
        default:
            break;
    }
    return item;
}
-(void) onTapEvent{
    [self.leCollectionView leSelectCellAtIndex:self.leIndexPath];
}
-(void) leSetData:(id)data IndexPath:(NSIndexPath *)path{
    [super leSetData:data IndexPath:path];
    LEConfigurableCellType type=[[data objectForKey:LEKeyOfSettingsCellType] intValue];
    [self leSetCellType:type];
    [curItem leSetData:data];
    self.selectedBackgroundView=[LEUIFramework leGetImageViewWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self EdgeInsects:UIEdgeInsetsZero] Image:[[data objectForKey:LEKeyOfSettingsCellFunction]?LEColorMask:LEColorClear leImageStrechedFromSizeOne]];
}
@end
