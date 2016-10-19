//
//  LEBaseConfigurableTableView.m
//  Pods
//
//  Created by emerson larry on 2016/10/19.
//
//

#import "LEBaseConfigurableTableView.h"


@interface LEBaseConfigurableTableViewCellItem ()
@property (nonatomic,readwrite) LESettingsCellType leItemType;
@property (nonatomic,readwrite) id<LETableViewCellSelectionDelegate> leDelegate;
@property (nonatomic,readwrite) NSIndexPath *leIndex;
@end
@implementation LEBaseConfigurableTableViewCellItem{
    UIButton *tapEvent;
}
-(id) initWithSuperView:(UIView *) view Type:(LESettingsCellType) type Delegate:(id<LETableViewCellSelectionDelegate>) delegate Index:(NSIndexPath *) index{
    self=[super initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:view EdgeInsects:UIEdgeInsetsZero]];
    self.leItemType=type;
    self.leDelegate=delegate;
    self.leIndex=index;
    [self leSetHeight:LEDefaultCellHeight];
    tapEvent=[UIButton new].leSuperView(self).leEdgeInsects(UIEdgeInsetsZero).leTapEvent(@selector(onTapped),self).leBackgroundImageHighlighted([LEColorMask leImageStrechedFromSizeOne]).leAutoLayout.leType;
    [self leExtraInits];
    [self leAddBottomSplitWithColor:LEColorSplit Offset:CGPointZero Width:LESCREEN_WIDTH];
    return self;
}
-(void) leSetIndex:(NSIndexPath *) index{
    self.leIndex=index;
}
-(void) leEnableTap:(BOOL) enable{
    [tapEvent setHidden:!enable];
}
-(void) leSetData:(id)data{
    if([data isKindOfClass:[NSDictionary class]]){
        if([data objectForKey:LEKeyOfSettingsCellFunction]){
            [self leEnableTap:YES];
        }else{
            [self leEnableTap:NO];
        }
    }
}
-(void) onTapped{
    if(self.leIndex&&self.leDelegate&&[self.leDelegate respondsToSelector:@selector(leOnTableViewCellSelectedWithInfo:)]){
        [self.leDelegate leOnTableViewCellSelectedWithInfo:@{LEKeyOfIndexPath:self.leIndex}];
    }
}
-(void) leSetHeight:(float) height{
    [self leSetSize:CGSizeMake(LESCREEN_WIDTH, height)];
    [tapEvent leSetSize:self.bounds.size];
}
@end

