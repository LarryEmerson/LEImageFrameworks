//
//  LEShowHDImage.h
//  ticket
//
//  Created by Larry Emerson on 14-8-14.
//  Copyright (c) 2014年 360CBS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LE_PZPhotoView.h" 
#import <LEFrameworks/LEFrameworks.h>
@interface LEShowHDImage : UIView<UIScrollViewDelegate,LE_PZPhotoViewDelegate>
- (id)initWithUrl:(NSString *) url AndAspect:(float) aspect;
+ (void) leShowHDImageWithUrl:(NSString *) url Aspect:(float) aspect; 
@end
