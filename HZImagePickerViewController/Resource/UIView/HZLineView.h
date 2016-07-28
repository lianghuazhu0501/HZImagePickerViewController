//
//  HZLineView.h
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/7/18.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZLineView : UIView

@property (nonatomic,assign) BOOL portrayTopFlag;
@property (nonatomic,assign) CGFloat lineViewX;
@property (nonatomic,assign) CGFloat lineViewHeight;
@property (nonatomic,strong) UIColor *lineTextColor;

@end
