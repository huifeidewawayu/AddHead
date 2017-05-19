//
//  ViewController.m
//  Photo_OR_Picture
//
//  Created by wurui on 17/4/6.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIButton *headButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
}

- (void)setupSubViews {
    CGRect headButtonFrame = CGRectMake(130, 300, 100, 100);
    self.headButton.frame = headButtonFrame;
    [self.view addSubview:self.headButton];
}

- (void)selectHead {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pick = [[UIImagePickerController alloc] init];
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (isCamera) {
            pick.sourceType = UIImagePickerControllerSourceTypeCamera;
            pick.delegate = self;
            pick.allowsEditing = YES;
            [self presentViewController:pick animated:YES completion:nil];
        } else {
            NSLog(@"没有摄像头");
        }
    }];
    [alert addAction:photo];
    UIAlertAction *picture = [UIAlertAction actionWithTitle:@"选择照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pick = [[UIImagePickerController alloc] init];
        pick.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pick.delegate = self;
        pick.allowsEditing = YES;
        [self presentViewController:pick animated:YES completion:nil];
    }];
    [alert addAction:picture];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    if (![cancle valueForKey:@"_titleTextColor"]) {
        [cancle setValue:[UIColor redColor] forKey:@"_titleTextColor"];
    }
    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"%@",info);
    UIImage *returnImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    //UIImagePickerControllerEditedImage可编辑图片，UIImagePickerControllerOriginalImage原始图片
    NSData *data = [NSData data];
    if (UIImagePNGRepresentation(returnImage) == nil) {
        data = UIImageJPEGRepresentation(returnImage, 1.0);
    } else {
        data = UIImagePNGRepresentation(returnImage);
    }
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    [manager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
    [self.headButton setImage:returnImage forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIButton *)headButton {
    if (!_headButton) {
        _headButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headButton setBackgroundColor:[UIColor brownColor]];
        [_headButton setTitle:@"点击添加头像" forState:UIControlStateNormal];
        [_headButton setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
        [_headButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_headButton addTarget:self action:@selector(selectHead) forControlEvents:UIControlEventTouchUpInside];
        _headButton.layer.cornerRadius = 10.0;
        _headButton.clipsToBounds = YES;
        NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *filePath = [NSString stringWithFormat:@"%@%@",DocumentsPath,@"/image.png"];
        if (filePath != nil) {
            [_headButton setImage:[UIImage imageWithContentsOfFile:filePath] forState:UIControlStateNormal];
        }
    }
    return _headButton;
}
@end