@interface LEItem_L_Title_R_Arrow : LEBaseConfigurableTableViewCellItem
@end
@implementation LEItem_L_Title_R_Arrow{
    UILabel *label;
    UIImageView *arrow;
}
-(void)leExtraInits{
    label=[UILabel new].leSuperView(self).leAnchor(LEAnchorInsideLeftCenter).leOffset(CGPointMake(LEKeyOfSettingsCellSideSpace, 0)).leAutoLayout.leType;
    arrow=[UIImageView new].leSuperView(self).leAnchor(LEAnchorInsideRightCenter).leOffset(CGPointMake(-LEKeyOfSettingsCellSideSpace, 0)).leSize(LESquareSize(LEKeyOfSettingsCellRightEdge-LEKeyOfSettingsCellSideSpace)).leAutoLayout.leType;
    [arrow setContentMode:UIViewContentModeCenter];
    [arrow leSetImage:[[LEUIFramework sharedInstance] leGetImageFromLEFrameworksWithName:@"LE_tableview_icon_arrow"]];
    [label.leWidth(LESCREEN_WIDTH-LEKeyOfSettingsCellSideSpace-LEKeyOfSettingsCellRightEdge).leFont(LEFont(LEKeyOfSettingsCellTitleFontsize)).leLine(1) leLabelLayout];
}
-(void) leSetData:(id) data{
    [super leSetData:data];
    [label leSetText:[data objectForKey:LEKeyOfSettingsCellTitle]];
}
@end
@interface LEItem_L_Title_R_Switch : LEBaseConfigurableTableViewCellItem
@end
@implementation LEItem_L_Title_R_Switch{
    UISwitch *curSwitch;
    UILabel *label;
}
-(void)leExtraInits{
    label=[UILabel new].leSuperView(self).leAnchor(LEAnchorInsideLeftCenter).leOffset(CGPointMake(LEKeyOfSettingsCellSideSpace, 0)).leAutoLayout.leType;
    curSwitch=[UISwitch new];
    [curSwitch.leSuperView(self).leAnchor(LEAnchorInsideRightCenter).leOffset(CGPointMake(-LEKeyOfSettingsCellSideSpace, 0)).leSize(curSwitch.bounds.size) leExecAutoLayout];
    [label.leWidth(LESCREEN_WIDTH-LEKeyOfSettingsCellSideSpace*3-curSwitch.bounds.size.width).leFont(LEFont(LEKeyOfSettingsCellTitleFontsize)).leLine(1) leLabelLayout];
    [curSwitch addTarget:self action:@selector(onTapped) forControlEvents:UIControlEventTouchUpInside];
}
-(void) leSetData:(id) data{
    [super leSetData:data];
    [label leSetText:[data objectForKey:LEKeyOfSettingsCellTitle]];
    [curSwitch setOn:[[data objectForKey:LEKeyOfSettingsCellSwitch] boolValue]];
}
@end
//
@interface LEItem_L_Title_R_Subtitle : LEBaseConfigurableTableViewCellItem
@end
@implementation LEItem_L_Title_R_Subtitle{
    UILabel *label;
    UILabel *labelSub;
}
-(void)leExtraInits{
    UIView *anchor=[UIView new].leSuperView(self).leSize(CGSizeMake(1, LEDefaultCellHeight)).leAutoLayout;
    label=[UILabel new].leSuperView(self).leRelativeView(anchor).leAnchor(LEAnchorOutsideRightCenter).leOffset(CGPointMake(LEKeyOfSettingsCellSideSpace-1, 0)).leAutoLayout.leType;
    [label.leFont(LEFont(LEKeyOfSettingsCellTitleFontsize)).leLine(1).leText(@" ") leLabelLayout];
    labelSub=[UILabel new].leSuperView(self).leAnchor(LEAnchorInsideTopRight).leOffset(CGPointMake(-LEKeyOfSettingsCellSideSpace, LEKeyOfSettingsSubtitleOffsetY)).leAutoLayout.leType;
    [labelSub.leFont(LEFont(LEKeyOfSettingsCellSubTitleFontsize)).leColor(LEKeyOfSettingsCellSubTitleColor).leAlignment(NSTextAlignmentRight).leLine(0).leWidth(LEKeyOfSettingsSubtitleWidth) leLabelLayout];
}
-(void) leSetData:(id) data{
    [super leSetData:data];
    [label leSetText:[data objectForKey:LEKeyOfSettingsCellTitle]];
    NSString *edge=[data objectForKey:LEKeyOfSettingsCellRightEdgeKey];
    if(edge){
        [labelSub leSetOffset:CGPointMake(-abs([edge intValue]), LEKeyOfSettingsSubtitleOffsetY)];
    }
    [labelSub.leText([data objectForKey:LEKeyOfSettingsCellSubtitle]) leLabelLayout];
    if([data objectForKey:LEKeyOfSettingsCellLinespace]){
        [labelSub leSetLineSpace:[[data objectForKey:LEKeyOfSettingsCellLinespace] intValue]];
    }
    CGSize size=CGSizeMake(self.bounds.size.width, MAX(LEKeyOfSettingsSubtitleOffsetY+(int)labelSub.bounds.size.height+LEKeyOfSettingsCellSideSpace, LEDefaultCellHeight));
    [self leSetHeight:size.height];
}
@end
@interface LEItem_L_Title_R_Subtitle_Arrow : LEBaseConfigurableTableViewCellItem
@end
@implementation LEItem_L_Title_R_Subtitle_Arrow{
    UILabel *label;
    UILabel *subtitle;
    UIImageView *arrow;
}
-(void) leExtraInits{
    label=[UILabel new].leSuperView(self).leAnchor(LEAnchorInsideLeftCenter).leOffset(CGPointMake(LEKeyOfSettingsCellSideSpace, 0)).leAutoLayout.leType;
    [label.leFont(LEFont(LEKeyOfSettingsCellTitleFontsize)).leLine(1) leLabelLayout];
    arrow= [UIImageView new].leSuperView(self).leAnchor(LEAnchorInsideRightCenter).leOffset(CGPointMake(-LEKeyOfSettingsCellSideSpace, 0)).leSize(LESquareSize(LEKeyOfSettingsCellRightEdge-LEKeyOfSettingsCellSideSpace)).leAutoLayout.leType;
    [arrow setContentMode:UIViewContentModeCenter];
    [arrow leSetImage:[[LEUIFramework sharedInstance] leGetImageFromLEFrameworksWithName:@"LE_tableview_icon_arrow"]];
    subtitle=[UILabel new].leSuperView(self).leAnchor(LEAnchorInsideRightCenter).leOffset(CGPointMake(-LEKeyOfSettingsCellRightEdge, 0)).leAutoLayout.leType;
    [subtitle.leFont(LEFont(LEKeyOfSettingsCellSubTitleFontsize)).leColor(LEKeyOfSettingsCellSubTitleColor).leLine(1).leAlignment(NSTextAlignmentRight) leLabelLayout];
}
-(void) leSetData:(id) data{
    [super leSetData:data];
    [label leSetText:[data objectForKey:LEKeyOfSettingsCellTitle]];
    [subtitle.leWidth(LESCREEN_WIDTH-LEKeyOfSettingsCellRightEdge-LEKeyOfSettingsCellSideSpace-label.bounds.size.width-LELayoutSideSpace).leText([data objectForKey:LEKeyOfSettingsCellSubtitle]) leLabelLayout];
}
@end
//
@interface LEItem_L_Icon_Title_R_Arrow : LEBaseConfigurableTableViewCellItem
@end
@implementation LEItem_L_Icon_Title_R_Arrow{
    UIImageView *icon;
    UILabel *label;
}
-(void) leExtraInits{
    icon=[UIImageView new].leSuperView(self).leAnchor(LEAnchorInsideLeftCenter).leOffset(CGPointMake(LEKeyOfSettingsCellSideSpace, 0)).leSize(CGSizeMake(LELayoutAvatarSize, LELayoutAvatarSize)).leRoundCorner(LELayoutAvatarSize/2).leAutoLayout.leType;
    label=[UILabel new].leSuperView(self).leRelativeView(icon).leAnchor(LEAnchorOutsideRightCenter).leOffset(CGPointMake(LEKeyOfSettingsCellSideSpace, 0)).leFont(LEFont(LEKeyOfSettingsCellTitleFontsize)).leLine(1).leWidth(LEKeyOfSettingsSubtitleWidth).leAutoLayout.leType;
    UIImageView *arrow= [UIImageView new].leSuperView(self).leAnchor(LEAnchorInsideRightCenter).leOffset(CGPointMake(-LEKeyOfSettingsCellSideSpace, 0)).leSize(LESquareSize(LEKeyOfSettingsCellRightEdge-LEKeyOfSettingsCellSideSpace)).leAutoLayout.leType;
    [arrow leSetImage:[[LEUIFramework sharedInstance] leGetImageFromLEFrameworksWithName:@"LE_tableview_icon_arrow"]];
    [arrow setContentMode:UIViewContentModeCenter];
}
-(void) leSetData:(id) data{
    [super leSetData:data];
    UIImage *img=[data objectForKey:LEKeyOfSettingsCellIconPlaceHolder];
    if(img&&[img isKindOfClass:[UIImage class]]){
        [icon leSetPlaceholder:img];
        if(icon.image==nil){
            [icon leSetImage:img];
        }
    }
    img=[data objectForKey:LEKeyOfSettingsCellLocalImage];
    if(img&&[img isKindOfClass:[UIImage class]]){
        [icon leSetImage:img];
    }
    NSString *str=[data objectForKey:LEKeyOfSettingsCellImage];
    if(str&&[str isKindOfClass:[NSString class]]&&str.length>0){
        [icon leSetImageWithUrlString:str];
    }
    str=[data objectForKey:LEKeyOfSettingsCellTitle];
    if(str&&[str isKindOfClass:[NSString class]]){
        [label leSetText:str];
    }
}
@end
@interface LEItem_L_Title_R_Icon_Arrow : LEBaseConfigurableTableViewCellItem
@end
@implementation LEItem_L_Title_R_Icon_Arrow{
    UIImageView *icon;
    UILabel *label;
}
-(void) leExtraInits{
    label=[UILabel new].leSuperView(self).leAnchor(LEAnchorInsideLeftCenter).leOffset(CGPointMake(LEKeyOfSettingsCellSideSpace, 0)).leAutoLayout.leType;
    UIImageView *arrow= [UIImageView new].leSuperView(self).leAnchor(LEAnchorInsideRightCenter).leOffset(CGPointMake(-LEKeyOfSettingsCellSideSpace, 0)).leSize(LESquareSize(LEKeyOfSettingsCellRightEdge-LEKeyOfSettingsCellSideSpace)).leAutoLayout.leType;
    [arrow leSetImage:[[LEUIFramework sharedInstance] leGetImageFromLEFrameworksWithName:@"LE_tableview_icon_arrow"]];
    [arrow setContentMode:UIViewContentModeCenter];
    icon=[UIImageView new].leSuperView(self).leAnchor(LEAnchorInsideRightCenter).leOffset(CGPointMake(-LEKeyOfSettingsCellRightEdge, 0)).leSize(CGSizeMake(LELayoutAvatarSize, LELayoutAvatarSize)).leRoundCorner(LELayoutAvatarSize/2).leAutoLayout.leType;
    [label.leFont(LEFont(LEKeyOfSettingsCellTitleFontsize)).leLine(1).leWidth(LESCREEN_WIDTH-LEKeyOfSettingsCellSideSpace-LEKeyOfSettingsCellRightEdge-LELayoutAvatarSize) leLabelLayout];
}
-(void) leSetData:(id) data{
    [super leSetData:data];
    UIImage *placeHolder=[data objectForKey:LEKeyOfSettingsCellIconPlaceHolder];
    if(placeHolder){
        [icon leSetPlaceholder:placeHolder];
    }
    [icon leSetCornerRadius:[[data objectForKey:LEKeyOfSettingsCellImageCorner] intValue]];
    [icon leSetImageForQiniuWithUrlString:[data objectForKey:LEKeyOfSettingsCellImage] Width:LELayoutAvatarSize Height:LELayoutAvatarSize];
    [label leSetText:[data objectForKey:LEKeyOfSettingsCellTitle]];
}

