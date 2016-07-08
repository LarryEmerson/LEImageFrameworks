//
//  LEImagesGridWithPreview.h
//  Letou
//
//  Created by emerson larry on 16/2/25.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEImageCache.h" 
#import "LEFrameworks.h"
#import "LEImagesPreview.h"

@interface LEImagesGrid : UIView
-(id) initWithAutoLayoutSettings:(LEAutoLayoutSettings *)settings Space:(int) space Cols:(int) cols Max:(int) max ImageUrlPrefix:(NSString *) prefix QiniuImageView2:(BOOL) qiniu;
-(void) setImageDataSource:(NSArray *) data; 
@end
