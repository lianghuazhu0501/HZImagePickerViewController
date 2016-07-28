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

typedef void(^SingleTapScrollViewBlock)(void);

@interface HZPreviewImageScrollView : UIScrollView

@property (strong,nonatomic) PHAsset *asset;

@property (strong,nonatomic) UIImageView *previewImageView;

@property (strong,nonatomic) UIActivityIndicatorView *loaddingActivityIndicatorView;

@property (strong,nonatomic) HZPreviewImageViewModel *previewImageViewModel;

@property (copy,nonatomic) SingleTapScrollViewBlock singleTapScrollViewBlock;

@property (weak,nonatomic) IBOutlet NSLayoutConstraint *letLayoutConstraint;

@end
