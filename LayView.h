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
 相机
 */
@property (nonatomic,strong) UIImagePickerController *pickerController;
/**
 闪光灯
 */
@property (nonatomic,strong) UIButton *flashBtn;
/**
 前置摄像头
 */
@property (nonatomic,strong) UIButton *frontBtn;
/**
 开始拍照
 */
@property (nonatomic,strong) UIButton *cameraBtn;
/**
 取消拍照
 */
@property (nonatomic,strong) UIButton *cancelBtn;
/**
 切换遮罩层
 */
@property (nonatomic,strong) UIButton *switchBtn;

- (id)initWithFrame:(CGRect)frame withCamera:(UIImagePickerController*)camera;

@end
