//
//  HZPreviewImageScrollView.m
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/7/20.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import "HZPreviewImageScrollView.h"
#import "NSLayoutConstraint+HZAddition.h"
#import "HZPickerHeader.h"

#define kDefaultPadding 2.0f
#define kDefaultAnmationDuration 0.35f
#define kBigImageScaleValue 3.0f

@interface HZPreviewImageScrollView()<UIScrollViewDelegate>

@property (assign,nonatomic) PHImageRequestID imageRequestID;

@property (strong,nonatomic) UITapGestureRecognizer *singleTapGestureRecognizer;

@property (strong,nonatomic) UITapGestureRecognizer *doubleGestureRecognizer;

@end

@implementation HZPreviewImageScrollView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.delegate = self;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    self.imageRequestID = -1;
    
    self.loaddingActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self addSubview:self.loaddingActivityIndicatorView];
    
    [NSLayoutConstraint addCenterXConstraintToView:self.loaddingActivityIndicatorView superView:self layoutRelation:NSLayoutRelationEqual constantValue:0];
    [NSLayoutConstraint addCenterYConstraintToView:self.loaddingActivityIndicatorView superView:self layoutRelation:NSLayoutRelationEqual constantValue:0];
    
    
    
}

-(void)setAsset:(PHAsset *)asset{
    
    if (asset) {
        
        _asset = asset;
        if (self.imageRequestID != -1) {
            [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
        }
        
        [self createPreviewImageView];
        
        __weak typeof(self) weakSelf = self;
        CGFloat imageWidth = asset.pixelWidth;
        CGFloat imageHeight = asset.pixelHeight;
        
        CGSize originalImageSize = CGSizeMake(imageWidth, imageHeight);
        
        PHImageManager *imageManager = [PHImageManager defaultManager];
        self.imageRequestID = [imageManager requestImageForAsset:asset targetSize:originalImageSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            HZShapeImageType imageType = [weakSelf shapeImageTypeWithImageSize:originalImageSize];
            BOOL imageWasOriginalSizeFlag = CGSizeEqualToSize(result.size, originalImageSize);
            BOOL imageLongSizeFlag = (imageType == HZRectangleImageForLongHeightType || imageType == HZRectangleImageForLongWidthType);
            
            if (weakSelf.letLayoutConstraint.constant == kHZScreenSize.width) {

                if (imageLongSizeFlag) {
                    
                    if (imageWasOriginalSizeFlag) {
                        
                        __strong typeof(weakSelf) strongSelf = weakSelf;
                        strongSelf.loaddingActivityIndicatorView.hidden = YES;
                        [strongSelf generateImageViewWithImage:result imageSize:originalImageSize imageType:imageType];
                        
                    }else{
                        
                        weakSelf.loaddingActivityIndicatorView.hidden = NO;
                        [weakSelf.loaddingActivityIndicatorView startAnimating];
                        
                    }
                    
                }else{
                    
                    weakSelf.loaddingActivityIndicatorView.hidden = YES;
                    [weakSelf generateImageViewWithImage:result imageSize:originalImageSize imageType:imageType];
                    
                }
                
            }else{
                
                if (imageLongSizeFlag) {
                    
                    weakSelf.loaddingActivityIndicatorView.hidden = NO;
                    [weakSelf.loaddingActivityIndicatorView startAnimating];
                    
                }else{
                    
                    weakSelf.loaddingActivityIndicatorView.hidden = YES;
                    if (![weakSelf.previewImageView.image isKindOfClass:[UIImage class]]) {
                        [weakSelf generateImageViewWithImage:result imageSize:originalImageSize imageType:imageType];
                    }
                    
                }
                
            }
            
        }];
        
    }
    
}

#pragma mark - UIGestureRecognizer
- (void)singleTap:(UIGestureRecognizer *)gestureRecognizer{
    self.singleTapScrollViewBlock();
}

- (void)doubleTap:(UIGestureRecognizer *)gestureRecognizer{
    
    if (self.zoomScale == self.maximumZoomScale) {
        [self updateZoomScaleWithGesture:gestureRecognizer newScale:self.minimumZoomScale];
    }else {
        CGFloat newScale = MIN(self.zoomScale * 1.5f, self.maximumZoomScale);
        [self updateZoomScaleWithGesture:gestureRecognizer newScale:newScale];
    }
    
}


#pragma mark - 计算缩放参数
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
-(void)createPreviewImageView{
    
    if ([self.previewImageView isKindOfClass:[UIImageView class]]) {
        [self.previewImageView removeFromSuperview];
        self.previewImageView = nil;
    }
    
    self.previewImageView = [[UIImageView alloc] init];
    self.previewImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.previewImageView.userInteractionEnabled = YES;
    [self addSubview:self.previewImageView];
    
    self.singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self addGestureRecognizer:self.singleTapGestureRecognizer];
    
    self.doubleGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(doubleTap:)];
    [self.doubleGestureRecognizer setNumberOfTapsRequired:2];
    [self addGestureRecognizer:self.doubleGestureRecognizer];
    
    [self.singleTapGestureRecognizer requireGestureRecognizerToFail:self.doubleGestureRecognizer];
    
}

