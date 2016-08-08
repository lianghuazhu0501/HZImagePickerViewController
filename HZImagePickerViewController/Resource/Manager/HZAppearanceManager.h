//
//  HZAppearanceManager.h
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/7/18.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "HZPickerHeader.h"


@interface HZAppearanceManager : NSObject

@property (assign, nonatomic) HZPickerImageStyle imageStyle;

@property (assign, nonatomic) BOOL previewingTouchEnable;

@property (assign, nonatomic) PHAssetMediaType mediaType;

@property (assign, nonatomic) NSInteger maximumNumberOfSelection;

@property (assign, nonatomic) CGSize cropImageSize;

+(HZAppearanceManager *)sharedManager;

@end
