//
//  HZPickerAlbumViewModel.m
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/7/15.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import "HZPickerAlbumViewModel.h"
#import "HZAppearanceManager.h"

@implementation HZPickerAlbumViewModel

-(instancetype)init{
    
    if (self = [super init]) {
        
        _selectMediaDataArray = [NSMutableArray array];
        
    }
    
    return self;
}

-(BOOL)selectionAnyMediaItem:(PHAsset *)asset{
    
    if (self.selectMediaDataArray.count>[HZAppearanceManager sharedManager].maximumNumberOfSelection) {
        
        self.exceedBoundsBlock();
        return NO;
        
    }else{
        
        if ([self.selectMediaDataArray containsObject:asset]) {
            
            [self.selectMediaDataArray removeObject:asset];
            return NO;
            
        }else{
            
            if (self.selectMediaDataArray.count==[HZAppearanceManager sharedManager].maximumNumberOfSelection) {
                
                self.exceedBoundsBlock();
                return NO;
                
            }else{
                [self.selectMediaDataArray addObject:asset];
            }
            
        }
        return YES;
    }
    
}

-(CGRect)touchPreviewingCellWithPoint:(CGPoint)location visibleCells:(NSArray *)visibleCells{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    CGFloat minX = 0;
    CGFloat minY = 0;
    CGFloat maxX = 0;
    CGFloat maxY = 0;
    
    CGRect touchRect = CGRectZero;
    
    for (UICollectionViewCell *cell in visibleCells) {
        
        CGPoint cellPoint = [cell convertPoint:CGPointZero toView:window];
        
        minX = cellPoint.x;
        minY = cellPoint.y;
        
        maxX = cellPoint.x+cell.frame.size.width;
        maxY = cellPoint.y+cell.frame.size.height;
        
        if (location.x>=minX && location.y>=minY && location.x<=maxX && location.y<=maxY) {
            
            self.touchColletionViewCell = cell;
            touchRect = CGRectMake(cellPoint.x, cellPoint.y, cell.frame.size.width, cell.frame.size.height);
            break;
            
        }
        
    }
    
    return touchRect;
    
}

@end
