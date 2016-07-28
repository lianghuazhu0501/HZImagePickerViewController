//
//  HZPickImageTableViewCell.m
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/7/14.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import "HZPickImageTableViewCell.h"
#import "HZPickerHeader.h"

@implementation HZPickImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.allViewWidthLayoutConstraint.constant = kHZScreenSize.width;
    
    self.screenshotsImageView.clipsToBounds = YES;
    self.screenshotsImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.albumNameLabel.font = [UIFont boldSystemFontOfSize:16];
    self.albumNameLabel.textColor = [UIColor darkGrayColor];
    
    self.photoCountLabel.font = [UIFont systemFontOfSize:14];
    self.photoCountLabel.textColor = [UIColor lightGrayColor];
    
}

-(void) setValueWithAlbumEnity:(HZAlbumEntity *)albumEntity{
    
    if ([albumEntity isKindOfClass:[HZAlbumEntity class]]) {
        
        __weak typeof(self) weakSelf = self;
        
        self.albumNameLabel.text = albumEntity.assetCollection.localizedTitle;
        
        self.photoCountLabel.text = [NSString stringWithFormat:@"(%ld)",albumEntity.fetchResult.count];
        
        @autoreleasepool {
            
            PHAsset *asset = albumEntity.fetchResult.lastObject;
            PHImageRequestOptions *opt = [[PHImageRequestOptions alloc]init];
            opt.synchronous = NO;
            opt.resizeMode = PHImageRequestOptionsResizeModeFast;
            opt.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            
            PHImageManager *imageManager = [PHImageManager defaultManager];
            [imageManager requestImageForAsset:asset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeAspectFill options:opt resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                
                if (result) {
                    weakSelf.screenshotsImageView.image = result;
                }
                
            }];
            
        }
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
