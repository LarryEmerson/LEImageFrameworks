//
//  TestConfigurableTableView.m
//  LEImageFrameworks
//
//  Created by emerson larry on 2016/10/20.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import "TestConfigurableTableView.h"
#import "LEImageFrameworks.h"

@interface LEConfigurableCell_Customized : LEBaseConfigurableTableViewCellItem
@end
@implementation LEConfigurableCell_Customized{
    UILabel *label;
    UILabel *subLabel;
    UIImageView *icon;
    int linespace;
    
}
-(void) leAdditionalInits{
    linespace=4;
    [self leSetHeight:LELayoutSideSpace*3+LELayoutFontSize16*2+LELayoutFontSize12+linespace];
    icon=[UIImageView new].leSuperView(self).leAnchor(LEAnchorInsideLeftCenter).leOffset(CGPointMake(LELayoutSideSpace, 0)).leSize(LESquareSize(self.bounds.size.height-LELayoutSideSpace*2)).leAutoLayout.leType;
    label=[UILabel new].leSuperView(self).leAnchor(LEAnchorOutsideRightTop).leRelativeView(icon).leOffset(CGPointMake(LELayoutSideSpace, 0)).leLine(2).leWidth(LESCREEN_WIDTH-LELayoutSideSpace*3-icon.bounds.size.width).leFont(LEBoldFont(LELayoutFontSize16)).leColor(LEColorRed).leAutoLayout.leType;
    subLabel=[UILabel new].leSuperView(self).leAnchor(LEAnchorOutsideRightBottom).leRelativeView(icon).leOffset(CGPointMake(LELayoutSideSpace, 0)).leLine(1).leWidth(LESCREEN_WIDTH-LELayoutSideSpace*3-icon.bounds.size.width).leFont(LEFont(LELayoutFontSize12)).leColor(LEColorBlue).leAutoLayout.leType;
}
-(void) leSetData:(id) data{
    [super leSetData:data];
    [icon setImage:[data objectForKey:LEConfigurableCellKey_LocalImage]];
    [label.leText([data objectForKey:LEConfigurableCellKey_Title]) leLabelLayout];
    [subLabel.leText([data objectForKey:LEConfigurableCellKey_Subtitle]) leLabelLayout];
    [label leSetLineSpace:linespace];
    [subLabel leSetLineSpace:0];
}
@end
@interface TestConfigurableTableView()<LETableViewDataSourceDelegate,LETableViewCellSelectionDelegate>
@end
@implementation TestConfigurableTableView{
    LEBaseConfigurableTableViewWithRefresh *tb;
}
-(void) leAdditionalInits{
    LEBaseView *base=[[LEBaseView alloc] initWithViewController:self];
    [[LEBaseNavigation alloc] initWithDelegate:nil SuperView:base Title:@"测试LEBaseConfigurableTableView"];
    tb=[[LEBaseConfigurableTableViewWithRefresh alloc] initWithSuperView:base.leViewBelowCustomizedNavigation EmptyTableViewCell:nil GetDataDelegate:self TableViewCellSelectionDelegate:self];
    [tb leOnAutoRefresh];
    [[LEConfigurableCellManager sharedInstance] leRegisterItemWithClassName:@"LEConfigurableCell_Customized" Type:100];
}
-(void) leOnRefreshData{
    NSMutableArray *curData=[NSMutableArray new];
    [curData addObject:@{LEConfigurableCellKey_Type:[NSNumber numberWithInt:100],
                         LEConfigurableCellKey_Title:@"这是自定义Item的title部分，最多允许显示2行内容，超过的内容部分会被...替代",
                         LEConfigurableCellKey_Subtitle:@"这是自定义Item的subtitle，只能显示1行，超过的内容部分会被...替代",
                         LEConfigurableCellKey_LocalImage:[LEColorBlue leImageWithSize:LESquareSize(LELayoutAvatarSize)],
                         LEConfigurableCellKey_Function:@"LEConfigurableCell_Customized"
                         }];
    [curData addObject:@{LEConfigurableCellKey_Type:[NSNumber numberWithInt:L_Icon_Title_R_Arrow],
                         LEConfigurableCellKey_Title:@"L_Icon_Title_R_Arrow. Icon's round corner is configurable  可设定图标圆角",
                         LEConfigurableCellKey_Color:LEColorBlue,
                         LEConfigurableCellKey_TitleFontsize:[NSNumber numberWithInt:20],
                         LEConfigurableCellKey_IconPlaceHolder:[LEColorMask leImageWithSize:LESquareSize(LELayoutAvatarSize)],
                         LEConfigurableCellKey_LocalImage:[LEColorBlue leImageWithSize:LESquareSize(LELayoutAvatarSize)],
                         LEConfigurableCellKey_Function:@"L_Icon_Title_R_Arrow"
                         }];
    [curData addObject:@{LEConfigurableCellKey_Type:[NSNumber numberWithInt:L_Title_R_Subtitle],
                         LEConfigurableCellKey_Title:@"L_Title_R_Subtitle",
                         LEConfigurableCellKey_Color:LEColorRed,
                         LEConfigurableCellKey_Subtitle:@"blue subtitle wraps automatically with line spacing assigned as 20 and right margin as 30\n蓝色的副标题当前行间距设定为20、右边距设定为30且自动换行",
                         LEConfigurableCellKey_SubTitleFontsize:[NSNumber numberWithInt:8],
                         LEConfigurableCellKey_SubTitleColor:LEColorBlue,
                         LEConfigurableCellKey_Linespace:[NSNumber numberWithInt:20],
                         LEConfigurableCellKey_RightEdgeKey:[NSNumber numberWithInt:LELayoutSideSpace*3],
                         LEConfigurableCellKey_Function:@"L_Title_R_Subtitle"
                         }];
    [curData addObject:@{LEConfigurableCellKey_Type:[NSNumber numberWithInt:L_Title_R_Icon_Arrow],
                         LEConfigurableCellKey_Title:@"L_Title_R_Icon_Arrow.可设定图标圆角 Icon's round corner is configurable",
                         LEConfigurableCellKey_IconPlaceHolder:[LEColorMask leImageWithSize:LESquareSize(LELayoutAvatarSize)],
                         LEConfigurableCellKey_LocalImage:[LEColorBlue leImageWithSize:LESquareSize(LELayoutAvatarSize)],
                         LEConfigurableCellKey_ImageCorner:[NSNumber numberWithInt:6],
                         LEConfigurableCellKey_Function:@"L_Title_R_Icon_Arrow"}];
    [curData addObject:@{LEConfigurableCellKey_Type:[NSNumber numberWithInt:L_Title_R_Arrow],
                         LEConfigurableCellKey_Title:@"L_Title_R_Arrow",
                         LEConfigurableCellKey_Function:@"L_Title_R_Arrow"}];
    [curData addObject:@{LEConfigurableCellKey_Type:[NSNumber numberWithInt:M_Submit],
                         LEConfigurableCellKey_LocalImage:[LEColorRed leImageStrechedFromSizeOne],
                         LEConfigurableCellKey_ImageCorner:[NSNumber numberWithInt:8],
                         LEConfigurableCellKey_Color:LEColorWhite,
                         LEConfigurableCellKey_TitleFontsize:[NSNumber numberWithInt:20],
                         LEConfigurableCellKey_Title:@"M_Submit.可设定按钮圆角 ",
                         LEConfigurableCellKey_Function:@"M_Submit"}];
    [curData addObject:@{LEConfigurableCellKey_Type:[NSNumber numberWithInt:L_Title_R_Switch],
                         LEConfigurableCellKey_Title:@"L_Title_R_Switch",
                         LEConfigurableCellKey_Switch:[NSNumber numberWithBool:YES],
                         LEConfigurableCellKey_Function:@"L_Title_R_Switch"}];
    [curData addObject:@{LEConfigurableCellKey_Type:[NSNumber numberWithInt:L_Title_R_Subtitle_Arrow],
                         LEConfigurableCellKey_Title:@"L_Title_R_Subtitle_Arrow",
                         LEConfigurableCellKey_Subtitle:@"下面是分割线 next comes the split line ",
                         LEConfigurableCellKey_Function:@"L_Title_R_Subtitle_Arrow"}];
    [curData addObject:@{LEConfigurableCellKey_Type:[NSNumber numberWithInt:F_SectionSolid],
                         LEConfigurableCellKey_Color:LEColorTest,
                         LEConfigurableCellKey_Function:@"F_SectionSolid"}];
    [tb leOnRefreshedWithData:curData];
}
-(void) leOnLoadMore{
    LELogFunc
    [tb leOnLoadedMoreWithData:[@[@{LEConfigurableCellKey_Type:[NSNumber numberWithInt:F_SectionSolid],
                                    LEConfigurableCellKey_Color:LERandomColor}] mutableCopy]];
}
-(void) L_Icon_Title_R_Arrow{
    LELogFunc
    [self.view leAddLocalNotification:@"根据方法名称，找到已经实现的方法L_Icon_Title_R_Arrow"];
}
-(void) leOnTableViewCellSelectedWithInfo:(NSDictionary *)info{
    NSIndexPath *index=[info objectForKey:LEKeyOfIndexPath];
    NSString *func=[[tb.leItemsArray objectAtIndex:index.row] objectForKey:LEConfigurableCellKey_Function];
    LELogObject(func);
    [self.view leAddLocalNotification:[NSString stringWithFormat:@"未找到方法%@，走回调leOnTableViewCellSelectedWithInfo", func]];
}
@end
