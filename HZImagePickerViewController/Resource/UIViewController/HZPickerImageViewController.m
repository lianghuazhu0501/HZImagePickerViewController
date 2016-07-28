//
//  HZPickerImageViewController.m
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/7/13.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import "HZPickerImageViewController.h"
#import <Photos/Photos.h>
#import "HZAlbumEntity.h"
#import "HZPickImageTableViewCell.h"
#import "HZPickImageViewModel.h"
#import "HZStoryBoardManager.h"
#import "HZPickerAlbumController.h"

@interface HZPickerImageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    NSMutableArray *_albumArray;
    HZPickImageViewModel *_pickImageViewModel;
    
}
@end

@implementation HZPickerImageViewController

-(void)awakeFromNib{
    [super awakeFromNib];
    
    _albumArray = [NSMutableArray array];
    _pickImageViewModel = [HZPickImageViewModel new];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationItem.title = NSLocalizedString(@"HZPickerViewControllerTitle",comment:nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"HZPickerViewControllerRightBarItemTitle",comment:nil) style:UIBarButtonItemStylePlain target:self action:@selector(clickCancelBarItem:)];
    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        
        _albumArray = _pickImageViewModel.albumArray;
        
    }else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            if (status == PHAuthorizationStatusAuthorized) {
                
                _albumArray = _pickImageViewModel.albumArray;
                
            }
        }];
    }
    
}

#pragma mark - 点击事件
-(void)clickCancelBarItem:(UIBarButtonItem *)barButtonItem{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITableViewDelegate And UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _albumArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"PickImageTableViewCellIdentifier";
    HZPickImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HZPickImageTableViewCell" owner:self options:nil] lastObject];
        [tableView registerNib:[UINib nibWithNibName:@"HZPickImageTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
        
    }
    
    [cell setValueWithAlbumEnity:_albumArray[indexPath.row]];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HZPickerAlbumController *albumController = [[HZStoryBoardManager sharedPickerStoryboard] instantiateViewControllerWithIdentifier:@"HZPickerAlbumController"];
    albumController.albumEntity = _albumArray[indexPath.row];
    [self.navigationController pushViewController:albumController animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
