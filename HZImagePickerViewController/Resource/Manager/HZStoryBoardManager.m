//
//  StoryBoardManager.m
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/7/14.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import "HZStoryBoardManager.h"

@implementation HZStoryBoardManager

static id _pickerStoryboardInstance = nil;

+(UIStoryboard *)sharedPickerStoryboard{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _pickerStoryboardInstance = [UIStoryboard storyboardWithName:@"HZPickerStoryboard" bundle:[NSBundle mainBundle]];
    });
    return _pickerStoryboardInstance;
}




@end
