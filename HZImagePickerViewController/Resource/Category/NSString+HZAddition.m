//
//  NSString+HZAddition.m
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/7/18.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import "NSString+HZAddition.h"

@implementation NSString (HZAddition)

+(NSString *)durationConvertMinutes:(NSTimeInterval)duration{
    
    NSDecimalNumber *durationDecimalNumber = [[NSDecimalNumber alloc] initWithDouble:duration];
    
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:0 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    long convertDuration = [[durationDecimalNumber decimalNumberByRoundingAccordingToBehavior:roundingBehavior] longValue];
    
    long minuteLong = convertDuration/60;
    long secondsLong = convertDuration%60;
    
    NSString *secondsString = @"";
    if (secondsLong<10) {
        secondsString = [NSString stringWithFormat:@"0%ld",secondsLong];
    }else{
        secondsString = [NSString stringWithFormat:@"%ld",secondsLong];
    }
    
    return [NSString stringWithFormat:@"%ld:%@",minuteLong,secondsString];
    
}

@end
