//
//  HZPreViewSingleImageScrollView.m
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/8/5.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import "HZPreViewSingleImageScrollView.h"

@implementation HZPreViewSingleImageScrollView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.previewImageView = [[UIImageView alloc] init];
    [self addSubview:self.previewImageView];
    
}




@end
