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
#import <UIImageView+WebCache.h>

@protocol LEImageDownloadDelegate <NSObject>
-(void) onDownloadImageWithError:(NSError *) error;
-(void) onDownloadedImageWith:(UIImage *) image;
@end

@interface UIImageView (LoadImageWithUrl)
@property (nonatomic) UIImage *placeholderImage;
@property (nonatomic) id<LEImageDownloadDelegate> imageDownloadDelegate;
-(void) setImageWithUrlString:(NSString *) url;
-(void) setImageForQiniuWithUrlString:(NSString *) url Width:(int)w Height:(int) h;
-(void) setImageForQiniuWithUrlString:(NSString *) url;
-(void) addToImageCacheWithUrl:(NSString *) url;

-(void) setCornerRadius:(int) radius;
+(UIImageView *) getUIImageViewWithSettings:(LEAutoLayoutSettings *) settings Image:(UIImage *) image;
+(UIImageView *) getUIImageViewWithSettings:(LEAutoLayoutSettings *) settings Image:(UIImage *) image CornerRadius:(int) radius;
@end

@interface LEImageCache : NSObject
+(instancetype) sharedInstance;

-(void) addImage:(UIImage *) image toCacheWithKey:(NSString *) key;
-(UIImage *) getImageFromCacheWithKey:(NSString *) key;
-(NSMutableDictionary *) getImageCache;
@end
