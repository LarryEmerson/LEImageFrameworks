//
//  LEImageCache.h
//  ticket
//
//  Created by emerson larry on 15/11/17.
//  Copyright © 2015年 360cbs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "LEUIFramework.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"

@protocol LEImageDownloadDelegate <NSObject>
-(void) leOnDownloadImageWithError:(NSError *) error;
-(void) leOnDownloadedImageWith:(UIImage *) image;
@end

@interface UIImageView (LEExtensileOnDownload)
-(void) leSetImageWithUrlString:(NSString *) url;
-(void) leSetImageForQiniuWithUrlString:(NSString *) url Width:(int)w Height:(int) h;
-(void) leSetImageForQiniuWithUrlString:(NSString *) url;
-(void) leAddToImageCacheWithUrl:(NSString *) url;
-(void) leSetPlaceholder:(UIImage *) image;
-(void) leSetImageDownloadDelegate:(id<LEImageDownloadDelegate>) delegate;
-(void) leSetCornerRadius:(int) radius;
+(UIImageView *) leGetImageViewWithSettings:(LEAutoLayoutSettings *) settings Image:(UIImage *) image;
+(UIImageView *) leGetImageViewWithSettings:(LEAutoLayoutSettings *) settings Image:(UIImage *) image CornerRadius:(int) radius;
@end

@interface LEImageCache : NSObject
+(instancetype) sharedInstance;
-(void) leAddImage:(UIImage *) image toCacheWithKey:(NSString *) key;
-(UIImage *) leGetImageFromCacheWithKey:(NSString *) key;
-(NSMutableDictionary *) leGetImageCache;
@end
