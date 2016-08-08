//
//  HZPickerAlbumCollectionViewCell.m
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/7/15.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import "HZPickerAlbumCollectionViewCell.h"
#import "HZPickerHeader.h"
#import "NSString+HZAddition.h"
#import "HZAppearanceManager.h"

#define kContrastWidth (120*2.0f)

@interface HZPickerAlbumCollectionViewCell()

@property (assign,nonatomic) CGFloat contrastImageWidth;

@property (strong,nonatomic) UIImage *videoIconImage;

@property (strong,nonatomic) UIImage *audioIconImage;

@property (assign,nonatomic) PHImageRequestID imageRequestID;

@property (weak,nonatomic) IBOutlet UIButton *selectedButton;

@property (weak,nonatomic) IBOutlet UIButton *thumbnailImageButton;

@property (weak,nonatomic) IBOutlet UIImageView *thumbnailImageView;

@property (weak,nonatomic) IBOutlet UIView *otherInfoView;

@property (weak,nonatomic) IBOutlet UILabel *timeLabel;

@property (weak,nonatomic) IBOutlet UIButton *flagImageButton;

-(IBAction)clickSelectedButton:(id)sender;

-(IBAction)clickImageBackgroundButton:(id)sender;

@end

@implementation HZPickerAlbumCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageRequestID = -1;
    
    self.contrastImageWidth = kHZScreenSize.width/375.0f*kContrastWidth;
    
    self.otherInfoView.backgroundColor = kHZRGBA(0, 0, 0, 0.8f);
    
    self.thumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.selectedButton.hidden = YES;
    [self.selectedButton setImage:[UIImage imageNamed:@"hz_unSelect_image_item"] forState:UIControlStateNormal];
    [self.selectedButton setImage:[UIImage imageNamed:@"hz_select_image_item"] forState:UIControlStateSelected];
    
    self.videoIconImage = [[UIImage imageNamed:@"hz_icon_video"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.audioIconImage = [[UIImage imageNamed:@"hz_icon_audio"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}

-(void)setValueWithAsset:(PHAsset *)asset{

    __weak typeof(self) weakSelf = self;
    
    self.asset = asset;
    self.thumbnailImageView.image = nil;
    self.selectedButton.selected = [self.albumViewModel.selectMediaDataArray containsObject:self.asset];
    
    if ([HZAppearanceManager sharedManager].imageStyle == HZPickerImageStyleCropSingleImage ) {
        
    }else{
        self.selectedButton.hidden = !([HZAppearanceManager sharedManager].mediaType == asset.mediaType);
    }
    
    if (self.imageRequestID != -1) {
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
    
    @autoreleasepool {
        
        PHImageRequestOptions *opt = [[PHImageRequestOptions alloc]init];
        opt.synchronous = NO;
        opt.resizeMode = PHImageRequestOptionsResizeModeFast;
        opt.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;

        PHImageManager *imageManager = [PHImageManager defaultManager];
        [imageManager requestImageForAsset:asset targetSize:CGSizeMake(self.contrastImageWidth, self.contrastImageWidth) contentMode:PHImageContentModeAspectFill options:opt resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            if (result) {
                weakSelf.thumbnailImageView.image = result;
            }
            
            if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaType == PHAssetMediaTypeAudio){
                
                weakSelf.otherInfoView.hidden = NO;
                weakSelf.timeLabel.text = [NSString durationConvertMinutes:asset.duration];
                
                if (asset.mediaType == PHAssetMediaTypeVideo) {
                    [weakSelf.flagImageButton setImage:weakSelf.videoIconImage forState:UIControlStateNormal];
                }else if (asset.mediaType == PHAssetMediaTypeAudio){
                    [weakSelf.flagImageButton setImage:weakSelf.audioIconImage forState:UIControlStateNormal];
                }
                
            }else{
                weakSelf.otherInfoView.hidden = YES;
            }
            
        }];
        
    }
    
}

-(void)setSelectedWithButton:(BOOL)flag{
    self.selectedButton.selected = flag;
}

#pragma mark - 点击事件
-(void)clickSelectedButton:(UIButton *)sender{

    sender.selected = [self.albumViewModel selectionAnyMediaItem:self.asset];

    self.clickSelectedButtonBlock();

}

-(void)clickImageBackgroundButton:(UIButton *)sender{
    self.clickBackgroundButtonBlock(self.asset);
}

@end
