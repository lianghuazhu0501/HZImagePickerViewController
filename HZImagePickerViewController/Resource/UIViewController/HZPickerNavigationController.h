//
//  HZPickerNavigationController.h
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/7/13.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "HZPickerHeader.h"

typedef void(^HZSelectMediaDataFinishBlock)(NSArray *array);

@interface HZPickerNavigationController : UINavigationController

@property (assign, nonatomic) HZPickerImageStyle imageStyle;

@property (assign, nonatomic) PHAssetMediaType mediaType;

@property (assign, nonatomic) BOOL previewingTouchEnable;

@property (assign, nonatomic) NSInteger maximumNumberOfSelection;

@property (copy , nonatomic) HZSelectMediaDataFinishBlock selectMediaDataFinishBlock;

@end
