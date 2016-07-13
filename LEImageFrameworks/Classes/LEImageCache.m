//
//  LEImageCache.m
//  ticket
//
//  Created by emerson larry on 15/11/17.
//  Copyright © 2015年 360cbs. All rights reserved.
//

#import "LEImageCache.h"

@implementation UIImageView (LoadImageWithUrl)
static void * UIImageViewPlaceHolderKey = (void *) @"UIImageViewPlaceHolder";
- (UIImage *) placeholderImage {
    return objc_getAssociatedObject(self, UIImageViewPlaceHolderKey);
}
- (void) setPlaceholderImage:(UIImage *)placeholderImage{
    objc_setAssociatedObject(self, UIImageViewPlaceHolderKey, placeholderImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self sd_setImageWithURL:nil placeholderImage:placeholderImage];
}
static void * UIImageDownloadDelegateKey = (void *) @"UIImageDownloadDelegateKey";
-(id<LEImageDownloadDelegate>) imageDownloadDelegate{
    return objc_getAssociatedObject(self, UIImageDownloadDelegateKey);
}
-(void) setImageDownloadDelegate:(id<LEImageDownloadDelegate>)imageDownloadDelegate{
    objc_setAssociatedObject(self, UIImageDownloadDelegateKey, imageDownloadDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void) setImageForQiniuWithUrlString:(NSString *) url Width:(int)w Height:(int) h{
    [self setImageWithUrlString:[NSString stringWithFormat:@"%@?imageView2/1/w/%d/h/%d",url,w*[LEUIFramework sharedInstance].curScreenScale,h*[LEUIFramework sharedInstance].curScreenScale]];
}
-(void) setImageForQiniuWithUrlString:(NSString *) url{
    [self setImageWithUrlString:[NSString stringWithFormat:@"%@?imageView2/1/w/%d/h/%d",url,(int)self.bounds.size.width*[LEUIFramework sharedInstance].curScreenScale,(int)self.bounds.size.height*[LEUIFramework sharedInstance].curScreenScale]];
}
-(void) setImageWithUrlString:(NSString *) url {
    if(url){
        UIImage *img=[[LEImageCache sharedInstance] getImageFromCacheWithKey:url];
        if(img){
            [self setImage:img];
        }else{
            //            NSLogObject(url);
            [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:self.placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                if(error){
                    [self setImage:self.placeholderImage];
                    if(self.imageDownloadDelegate&&[self.imageDownloadDelegate respondsToSelector:@selector(onDownloadImageWithError:)]){
                        [self.imageDownloadDelegate onDownloadImageWithError:error];
                    }
                }else if(image){
                    [[LEImageCache sharedInstance] addImage:image toCacheWithKey:imageURL.absoluteString];
                    if(self.imageDownloadDelegate&&[self.imageDownloadDelegate respondsToSelector:@selector(onDownloadedImageWith:)]){
                        [self.imageDownloadDelegate onDownloadedImageWith:image];
                    }
                }
            }];
        }
    }
}
-(void) addToImageCacheWithUrl:(NSString *) url{
    if(self.image){
        [[LEImageCache sharedInstance] addImage:self.image toCacheWithKey:url];
    }
}
-(void) setCornerRadius:(int) radius{
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:radius];
}
+(UIImageView *) getUIImageViewWithSettings:(LEAutoLayoutSettings *) settings Image:(UIImage *) image{
    if(CGSizeEqualToSize(settings.leSize, CGSizeZero)){
        settings.leSize=image.size;
    }
    UIImageView *view=[[UIImageView alloc] initWithAutoLayoutSettings:settings];
    [view setImage:image];
    [view setPlaceholderImage:image];
    return view;
}
+(UIImageView *) getUIImageViewWithSettings:(LEAutoLayoutSettings *) settings Image:(UIImage *) image CornerRadius:(int) radius{
    UIImageView *img=[self getUIImageViewWithSettings:settings Image:image];
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
-(void) addImage:(UIImage *) image toCacheWithKey:(NSString *) key{
    [imageCache setObject:image forKey:key];
}
-(UIImage *) getImageFromCacheWithKey:(NSString *) key{
    return [imageCache objectForKey:key];
}
-(NSMutableDictionary *) getImageCache{
    return imageCache;
}

@end
