//
//  NewCoverVc.m
//  GetSystemPic
//
//  Created by ChangWingchit on 2017/2/21.
//  Copyright © 2017年 chit. All rights reserved.
//

#import "NewCoverVc.h"

@interface NewCoverVc ()

@property (nonatomic,strong) UIImagePickerController *picker;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIImage  *originImage;
@property (nonatomic,strong) UIImage  *layerImage;
@property (nonatomic,strong) UIButton *chooseBtn;
@property (nonatomic,strong) UIButton *cancelBtn;

@end

@implementation NewCoverVc

#pragma mark - Init Method
- (id)initWithOriginImage:(UIImage *)originImage layerImage:(UIImage *)layerImage picker:(UIImagePickerController *)picker
{
    if (self = [super init]) {
        self.picker = picker;
        self.originImage = originImage;
        self.layerImage = layerImage;
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    
    UIImageView *layerView = [[UIImageView alloc]initWithFrame:self.imageView.bounds];
    layerView.image = self.layerImage;
    [self.imageView addSubview:layerView];
    
    //如果是前置照片需要反转处理
    if (self.picker.cameraDevice == UIImagePickerControllerCameraDeviceFront)
    {
        self.imageView.transform = CGAffineTransformIdentity;
        self.imageView.transform = CGAffineTransformScale(self.picker.cameraViewTransform, -1, 1);
        
        layerView.transform = CGAffineTransformIdentity;
        layerView.transform = CGAffineTransformScale(self.picker.cameraViewTransform, -1, 1);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Pricvate Method
- (void)initSubViews
{
    [self imageView];
    [self cancelBtn];
    [self chooseBtn];
}

#pragma mark - Get Lazy Load
- (UIImageView*)imageView
{
    return MY_LAZY(_imageView, ({
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.image = self.originImage;
        [self.view addSubview:imageView];
        imageView;
    }));
}

- (UIButton*)cancelBtn
{
    return MY_LAZY(_cancelBtn, ({
        UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleBtn.frame = CGRectMake(10, 20, 60, 40);
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cancleBtn addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:cancleBtn];
        cancleBtn;
    }));
}

- (UIButton*)chooseBtn
{
    return MY_LAZY(_chooseBtn, ({
        UIButton *useBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        useBtn.frame = CGRectMake(self.view.bounds.size.width-65, 20, 60, 40);
        [useBtn setTitle:@"使用" forState:UIControlStateNormal];
        [useBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [useBtn addTarget:self action:@selector(chooseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:useBtn];
        useBtn;
    }));
}

#pragma mark - Action
- (void)cancelButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)chooseButtonClicked
{
    UIImage *saveImage = [self addImage:self.layerImage toImage:self.originImage];
    UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (UIImage*)addImage:(UIImage*)topImage toImage:(UIImage*)bottomImage
{
    UIGraphicsBeginImageContext(self.imageView.bounds.size);
    [bottomImage drawInRect:self.imageView.bounds];
    [topImage drawInRect:self.imageView.bounds];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndPDFContext();
    return resultImage;
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
    
    [self.navigationController popViewControllerAnimated:YES];
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
