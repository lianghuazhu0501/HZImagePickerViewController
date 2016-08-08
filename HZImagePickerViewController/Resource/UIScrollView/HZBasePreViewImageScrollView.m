//
//  HZBasePreViewImageScrollView.m
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/8/4.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import "HZBasePreViewImageScrollView.h"

@interface HZBasePreViewImageScrollView()

@end


@implementation HZBasePreViewImageScrollView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.delegate = self;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
}

#pragma mark - calculateZoomScale
- (void)updateZoomScaleWithGesture:(UIGestureRecognizer *)gestureRecognizer newScale:(CGFloat)newScale {
    CGPoint center = [gestureRecognizer locationInView:gestureRecognizer.view];
    [self updateZoomScale:newScale withCenter:center];
}

- (void)updateZoomScale:(CGFloat)newScale withCenter:(CGPoint)center {
    
    assert(newScale >= self.minimumZoomScale);
    assert(newScale <= self.maximumZoomScale);
    
    if (self.zoomScale != newScale) {
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:center];
        [self zoomToRect:zoomRect animated:YES];
    }
    
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    assert(scale >= self.minimumZoomScale);
    assert(scale <= self.maximumZoomScale);
    
    CGRect zoomRect;
    zoomRect.size.width = self.frame.size.width / scale;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
    
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.previewImageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    CGSize viewSize = self.previewImageView.frame.size;
    CGPoint centerPoint;
    
    if (viewSize.width<=CGRectGetWidth(self.bounds) && viewSize.height<=CGRectGetHeight(self.bounds)) {
        
        centerPoint = CGPointMake(CGRectGetWidth(self.bounds)*0.5f, CGRectGetHeight(self.bounds)*0.5f);
        
    }else if (viewSize.width>=CGRectGetWidth(self.bounds) && viewSize.height>=CGRectGetHeight(self.bounds) ){
        
        centerPoint = CGPointMake(scrollView.contentSize.width*0.5f, scrollView.contentSize.height*0.5f);
        
    }else if (viewSize.width<=CGRectGetWidth(self.bounds) && viewSize.height>=CGRectGetHeight(self.bounds) ){
        
        centerPoint = CGPointMake(CGRectGetWidth(self.bounds)*0.5f, scrollView.contentSize.height*0.5f);
        
    }else if (viewSize.width>=CGRectGetWidth(self.bounds) && viewSize.height<=CGRectGetHeight(self.bounds)){
        
        centerPoint = CGPointMake(scrollView.contentSize.width*0.5f, CGRectGetHeight(self.bounds)*0.5f);
        
    }
    
    self.previewImageView.center = centerPoint;
    
}

#pragma mark - Other
-(HZShapeImageType)shapeImageTypeWithImageSize:(CGSize)imageSize{
    
    CGFloat imageScale = 1.5f;
    CGFloat imageWHScale = kHZBigImageScaleValue;
    
    HZShapeImageType shapeImageType = HZShapeImageTypeNone;
    
    if (imageSize.width == imageSize.height) {
        shapeImageType = HZShapeImageTypeSquare;
    }else if(imageSize.height>imageSize.width){
        
        if (imageSize.height>=CGRectGetHeight(self.frame)*imageScale && (imageSize.height/imageSize.width)> imageWHScale) {
            shapeImageType = HZShapeImageTypeLongHeight;
        }else{
            shapeImageType = HZShapeImageTypeHeight;
        }
        
    }else if (imageSize.width>imageSize.height){
        
        if (imageSize.width>=CGRectGetWidth(self.frame)*imageScale && (imageSize.width/imageSize.height)> imageWHScale) {
            shapeImageType = HZShapeImageTypeLongWidth;
        }else{
            shapeImageType = HZShapeImageTypeWidth;
        }
        
    }
    return shapeImageType;
}

