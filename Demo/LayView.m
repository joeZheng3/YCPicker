//
//  LayView.m
//  GetSystemPic
//
//  Created by ChangWingchit on 2017/2/21.
//  Copyright © 2017年 chit. All rights reserved.
//

#import "LayView.h"

#define MY_LAZY(object, assignment) (object = object ?: assignment)

@interface LayView ()

/**
 遮罩层图片
 */
@property (nonatomic,strong) UIImageView *imageView;
/**
 相机
 */
@property (nonatomic,strong) UIImagePickerController *camera;
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

@end

@implementation LayView

#pragma mark - Init Method
- (id)initWithFrame:(CGRect)frame withCamera:(UIImagePickerController *)camera
{
    if (self = [super initWithFrame:frame]) {
        self.camera = camera;
        
        [self initSubViews];
    }
    return self;
}

#pragma mark - Private Method
- (void)initSubViews
{
  

}

#pragma mark - Getter with lazy load
//- (UIImageView*)imageView
//{
//   
//}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
