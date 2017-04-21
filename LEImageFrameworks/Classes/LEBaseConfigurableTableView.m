//
//  LEBaseConfigurableTableView.m
//  Pods
//
//  Created by emerson larry on 2016/10/19.
//
//

#import "LEBaseConfigurableTableView.h"

@interface LEConfigurableCellManager ()
@property (nonatomic) NSMutableDictionary *registedItems;
@property (nonatomic) UIImage *arrowImage;
@end
@implementation LEConfigurableCellManager
LESingleton_implementation(LEConfigurableCellManager)
-(void) leAdditionalInits{
//-(void) leAdditionalInits{
    self.registedItems=[NSMutableDictionary new];
    self.arrowImage=[[LEUIFramework sharedInstance] leGetImageFromLEFrameworksWithName:@"LE_tableview_icon_arrow"];
}
-(void) leRegisterItemWithClassName:(NSString *) className Type:(int) type{
    [self.registedItems setObject:className forKey:[NSNumber numberWithInt:type]];
}
-(void) leSetArrowWith:(UIImage *) arrow{
    self.arrowImage=arrow;
}
@end

@interface LEBaseConfigurableTableViewCellItem ()
@property (nonatomic,readwrite) LEConfigurableCellType leItemType;
@property (nonatomic,readwrite) id<LETableViewCellSelectionDelegate> leDelegate;
@property (nonatomic,readwrite) NSIndexPath *leIndex;
@end
@implementation LEBaseConfigurableTableViewCellItem{
    UIButton *tapEvent;
}
-(id) initWithSuperView:(UIView *) view Type:(LEConfigurableCellType) type Delegate:(id<LETableViewCellSelectionDelegate>) delegate Index:(NSIndexPath *) index{
    self=[super initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:view EdgeInsects:UIEdgeInsetsZero]];
    self.leItemType=type;
    self.leDelegate=delegate;
    self.leIndex=index;
    [self leSetHeight:LEDefaultCellHeight];
    tapEvent=[UIButton new].leSuperView(self).leEdgeInsects(UIEdgeInsetsZero).leTapEvent(@selector(onTapped),self).leBackgroundImageHighlighted([LEColorMask leImageStrechedFromSizeOne]).leAutoLayout.leType;
    [self leAdditionalInits];
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
        if([data objectForKey:LEConfigurableCellKey_Function]){
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
-(void)leAdditionalInits{
    label=[UILabel new].leSuperView(self).leAnchor(LEAnchorInsideLeftCenter).leOffset(CGPointMake(LELayoutSideSpace, 0)).leAutoLayout.leType;
    arrow=[UIImageView new].leSuperView(self).leAnchor(LEAnchorInsideRightCenter).leOffset(CGPointMake(-LELayoutSideSpace, 0)).leSize(LESquareSize(LELayoutAvatarSize)).leAutoLayout.leType;
    [arrow setContentMode:UIViewContentModeCenter];
    [arrow leSetImage:[LEConfigurableCellManager sharedInstance].arrowImage];
    [label.leWidth(LESCREEN_WIDTH-LELayoutSideSpace-LELayoutAvatarSize).leFont(LEFont(LELayoutFontSize16)).leLine(1) leLabelLayout];
}
-(void) leSetData:(id) data{
    [super leSetData:data];
    id value=[data objectForKey:LEConfigurableCellKey_Color];
    if(value&&[value isKindOfClass:[UIColor class]]){
        [label setTextColor:value];
    }
    value=[data objectForKey:LEConfigurableCellKey_TitleFontsize];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        [label setFont:LEFont([value intValue])];
    }
    value=[data objectForKey:LEConfigurableCellKey_Title];
    if(value&&[value isKindOfClass:[NSString class]]){
        [label leSetText:value];
    }
}
@end
@interface LEItem_L_Title_R_Switch : LEBaseConfigurableTableViewCellItem
@end
@implementation LEItem_L_Title_R_Switch{
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
    [super leSetData:data];
    [self leEnableTap:NO];
    id value=[data objectForKey:LEConfigurableCellKey_Color];
    if(value&&[value isKindOfClass:[UIColor class]]){
        [label setTextColor:value];
    }
    value=[data objectForKey:LEConfigurableCellKey_TitleFontsize];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        [label setFont:LEFont([value intValue])];
    }
    value=[data objectForKey:LEConfigurableCellKey_Title];
    if(value&&[value isKindOfClass:[NSString class]]){
        [label leSetText:value];
    }
    value=[data objectForKey:LEConfigurableCellKey_Switch];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        [curSwitch setOn:[value boolValue]];
    }
}
@end
//
@interface LEItem_L_Title_R_Subtitle : LEBaseConfigurableTableViewCellItem
@end
@implementation LEItem_L_Title_R_Subtitle{
    UILabel *label;
    UILabel *labelSub;
}
-(void)leAdditionalInits{
    UIView *anchor=[UIView new].leSuperView(self).leSize(CGSizeMake(1, LEDefaultCellHeight)).leAutoLayout;
    label=[UILabel new].leSuperView(self).leRelativeView(anchor).leAnchor(LEAnchorOutsideRightCenter).leOffset(CGPointMake(LELayoutSideSpace-1, 0)).leFont(LEFont(LELayoutFontSize16)).leLine(1).leColor(LEColorBlack).leAutoLayout.leType;
    labelSub=[UILabel new].leSuperView(self).leAnchor(LEAnchorInsideTopRight).leOffset(CGPointMake(-LELayoutSideSpace, (LEDefaultCellHeight-LELayoutFontSize13)*0.5)).leFont(LEFont(LELayoutFontSize13)).leColor(LEColorTextGray).leAlignment(NSTextAlignmentRight).leLine(0).leWidth((LESCREEN_WIDTH-LELayoutSideSpace*3-6*LELayoutFontSize16)).leAutoLayout.leType;
}
-(void) leSetData:(id) data{
    [super leSetData:data];
    int fontsize=LELayoutFontSize16;
    int subfontsize=LELayoutFontSize13;
    int edge=LELayoutSideSpace;
    id value=[data objectForKey:LEConfigurableCellKey_Color];
    if(value&&[value isKindOfClass:[UIColor class]]){
        [label setTextColor:value];
    }else{
        [label setTextColor:LEColorBlack];
    }
    value=[data objectForKey:LEConfigurableCellKey_Title];
    if(value&&[value isKindOfClass:[NSString class]]){
        [label leSetText:value];
    }
    value=[data objectForKey:LEConfigurableCellKey_TitleFontsize];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        [label setFont:LEFont(fontsize=[value intValue])];
    }
    value=[data objectForKey:LEConfigurableCellKey_RightEdgeKey];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        edge=abs([value intValue]);
        [labelSub leSetOffset:CGPointMake(-edge, (LEDefaultCellHeight-subfontsize)*0.5)];
    }
    value=[data objectForKey:LEConfigurableCellKey_SubTitleFontsize];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        subfontsize=[value intValue];
        [labelSub.leFont(LEFont(subfontsize)) leLabelLayout];
    }
    value=[data objectForKey:LEConfigurableCellKey_Subtitle];
    if(value&&[value isKindOfClass:[NSString class]]){
        [labelSub.leWidth(LESCREEN_WIDTH-LELayoutSideSpace*2-edge-(MAX(6*fontsize, label.bounds.size.width))).leText(value) leLabelLayout];
    }
    value=[data objectForKey:LEConfigurableCellKey_SubTitleColor];
    if(value&&[value isKindOfClass:[UIColor class]]){
        [labelSub.leColor(value) leLabelLayout]; 
    }else{
        [labelSub.leColor(LEColorTextGray) leLabelLayout];
    }
    value=[data objectForKey:LEConfigurableCellKey_Linespace];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        [labelSub leSetLineSpace:[value intValue]];
    } 
    CGSize size=CGSizeMake(self.bounds.size.width, MAX((LEDefaultCellHeight-subfontsize)*0.5+(int)labelSub.bounds.size.height+LELayoutSideSpace, LEDefaultCellHeight));
    [self leSetHeight:size.height];
}
@end
@interface LEItem_L_Title_R_Subtitle_Arrow : LEBaseConfigurableTableViewCellItem
@end
@implementation LEItem_L_Title_R_Subtitle_Arrow{
    UILabel *label;
    UILabel *labelSub;
    UIImageView *arrow;
}
-(void) leAdditionalInits{
    label=[UILabel new].leSuperView(self).leAnchor(LEAnchorInsideLeftCenter).leOffset(CGPointMake(LELayoutSideSpace, 0)).leAutoLayout.leType;
    [label.leFont(LEFont(LELayoutFontSize16)).leLine(1) leLabelLayout];
    arrow= [UIImageView new].leSuperView(self).leAnchor(LEAnchorInsideRightCenter).leOffset(CGPointMake(-LELayoutSideSpace, 0)).leSize(LESquareSize(LELayoutAvatarSize)).leAutoLayout.leType;
    [arrow setContentMode:UIViewContentModeCenter];
    [arrow leSetImage:[LEConfigurableCellManager sharedInstance].arrowImage];
    labelSub=[UILabel new].leSuperView(self).leAnchor(LEAnchorInsideRightCenter).leOffset(CGPointMake(-LELayoutAvatarSize, 0)).leAutoLayout.leType;
    [labelSub.leFont(LEFont(LELayoutFontSize13)).leColor(LEColorTextGray).leLine(1).leAlignment(NSTextAlignmentRight) leLabelLayout];
}
-(void) leSetData:(id) data{
    [super leSetData:data];
    int subfontsize=LELayoutFontSize13;
    id value=[data objectForKey:LEConfigurableCellKey_Color];
    if(value&&[value isKindOfClass:[UIColor class]]){
        [label setTextColor:value];
    }
    value=[data objectForKey:LEConfigurableCellKey_TitleFontsize];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        [label setFont:LEFont([value intValue])];
    }
    value=[data objectForKey:LEConfigurableCellKey_Title];
    if(value&&[value isKindOfClass:[NSString class]]){
        [label leSetText:value];
    }
    value=[data objectForKey:LEConfigurableCellKey_SubTitleColor];
    if(value&&[value isKindOfClass:[UIColor class]]){
        [labelSub.leColor(value) leLabelLayout];
    }else{
        [labelSub.leColor(LEColorTextGray) leLabelLayout];
    }
    value=[data objectForKey:LEConfigurableCellKey_SubTitleFontsize];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        subfontsize=[value intValue];
        [labelSub.leFont(LEFont(subfontsize)) leLabelLayout];
    }
    value=[data objectForKey:LEConfigurableCellKey_Subtitle];
    if(value&&[value isKindOfClass:[NSString class]]){
        [labelSub.leWidth(LESCREEN_WIDTH-LELayoutAvatarSize-LELayoutSideSpace*2-label.bounds.size.width).leText(value) leLabelLayout];
    }
}
@end
//
@interface LEItem_L_Icon_Title_R_Arrow : LEBaseConfigurableTableViewCellItem
@end
@implementation LEItem_L_Icon_Title_R_Arrow{
    UIImageView *icon;
    UILabel *label;
}
-(void) leAdditionalInits{
    icon=[UIImageView new].leSuperView(self).leAnchor(LEAnchorInsideLeftCenter).leOffset(CGPointMake(LELayoutSideSpace, 0)).leSize(LESquareSize(LELayoutAvatarSize)).leRoundCorner(LELayoutAvatarSize/2).leAutoLayout.leType;
    label=[UILabel new].leSuperView(self).leRelativeView(icon).leAnchor(LEAnchorOutsideRightCenter).leOffset(CGPointMake(LELayoutSideSpace, 0)).leFont(LEFont(LELayoutFontSize16)).leLine(1).leWidth((LESCREEN_WIDTH-LELayoutSideSpace*3-LELayoutAvatarSize*2)).leAutoLayout.leType;
    UIImageView *arrow= [UIImageView new].leSuperView(self).leAnchor(LEAnchorInsideRightCenter).leOffset(CGPointMake(-LELayoutSideSpace, 0)).leSize(LESquareSize(LELayoutAvatarSize)).leAutoLayout.leType;
    [arrow leSetImage:[LEConfigurableCellManager sharedInstance].arrowImage];
    [arrow setContentMode:UIViewContentModeCenter];
}
-(void) leSetData:(id) data{
    [super leSetData:data];
    id value=[data objectForKey:LEConfigurableCellKey_IconPlaceHolder];
    if(value&&[value isKindOfClass:[UIImage class]]){
        [icon leSetPlaceholder:value];
        if(icon.image==nil){
            [icon leSetImage:value];
        }
    }
    value=[data objectForKey:LEConfigurableCellKey_LocalImage];
    if(value&&[value isKindOfClass:[UIImage class]]){
        [icon leSetImage:value];
    }
    value=[data objectForKey:LEConfigurableCellKey_ImageURL];
    if(value&&[value isKindOfClass:[NSString class]]&&[value length]>0){
        [icon leSetImageWithUrlString:value];
    }
    value=[data objectForKey:LEConfigurableCellKey_ImageCorner];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        [icon leSetCornerRadius:[value intValue]];
    }
    value=[data objectForKey:LEConfigurableCellKey_Color];
    if(value&&[value isKindOfClass:[UIColor class]]){
        [label setTextColor:value];
    }
    value=[data objectForKey:LEConfigurableCellKey_TitleFontsize];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        [label setFont:LEFont([value intValue])];
    }
    value=[data objectForKey:LEConfigurableCellKey_Title];
    if(value&&[value isKindOfClass:[NSString class]]){
        [label leSetText:value];
    }
}
@end
@interface LEItem_L_Title_R_Icon_Arrow : LEBaseConfigurableTableViewCellItem
@end
@implementation LEItem_L_Title_R_Icon_Arrow{
    UIImageView *icon;
    UILabel *label;
}
-(void) leAdditionalInits{
    label=[UILabel new].leSuperView(self).leAnchor(LEAnchorInsideLeftCenter).leOffset(CGPointMake(LELayoutSideSpace, 0)).leAutoLayout.leType;
    UIImageView *arrow= [UIImageView new].leSuperView(self).leAnchor(LEAnchorInsideRightCenter).leOffset(CGPointMake(-LELayoutSideSpace, 0)).leSize(LESquareSize(LELayoutAvatarSize)).leAutoLayout.leType;
    [arrow leSetImage:[LEConfigurableCellManager sharedInstance].arrowImage];
    [arrow setContentMode:UIViewContentModeCenter];
    icon=[UIImageView new].leSuperView(self).leAnchor(LEAnchorInsideRightCenter).leOffset(CGPointMake(-LELayoutAvatarSize, 0)).leSize(LESquareSize(LELayoutAvatarSize)).leRoundCorner(LELayoutAvatarSize/2).leAutoLayout.leType;
    [label.leFont(LEFont(LELayoutFontSize16)).leLine(1).leWidth(LESCREEN_WIDTH-LELayoutSideSpace-LELayoutAvatarSize*2) leLabelLayout];
}
-(void) leSetData:(id) data{
    [super leSetData:data];
    id value=[data objectForKey:LEConfigurableCellKey_Color];
    if(value&&[value isKindOfClass:[UIColor class]]){
        [label setTextColor:value];
    }
    value=[data objectForKey:LEConfigurableCellKey_TitleFontsize];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        [label setFont:LEFont([value intValue])];
    }
    value=[data objectForKey:LEConfigurableCellKey_Title];
    if(value&&[value isKindOfClass:[NSString class]]){
        [label leSetText:value];
    }
    value=[data objectForKey:LEConfigurableCellKey_IconPlaceHolder];
    if(value&&[value isKindOfClass:[UIImage class]]){
        [icon leSetPlaceholder:value];
        if(!icon.image){
            [icon leSetImage:value];
        }
    }
    value=[data objectForKey:LEConfigurableCellKey_ImageCorner];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        [icon leSetCornerRadius:[value intValue]];
    }
    value=[data objectForKey:LEConfigurableCellKey_LocalImage];
    if(value&&[value isKindOfClass:[UIImage class]]){
        [icon leSetImage:value];
    }
    value=[data objectForKey:LEConfigurableCellKey_ImageURL];
    if(value&&[value isKindOfClass:[NSString class]]){
        [icon leSetImageForQiniuWithUrlString:value Width:LELayoutAvatarSize Height:LELayoutAvatarSize];
    }
}

