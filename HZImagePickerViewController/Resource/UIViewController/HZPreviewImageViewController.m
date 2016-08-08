//
//  HZPreviewImageViewController.m
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/7/18.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import "HZPreviewImageViewController.h"
#import "HZPickerHeader.h"
#import "HZAppearanceManager.h"
#import "HZPreviewImageViewModel.h"

@interface HZPreviewImageViewController()

@property (weak,nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (weak,nonatomic) IBOutlet HZPreviewImageScrollView *previewScrollView1;

@property (weak,nonatomic) IBOutlet HZPreviewImageScrollView *previewScrollView2;

@property (weak,nonatomic) IBOutlet HZPreviewImageScrollView *previewScrollView3;


@property (weak,nonatomic) IBOutlet UIView *topView;

@property (weak,nonatomic) IBOutlet UIButton *backButton;

@property (weak,nonatomic) IBOutlet UIButton *selectButton;


@property (weak,nonatomic) IBOutlet UIView *bottomView;

@property (weak,nonatomic) IBOutlet UIButton *enterButton;

@property (weak,nonatomic) IBOutlet UILabel *mediaNumberLabel;

@property (weak,nonatomic) IBOutlet UIImageView *touchPreviewImageView;

@property (strong,nonatomic) HZPreviewImageViewModel *previewImageViewModel;

-(IBAction)clickBackButton:(id)sender;

-(IBAction)clickSelectButton:(id)sender;

-(IBAction)clickEnterButton:(id)sender;


@end

@implementation HZPreviewImageViewController

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (!self.is3DTouchFlag) {
        
        [self showStatusBar];
        
    }else{
        
        __weak typeof(self) weakSelf = self;
        PHAsset *asset = self.fetchResult[self.selectedIndex];
        
        PHImageManager *imageManager = [PHImageManager defaultManager];
        [imageManager requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth*0.8f, asset.pixelHeight*0.8f) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            weakSelf.touchPreviewImageView.image = result;
        }];
        
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
    if (self.is3DTouchFlag) {
        [self showStatusBar];
        
        if (self.view.frame.size.height == kHZScreenSize.height) {
            self.is3DTouchFlag = NO;
        }
    }
    
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.topView.backgroundColor = kHZRGBA(50, 50, 50, 0.7f);
    self.bottomView.backgroundColor = self.topView.backgroundColor;
    
    self.mainScrollView.delegate = self;
    [self.mainScrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    if ((self.albumViewModel.selectMediaDataArray.count == 1 && self.isPreViewFlag) || self.fetchResult.count == 1) {
        self.mainScrollView.scrollEnabled = NO;
    }
    
    [self.backButton setImage:[[UIImage imageNamed:@"hz_icon_back_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    [self.selectButton setImage:[[UIImage imageNamed:@"hz_unSelect_image_item"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.selectButton setImage:[[UIImage imageNamed:@"hz_select_image_item"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"contentSize"] && CGSizeEqualToSize(self.view.frame.size, [UIScreen mainScreen].bounds.size)) {
        
        __weak typeof(self) weakSelf = self;
        
        self.touchPreviewImageView.superview.hidden = YES;
        
        self.previewImageViewModel = [[HZPreviewImageViewModel alloc] init];
        self.previewImageViewModel.fetchResult = self.fetchResult;
        self.previewImageViewModel.selectedIndex = self.selectedIndex;
        self.previewImageViewModel.isPreviewFlag = self.isPreViewFlag;
        self.previewImageViewModel.selectMediaDataArray = self.albumViewModel.selectMediaDataArray;
        self.previewImageViewModel.showMediaDataArray = [NSMutableArray arrayWithArray:self.previewImageViewModel.selectMediaDataArray];
        
        self.previewScrollView1.previewImageViewModel = self.previewImageViewModel;
        self.previewScrollView2.previewImageViewModel = self.previewImageViewModel;
        self.previewScrollView3.previewImageViewModel = self.previewImageViewModel;
        
        self.previewScrollView1.letLayoutConstraint.constant = 0;
        self.previewScrollView2.letLayoutConstraint.constant = kHZScreenSize.width;
        self.previewScrollView3.letLayoutConstraint.constant = 2*kHZScreenSize.width;
        
        self.previewScrollView1.singleTapScrollViewBlock = ^(){
            [weakSelf hideOperationView];
        };
        self.previewScrollView2.singleTapScrollViewBlock = ^(){
            [weakSelf hideOperationView];
        };
        self.previewScrollView3.singleTapScrollViewBlock = ^(){
            [weakSelf hideOperationView];
        };
        
        [self scrollViewChangeImage];
        
    }
    
}

#pragma mark - ClickEvent
-(void)clickEnterButton:(UIButton *)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:kHZSelectMediaFinishNotification object:self.albumViewModel.selectMediaDataArray];
}

