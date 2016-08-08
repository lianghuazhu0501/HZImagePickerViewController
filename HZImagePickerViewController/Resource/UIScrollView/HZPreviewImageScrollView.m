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


#define kDefaultAnmationDuration 0.35f


@interface HZPreviewImageScrollView()

@property (assign,nonatomic) PHImageRequestID imageRequestID;

@property (strong,nonatomic) UITapGestureRecognizer *singleTapGestureRecognizer;

@property (strong,nonatomic) UITapGestureRecognizer *doubleGestureRecognizer;



@property (strong,nonatomic) UIActivityIndicatorView *loaddingActivityIndicatorView;

@end

@implementation HZPreviewImageScrollView

-(void)awakeFromNib{
    [super awakeFromNib];
    
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
            BOOL imageLongSizeFlag = (imageType == HZShapeImageTypeLongWidth || imageType == HZShapeImageTypeLongHeight);
            
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
    if (imageType == HZShapeImageTypeLongWidth || originalImageSize.width>=kHZBigImageScaleValue*kHZScreenSize.width) {
        [self setMaximumZoomScale:(originalImageSize.width/self.frame.size.width)*0.7f];
    }else if (imageType == HZShapeImageTypeLongHeight || originalImageSize.height>=kHZBigImageScaleValue*kHZScreenSize.height){
        [self setMaximumZoomScale:(originalImageSize.height/self.frame.size.height)*0.7f];
    }else{
        [self setMaximumZoomScale:2];
    }
    [self setMinimumZoomScale:0.8f];
    
}


@end