@end
@interface LEItem_M_Submit : LEBaseConfigurableTableViewCellItem
@end
@implementation LEItem_M_Submit{
    UIButton *btn;
}
-(void) leAdditionalInits{
    [self leSetHeight:LENavigationBarHeight+LELayoutSideSpace*2];
    [self setBackgroundColor:[LEUIFramework sharedInstance].leColorViewContainer];
    btn=[UIButton new].leSuperView(self).leEdgeInsects(UIEdgeInsetsMake(LELayoutSideSpace, LELayoutSideSpace, LELayoutSideSpace, LELayoutSideSpace)).leAutoLayout.leType;
    [btn.leButtonSize(btn.bounds.size).leFont(LEFont(LELayoutFontSize14)).leTapEvent(@selector(onTapped),self) leButtonLayout];
}
-(void) leSetData:(id) data{
    [super leSetData:data];
    [self leEnableTap:NO];
    id value=[data objectForKey:LEConfigurableCellKey_LocalImage];
    if(value&&[value isKindOfClass:[UIImage class]]){
        [btn.leBackgroundImage([value leMiddleStrechedImage]) leButtonLayout];
    }
    value=[data objectForKey:LEConfigurableCellKey_Color];
    if(value&&[value isKindOfClass:[UIColor class]]){
        [btn.leNormalColor(value) leButtonLayout];
    }
    value=[data objectForKey:LEConfigurableCellKey_TitleFontsize];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        [btn.titleLabel setFont:LEFont([value intValue])];
    }
    value=[data objectForKey:LEConfigurableCellKey_Title];
    if(value&&[value isKindOfClass:[NSString class]]){
        [btn.leText(value) leButtonLayout];
    }
    value=[data objectForKey:LEConfigurableCellKey_ImageCorner];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        [btn leSetRoundCornerWithRadius:([value intValue])];
    }
    
}
@end
@interface LEItem_F_SectionSolid : LEBaseConfigurableTableViewCellItem
@end
@implementation LEItem_F_SectionSolid
-(void) leAdditionalInits{
    [self leSetHeight:LEDefaultSectionHeight];
}
-(void) leSetData:(id) data{
    [super leSetData:data];
    [self leEnableTap:NO];
    id value=[data objectForKey:LEConfigurableCellKey_Color];
    if(value&&[value isKindOfClass:[UIColor class]]){
        [self setBackgroundColor:value];
    }
    value=[data objectForKey:LEConfigurableCellKey_Height];
    if(value&&[value isKindOfClass:[NSNumber class]]){
        [self leSetHeight:[value intValue]];
    }
}
@end
//============
@interface LEBaseConfigurableTableViewCell ()
@property (nonatomic,readwrite) LEConfigurableCellType leCellType;
@end
@implementation LEBaseConfigurableTableViewCell{
    LEBaseConfigurableTableViewCellItem *curItem;
}
-(void) leSetType:(LEConfigurableCellType) type{
    self.leCellType=type;
    if(!curItem||curItem.leItemType!=type){
        if(curItem){
            [curItem removeFromSuperview];
        }
        curItem=[self getItemWithType:type];
    }
}
-(LEBaseConfigurableTableViewCellItem *) getItemWithType:(LEConfigurableCellType) type{
    LEBaseConfigurableTableViewCellItem *item=nil; 
    NSString *className=[[LEConfigurableCellManager sharedInstance].registedItems objectForKey:[NSNumber numberWithInt:type]];
    if(className){
        id obj=[className leGetInstanceFromClassName];
        if(obj&&[obj respondsToSelector:@selector(initWithSuperView:Type:Delegate:Index:)]){
            item=[obj initWithSuperView:self Type:type Delegate:self.leSelectionDelegate Index:self.leIndexPath];
        }
    }
    if(item){
        return item;
    }
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
        [self leSetType:[[data objectForKey:LEConfigurableCellKey_Type] intValue]];
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
        NSString *func=[[self.leItemsArray objectAtIndex:index.row] objectForKey:LEConfigurableCellKey_Function];
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
        NSString *func=[[self.leItemsArray objectAtIndex:index.row] objectForKey:LEConfigurableCellKey_Function];
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