-(void)clickBackButton:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickSelectButton:(UIButton *)sender{
    
    PHAsset *selectAsset = [self inTheMiddleScrollViewForAsset];
    
    if (![self.albumViewModel.selectMediaDataArray containsObject:selectAsset] && self.albumViewModel.selectMediaDataArray.count >= [HZAppearanceManager sharedManager].maximumNumberOfSelection ) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warm prompt" message:@"More than limit" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        
        sender.selected = !sender.selected;
        if (sender.selected) {
            [self.albumViewModel.selectMediaDataArray addObject:selectAsset];
        }else{
            [self.albumViewModel.selectMediaDataArray removeObject:selectAsset];
        }
        
        [self setBottomViewState];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kHZPickerPreViewControllerClickSelectButtonNotification object:selectAsset];
        
    }
    
    
    
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int x = scrollView.contentOffset.x;
    
    if(x >= (2*scrollView.frame.size.width)) {
        [self scrollViewComeToNextPage:YES];
    }
    
    if(x <= 0) {
        [self scrollViewComeToNextPage:NO];
    }
    
}

-(void)scrollViewComeToNextPage:(BOOL)flag{
    
    if (flag) {
        self.previewImageViewModel.selectedIndex++;
    }else{
        self.previewImageViewModel.selectedIndex--;
    }
    
    NSArray *leftLayoutConstraintArray = @[self.previewScrollView1.letLayoutConstraint,self.previewScrollView2.letLayoutConstraint,self.previewScrollView3.letLayoutConstraint];
    
    for (NSLayoutConstraint *layoutConstraint in leftLayoutConstraintArray) {
        
        if (!flag) {
            
            if (layoutConstraint.constant==0) {
                layoutConstraint.constant = CGRectGetWidth(self.view.bounds);
            }else if (layoutConstraint.constant == CGRectGetWidth(self.view.bounds)){
                layoutConstraint.constant = 2*CGRectGetWidth(self.view.bounds);
            }else if (layoutConstraint.constant == 2*CGRectGetWidth(self.view.bounds)){
                layoutConstraint .constant = 0;
            }
            
        }else{
            
            if (layoutConstraint.constant==0) {
                layoutConstraint.constant = 2*CGRectGetWidth(self.view.bounds);
            }else if (layoutConstraint.constant == CGRectGetWidth(self.view.bounds)){
                layoutConstraint.constant = 0;
            }else{
                layoutConstraint.constant = CGRectGetWidth(self.view.bounds);
            }
            
        }
    }
    
    [self scrollViewChangeImage];
}

#pragma mark - Other
-(void)hideOperationView{
    
    if ([HZAppearanceManager sharedManager].mediaType == PHAssetMediaTypeImage) {
        
        self.topView.hidden = !self.topView.hidden;
        self.bottomView.hidden = !self.bottomView.hidden;
        
    }

}


-(void)setBottomViewState{
    
    BOOL buttonEnabled = self.albumViewModel.selectMediaDataArray.count>0?YES:NO;

    self.enterButton.enabled = buttonEnabled;
    
    if (buttonEnabled) {
        [self.enterButton setTitleColor:kHZButtonEnableColor forState:UIControlStateNormal];
        [self.enterButton setTitleColor:kHZButtonHighlightColor forState:UIControlStateHighlighted];
    }else{
        [self.enterButton setTitleColor:kHZButtonDetailDisableColor forState:UIControlStateNormal];
    }

    [self.enterButton setTitle:[NSString stringWithFormat:@"%@(%ld)",NSLocalizedString(@"HZPickerAlbumControllerEnterButtonTitle", nil),self.albumViewModel.selectMediaDataArray.count] forState:UIControlStateNormal];
    
    self.mediaNumberLabel.text = self.previewImageViewModel.mediaNumberText;
    
}

-(PHAsset *)inTheMiddleScrollViewForAsset{
    PHAsset *selectAsset;
    if (self.previewScrollView1.letLayoutConstraint.constant == CGRectGetWidth(self.mainScrollView.frame)) {
        selectAsset = self.previewScrollView1.asset;
    }else if (self.previewScrollView2.letLayoutConstraint.constant == CGRectGetWidth(self.mainScrollView.frame)){
        selectAsset = self.previewScrollView2.asset;
    }else if (self.previewScrollView3.letLayoutConstraint.constant == CGRectGetWidth(self.mainScrollView.frame)){
        selectAsset = self.previewScrollView3.asset;
    }
    return selectAsset;
}

-(void) showStatusBar{
    if (self.view.frame.size.height == kHZScreenSize.height) {
        
        if ([HZAppearanceManager sharedManager].mediaType == PHAssetMediaTypeImage) {
            
            self.topView.hidden = NO;
            self.bottomView.hidden = NO;
            
        }else{
            
            self.topView.hidden = YES;
            self.bottomView.hidden = YES;
        
        }
        
    }
}

-(void)scrollViewChangeImage{
    
    self.previewScrollView1.asset = [self.previewImageViewModel assetFormLayoutConstraint:self.previewScrollView1.letLayoutConstraint];
    self.previewScrollView2.asset = [self.previewImageViewModel assetFormLayoutConstraint:self.previewScrollView2.letLayoutConstraint];
    self.previewScrollView3.asset = [self.previewImageViewModel assetFormLayoutConstraint:self.previewScrollView3.letLayoutConstraint];
    
    [self.mainScrollView setContentOffset:CGPointMake(self.mainScrollView.frame.size.width, 0)];
    
    self.selectButton.selected = [self.albumViewModel.selectMediaDataArray containsObject:[self inTheMiddleScrollViewForAsset]];
    
    [self setBottomViewState];
    
}

#pragma mark - Dealloc
-(void)dealloc{
    
    [self.mainScrollView removeObserver:self forKeyPath:@"contentSize"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
