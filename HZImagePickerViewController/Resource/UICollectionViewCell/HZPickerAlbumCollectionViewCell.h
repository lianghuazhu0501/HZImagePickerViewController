//
//  HZPickerAlbumCollectionViewCell.h
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/7/15.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "HZPickerAlbumViewModel.h"

typedef void(^ClickSelectedButtonBlock)();

typedef void (^ClickBackgroundButtonBlock)(PHAsset *asset);

@interface HZPickerAlbumCollectionViewCell : UICollectionViewCell

@property (strong,nonatomic) PHAsset *asset;

@property (weak,nonatomic) HZPickerAlbumViewModel *albumViewModel;

@property (copy,nonatomic) ClickSelectedButtonBlock clickSelectedButtonBlock;

@property (copy,nonatomic) ClickBackgroundButtonBlock clickBackgroundButtonBlock;


-(void)setValueWithAsset:(PHAsset *)asset;

-(void)setSelectedWithButton:(BOOL)flag;

@end
