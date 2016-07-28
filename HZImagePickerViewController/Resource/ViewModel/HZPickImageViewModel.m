//
//  HZPickImageViewModel.m
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/7/14.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import "HZPickImageViewModel.h"
#import "HZAlbumEntity.h"
#import <Photos/Photos.h>

@implementation HZPickImageViewModel


-(NSMutableArray *)albumArray{
    
    if (![_albumArray isKindOfClass:[NSMutableArray class]]) {
        _albumArray = [NSMutableArray array];
    }else{
        [_albumArray removeAllObjects];
    }
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:NO]];
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:options];
    for (PHAssetCollection *assetCollection in smartAlbums) {
        
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        if (fetchResult.count>0) {
            
            HZAlbumEntity *albumEntity = [[HZAlbumEntity alloc] init];
            albumEntity.fetchResult = fetchResult;
            albumEntity.assetCollection = assetCollection;
            
            if (assetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
                [_albumArray insertObject:albumEntity atIndex:0];
            }else{
                [_albumArray addObject:albumEntity];
            }
        }
        
    }
    
    PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *assetCollection in albums) {
        
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        if (fetchResult.count>0) {
            
            HZAlbumEntity *albumEntity = [[HZAlbumEntity alloc] init];
            albumEntity.fetchResult = fetchResult;
            albumEntity.assetCollection = assetCollection;
            [_albumArray addObject:albumEntity];
        }
        
    }
    
    return _albumArray;
}

@end
