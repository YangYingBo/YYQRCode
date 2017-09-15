//
//  YYQRCodeManager.h
//  YYQRCode
//
//  Created by Loser on 2017/9/1.
//  Copyright © 2017年 Loser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "YYQRCodeView.h"

@interface UIImage (Loser)
+ (UIImage *)imageSizeWithScreenImage:(UIImage *)image;
@end


/// 
@interface YYQRCodeView : UIView

//@property (nonatomic,assign) ScanningAnimationStyle scanningStyle;
/// 边框颜色
@property (nonatomic,strong) UIColor *lineColor;
/// 边框宽度
@property (nonatomic,assign) CGFloat lineWidth;
/// 边角线颜色
@property (nonatomic,strong) UIColor *hornLineColor;
/// 边角线长度
@property (nonatomic,assign) CGFloat hornLineLenght;
/// 边角线宽度
@property (nonatomic,assign) CGFloat hornLineHeight;

- (void)showLapmView;
- (void)hiddenLapmView;
- (void)addTime;
- (void)stopTime;
@end

@interface YYQRCodeManager : NSObject
@property (nonatomic,strong) YYQRCodeView *QRCodeView;
+ (YYQRCodeManager *)sharedYYQRCodeManager;
/// 获取扫描二维码结果
- (void)setupScanningARCodeToViewController:(__weak UIViewController *)VC MetadataObjectBlock:(void (^)(NSString *metadata))metadata BrightnessValueBlock:(void(^)(float brighnessValue))brighness;
/// 从相册图片上获取二维码
- (void)getPhontolQRCodeFromAlbumWithCurrentController:(__weak UIViewController *)vc didFinishPickingQRCodeMediaBlock:(void(^)(NSString *code))block;
/// 设置声音
- (void)YY_palySoundName:(NSString *)name;
- (void)addTime;
- (void)cleanSomeObj;
@end
