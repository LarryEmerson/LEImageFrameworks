//
//  LEImagesPreview.h
//  LEUIFrameworkDemo
//
//  Created by emerson larry on 16/7/8.
//  Copyright © 2016年 Larry Emerson. All rights reserved.
//
#import <LEFrameworks/LEFrameworks.h> 
#import "LE_PZPhotoView.h"

@interface LEImagesPreview : LEBaseViewController
-(id) initWithImageDataSource:(NSArray *) data CurrentIndex:(NSInteger) index ImageUrlPrefix:(NSString *) prefix QiniuImageView2:(BOOL) qiniu;
@end
