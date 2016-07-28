//
//  HZAppearanceManager.m
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/7/18.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import "HZAppearanceManager.h"

@implementation HZAppearanceManager

static id _appearanceManagerInstance = nil;

+(HZAppearanceManager *)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _appearanceManagerInstance = [[super alloc] init];
    });
    return _appearanceManagerInstance;
}



@end
