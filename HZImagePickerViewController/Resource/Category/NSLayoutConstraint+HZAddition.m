//
//  NSLayoutConstraint+HZAddition.m
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/7/22.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import "NSLayoutConstraint+HZAddition.h"

@implementation NSLayoutConstraint (HZAddition)

+(void)addConstraintToView:(UIView *)view superView:(UIView *)superView constantValue:(CGFloat)constantValue{
    
    if (superView) {
        
        view.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *topLayoutConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                               attribute:NSLayoutAttributeTop
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:superView
                                                                               attribute:NSLayoutAttributeTop
                                                                              multiplier:1.0
                                                                                constant:constantValue];
        [superView addConstraint:topLayoutConstraint]; 
        
        NSLayoutConstraint *rightLayoutConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                                 attribute:NSLayoutAttributeRight
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:superView
                                                                                 attribute:NSLayoutAttributeRight
                                                                                multiplier:1.0
                                                                                  constant:constantValue];
        [superView addConstraint:rightLayoutConstraint];
        
        NSLayoutConstraint *bottomLayoutConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                                  attribute:NSLayoutAttributeBottom
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:superView
                                                                                  attribute:NSLayoutAttributeBottom
                                                                                 multiplier:1.0
                                                                                   constant:-constantValue];
        [superView addConstraint:bottomLayoutConstraint];
        
        NSLayoutConstraint *leftLayoutConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                                attribute:NSLayoutAttributeLeft
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:superView
                                                                                attribute:NSLayoutAttributeLeft
                                                                               multiplier:1.0
                                                                                 constant:-constantValue];
        [superView addConstraint:leftLayoutConstraint];
        
    }
    
}

+(NSLayoutConstraint *)addCenterXConstraintToView:(UIView *)view superView:(UIView *)superView layoutRelation:(NSLayoutRelation)layoutRelation constantValue:(CGFloat)constantValue{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *centerXLayoutConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                               attribute:NSLayoutAttributeCenterX
                                                                               relatedBy:layoutRelation
                                                                                  toItem:superView
                                                                               attribute:NSLayoutAttributeCenterX
                                                                              multiplier:1.0
                                                                                constant:constantValue];
    [superView addConstraint:centerXLayoutConstraint];
    return centerXLayoutConstraint;
}

+(NSLayoutConstraint *)addCenterYConstraintToView:(UIView *)view superView:(UIView *)superView layoutRelation:(NSLayoutRelation)layoutRelation constantValue:(CGFloat)constantValue{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *centerYLayoutConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                               attribute:NSLayoutAttributeCenterY
                                                                               relatedBy:layoutRelation
                                                                                  toItem:superView
                                                                               attribute:NSLayoutAttributeCenterY
                                                                              multiplier:1.0
                                                                                constant:constantValue];
    [superView addConstraint:centerYLayoutConstraint];
    return centerYLayoutConstraint;
}


@end
