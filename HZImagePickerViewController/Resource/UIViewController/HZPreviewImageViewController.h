//
//  HZPreviewImageViewController.h
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/7/18.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "HZPreviewImageScrollView.h"
#import "HZPickerAlbumViewModel.h"

@interface HZPreviewImageViewController : UIViewController<UIScrollViewDelegate>

@property (assign,nonatomic) NSInteger selectedIndex;

@property (strong,nonatomic) PHFetchResult *fetchResult;

@property (assign,nonatomic) BOOL is3DTouchFlag;

@property (assign,nonatomic) BOOL isPreViewFlag;

@property (strong,nonatomic) HZPickerAlbumViewModel *albumViewModel;


@end
