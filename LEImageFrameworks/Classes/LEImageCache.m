//
//  LEImageCache.m
//  ticket
//
//  Created by emerson larry on 15/11/17.
//  Copyright © 2015年 360cbs. All rights reserved.
//

#import "LEImageCache.h"

@implementation UIImageView (LEExtensileOnDownload)
static void * UIImageViewPlaceHolderKey = (void *) @"UIImageViewPlaceHolder";
- (UIImage *) lePlaceholderImage {
    return objc_getAssociatedObject(self, UIImageViewPlaceHolderKey);
}
- (void) setLePlaceholderImage:(UIImage *)lePlaceholderImage{
    objc_setAssociatedObject(self, UIImageViewPlaceHolderKey, lePlaceholderImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self sd_setImageWithURL:nil placeholderImage:lePlaceholderImage];
}
static void * UIImageDownloadDelegateKey = (void *) @"UIImageDownloadDelegateKey";
-(id<LEImageDownloadDelegate>) leImageDownloadDelegate{
    return objc_getAssociatedObject(self, UIImageDownloadDelegateKey);
}
-(void) setLeImageDownloadDelegate:(id<LEImageDownloadDelegate>)leImageDownloadDelegate{
    objc_setAssociatedObject(self, UIImageDownloadDelegateKey, leImageDownloadDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void) leSetImageForQiniuWithUrlString:(NSString *) url Width:(int)w Height:(int) h{
    [self leSetImageWithUrlString:[NSString stringWithFormat:@"%@?imageView2/1/w/%d/h/%d",url,w*(int)LESCREEN_SCALE,h*(int)LESCREEN_SCALE]];
}
-(void) leSetImageForQiniuWithUrlString:(NSString *) url{
    [self leSetImageWithUrlString:[NSString stringWithFormat:@"%@?imageView2/1/w/%d/h/%d",url,(int)self.bounds.size.width*(int)LESCREEN_SCALE,(int)self.bounds.size.height*(int)LESCREEN_SCALE]];
}
-(void) leSetImageWithUrlString:(NSString *) url {
    if(url){
//        UIImage *img=[[LEImageCache sharedInstance] leGetImageFromCacheWithKey:url];
        [self sd_cancelCurrentImageLoad];
        UIImage *img=[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:url];
        if(!img){
            img=[[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:url];
        }
        if(img){
            [self setImage:img];
            if(self.leImageDownloadDelegate&&[self.leImageDownloadDelegate respondsToSelector:@selector(leOnDownloadedImageWith:)]){
                [self.leImageDownloadDelegate leOnDownloadedImageWith:img];
            }
        }else{
            //            LELogObject(url);
            LEWeakSelf(self);
            [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:self.lePlaceholderImage options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                if(error){ 
//                    [weakself setImage:weakself.lePlaceholderImage];
                    if(weakself.leImageDownloadDelegate&&[weakself.leImageDownloadDelegate respondsToSelector:@selector(leOnDownloadImageWithError:)]){
                        [weakself.leImageDownloadDelegate leOnDownloadImageWithError:error];
                    }
                }else if(image){
//                    [[LEImageCache sharedInstance] leAddImage:image toCacheWithKey:imageURL.absoluteString];
                    if(weakself.leImageDownloadDelegate&&[weakself.leImageDownloadDelegate respondsToSelector:@selector(leOnDownloadedImageWith:)]){
                        [weakself.leImageDownloadDelegate leOnDownloadedImageWith:image];
                    }
                }
            }];
        }
    }
}
-(void) leAddToImageCacheWithUrl:(NSString *) url{
    if(self.image){
        [[LEImageCache sharedInstance] leAddImage:self.image toCacheWithKey:url];
//        [[SDImageCache sharedImageCache] storeImage:self.image forKey:url];
    }
}
-(void) leSetPlaceholder:(UIImage *) image{
    self.lePlaceholderImage=image;
}
-(void) leSetImageDownloadDelegate:(id<LEImageDownloadDelegate>) delegate{
    self.leImageDownloadDelegate=delegate;
}
-(void) leSetCornerRadius:(int) radius{
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:radius];
}
+(UIImageView *) leGetImageViewWithSettings:(LEAutoLayoutSettings *) settings Image:(UIImage *) image{
    if(CGSizeEqualToSize(settings.leSize, CGSizeZero)){
        settings.leSize=image.size;
    }
    UIImageView *view=[[UIImageView alloc] initWithAutoLayoutSettings:settings];
    [view setImage:image];
    [view setLePlaceholderImage:image];
    return view;
}
+(UIImageView *) leGetImageViewWithSettings:(LEAutoLayoutSettings *) settings Image:(UIImage *) image CornerRadius:(int) radius{
    UIImageView *img=[self leGetImageViewWithSettings:settings Image:image];
    [img.layer setMasksToBounds:YES];
    [img.layer setCornerRadius:radius];
    return img;
}
@end

@implementation LEImageCache
static NSMutableDictionary *imageCache;
#pragma Singleton
static LEImageCache *theSharedInstance = nil;
+ (instancetype) sharedInstance { @synchronized(self) { if (theSharedInstance == nil) { theSharedInstance = [[self alloc] init];
} } return theSharedInstance; }
+ (id) allocWithZone:(NSZone *)zone { @synchronized(self) { if (theSharedInstance == nil) { theSharedInstance = [super allocWithZone:zone]; return theSharedInstance; } } return nil; }
+ (id) copyWithZone:(NSZone *)zone { return self; }
+ (id) mutableCopyWithZone:(NSZone *)zone { return self; }
//
-(void) leAddImage:(UIImage *) image toCacheWithKey:(NSString *) key{
    [imageCache setObject:image forKey:key];
}
-(UIImage *) leGetImageFromCacheWithKey:(NSString *) key{
    return [imageCache objectForKey:key];
}
-(NSMutableDictionary *) leGetImageCache{
    return imageCache;
}

@end
