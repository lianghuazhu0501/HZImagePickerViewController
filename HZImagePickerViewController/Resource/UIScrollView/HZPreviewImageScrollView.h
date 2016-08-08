//
//  HZPreviewImageScrollView.h
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/7/20.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "HZPreviewImageViewModel.h"
#import "HZBasePreViewImageScrollView.h"

typedef void(^SingleTapScrollViewBlock)(void);

@interface HZPreviewImageScrollView : HZBasePreViewImageScrollView

@property (strong,nonatomic) PHAsset *asset;

@property (strong,nonatomic) HZPreviewImageViewModel *previewImageViewModel;

@property (copy,nonatomic) SingleTapScrollViewBlock singleTapScrollViewBlock;

@property (weak,nonatomic) IBOutlet NSLayoutConstraint *letLayoutConstraint;

@end
