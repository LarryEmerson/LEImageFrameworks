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
-(void) onDownloadImageWithError:(NSError *) error;
-(void) onDownloadedImageWith:(UIImage *) image;
@end

@interface UIImageView (LoadImageWithUrl)
@property (nonatomic) UIImage *lePlaceholderImage;
@property (nonatomic) id<LEImageDownloadDelegate> leImageDownloadDelegate;
-(void) leSetImageWithUrlString:(NSString *) url;
-(void) leSetImageForQiniuWithUrlString:(NSString *) url Width:(int)w Height:(int) h;
-(void) leSetImageForQiniuWithUrlString:(NSString *) url;
-(void) leAddToImageCacheWithUrl:(NSString *) url;

-(void) leSetCornerRadius:(int) radius;
+(UIImageView *) leGetImageViewWithSettings:(LEAutoLayoutSettings *) settings Image:(UIImage *) image;
+(UIImageView *) leGetImageViewWithSettings:(LEAutoLayoutSettings *) settings Image:(UIImage *) image CornerRadius:(int) radius;
@end

@interface LEImageCache : NSObject
+(instancetype) sharedInstance;

-(void) addImage:(UIImage *) image toCacheWithKey:(NSString *) key;
-(UIImage *) getImageFromCacheWithKey:(NSString *) key;
-(NSMutableDictionary *) getImageCache;
@end
