//
//  HZPickerNavigationController.m
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/7/13.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import "HZPickerNavigationController.h"
#import "HZAppearanceManager.h"
#import "HZStoryBoardManager.h"
#import "HZPickerAlbumController.h"
#import "UIImage+HZAddtion.h"

@interface HZPickerNavigationController ()
{
    BOOL _firstConfigFlag;
}
@end

@implementation HZPickerNavigationController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ((self.imageStyle == HZPickerImageStyleFilmCameras || self.imageStyle == HZPickerImageStyleCropSingleImage) && !_firstConfigFlag) {
        
        HZPickerAlbumController *pickerAlbumController = [[HZStoryBoardManager sharedPickerStoryboard] instantiateViewControllerWithIdentifier:@"HZPickerAlbumController"];
        pickerAlbumController.albumEntity = [HZAlbumEntity filmCameras];
        [self pushViewController:pickerAlbumController animated:NO];
        
    }
    
    _firstConfigFlag = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectMediaFinishNotification:) name:kHZSelectMediaFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(previewSingleImageViewControllerCropFinishNotification:) name:kHZPreviewSingleImageViewControllerCropFinishNotification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setter
-(void)setMediaType:(PHAssetMediaType)mediaType{
    _mediaType = mediaType;
    [HZAppearanceManager sharedManager].mediaType = mediaType;
}

-(void)setImageStyle:(HZPickerImageStyle)imageStyle{
    _imageStyle = imageStyle;
    [HZAppearanceManager sharedManager].imageStyle = imageStyle;
}

-(void)setPreviewingTouchEnable:(BOOL)previewingTouchEnable{
    _previewingTouchEnable = previewingTouchEnable;
    [HZAppearanceManager sharedManager].previewingTouchEnable = previewingTouchEnable;
}

-(void)setMaximumNumberOfSelection:(NSInteger)maximumNumberOfSelection{
    _maximumNumberOfSelection = maximumNumberOfSelection;
    [HZAppearanceManager sharedManager].maximumNumberOfSelection = maximumNumberOfSelection;
}

#pragma mark - Notification
-(void)selectMediaFinishNotification:(NSNotification *)notification{
    
    NSArray *selectMediaArray = notification.object;
    if ([selectMediaArray isKindOfClass:[NSArray class]]) {
        
        self.selectMediaDataFinishBlock(selectMediaArray);
        UIViewController *viewController = self.viewControllers.firstObject;
        [viewController dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}

-(void)previewSingleImageViewControllerCropFinishNotification:(NSNotification *)notification{
    
    NSArray *noticeArray = notification.object;
    self.singleImageCropFinishBlock(noticeArray[0],noticeArray[1],[noticeArray[2] CGRectValue]);
    [self.viewControllers.lastObject dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Dealloc
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
