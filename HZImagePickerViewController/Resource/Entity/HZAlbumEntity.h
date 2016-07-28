//
//  AlbumEntity.h
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/7/14.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface HZAlbumEntity : NSObject

@property (strong,nonatomic) PHFetchResult *fetchResult;

@property (strong,nonatomic) PHAssetCollection *assetCollection;

+(HZAlbumEntity *)filmCameras;



@end
