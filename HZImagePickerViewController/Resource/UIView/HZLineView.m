//
//  HZLineView.m
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/7/18.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import "HZLineView.h"
#import "HZPickerHeader.h"

@implementation HZLineView

- (void)drawRect:(CGRect)rect {
    self.backgroundColor = [UIColor clearColor];
    float lineViewX = self.lineViewX;
    float lineViewHeight = 0.0f;
    float lineViewY = 0.0f;
    
    if (kHZScreenSize.width == 375.0f) {
        lineViewHeight = 0.4f;
        lineViewY = 0.7f;
    }else{
        lineViewHeight = 0.5f;
        lineViewY = 0.5f;
    }
    
    if (self.portrayTopFlag) {
        lineViewY = 0.1f;
    }else{
        lineViewY = self.frame.size.height - lineViewHeight;
    }
    if (self.lineViewHeight>0) {
        lineViewHeight = self.lineViewHeight;
    }
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextRef, lineViewHeight);
    CGContextSetShouldAntialias(contextRef, NO);
    if ([self.lineTextColor isKindOfClass:[UIColor class]]) {
        [self.lineTextColor set];
    }else{
        [kHZRGBA(222, 222, 222, 1) set];
    }
    CGContextMoveToPoint(contextRef, lineViewX, lineViewY);
    CGContextAddLineToPoint(contextRef, self.frame.size.width, lineViewY);
    CGContextStrokePath(contextRef);
}

@end
