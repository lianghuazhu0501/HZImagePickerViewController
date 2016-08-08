//
//  HZPickerAlbumDetailViewController.m
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/7/15.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import "HZPickerAlbumController.h"
#import "HZPickerHeader.h"
#import "HZPickerAlbumCollectionViewCell.h"
#import "HZPickerAlbumViewModel.h"
#import "HZPreviewImageViewController.h"
#import "HZStoryBoardManager.h"
#import "HZAppearanceManager.h"
#import "HZPreviewVideoViewController.h"
#import "HZPreviewSingleImageViewController.h"

#define kSpacePadding 4.0f

#define kCollectionViewCellWithReuseIdentifier @"CollectionViewCellWithReuseIdentifier"
#define kTabbarCollectionViewCellWithReuseIdentifier @"TabbarCollectionViewCellWithReuseIdentifier"

@interface HZPickerAlbumController()<UICollectionViewDelegate,UICollectionViewDataSource,UIViewControllerPreviewingDelegate>

@property (assign,nonatomic) BOOL compelteFlag;

@property (assign,nonatomic) CGFloat collectionViewCellWidth;

@property (assign,nonatomic) CGFloat collectionViewHeight;

@property (assign,nonatomic) CGFloat collectionViewContentSizeHeight;

@property (strong,nonatomic) HZPickerAlbumViewModel *albumViewModel;

@property (weak,nonatomic) IBOutlet UIButton *enterButton;

@property (weak,nonatomic) IBOutlet UIButton *previewButton;

@property (weak,nonatomic) IBOutlet UIView *bottomView;
@property (weak,nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightLayouctConstraint;

@property (weak,nonatomic) IBOutlet HZLineView *lineView;

@property (weak,nonatomic) IBOutlet UICollectionView *colletionView;

@property (weak,nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewFlowLayout;


-(IBAction)clickEnterButton:(id)sender;

-(IBAction)clickPreviewButton:(id)sender;


@end

@implementation HZPickerAlbumController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!self.compelteFlag) {
        
        __weak typeof(self) weakSelf = self;
        
        self.compelteFlag = YES;
        
        self.lineView.portrayTopFlag = YES;        
        
        self.colletionView.delegate = self;
        self.colletionView.dataSource = self;
        
        self.collectionViewCellWidth = (kHZScreenSize.width-12)/kSpacePadding;
        
        [self.colletionView registerNib:[UINib nibWithNibName:@"HZPickerAlbumCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kCollectionViewCellWithReuseIdentifier];
        
        [self.colletionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        
        self.albumViewModel = [[HZPickerAlbumViewModel alloc] init];
        self.albumViewModel.exceedBoundsBlock = ^(){
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warm prompt" message:@"More than limit" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
            
        };
        
    }
    
}


-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title = self.albumEntity.assetCollection.localizedTitle;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"HZPickerViewControllerRightBarItemTitle",comment:nil) style:UIBarButtonItemStylePlain target:self action:@selector(clickCancelBarItem:)];
    
    if(self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable && [HZAppearanceManager sharedManager].previewingTouchEnable) {
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
    
    [self setUpBottomViewButtonState];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectMediaArrayChangeNotification:) name:kHZPickerPreViewControllerClickSelectButtonNotification object:nil];

}

#pragma mark - 3D Touch
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {

    if (location.x >= self.colletionView.frame.origin.x && location.y >= self.colletionView.frame.origin.y && location.x <= self.colletionView.frame.origin.x+self.colletionView.frame.size.width && location.y <= self.colletionView.frame.origin.y+self.colletionView.frame.size.height) {
        
        previewingContext.sourceRect = [self.albumViewModel touchPreviewingCellWithPoint:location visibleCells:self.colletionView.visibleCells];
        
        NSIndexPath *touchIndexPath = [self.colletionView indexPathForCell:self.albumViewModel.touchColletionViewCell];
        
        PHAsset *selectAsset = self.albumEntity.fetchResult[touchIndexPath.row];
        
        if (selectAsset.mediaType == PHAssetMediaTypeImage) {
            
            CGSize preferredContentSize = CGSizeMake(50.0f, selectAsset.pixelHeight*50.0f/selectAsset.pixelWidth);
            
            HZPreviewImageViewController *previewImageViewController = [[HZStoryBoardManager sharedPickerStoryboard] instantiateViewControllerWithIdentifier:@"HZPreviewImageViewController"];
            previewImageViewController.is3DTouchFlag = YES;
            previewImageViewController.selectedIndex = touchIndexPath.row;
            previewImageViewController.fetchResult = self.albumEntity.fetchResult;
            previewImageViewController.albumViewModel = self.albumViewModel;
            previewImageViewController.preferredContentSize = preferredContentSize;
            return previewImageViewController;
            
        }
        
    }
    
    return nil;
    
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self.navigationController pushViewController:viewControllerToCommit animated:nil];
}

#pragma mark - Click Method
-(void)clickCancelBarItem:(UIBarButtonItem *)barButtonItem{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)clickEnterButton:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:kHZSelectMediaFinishNotification object:self.albumViewModel.selectMediaDataArray];
}

-(void)clickPreviewButton:(id)sender{
    [self comeToPreviewImageViewControllerWithFlag:YES index:0];
}

