//
//  LayView.m
//  GetSystemPic
//
//  Created by ChangWingchit on 2017/2/21.
//  Copyright © 2017年 chit. All rights reserved.
//

#import "LayView.h"


@interface LayView ()

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
    [self imageView];
    [self flashBtn];
    [self frontBtn];
    [self cameraBtn];
    [self cancelBtn];
    [self switchBtn];
}

#pragma mark - Getter with lazy load
- (UIImageView*)imageView
{
    return MY_LAZY(_imageView, ({
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        imageView.image = [UIImage imageNamed:@"coverFloat"];
        [self addSubview:imageView];
        imageView;
    }));
}

- (UIButton*)flashBtn
{
    return MY_LAZY(_flashBtn, ({
        UIButton *flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        flashBtn.frame = CGRectMake(10, 20, 100, 40);
        [flashBtn setTitle:@"闪光灯auto" forState:UIControlStateNormal];
        [flashBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [flashBtn addTarget:self action:@selector(flashBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:flashBtn];
        flashBtn;
    }));
}

- (UIButton*)frontBtn
{
    return MY_LAZY(_frontBtn, ({
        UIButton *frontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        frontBtn.frame = CGRectMake(self.bounds.size.width-70, 20, 60, 35);
        [frontBtn setBackgroundImage:[UIImage imageNamed:@"自动切换"] forState:UIControlStateNormal];
        [frontBtn addTarget:self action:@selector(frontBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:frontBtn];
        frontBtn;
    }));
}

- (UIButton*)cameraBtn
{
    return MY_LAZY(_cameraBtn, ({
        UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cameraBtn.frame = CGRectMake(self.center.x-14, self.bounds.size.height-38, 28, 28);
        [cameraBtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [cameraBtn addTarget:self action:@selector(cameraBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cameraBtn];
        cameraBtn;
    }));
}

- (UIButton*)cancelBtn
{
    return MY_LAZY(_cancelBtn, ({
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(5, self.bounds.size.height-50, 60, 40);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        cancelBtn;
    }));
}

- (UIButton*)switchBtn
{
    return MY_LAZY(_switchBtn, ({
        UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        switchBtn.frame = CGRectMake(self.bounds.size.width-105, self.bounds.size.height-50, 100, 40);
        [switchBtn setTitle:@"切换遮罩层" forState:UIControlStateNormal];
        [switchBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [switchBtn addTarget:self action:@selector(switchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:switchBtn];
        switchBtn;
    }));
}

#pragma mark - Action
- (void)flashBtnClicked
{
    if (self.camera) {
        if (self.camera == UIImagePickerControllerCameraDeviceRear) {
            static int num = 0;
            num++;
            if (num == 3) {
                num = 0;
            }
            if (num == 0) {
                self.camera.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
                [self.flashBtn setTitle:@"闪光灯Auto" forState:UIControlStateNormal];
            }
            if (num == 1) {
                self.camera.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
                [self.flashBtn setTitle:@"闪光灯On" forState:UIControlStateNormal];
            }
            if (num == 2) {
                self.camera.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
                [self.flashBtn setTitle:@"闪光灯Off" forState:UIControlStateNormal];
            }
        }
    }
}

- (void)frontBtnClicked
{
    if (self.camera) {
        if (self.camera.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
            self.camera.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        else
        {
            self.camera.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        }
    }
}

- (void)cameraBtnClicked
{
    if (self.camera) {
        [self.camera takePicture];
    }
}

- (void)cancelBtnClicked
{
    if (self.camera) [self.camera dismissViewControllerAnimated:YES completion:^{}];
}

- (void)switchBtnClicked
{
    static BOOL switchLay = FALSE;
    if (switchLay) {
        self.imageView.image = [UIImage imageNamed:@"coverFloat"];
        switchLay = FALSE;
    }
    else
    {
        self.imageView.image = [UIImage imageNamed:@"overlay"];
    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
