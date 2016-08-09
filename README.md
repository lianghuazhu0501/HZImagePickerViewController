# Introduction
Since the iOS9 apple give up support for assetsLibrary and suggestion photoKit. If you want to use photokit for image  multi-select, preview or cut , maybe HZImagePickerViewController is good choice.
 
 <br/>
# Requirements
HZPickverImageViewController supports iOS 8.0+, only use ARC

<br/>
# How to use
### For image multi-select and preview , you can refer to the following code 
 <br/>
```c
HZPickerNavigationController *navigationController = [[HZStoryBoardManager sharedPickerStoryboard] instantiateViewControllerWithIdentifier:@"HZPickerNavigationController"];
navigationController.mediaType = PHAssetMediaTypeImage;
navigationController.imageStyle = HZPickerImageStyleFilmCameras;
navigationController.previewingTouchEnable = YES;
navigationController.maximumNumberOfSelection = 8;
navigationController.selectMediaDataFinishBlock = ^(NSArray *mediaArray){
};
[self presentViewController:navigationController animated:YES completion:nil];
```

 <br/>
![](https://raw.githubusercontent.com/lianghuazhu0501/HZImagePickerViewController/master/HZImagePickerViewController/IMG_5916.PNG)


