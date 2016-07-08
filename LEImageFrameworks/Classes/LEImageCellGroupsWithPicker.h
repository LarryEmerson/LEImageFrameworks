//
//  ImagePicker.h
//  Letou
//
//  Created by emerson larry on 16/2/26.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEImageCache.h"  
#import "LEFrameworks.h"
@interface LEImagePickerCell : UIImageView 
@end
@interface LEImageCellGroupsWithPicker : UIView
@property (nonatomic) NSMutableArray *curCellCache;
-(id) initWithAutoLayoutSettings:(LEAutoLayoutSettings *)settings Space:(int) space Cols:(int) cols Max:(int) max AddImage:(UIImage *) add DeleteImage:(UIImage *) delete ViewController:(UIViewController *) viewController;
@end
