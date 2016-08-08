//
//  HZBasePreViewImageScrollView.h
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/8/4.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZPickerHeader.h"

#define kHZDefaultPadding 2.0f
#define kHZBigImageScaleValue 3.0f

@interface HZBasePreViewImageScrollView : UIScrollView<UIScrollViewDelegate>

@property (strong,nonatomic) UIImageView *previewImageView;

#pragma mark - calculateZoomScale
- (void)updateZoomScaleWithGesture:(UIGestureRecognizer *)gestureRecognizer newScale:(CGFloat)newScale;

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;

-(void)scrollViewDidZoom:(UIScrollView *)scrollView;

#pragma mark - Other
-(HZShapeImageType)shapeImageTypeWithImageSize:(CGSize)imageSize;

-(CGRect)calculateShowImageRectWithImageType:(HZShapeImageType)imageType originalImageSize:(CGSize)imageSize;

@end
