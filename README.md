# LEImageFrameworks
20170508 最新开发库LEUIMaker中已经整合了LEImageFrameworks的所有内容，并且对接口做了进一步升级，详见https://github.com/LarryEmerson/LEUIMaker ImageFrameworks、LEBanner、LEConfigurableList） LEImageFrameworks不再更新维护, LEUIMaker持续更新中...
```
#import <LEImageFrameworks/LEImageFrameworks.h>
```
[![Version](https://img.shields.io/cocoapods/v/LEImageFrameworks.svg?style=flat)](http://cocoapods.org/pods/LEImageFrameworks) [![License](https://img.shields.io/cocoapods/l/LEImageFrameworks.svg?style=flat)](http://cocoapods.org/pods/LEImageFrameworks) [![Platform](https://img.shields.io/cocoapods/p/LEImageFrameworks.svg?style=flat)](http://cocoapods.org/pods/LEImageFrameworks)
 
## Installation 
```
use_frameworks!
target 'xxx' do
  pod 'LEImageFrameworks' 
end
```

### 2016-10-20 新增可配置化列表封装
![](https://github.com/LarryEmerson/LEAllFrameworksGif/blob/master/LEBaseConfigurableTableView.gif)

### 简介：
1-这是一个可配置化的列表封装（LEBaseConfigurableTableView）。经常做项目会发现，很多项目都存在个人中心、个人设置、系统设置等列表界面，但是每次的项目却并不一致。每次都重新构架或者复制粘贴是件非常浪费时间的事情。
2-LEBaseConfigurableTableView就是抽离出Cell的模板，并且定义配置规则，使用时只需要建立数据源和实现点击事件即可。
3-另外为了满足特殊要求，LEBaseConfigurableTableView定义了自定义入口。可以通过注册自定义的Cell，把自定义Cell添加到LEBaseConfigurableTableView中。
### 目前支持的样式：按照demo中的顺序
###### 模板说明：L:left, R:right, M:middle, F:fullscreenwidth, icon:图标, title:标题(黑), Arrow:箭头, SectionSolid:实心分割(灰), Subtitle:副标题(灰)

1-自定义：demo代码中演示了如何添加注册自己的模板
2-L_Icon_Title_R_Arrow：图标+标题+箭头
3-L_Title_R_Subtitle：标题+副标题，特点是subtitle满足多行显示的要求
4-L_Title_R_Icon_Arrow：标题+图标+箭头
5-L_Title_R_Arrow：标题+箭头
6-M_Submit：按钮（退出登录、确定...）
7-L_Title_R_Switch：标题+开关（推送开启？）
8-L_Title_R_Subtitle_Arrow：标题+副标题+箭头，副标题不支持多行
9-F_SectionSolid：分割线

### 使用方法：（具体内容见demo）
自定义cell的数据源举例：
```
[curData addObject:@{
    LEConfigurableCellKey_Type:[NSNumber numberWithInt:100],
    LEConfigurableCellKey_Title:@"这是自定义Item的title部分，最多允许显示2行内容，超过的内容部分会被...替代",
    LEConfigurableCellKey_Subtitle:@"这是自定义Item的subtitle，只能显示1行，超过的内容部分会被...替代",
    LEConfigurableCellKey_LocalImage:[LEColorBlue leImageWithSize:LESquareSize(LELayoutAvatarSize)],
    LEConfigurableCellKey_Function:@"LEConfigurableCell_Customized"
}];
```

第2个cell点击事件接口举例（L_Icon_Title_R_Arrow）：
```
-(void) L_Icon_Title_R_Arrow{ 
    [self.view leAddLocalNotification:@"根据方法名称，找到已经实现的方法L_Icon_Title_R_Arrow"];
}
```

### Key值举例
```
/**
 用于给M_Submit赋值按钮文字以及其他Cell赋值Title（NSString），适用：L_Icon_Title_R_Arrow、L_Title_R_Subtitle、L_Title_R_Icon_Arrow、L_Title_R_Arrow、L_Title_R_Switch、L_Title_R_Subtitle_Arrow
 */
#define LEConfigurableCellKey_Title @"title"
```
其他Key请查看接口
 

## Frameworks 2016-10-20 之前的内容
![](https://github.com/LarryEmerson/LEAllFrameworksGif/blob/master/LEImageFrameworks.gif)
### 1-LETableViewPageWithBanner
###### LETableViewPageWithBanner=LEBaseTableView+LE_HMBannerView(滚动图片广告栏)
###### 分为两种显示方式：1-BannerStayAtTheTop 在视图的顶部，不会随着列表的滚动而滚动 2-BannerScrollWithCells 在视图的顶部，但是处在列表中，会随着列表的滚动而滚动

### 2-LEImageCellGroupsWithPicker 朋友圈发布图片时的图片多选控件，点击“+”添加多张图片，点击图片打开预览并且提供删除正在预览的图片的功能。
![](https://github.com/LarryEmerson/LEAllFrameworksGif/blob/master/LEImageCellGroupsWithPicker.png)



### 3-LEImagesGridWithPreview 已发布的朋友圈图片九宫格，点击图片即可顺序全屏预览。
![](https://github.com/LarryEmerson/LEAllFrameworksGif/blob/master/LEImagesGridWithPreview.png)

### 4-LESingleImagePicker 用于设置头像背景等单张图片。
###### 调用方式为静态方法：+(void) leOnSingleImagePickerWithSuperView:(UIView *) superView ViewController:(UIViewController *) viewController Title:(NSString *) title Aspect:(float) aspect Delegate:(id<LEImageCropperDelegate>) delegate;
###### superview 是否为nil表示是否提供弹出窗，用来选择图片来源。
###### aspect=-1时表示不对选择的图片进行裁剪，否则提供裁剪界面 
 

## Author

LarryEmerson, larryemerson@163.com

## License

LEImageFrameworks is available under the MIT license. See the LICENSE file for more info.


