# LEImageFrameworks
## #import "LEImageFrameworks.h"
[![Version](https://img.shields.io/cocoapods/v/LEImageFrameworks.svg?style=flat)](http://cocoapods.org/pods/LEImageFrameworks)
[![License](https://img.shields.io/cocoapods/l/LEImageFrameworks.svg?style=flat)](http://cocoapods.org/pods/LEImageFrameworks)
[![Platform](https://img.shields.io/cocoapods/p/LEImageFrameworks.svg?style=flat)](http://cocoapods.org/pods/LEImageFrameworks)

![](https://github.com/LarryEmerson/LEAllFrameworksGif/blob/master/LEImageFrameworks.gif)


## Frameworks
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

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
ios 7.0
## Installation

LEImageFrameworks is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LEImageFrameworks"
```

## Author

LarryEmerson, larryemerson@163.com

## License

LEImageFrameworks is available under the MIT license. See the LICENSE file for more info.


