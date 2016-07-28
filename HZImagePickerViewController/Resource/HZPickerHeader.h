//
//  HZPickerHeader.h
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/7/14.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#ifndef HZPickerHeader_h
#define HZPickerHeader_h

#define kHZScreenSize [UIScreen mainScreen].bounds.size

#define kHZRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define kHZButtonEnableColor kHZRGBA(35, 120, 250, 1)
#define kHZButtonDisableColor kHZRGBA(194, 194, 194, 1)
#define kHZButtonHighlightColor kHZRGBA(35, 120, 250, 0.3)

#define kHZSelectMediaFinishNotification @"HZSelectMediaFinishNotification"

#define kHZPickerPreViewControllerClickSelectButtonNotification @"HZPickerPreViewControllerClickSelectButtonNotification"



typedef enum : NSInteger {
    HZShapeImageForNotType=0,
    HZSquareImageType,
    HZRectangleImageForHeightType,
    HZRectangleImageForLongHeightType,
    HZRectangleImageForWidthType,
    HZRectangleImageForLongWidthType,
}HZShapeImageType;

typedef enum : NSUInteger {
    HZPickerImageStyleFilmCameras,
    HZPickerImageStyleList,
} HZPickerImageStyle;





#endif /* HZPickerHeader_h */
