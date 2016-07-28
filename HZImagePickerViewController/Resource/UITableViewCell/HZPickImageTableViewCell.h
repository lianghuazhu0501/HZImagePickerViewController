//
//  HZPickImageTableViewCell.h
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/7/14.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZAlbumEntity.h"

@interface HZPickImageTableViewCell : UITableViewCell

@property (weak,nonatomic) IBOutlet UIView *allView;
@property (weak,nonatomic) IBOutlet NSLayoutConstraint *allViewWidthLayoutConstraint;

@property (weak,nonatomic) IBOutlet UIImageView *screenshotsImageView;

@property (weak,nonatomic) IBOutlet UILabel *albumNameLabel;

@property (weak,nonatomic) IBOutlet UILabel *photoCountLabel;

-(void) setValueWithAlbumEnity:(HZAlbumEntity *)albumEntity;

@end
