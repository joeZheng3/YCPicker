//
//  LayView.h
//  GetSystemPic
//
//  Created by ChangWingchit on 2017/2/21.
//  Copyright © 2017年 chit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LayView : UIView

/**
 遮罩层图片
 */
@property (nonatomic,strong) UIImageView *imageView;

/**
 @功能：初始化遮罩层视图
 @参数：frame 相机对象
 @返回值：self
 */
- (id)initWithFrame:(CGRect)frame withCamera:(UIImagePickerController*)camera;

@end
