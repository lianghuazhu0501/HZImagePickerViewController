//
//  HZPickerAlbumViewModel.h
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/7/15.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef void(^PHAssetExceedBoundsBlock)(void);

@interface HZPickerAlbumViewModel : NSObject

@property (strong,nonatomic) NSMutableArray *selectMediaDataArray;

@property (strong,nonatomic) id touchColletionViewCell;

@property (copy,nonatomic) PHAssetExceedBoundsBlock exceedBoundsBlock;

-(BOOL)selectionAnyMediaItem:(PHAsset *)asset;

-(CGRect)touchPreviewingCellWithPoint:(CGPoint)location visibleCells:(NSArray *)visibleCells;




@end