-(void)generateImageViewWithImage:(UIImage *)image imageSize:(CGSize)originalImageSize imageType:(HZShapeImageType)imageType{
    
    self.previewImageView.image = image;
    self.previewImageView.frame = [self calculateShowImageRectWithImageType:imageType originalImageSize:originalImageSize];
    
    [self setZoomScale:1];
    if (imageType == HZRectangleImageForLongWidthType || originalImageSize.width>=kBigImageScaleValue*kHZScreenSize.width) {
        [self setMaximumZoomScale:(originalImageSize.width/self.frame.size.width)*0.7f];
    }else if (imageType == HZRectangleImageForLongHeightType || originalImageSize.height>=kBigImageScaleValue*kHZScreenSize.height){
        [self setMaximumZoomScale:(originalImageSize.height/self.frame.size.height)*0.7f];
    }else{
        [self setMaximumZoomScale:2];
    }
    [self setMinimumZoomScale:0.8f];
    
}

-(HZShapeImageType)shapeImageTypeWithImageSize:(CGSize)imageSize{
    
    CGFloat imageScale = 1.5f;
    CGFloat imageWHScale = kBigImageScaleValue;
    
    HZShapeImageType shapeImageType = HZShapeImageForNotType;
    
    if (imageSize.width == imageSize.height) {
        shapeImageType = HZSquareImageType;
    }else if(imageSize.height>imageSize.width){
        
        if (imageSize.height>=CGRectGetHeight(self.frame)*imageScale && (imageSize.height/imageSize.width)> imageWHScale) {
            shapeImageType = HZRectangleImageForLongHeightType;
        }else{
            shapeImageType = HZRectangleImageForHeightType;
        }
        
    }else if (imageSize.width>imageSize.height){
        
        if (imageSize.width>=CGRectGetWidth(self.frame)*imageScale && (imageSize.width/imageSize.height)> imageWHScale) {
            shapeImageType = HZRectangleImageForLongWidthType;
        }else{
            shapeImageType = HZRectangleImageForWidthType;
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
    
    if (imageType == HZSquareImageType) {
        
        if (imageSize.width>=originalScreenWidth) {
            imageInitializeWidth = originalScreenWidth - kDefaultPadding;
        }else{
            imageInitializeWidth = imageSize.width*0.5f;
        }
        
        imageInitializeHeight = imageInitializeWidth;
        imageInitializeX = (originalScreenWidth - imageInitializeWidth)*0.5f;
        imageInitializeY = (originalScreenHeight - imageInitializeWidth)*0.5f;
        
    }else if(imageType == HZRectangleImageForHeightType || imageType == HZRectangleImageForLongHeightType){
        
        if (imageSize.width>=originalScreenWidth && imageSize.height >= originalScreenHeight) {
            
            imageInitializeWidth = originalScreenWidth - kDefaultPadding;
            imageInitializeHeight = imageSize.height*imageInitializeWidth/imageSize.width;
            
        }else if (imageSize.width<=originalScreenWidth && imageSize.height>=originalScreenHeight){
            
            imageInitializeWidth = imageSize.width*0.9f;
            imageInitializeHeight = imageSize.height*imageInitializeWidth/imageSize.width;
            
        }else if (imageSize.width<=originalScreenWidth && imageSize.height<=originalScreenHeight){
            
            imageInitializeWidth = imageSize.width*0.9f;
            imageInitializeHeight = imageSize.height*imageInitializeWidth/imageSize.width;
            
        }else if (imageSize.width>=originalScreenWidth && imageSize.height<=originalScreenHeight){
            
            imageInitializeWidth = originalScreenWidth - kDefaultPadding;
            imageInitializeHeight = imageSize.height*imageInitializeWidth/imageSize.width;
            
        }
        
        imageInitializeX = (originalScreenWidth - imageInitializeWidth)*0.5f;
        if (imageInitializeHeight>originalScreenHeight) {
            imageInitializeY = 0;
        }else{
            imageInitializeY = (originalScreenHeight - imageInitializeHeight)*0.5f;
        }
        
    }else if(imageType == HZRectangleImageForWidthType || imageType == HZRectangleImageForLongWidthType){
        
        if (imageSize.width <= originalScreenWidth && imageSize.height <= originalScreenHeight) {
            
            imageInitializeWidth = originalScreenWidth - kDefaultPadding;
            imageInitializeHeight = imageSize.height*imageInitializeWidth/imageSize.width;
            
            imageInitializeX = (originalScreenWidth - imageInitializeWidth)*0.5f;
            imageInitializeY = (originalScreenHeight - imageInitializeHeight)*0.5f;
            
        }else if (imageSize.width >= originalScreenWidth && imageSize.height >= originalScreenHeight){
            
            if (imageType == HZRectangleImageForWidthType) {
                imageInitializeWidth = originalScreenWidth - kDefaultPadding;
            }else{
                imageInitializeWidth = imageSize.width*0.5f;
            }
            
            imageInitializeHeight = imageSize.height*imageInitializeWidth/imageSize.width;
            imageInitializeX = (originalScreenWidth - imageInitializeWidth)*0.5f;
            
            if (imageInitializeHeight<originalScreenHeight) {
                imageInitializeY = (originalScreenHeight - imageInitializeHeight)*0.5f;
            }
            
        }else if (imageSize.width >= originalScreenWidth && imageSize.height <= originalScreenHeight){
            
            if (imageType == HZRectangleImageForWidthType) {
                imageInitializeWidth = originalScreenWidth - kDefaultPadding;
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
