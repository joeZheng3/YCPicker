//
//  CustomPicVc.m
//  GetSystemPic
//
//  Created by ChangWingchit on 2017/2/21.
//  Copyright © 2017年 chit. All rights reserved.
//

#import "CustomPicVc.h"
#import "LayView.h"
#import "NewCoverVc.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "Masonry.h"

#define MY_LAZY(object, assignment) (object = object ?: assignment)

@interface CustomPicVc ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) LayView *layView;
@property (nonatomic,strong) UIImagePickerController *pickerVc;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *button1;
@property (nonatomic,strong) UIButton *button2;

@end

@implementation CustomPicVc

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(80);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(@(40));
    }];
    
    [self.button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.button1.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(@(40));
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.button2.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(@(200));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
- (void)takePhoto
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"当前设备不支持相机");
        return;
    }
    
    self.pickerVc = [[UIImagePickerController alloc]init];
    self.pickerVc.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.pickerVc.allowsEditing = NO;
    self.pickerVc.delegate = self;
    self.pickerVc.showsCameraControls = NO;
    self.pickerVc.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeImage];
    
    self.layView = [[LayView alloc]initWithFrame:self.pickerVc.view.bounds
                                      withCamera:self.pickerVc];
    self.pickerVc.cameraOverlayView = self.layView;
    [self presentViewController:self.pickerVc animated:YES completion:^{}];
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - Getter with lazy load
- (UIButton*)button1
{
    return MY_LAZY(_button1, ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectZero;
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:@"拍照" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
        button;
    }));
}

- (UIButton*)button2
{
    return MY_LAZY(_button2, ({
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        button2.frame = CGRectZero;
        button2.backgroundColor = [UIColor blueColor];
        [button2 setTitle:@"取消" forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.view addSubview:button2];
        button2;
    }));
}

- (UIImageView*)imageView
{
    return MY_LAZY(_imageView, ({
        UIImageView *imageView= [[UIImageView alloc]initWithFrame:CGRectZero];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [self.view addSubview:imageView];
        imageView;
    }));
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if ([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
            UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            
        }
        
        
        
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
