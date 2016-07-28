//
//  HZPreviewVideoViewController.m
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/7/27.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import "HZPreviewVideoViewController.h"

@interface HZPreviewVideoViewController()

@property (strong,nonatomic) AVPlayer *player;

@property (assign,nonatomic) BOOL playFlag;


@property (weak,nonatomic) IBOutlet UIView *allView;

@property (weak,nonatomic) IBOutlet UIButton *playButton;

-(IBAction)clickPlayButton:(id)sender;

@end

@implementation HZPreviewVideoViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    
    self.navigationItem.title = NSLocalizedString(@"HZPreviewVideoViewControllerTitle",comment:nil);
    
    [self.playButton setImage:[UIImage imageNamed:@"hz_icon_play_video_normal"] forState:UIControlStateNormal];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    CGFloat layerWidth = self.view.bounds.size.width;
    CGFloat layerHeight = layerWidth * 9.0f / 16.0f;
    CGFloat layerY = (self.view.bounds.size.height - layerHeight)*0.5f;
    CGFloat layerX = 0;
    
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager requestPlayerItemForVideo:self.asset options:nil resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        
        weakSelf.player = [AVPlayer playerWithPlayerItem:playerItem];
        
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:weakSelf.player];
        layer.frame = CGRectMake(layerX, layerY, layerWidth, layerHeight);
        [weakSelf.allView.layer addSublayer:layer];
        
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideoFinishNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideoFinishNotification:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
    
}

#pragma mark - ClickEvent
-(void)clickPlayButton:(UIButton *)sender{
    
    if (self.player.status == AVPlayerStatusUnknown || self.player.status == AVPlayerStatusFailed) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warm prompt" message:@"Video can not play" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        
        [sender setImage:nil forState:UIControlStateNormal];
        if (!self.playFlag) {
            
            [self.player play];
            self.playFlag = YES;
            
        }else{
            
            [self.player pause];
            self.playFlag = NO;
            
        }
        
    }
    
}

#pragma mark - Notification
-(void)playVideoFinishNotification:(NSNotification *)notification{
    [self.player seekToTime:kCMTimeZero];
    [self.player play];
}

#pragma mark - Dealloc

-(void)dealloc{
    
    [self.player replaceCurrentItemWithPlayerItem:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
