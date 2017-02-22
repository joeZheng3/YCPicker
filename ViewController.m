//
//  ViewController.m
//  GetSystemPic
//
//  Created by ChangWingchit on 2017/2/19.
//  Copyright © 2017年 chit. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "CustomPicVc.h"

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

/**
  图像选取控制器
 */
@property (nonatomic,strong) UIImagePickerController *pickerVc;

/**
  图像显示
 */
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

/**
 拍照
 @param sender 点击事件
 */
- (IBAction)takePicture:(id)sender;

/**
 获取系统相册
 @param sender 点击事件
 */
- (IBAction)getPicture:(id)sender;

/**
 获取系统相册
 @param sender 点击事件
 */
- (IBAction)getPicAlbum:(id)sender;

/**
 视频录制
 @param sender 点击事件
 */
- (IBAction)takeMovie:(id)sender;

/**
 自定义拍照界面
 @param sender 点击事件
 */
- (IBAction)customTakePic:(id)sender;

@end

@implementation ViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Method
- (IBAction)takePicture:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"当前设备不支持拍照");
        return;
    }
    self.pickerVc = [[UIImagePickerController alloc]init];
    self.pickerVc.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.pickerVc.delegate = self;
    self.pickerVc.allowsEditing = YES;
    self.pickerVc.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeImage]; //MobileCoreServices
    
    //相机常用设置属性
    self.pickerVc.showsCameraControls = YES; //默认YES
//    self.pickerVc.cameraDevice = UIImagePickerControllerCameraDeviceFront; // 设置前置
    self.pickerVc.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;//设置闪光灯开
    self.pickerVc.cameraViewTransform = CGAffineTransformScale(self.pickerVc.cameraViewTransform, 0.5, 0.5); //设置相机视图变换(放大缩小，旋转等)
    
    [self presentViewController:self.pickerVc animated:YES completion:^{}];
}

- (IBAction)getPicture:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        NSLog(@"当前设备不支持访问相册根目录");
        return;
    }
    self.pickerVc = [[UIImagePickerController alloc]init];
    self.pickerVc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.pickerVc.allowsEditing = YES;
    self.pickerVc.delegate = self;
    [self presentViewController:self.pickerVc animated:YES completion:^{}];
}

- (IBAction)getPicAlbum:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        NSLog(@"当前设备不支持访问相册胶卷");
        return;
    }
    self.pickerVc = [[UIImagePickerController alloc]init];
    self.pickerVc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    self.pickerVc.allowsEditing = YES;
    self.pickerVc.delegate = self;
    [self presentViewController:self.pickerVc animated:YES completion:^{}];
}

- (IBAction)takeMovie:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"当前设备不支持视频录制");
        return;
    }
    self.pickerVc = [[UIImagePickerController alloc]init];
    self.pickerVc.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.pickerVc.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeMovie]; //MobileCoreServices
    self.pickerVc.delegate = self;
    self.pickerVc.allowsEditing = YES;
    
    self.pickerVc.videoMaximumDuration = 600;
    self.pickerVc.videoQuality = UIImagePickerControllerQualityTypeMedium;
    [self presentViewController:self.pickerVc animated:YES completion:^{}];
}

- (IBAction)customTakePic:(id)sender {
    CustomPicVc *vc = [[CustomPicVc alloc]init];
    [self presentViewController:vc animated:YES completion:^{}];
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (!error)
    {
        NSLog(@"图像保存成功");
    }
    else
    {
        NSLog(@"图像保存失败:%@", [error localizedDescription]);
    }
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        self.imageView.image = [info objectForKey:UIImagePickerControllerEditedImage];//原始图片为UIImagePickerControllerOriginalImage
    }
    else if(picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum)
    {
        self.imageView.image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    else if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        //获取媒体类型
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        
        if ([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
            self.imageView.image = [info objectForKey:UIImagePickerControllerEditedImage];
            
            if (picker.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
                self.imageView.transform = CGAffineTransformIdentity;
                self.imageView.transform = CGAffineTransformScale(picker.cameraViewTransform, -1, -1);//t图片反转
            }
            UIImageWriteToSavedPhotosAlbum(self.imageView.image,self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
        }
        else if([mediaType isEqualToString:(NSString*)kUTTypeMovie])
        {
            NSURL *mediaUrl = [info objectForKey:UIImagePickerControllerMediaURL];
            
            ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];
            [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:mediaUrl completionBlock:^(NSURL *assetURL, NSError *error) {
                if (!error) {
                    NSLog(@"视频保存成功");
                }
                else{
                    NSLog(@"视频保存失败:%@",[error localizedDescription]);
                }
            }];
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}



@end
