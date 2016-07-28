//
//  HZPreviewImageViewModel.m
//  HZImagePickerViewController
//
//  Created by 梁华柱 on 16/7/22.
//  Copyright © 2016年 Robert Liang. All rights reserved.
//

#import "HZPreviewImageViewModel.h"
#import "HZPickerHeader.h"

@implementation HZPreviewImageViewModel

-(void)setSelectedIndex:(NSInteger)selectedIndex{
    
    _selectedIndex = selectedIndex;
    
    if (_selectedIndex<0) {
        
        if (self.isPreviewFlag) {
            _selectedIndex = self.showMediaDataArray.count-1;
        }else{
            _selectedIndex = self.fetchResult.count-1;
        }
        
    }
    
    if (self.isPreviewFlag) {
        if (_selectedIndex>=self.showMediaDataArray.count) {
            _selectedIndex = 0;
        }
    }else{
        if (_selectedIndex>=self.fetchResult.count) {
            _selectedIndex = 0;
        }
    }
    
}

-(NSString *)mediaNumberText{
    
    if (self.isPreviewFlag) {
        return [NSString stringWithFormat:@"%ld/%ld",self.selectedIndex+1,self.showMediaDataArray.count];
    }else{
        return [NSString stringWithFormat:@"%ld/%ld",self.selectedIndex+1,self.fetchResult.count];
    }
    
}

-(PHAsset *)assetFormLayoutConstraint:(NSLayoutConstraint *)letLayouConstraint{
    
    if (self.isPreviewFlag) {
        return [self assetFormLayoutConstraint:letLayouConstraint selectMediaArray:self.showMediaDataArray];
    }else{
        
        if (self.fetchResult.count>=3) {
            
            if (letLayouConstraint.constant == 0) {
                
                if (self.selectedIndex-1 < 0) {
                    return self.fetchResult.lastObject;
                }else{
                    return self.fetchResult[self.selectedIndex-1];
                }
                
            }else if (letLayouConstraint.constant == kHZScreenSize.width){
                return self.fetchResult[self.selectedIndex];
            }else{
                
                if (self.selectedIndex+1 == self.fetchResult.count) {
                    return self.fetchResult[0];
                }else{
                    return self.fetchResult[self.selectedIndex+1];
                }
                
            }
            
        }else if(self.fetchResult.count == 2){
            
            if (letLayouConstraint.constant == kHZScreenSize.width){
                return self.fetchResult[self.selectedIndex];
            }else{
                
                if (self.selectedIndex == 0) {
                    return self.fetchResult.lastObject;
                }else{
                    return self.fetchResult.firstObject;
                }
                
            }
            
        }else if (self.fetchResult.count == 1){
            
            if (letLayouConstraint.constant == kHZScreenSize.width){
                return self.fetchResult.firstObject;
            }
        }
        
        return nil;
    }
    
}

-(PHAsset *)assetFormLayoutConstraint:(NSLayoutConstraint *)letLayouConstraint selectMediaArray:(NSArray *)mediaArray{
    
    if (mediaArray.count>=3) {
        
        if (letLayouConstraint.constant == 0) {
            
            if (self.selectedIndex-1 < 0) {
                return mediaArray.lastObject;
            }else{
                return mediaArray[self.selectedIndex-1];
            }
            
        }else if (letLayouConstraint.constant == kHZScreenSize.width){
            return mediaArray[self.selectedIndex];
        }else{
            
            if (self.selectedIndex+1 == mediaArray.count) {
                return mediaArray[0];
            }else{
                return mediaArray[self.selectedIndex+1];
            }
            
        }
        
    }else if(mediaArray.count == 2){
        
        if (letLayouConstraint.constant == kHZScreenSize.width){
            return mediaArray[self.selectedIndex];
        }else{
            
            if (self.selectedIndex == 0) {
                return mediaArray.lastObject;
            }else{
                return mediaArray.firstObject;
            }
            
        }
        
    }else if (mediaArray.count == 1){
        
        if (letLayouConstraint.constant == kHZScreenSize.width){
            return mediaArray.firstObject;
        }
    }
    
    return nil;
    
}


@end