#pragma mark - UICollectionDelete And DataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.collectionViewCellWidth,self.collectionViewCellWidth);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kSpacePadding;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kSpacePadding;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.albumEntity.fetchResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak typeof(self) weakSelf = self;
    
    HZPickerAlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellWithReuseIdentifier forIndexPath:indexPath];
    cell.albumViewModel = self.albumViewModel;
    [cell setValueWithAsset:self.albumEntity.fetchResult[indexPath.item]];
    cell.clickSelectedButtonBlock = ^(){
        [weakSelf setUpBottomViewButtonState];
    };
    cell.clickBackgroundButtonBlock = ^(PHAsset *asset){
        
        if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaType == PHAssetMediaTypeAudio) {
            
            HZPreviewVideoViewController *previewVideoViewController = [[HZStoryBoardManager sharedPickerStoryboard] instantiateViewControllerWithIdentifier:@"HZPreviewVideoViewController"];
            previewVideoViewController.asset = asset;
            [weakSelf.navigationController pushViewController:previewVideoViewController animated:YES];
            
        }else{
            [weakSelf comeToPreviewImageViewControllerWithFlag:NO index:[weakSelf.albumEntity.fetchResult indexOfObject:asset]];
        }
        
    };
    
    return cell;
    
}

#pragma mark - Notification
-(void)selectMediaArrayChangeNotification:(NSNotification *)notification{
    
    [self setUpBottomViewButtonState];
    
    PHAsset *selectAsset = notification.object;
    if ([selectAsset isKindOfClass:[PHAsset class]]) {
        
        BOOL selectFlag = [self.albumViewModel.selectMediaDataArray containsObject:selectAsset];
        for (HZPickerAlbumCollectionViewCell *collectionViewCell in self.colletionView.visibleCells) {
            
            if ([collectionViewCell.asset isEqual:selectAsset]) {
                [collectionViewCell setSelectedWithButton:selectFlag];
                break;
            }
            
        }
        
    }
    
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"contentSize"]) {
        
        BOOL changeFlag = NO;
        NSDictionary *changeDictionary = change;
        CGSize newSize = [[changeDictionary objectForKey:@"new"] CGSizeValue];
        
        if (self.collectionViewContentSizeHeight == 0 && newSize.height>0) {
            changeFlag = YES;
        }else{
            if (self.collectionViewContentSizeHeight >0 && CGRectGetHeight(self.colletionView.frame) > self.collectionViewHeight) {
                changeFlag = YES;
            }
        }
        
        if (changeFlag) {
            
            self.collectionViewContentSizeHeight = newSize.height;
            self.collectionViewHeight = CGRectGetHeight(self.colletionView.frame);
            [self.colletionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.albumEntity.fetchResult.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        
    }
    
}

#pragma mark - Other
-(void)setUpBottomViewButtonState{
    
    if ([HZAppearanceManager sharedManager].imageStyle == HZPickerImageStyleCropSingleImage) {
        
        self.bottomView.hidden = YES;
        self.bottomViewHeightLayouctConstraint.constant = 0;
        
    }else{
        
        BOOL buttonEnabled = self.albumViewModel.selectMediaDataArray.count>0?YES:NO;
        
        self.enterButton.enabled = buttonEnabled;
        self.previewButton.enabled = buttonEnabled;
        
        if (buttonEnabled) {
            
            [self.enterButton setTitleColor:kHZButtonEnableColor forState:UIControlStateNormal];
            [self.previewButton setTitleColor:kHZButtonEnableColor forState:UIControlStateNormal];
            
            [self.enterButton setTitleColor:kHZButtonHighlightColor forState:UIControlStateHighlighted];
            [self.previewButton setTitleColor:kHZButtonHighlightColor forState:UIControlStateHighlighted];
            
        }else{
            
            [self.enterButton setTitleColor:kHZButtonDisableColor forState:UIControlStateNormal];
            [self.previewButton setTitleColor:kHZButtonDisableColor forState:UIControlStateNormal];
            
        }
        
        [self.previewButton setTitle:NSLocalizedString(@"HZPickerAlbumControllerPreviewButtonTitle", nil) forState:UIControlStateNormal];
        [self.enterButton setTitle:[NSString stringWithFormat:@"%@(%ld)",NSLocalizedString(@"HZPickerAlbumControllerEnterButtonTitle", nil),self.albumViewModel.selectMediaDataArray.count] forState:UIControlStateNormal];
        
    }
    
}

-(void)comeToPreviewImageViewControllerWithFlag:(BOOL)previewFlag index:(NSInteger)selectIndex{
    
    if ([HZAppearanceManager sharedManager].imageStyle == HZPickerImageStyleCropSingleImage) {
        
        HZPreviewSingleImageViewController *singleImageViewController = [[HZStoryBoardManager sharedPickerStoryboard] instantiateViewControllerWithIdentifier:@"HZPreviewSingleImageViewController"];
        singleImageViewController.asset = self.albumEntity.fetchResult[selectIndex];
        singleImageViewController.albumViewModel = self.albumViewModel;
        [self.navigationController pushViewController:singleImageViewController animated:YES];

        
    }else{
        
        HZPreviewImageViewController *previewImageViewController = [[HZStoryBoardManager sharedPickerStoryboard] instantiateViewControllerWithIdentifier:@"HZPreviewImageViewController"];
        previewImageViewController.isPreViewFlag = previewFlag;
        previewImageViewController.selectedIndex = selectIndex;
        previewImageViewController.fetchResult = self.albumEntity.fetchResult;
        previewImageViewController.albumViewModel = self.albumViewModel;
        [self.navigationController pushViewController:previewImageViewController animated:YES];
        
    }
    
}


#pragma mark - Dealloc
-(void)dealloc{
    
    [self.colletionView removeObserver:self forKeyPath:@"contentSize"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
