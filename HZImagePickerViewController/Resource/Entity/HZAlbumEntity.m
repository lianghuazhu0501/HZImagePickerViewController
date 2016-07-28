//
//  AlbumEntity.m
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/7/14.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import "HZAlbumEntity.h"

@implementation HZAlbumEntity

+(HZAlbumEntity *)filmCameras{

    HZAlbumEntity *albumEntity;
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *assetCollection in smartAlbums) {
        
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        if (assetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary && fetchResult.count>0) {
            
            albumEntity = [[HZAlbumEntity alloc] init];
            albumEntity.fetchResult = fetchResult;
            albumEntity.assetCollection = assetCollection;
            
        }
        
    }
    
    return albumEntity;
    
}

@end
