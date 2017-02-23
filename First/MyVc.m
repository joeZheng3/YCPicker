//
//  MyView.m
//  GetSystemPic
//
//  Created by ChangWingchit on 2017/2/23.
//  Copyright © 2017年 chit. All rights reserved.
//

#import "MyVc.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface MyVc ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UIImagePickerController *picker;
@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation MyVc

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addMyGestureRecognizer];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PriVate Method
- (void)addMyGestureRecognizer
{
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(actionSheetShow:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:recognizer];
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (!error) {
        NSLog(@"保存照片成功");
    }
    else
    {
        NSLog(@"保存图片失败:%@",[error localizedDescription]);
    }
}

#pragma mark - Get Lazy Load
- (UIImageView*)imageView
{
    return MY_LAZY(_imageView, ({
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [self.view addSubview:imageView];
        imageView;
    }));
}

#pragma mark - Action
- (void)actionSheetShow:(UISwipeGestureRecognizer*)gesture
{
    if (gesture.direction == UISwipeGestureRecognizerDirectionUp) {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"拍照神器" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        __weak MyVc *weakSelf = self;
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                NSLog(@"该设备不支持拍照");
                return;
            }
           
            weakSelf.picker = [[UIImagePickerController alloc]init];
            weakSelf.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            weakSelf.picker.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeImage];
            weakSelf.picker.allowsEditing = YES;
            weakSelf.picker.delegate = self;
            [self presentViewController:weakSelf.picker animated:YES completion:^{}];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"录制视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                NSLog(@"该设备不支持视频录制");
                return;
            }
            weakSelf.picker = [[UIImagePickerController alloc]init];
            weakSelf.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            weakSelf.picker.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeMovie];
            weakSelf.picker.allowsEditing = YES;
            weakSelf.picker.delegate = self;
            weakSelf.picker.videoMaximumDuration = 100;
            weakSelf.picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
            [self presentViewController:weakSelf.picker animated:YES completion:^{}];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"系统相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                NSLog(@"该设备不支持系统相册");
                return;
            }
            weakSelf.picker = [[UIImagePickerController alloc]init];
            weakSelf.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            weakSelf.picker.allowsEditing = YES;
            weakSelf.picker.delegate = self;
            [self presentViewController:weakSelf.picker animated:YES completion:^{}];
        }]];
        
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
        [self presentViewController:actionSheet animated:YES completion:^{}];
    }
}

#pragma mark - UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        self.imageView.image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if ([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
            self.imageView.image = [info objectForKey:UIImagePickerControllerEditedImage];
            if (picker.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
                self.imageView.transform = CGAffineTransformIdentity;
                self.imageView.transform = CGAffineTransformScale(picker.cameraViewTransform, -1, 1);
            }
            UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
        else if([mediaType isEqualToString:(NSString*)kUTTypeMovie])
        {
            NSURL *mediaUrl = [info objectForKey:UIImagePickerControllerMediaURL];
            
            ALAssetsLibrary *asLib = [[ALAssetsLibrary alloc]init];
            
            [asLib writeVideoAtPathToSavedPhotosAlbum:mediaUrl completionBlock:^(NSURL *assetURL, NSError *error) {
                if (!error) {
                    NSLog(@"保存视频成功");
                }else{
                    NSLog(@"保存视频失败:%@",[error localizedDescription]);
                }
            }];
        
        }
    }
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [self dismissViewControllerAnimated:YES completion:^{}];
}


@end
