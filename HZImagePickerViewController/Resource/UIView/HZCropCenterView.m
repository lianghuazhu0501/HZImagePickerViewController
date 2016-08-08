//
//  HZCropCenterView.m
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/8/4.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import "HZCropCenterView.h"
#import "HZPickerHeader.h"

@implementation HZCropCenterView

-(void)drawRect:(CGRect)rect{
    
    CGFloat viewWidth = CGRectGetWidth(self.frame);
    CGFloat viewHeight = CGRectGetHeight(self.frame);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(context, 0, 0, 0, 0.8f);
    CGContextFillRect(context, CGRectMake(0, 0, viewWidth, viewHeight));
    CGContextFillPath(context);

    if (CGSizeEqualToSize(self.cropSize, CGSizeZero)) {
        self.cropSize = CGSizeMake(viewWidth, viewWidth);
    }else{
        
        CGFloat cropSizeWidth = self.cropSize.width;
        CGFloat cropSizeHeight = self.cropSize.width;
        
        if (cropSizeWidth>viewWidth) {
            cropSizeWidth = viewWidth;
        }
        
        if (cropSizeHeight>viewHeight) {
            cropSizeHeight = viewHeight;
        }
        
        self.cropSize = CGSizeMake(cropSizeWidth, cropSizeHeight);
        
    }
    
    CGFloat clearRectangularX = (viewWidth - self.cropSize.width)*0.5f;
    CGFloat clearRectangularY = (viewHeight - self.cropSize.height)*0.5f;
    CGFloat clearRectangularWidth = self.cropSize.width;
    CGFloat clearRectangularHeight = self.cropSize.height;
    
    CGContextClearRect(context, CGRectMake(clearRectangularX, clearRectangularY , clearRectangularWidth, clearRectangularHeight));
    
}


@end
