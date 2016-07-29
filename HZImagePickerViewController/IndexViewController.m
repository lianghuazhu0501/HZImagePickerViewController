//
//  IndexViewController.m
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/7/13.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import "IndexViewController.h"
#import "HZPickerNavigationController.h"
#import "HZStoryBoardManager.h"
#import <Photos/Photos.h>
#import "HZAlbumEntity.h"

@interface IndexViewController ()


@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - IBAction Click
-(void)clickButton:(id)sender{
    
    HZPickerNavigationController *navigationController = [[HZStoryBoardManager sharedPickerStoryboard] instantiateViewControllerWithIdentifier:@"HZPickerNavigationController"];
    navigationController.mediaType = PHAssetMediaTypeImage;
    navigationController.maximumNumberOfSelection = 9;
    navigationController.imageStyle = HZPickerImageStyleFilmCameras;
    navigationController.previewingTouchEnable = YES;
    navigationController.selectMediaDataFinishBlock = ^(NSArray *mediaArray){
        
        /*
         * mediaArray of object always PHAsset
         *if choose mediaType is PHAssetMediaTypeImage , you can use the following code
         
         *[[PHImageManager defaultManager] requestImageForAsset:<#(nonnull PHAsset *)#> targetSize:<#(CGSize)#> contentMode:<#(PHImageContentMode)#> options:<#(nullable PHImageRequestOptions *)#> resultHandler:<#^(UIImage * _Nullable result, NSDictionary * _Nullable info)resultHandler#>]
         
         * or
         
         *[[PHImageManager defaultManager] requestImageDataForAsset:<#(nonnull PHAsset *)#> options:<#(nullable PHImageRequestOptions *)#> resultHandler:<#^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info)resultHandler#>]
         
         
         
         
          *if choose mediaType is PHAssetMediaTypeVideo , you can use the following code
         
         *[[PHImageManager defaultManager] requestPlayerItemForVideo:<#(nonnull PHAsset *)#> options:<#(nullable PHVideoRequestOptions *)#> resultHandler:<#^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info)resultHandler#>]
         
         *or
         
         *[PHImageManager defaultManager] requestAVAssetForVideo:<#(nonnull PHAsset *)#> options:<#(nullable PHVideoRequestOptions *)#> resultHandler:<#^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info)resultHandler#>
         
         */
        
        NSLog(@"user select finish     %@",mediaArray);
        
        
    };
    [self presentViewController:navigationController animated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
