//
//  HZPreviewImageViewModel.h
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/7/22.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface HZPreviewImageViewModel : NSObject

@property (assign,nonatomic) NSInteger selectedIndex;

@property (strong,nonatomic) PHFetchResult *fetchResult;

@property (assign,nonatomic) BOOL isPreviewFlag;

@property (strong,nonatomic) NSMutableArray *selectMediaDataArray;

@property (strong,nonatomic) NSMutableArray *showMediaDataArray;

@property (copy,nonatomic) NSString *mediaNumberText;


-(PHAsset *)assetFormLayoutConstraint:(NSLayoutConstraint *)letLayouConstraint;

-(PHAsset *)assetFormLayoutConstraint:(NSLayoutConstraint *)letLayouConstraint selectMediaArray:(NSArray *)mediaArray;


@end
