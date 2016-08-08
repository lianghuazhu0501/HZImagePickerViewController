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

@property (weak, nonatomic) IBOutlet UIButton *cropImageButton;

@property (weak, nonatomic) IBOutlet UIButton *selectImageButton;

@property (weak, nonatomic) IBOutlet UIScrollView *showScrollView;

@property (weak, nonatomic) IBOutlet UIButton *selectFinishCropButton;


-(IBAction)clickSelectImageButton:(id)sender;

-(IBAction)clickCropImageButton:(id)sender;

@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.cropImageButton setTitle:@"crop style" forState:UIControlStateNormal];
    [self.selectImageButton setTitle:@"select  style" forState:UIControlStateNormal];
    
}

#pragma mark - IBAction
-(void)clickSelectImageButton:(id)sender{
    
    __weak typeof(self) weakSelf = self;
    
    HZPickerNavigationController *navigationController = [[HZStoryBoardManager sharedPickerStoryboard] instantiateViewControllerWithIdentifier:@"HZPickerNavigationController"];
    navigationController.mediaType = PHAssetMediaTypeImage;
    navigationController.imageStyle = HZPickerImageStyleFilmCameras;
    navigationController.previewingTouchEnable = YES;
    navigationController.maximumNumberOfSelection = 8;
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
        
        weakSelf.showScrollView.hidden = NO;
        weakSelf.selectFinishCropButton.hidden = YES;
        
        for (UIView *subView in weakSelf.showScrollView.subviews) {
            [subView removeFromSuperview];
        }
        
        CGFloat showImageViewX = 0;
        CGFloat showImageViewY = 0;
        CGFloat showImageViewWidth = weakSelf.showScrollView.frame.size.height;
        CGFloat showImageViewHeight = showImageViewWidth;
        
        for (int i=0; i<mediaArray.count; i++) {
            
            showImageViewX = i*showImageViewWidth;
            UIImageView *showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(showImageViewX, showImageViewY, showImageViewWidth, showImageViewHeight)];
            showImageView.clipsToBounds = YES;
            showImageView.contentMode = UIViewContentModeScaleAspectFill;
            [weakSelf.showScrollView addSubview:showImageView];
            
            [[PHImageManager defaultManager] requestImageForAsset:mediaArray[i] targetSize:CGSizeMake(200, 200) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                showImageView.image = result;
            }];
            
        }
        
        [weakSelf.showScrollView setContentSize:CGSizeMake(mediaArray.count*showImageViewWidth, showImageViewHeight)];
        
        NSLog(@"user select finish     %@",mediaArray);  
    };
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

-(void)clickCropImageButton:(id)sender{

    __weak typeof(self) weakSelf = self;
    
    HZPickerNavigationController *navigationController = [[HZStoryBoardManager sharedPickerStoryboard] instantiateViewControllerWithIdentifier:@"HZPickerNavigationController"];
    navigationController.mediaType = PHAssetMediaTypeImage;
    navigationController.imageStyle = HZPickerImageStyleCropSingleImage;
    navigationController.singleImageCropFinishBlock = ^(UIImage *cropImage,PHAsset *asset,CGRect cropRect){
        
        weakSelf.showScrollView.hidden = YES;
        weakSelf.selectFinishCropButton.hidden = NO;
        [weakSelf.selectFinishCropButton setBackgroundImage:cropImage forState:UIControlStateNormal];
        
    };
    
    [self presentViewController:navigationController animated:YES completion:nil];
    
}

-(void)clickButton:(id)sender{
    
    
    
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