-(CGRect)calculateShowImageRectWithImageType:(HZShapeImageType)imageType originalImageSize:(CGSize)imageSize{
    
    CGFloat originalScreenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat originalScreenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    
    CGFloat imageInitializeX = 0;
    CGFloat imageInitializeY = 0;
    CGFloat imageInitializeWidth = 0;
    CGFloat imageInitializeHeight = 0;
    
    if (imageType == HZShapeImageTypeSquare) {
        
        if (imageSize.width>=originalScreenWidth) {
            imageInitializeWidth = originalScreenWidth - kHZDefaultPadding;
        }else{
            imageInitializeWidth = imageSize.width*0.5f;
        }
        
        imageInitializeHeight = imageInitializeWidth;
        imageInitializeX = (originalScreenWidth - imageInitializeWidth)*0.5f;
        imageInitializeY = (originalScreenHeight - imageInitializeWidth)*0.5f;
        
    }else if(imageType == HZShapeImageTypeHeight || imageType == HZShapeImageTypeLongHeight){
        
        if (imageSize.width>=originalScreenWidth && imageSize.height >= originalScreenHeight) {
            
            imageInitializeWidth = originalScreenWidth - kHZDefaultPadding;
            imageInitializeHeight = imageSize.height*imageInitializeWidth/imageSize.width;
            
        }else if (imageSize.width<=originalScreenWidth && imageSize.height>=originalScreenHeight){
            
            imageInitializeWidth = imageSize.width*0.9f;
            imageInitializeHeight = imageSize.height*imageInitializeWidth/imageSize.width;
            
        }else if (imageSize.width<=originalScreenWidth && imageSize.height<=originalScreenHeight){
            
            imageInitializeWidth = imageSize.width*0.9f;
            imageInitializeHeight = imageSize.height*imageInitializeWidth/imageSize.width;
            
        }else if (imageSize.width>=originalScreenWidth && imageSize.height<=originalScreenHeight){
            
            imageInitializeWidth = originalScreenWidth - kHZDefaultPadding;
            imageInitializeHeight = imageSize.height*imageInitializeWidth/imageSize.width;
            
        }
        
        imageInitializeX = (originalScreenWidth - imageInitializeWidth)*0.5f;
        if (imageInitializeHeight>originalScreenHeight) {
            imageInitializeY = 0;
        }else{
            imageInitializeY = (originalScreenHeight - imageInitializeHeight)*0.5f;
        }
        
    }else if(imageType == HZShapeImageTypeWidth || imageType == HZShapeImageTypeLongWidth){
        
        if (imageSize.width <= originalScreenWidth && imageSize.height <= originalScreenHeight) {
            
            imageInitializeWidth = originalScreenWidth - kHZDefaultPadding;
            imageInitializeHeight = imageSize.height*imageInitializeWidth/imageSize.width;
            
            imageInitializeX = (originalScreenWidth - imageInitializeWidth)*0.5f;
            imageInitializeY = (originalScreenHeight - imageInitializeHeight)*0.5f;
            
        }else if (imageSize.width >= originalScreenWidth && imageSize.height >= originalScreenHeight){
            
            if (imageType == HZShapeImageTypeWidth) {
                imageInitializeWidth = originalScreenWidth - kHZDefaultPadding;
            }else{
                imageInitializeWidth = imageSize.width*0.5f;
            }
            
            imageInitializeHeight = imageSize.height*imageInitializeWidth/imageSize.width;
            imageInitializeX = (originalScreenWidth - imageInitializeWidth)*0.5f;
            
            if (imageInitializeHeight<originalScreenHeight) {
                imageInitializeY = (originalScreenHeight - imageInitializeHeight)*0.5f;
            }
            
        }else if (imageSize.width >= originalScreenWidth && imageSize.height <= originalScreenHeight){
            
            if (imageType == HZShapeImageTypeWidth) {
                imageInitializeWidth = originalScreenWidth - kHZDefaultPadding;
            }else{
                imageInitializeWidth = imageSize.width*0.5f;
            }
            
            imageInitializeHeight = imageSize.height*imageInitializeWidth/imageSize.width;
            imageInitializeY = (originalScreenHeight - imageInitializeHeight)*0.5f;
            imageInitializeX = (originalScreenWidth - imageInitializeWidth)*0.5f;
            
        }
        
        if (imageInitializeX<0) {
            imageInitializeX = 0;
        }
        
    }
    
    return CGRectMake(imageInitializeX, imageInitializeY, imageInitializeWidth, imageInitializeHeight);
}

@end