@end
@interface LEItem_M_Submit : LEBaseConfigurableTableViewCellItem
@end
@implementation LEItem_M_Submit{
    UIButton *btn;
}
-(void) leExtraInits{
    [self setBackgroundColor:[LEUIFramework sharedInstance].leColorViewContainer];
    btn=[UIButton new].leSuperView(self).leEdgeInsects(UIEdgeInsetsMake(LEKeyOfSettingsCellSideSpace, LEKeyOfSettingsCellSideSpace, LEKeyOfSettingsCellSideSpace, LEKeyOfSettingsCellSideSpace)).leAutoLayout.leType;
    [btn.leButtonSize(btn.bounds.size).leFont(LEFont(LELayoutFontSize14)).leTapEvent(@selector(onTapped),self) leButtonLayout];
}
-(void) leSetData:(id) data{
    [super leSetData:data];
    [self leEnableTap:NO];
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
@interface LEItem_F_SectionSolid : LEBaseConfigurableTableViewCellItem
@end
@implementation LEItem_F_SectionSolid
-(void) leExtraInits{
    [self leSetHeight:LEDefaultSectionHeight];
}
-(void) leSetData:(id) data{
    [super leSetData:data];
    [self setBackgroundColor:[data objectForKey:LEKeyOfSettingsCellColor]];
}
@end
//============
@interface LEBaseConfigurableTableViewCell ()
@property (nonatomic,readwrite) LESettingsCellType leCellType;
@end
@implementation LEBaseConfigurableTableViewCell{
    LEBaseConfigurableTableViewCellItem *curItem;
}
-(void) leSetType:(LESettingsCellType) type{
    self.leCellType=type;
    if(!curItem||curItem.leItemType!=type){
        if(curItem){
            [curItem removeFromSuperview];
        }
        curItem=[self getItemWithType:type];
    }
}
-(LEBaseConfigurableTableViewCellItem *) getItemWithType:(LESettingsCellType) type{
    LEBaseConfigurableTableViewCellItem *item=nil;
    switch (type) {
        case L_Title_R_Arrow:
            item=[[LEItem_L_Title_R_Arrow alloc] initWithSuperView:self Type:type Delegate:self.leSelectionDelegate Index:self.leIndexPath];
            break;
        case L_Title_R_Switch:
            item=[[LEItem_L_Title_R_Switch alloc] initWithSuperView:self Type:type Delegate:self.leSelectionDelegate Index:self.leIndexPath];
            break;
        case L_Title_R_Subtitle:
            item=[[LEItem_L_Title_R_Subtitle alloc] initWithSuperView:self Type:type Delegate:self.leSelectionDelegate Index:self.leIndexPath];
            break;
        case L_Icon_Title_R_Arrow:
            item=[[LEItem_L_Icon_Title_R_Arrow alloc] initWithSuperView:self Type:type Delegate:self.leSelectionDelegate Index:self.leIndexPath];
            break;
        case L_Title_R_Icon_Arrow:
            item=[[LEItem_L_Title_R_Icon_Arrow alloc] initWithSuperView:self Type:type Delegate:self.leSelectionDelegate Index:self.leIndexPath];
            break;
        case L_Title_R_Subtitle_Arrow:
            item=[[LEItem_L_Title_R_Subtitle_Arrow alloc] initWithSuperView:self Type:type Delegate:self.leSelectionDelegate Index:self.leIndexPath];
            break;
        case M_Submit:
            item=[[LEItem_M_Submit alloc] initWithSuperView:self Type:type Delegate:self.leSelectionDelegate Index:self.leIndexPath];
            break;
        case F_SectionSolid:
            item=[[LEItem_F_SectionSolid alloc] initWithSuperView:self Type:type Delegate:self.leSelectionDelegate Index:self.leIndexPath];
            break;
        default:
            break;
    }
    return item;
}
-(void) leSetData:(id)data{
    [super leSetData:data];
    if([data isKindOfClass:[NSDictionary class]]){
        [self leSetType:[[data objectForKey:LEKeyOfSettingsCellType] intValue]];
    }
    if(curItem){
        [curItem leSetData:data]; 
        [self leSetCellHeight:curItem.bounds.size.height];
    }
}
-(void) leOnIndexSet{
    if(curItem){
        [curItem leSetIndex:self.leIndexPath];
    }
}
@end

@interface LEBaseConfigurableTableView ()<LETableViewCellSelectionDelegate>
@property (nonatomic) id<LETableViewCellSelectionDelegate> curDelegate;
@end
@implementation LEBaseConfigurableTableView
-(id) initWithSuperView:(UIView *) superView EmptyTableViewCell:(NSString *)emptyCell TableViewCellSelectionDelegate:(id<LETableViewCellSelectionDelegate>) selectionDelegate{
    self= [super initWithSettings:[[LETableViewSettings alloc] initWithSuperView:superView TableViewCell:@"LEBaseConfigurableTableViewCell" EmptyTableViewCell:emptyCell GetDataDelegate:nil TableViewCellSelectionDelegate:self]];
    self.curDelegate=selectionDelegate;
    return self;
}
-(void) leOnTableViewCellSelectedWithInfo:(NSDictionary *)info{
    NSIndexPath *index=[info objectForKey:LEKeyOfIndexPath];
    if(index.row<self.leItemsArray.count){
        BOOL noti=NO;
        NSString *func=[[self.leItemsArray objectAtIndex:index.row] objectForKey:LEKeyOfSettingsCellFunction];
        if(func&&func.length>0&&[self.curDelegate respondsToSelector:NSSelectorFromString(func)]){
            LESuppressPerformSelectorLeakWarning(
                                                 noti=YES;
                                                 [self.curDelegate performSelector:NSSelectorFromString(func)];
                                                 );
        }
        if(!noti){
            if(self.curDelegate&&[self.curDelegate respondsToSelector:@selector(leOnTableViewCellSelectedWithInfo:)]){
                [self.curDelegate leOnTableViewCellSelectedWithInfo:info];
            }
        }
    }
}
@end
@interface LEBaseConfigurableTableViewWithRefresh ()<LETableViewCellSelectionDelegate>
@property (nonatomic) id<LETableViewCellSelectionDelegate> curDelegate;
@end
@implementation LEBaseConfigurableTableViewWithRefresh
-(id) initWithSuperView:(UIView *) superView EmptyTableViewCell:(NSString *)emptyCell GetDataDelegate:(id<LETableViewDataSourceDelegate>) dataDelegate TableViewCellSelectionDelegate:(id<LETableViewCellSelectionDelegate>) selectionDelegate{
    self= [super initWithSettings:[[LETableViewSettings alloc] initWithSuperView:superView TableViewCell:@"LEBaseConfigurableTableViewCell" EmptyTableViewCell:emptyCell GetDataDelegate:dataDelegate TableViewCellSelectionDelegate:self]];
    self.curDelegate=selectionDelegate;
    return self;
}
-(void) leOnTableViewCellSelectedWithInfo:(NSDictionary *)info{
    NSIndexPath *index=[info objectForKey:LEKeyOfIndexPath];
    if(index.row<self.leItemsArray.count){
        BOOL noti=NO;
        NSString *func=[[self.leItemsArray objectAtIndex:index.row] objectForKey:LEKeyOfSettingsCellFunction];
        if(func&&func.length>0&&[self.curDelegate respondsToSelector:NSSelectorFromString(func)]){
            LESuppressPerformSelectorLeakWarning(
                                                 noti=YES;
                                                 [self.curDelegate performSelector:NSSelectorFromString(func)];
                                                 );
        }
        if(!noti){
            if(self.curDelegate&&[self.curDelegate respondsToSelector:@selector(leOnTableViewCellSelectedWithInfo:)]){
                [self.curDelegate leOnTableViewCellSelectedWithInfo:info];
            }
        }
    }
}
@end

