//
//  ViewController.m
//  YYQRCode
//
//  Created by Loser on 2017/8/31.
//  Copyright © 2017年 Loser. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "YYQRCodeVC.h"
#import "YYQRCodeManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 50);
    [button setTitle:@"扫面二维码" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(saoMiaoQRCode) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    UIButton *button1 =[UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(100, 180, 100, 50);
    [button1 setTitle:@"识别二维码" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button1];
    [button1 addTarget:self action:@selector(shiBeiQRCode) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"%f  %f",self.view.frame.size.height,[UIScreen mainScreen].bounds.size.height);
}

- (void)shiBeiQRCode
{
    [[YYQRCodeManager sharedYYQRCodeManager] getPhontolQRCodeFromAlbumWithCurrentController:self didFinishPickingQRCodeMediaBlock:^(NSString *code) {
        NSLog(@"%@",code);
        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"从图片获取数据" message:code delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aler show];
    }];
}

- (void)saoMiaoQRCode
{
    
    // 获取设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    if (device) {
        // 获取摄像头权限
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        if (status == AVAuthorizationStatusNotDetermined) {
            
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        YYQRCodeVC *vc = [[YYQRCodeVC alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    });
                }
                else
                {
                    
                }
            }];
        }
        else if (status == AVAuthorizationStatusAuthorized)// 用户允许当前应用访问相机
        {
            YYQRCodeVC *vc = [[YYQRCodeVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (status == AVAuthorizationStatusDenied){ // 用户拒绝当前应用访问相机
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
        }
        else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问相册");
        }
    }
    else
    {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[YYQRCodeManager sharedYYQRCodeManager] cleanSomeObj];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
