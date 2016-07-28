//
//  NSLayoutConstraint+HZAddition.h
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/7/22.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (HZAddition)

+(void)addConstraintToView:(UIView *)view superView:(UIView *)superView constantValue:(CGFloat)constantValue;

+(NSLayoutConstraint *)addCenterXConstraintToView:(UIView *)view superView:(UIView *)superView layoutRelation:(NSLayoutRelation)layoutRelation constantValue:(CGFloat)constantValue;

+(NSLayoutConstraint *)addCenterYConstraintToView:(UIView *)view superView:(UIView *)superView layoutRelation:(NSLayoutRelation)layoutRelation constantValue:(CGFloat)constantValue;

@end
