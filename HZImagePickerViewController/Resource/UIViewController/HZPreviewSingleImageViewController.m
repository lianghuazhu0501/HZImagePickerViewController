//
//  HZPreviewSingleImageViewController.m
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/8/4.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import "HZPreviewSingleImageViewController.h"
#import "HZCropCenterView.h"
#import "HZPickerHeader.h"
#import "HZPreViewSingleImageScrollView.h"
#import "NSLayoutConstraint+HZAddition.h"

@interface HZPreviewSingleImageViewController()<UIScrollViewDelegate>

@property (weak,nonatomic) IBOutlet HZCropCenterView *cropCenterView;

@property (strong,nonatomic) IBOutlet HZPreViewSingleImageScrollView *zoomScrollView1;

@property (weak,nonatomic) IBOutlet UIButton *cancelButton;

@property (weak,nonatomic) IBOutlet UIButton *enterButton;

-(IBAction)clickCancelButton:(id)sender;

-(IBAction)clickEneterButton:(id)sender;


@end

@implementation HZPreviewSingleImageViewController

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
    [self.enterButton setTitle:NSLocalizedString(@"HZPreviewSingleImageViewControllerEnterButtonTitle",comment:nil) forState:UIControlStateNormal];
    [self.cancelButton setTitle:NSLocalizedString(@"HZPreviewSingleImageViewControllerCancelButtonTitle",comment:nil) forState:UIControlStateNormal];
    
    self.cropCenterView.cropSize = CGSizeMake(250*(320.0f/kHZScreenSize.width), 250*(320.0f/kHZScreenSize.width));
    
    __weak typeof(self) weakSelf = self;
    CGFloat imageWidth = self.asset.pixelWidth;
    CGFloat imageHeight = self.asset.pixelHeight;
    
    CGSize originalImageSize = CGSizeMake(imageWidth, imageHeight);
    
    HZShapeImageType imageType = [weakSelf.zoomScrollView1 shapeImageTypeWithImageSize:originalImageSize];
    
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager requestImageForAsset:self.asset targetSize:originalImageSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        CGRect calculateFrame = [weakSelf.zoomScrollView1 calculateShowImageRectWithImageType:imageType originalImageSize:originalImageSize];
        
        weakSelf.zoomScrollView1.previewImageView.image = result;
        weakSelf.zoomScrollView1.previewImageView.frame = calculateFrame;
        
        if (originalImageSize.width < originalImageSize.height) {
            [weakSelf.zoomScrollView1 setMinimumZoomScale:(weakSelf.cropCenterView.cropSize.width/calculateFrame.size.width)];
        }else{
            [weakSelf.zoomScrollView1 setMinimumZoomScale:(weakSelf.cropCenterView.cropSize.height/calculateFrame.size.height)];
        }
        
        if (weakSelf.zoomScrollView1.minimumZoomScale>1.0f) {
            [weakSelf.zoomScrollView1 setZoomScale:weakSelf.zoomScrollView1.minimumZoomScale];
        }else{
            [weakSelf.zoomScrollView1 setZoomScale:1.0f];
        }
        
        [weakSelf.zoomScrollView1 setMaximumZoomScale:2.5f];
        
    }];
    
    [self.zoomScrollView1 addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
}

