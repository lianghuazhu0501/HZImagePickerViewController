//
//  HZPreviewSingleImageViewController.h
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/8/4.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZPickerAlbumViewModel.h"
#import <Photos/Photos.h>

@interface HZPreviewSingleImageViewController : UIViewController

@property (strong,nonatomic) PHAsset *asset;

@property (strong,nonatomic) HZPickerAlbumViewModel *albumViewModel;

@end
