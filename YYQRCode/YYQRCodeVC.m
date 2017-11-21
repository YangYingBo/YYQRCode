//
//  YYQRCodeVC.m
//  YYQRCode
//
//  Created by Loser on 2017/8/31.
//  Copyright © 2017年 Loser. All rights reserved.
//
#define heightAndHeight      250
#define view_X                    (Size.width-heightAndHeight)/2
#define view_Y                    (Size.height-heightAndHeight)/2
#define Size                      [UIScreen mainScreen].bounds.size
#import "YYQRCodeVC.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
//#import "YYQRCodeView.h"
#import "YYQRCodeManager.h"
#import "NSString+Category.h"

@interface YYQRCodeVC ()

@end

@implementation YYQRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"扫描二维码";
    self.view.backgroundColor = [UIColor whiteColor];
    

    [[YYQRCodeManager sharedYYQRCodeManager] setupScanningARCodeToViewController:self MetadataObjectBlock:^(NSString *metadata) {
        if ([metadata isValidUrl]) {
           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:metadata]];
        }
        else
        {
            UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"扫描结果" message:metadata delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [aler show];
        }
        
        
        [self.navigationController popViewControllerAnimated:YES];
    } BrightnessValueBlock:^(float brighnessValue) {
        
        
    }];
    

    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[YYQRCodeManager sharedYYQRCodeManager] addTime];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