#pragma mark - Click Event
-(void)clickCancelButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickEneterButton:(id)sender{
    
    CGFloat cropViewWidth = self.cropCenterView.cropSize.width;
    CGFloat cropViewHeight = self.cropCenterView.cropSize.height;
    
    CGFloat zoomScrollViewWidth = CGRectGetWidth(self.zoomScrollView1.frame);
    CGFloat zoomScrollViewHeight = CGRectGetHeight(self.zoomScrollView1.frame);
    
    CGFloat cropImageRectX = (zoomScrollViewWidth - cropViewWidth)*0.5f;
    CGFloat cropImageRectY = (zoomScrollViewHeight - cropViewHeight)*0.5f;
    
    CGRect cropPreviewImageViewRect = [self.zoomScrollView1.previewImageView convertRect:CGRectZero toView:self.view];
    
    CGFloat scaleRatio = self.asset.pixelWidth/CGRectGetWidth(self.zoomScrollView1.previewImageView.frame);
    
    CGFloat actualCropX = (cropImageRectX - cropPreviewImageViewRect.origin.x)*scaleRatio;
    CGFloat actualCropY = (cropImageRectY - cropPreviewImageViewRect.origin.y)*scaleRatio;
    CGFloat actualCropWidth = cropViewWidth*scaleRatio;
    CGFloat actualCropHeight = cropViewHeight*scaleRatio;
    
    NSValue *rectValue = [NSValue valueWithCGRect:CGRectMake(actualCropX, actualCropY, actualCropWidth, actualCropHeight)];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kHZPreviewSingleImageViewControllerClickCropEnterNotification object:@[rectValue,self.asset]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([object isEqual:self.zoomScrollView1]) {
        
        BOOL changeFlag = NO;
        
        NSDictionary *changeDictionary = change;
        CGSize newSize = [[changeDictionary objectForKey:@"new"] CGSizeValue];
        
        CGFloat adjustContentWidth = self.zoomScrollView1.contentSize.width;
        CGFloat adjustContentHeight = self.zoomScrollView1.contentSize.height;
        
        if (newSize.height < self.zoomScrollView1.frame.size.height) {
            changeFlag = YES;
            adjustContentHeight = self.zoomScrollView1.frame.size.height;
        }
        
        if (newSize.width < self.zoomScrollView1.frame.size.width) {
            changeFlag = YES;
            adjustContentWidth = self.zoomScrollView1.frame.size.width;
        }
        
        if (changeFlag) {
            [self.zoomScrollView1 setContentSize:CGSizeMake(adjustContentWidth, adjustContentHeight)];
        }
        
        CGFloat left = 0;
        CGFloat top = 0;
        CGRect calculateFrame = self.zoomScrollView1.previewImageView.frame;
        
        if ( calculateFrame.size.width <= self.zoomScrollView1.frame.size.width && calculateFrame.size.height <= self.zoomScrollView1.frame.size.height) {
            
            left = (calculateFrame.size.width - self.cropCenterView.cropSize.width)*0.5f;
            top = (calculateFrame.size.height - self.cropCenterView.cropSize.height)*0.5f;

        }else if(calculateFrame.size.width >= self.zoomScrollView1.frame.size.width && calculateFrame.size.height <= self.zoomScrollView1.frame.size.height){
            
            left = (CGRectGetWidth(self.zoomScrollView1.bounds) - self.cropCenterView.cropSize.width)*0.5f;
            top = (calculateFrame.size.height - self.cropCenterView.cropSize.height)*0.5f;
            
        }else if (calculateFrame.size.width <= self.zoomScrollView1.frame.size.width && calculateFrame.size.height >= self.zoomScrollView1.frame.size.height){
            
            left = (calculateFrame.size.width - self.cropCenterView.cropSize.width)*0.5f;
            top = (CGRectGetHeight(self.zoomScrollView1.bounds) - self.cropCenterView.cropSize.height)*0.5f;
            
        }else if (calculateFrame.size.width >= self.zoomScrollView1.frame.size.width && calculateFrame.size.height >= self.zoomScrollView1.frame.size.height){
            
            left = (CGRectGetWidth(self.zoomScrollView1.bounds) - self.cropCenterView.cropSize.width)*0.5f;
            top = (CGRectGetHeight(self.zoomScrollView1.bounds) - self.cropCenterView.cropSize.height)*0.5f;
        
        }
        
        [UIView animateWithDuration:0.1f animations:^{
            [self.zoomScrollView1 setContentInset:UIEdgeInsetsMake(top, left , top, left)];
        }];
        
        
    }
    
}

#pragma mark - Dealloc
-(void)dealloc{
    [self.zoomScrollView1 removeObserver:self forKeyPath:@"contentSize"];
}


@end
