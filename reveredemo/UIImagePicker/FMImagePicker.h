//
//  FMImagePicker.h
//  FMRecordVideo
//
//  Created by qianjn on 2017/2/27.
//  Copyright © 2017年 SF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol FMImagePickerDelegate<NSObject>

- (void)play:(NSURL *)url;

@end

@interface FMImagePicker : UIImagePickerController

@property (nonatomic, weak)id<FMImagePickerDelegate>fmdelegate;

@end
