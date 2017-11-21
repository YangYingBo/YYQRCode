//
//  YYQRCodeManager.m
//  YYQRCode
//
//  Created by Loser on 2017/9/1.
//  Copyright © 2017年 Loser. All rights reserved.
//

#define Size                      [UIScreen mainScreen].bounds.size
#define heightAndHeight           250*Size.width/320
#define view_X                    (Size.width-heightAndHeight)/2
#define view_Y                    (Size.height-heightAndHeight)/2

#import "YYQRCodeManager.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
#import <Photos/Photos.h>

@implementation UIImage(Loser)
/// 返回一张不超过屏幕尺寸的 image
+ (UIImage *)imageSizeWithScreenImage:(UIImage *)image {
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat screenWidth = Size.width;
    CGFloat screenHeight = Size.height;
    
    if (imageWidth <= screenWidth && imageHeight <= screenHeight) {
        return image;
    }
    
    CGFloat max = MAX(imageWidth, imageHeight);
    CGFloat scale = max / (screenHeight * 2.0);
    
    CGSize size = CGSizeMake(imageWidth / scale, imageHeight / scale);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end


//////////////////////////////////////我是分割线 扫描二维码Viwe/////////////////////////////////////////
@interface YYQRCodeView ()
@property (nonatomic,strong) UIImageView *scanningLine;
@property (nonatomic,strong) UILabel *promptLabel;
@property (nonatomic,strong) UIView *lapmOFF_ONView;
@property (nonatomic,strong) UIImageView *lapmImg;
@property (nonatomic,strong) UILabel *alerLabel;
@property (nonatomic,assign) BOOL isShowLapmView;
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation YYQRCodeView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _isShowLapmView = NO;
        [self InitializeAttributeDefaultData];
    }
    return self;
}


- (void)InitializeAttributeDefaultData
{
    self.lineColor = [UIColor whiteColor];
    self.lineWidth = 1;
    self.hornLineColor = [UIColor colorWithRed:85/255.0f green:183/255.0 blue:55/255.0 alpha:1.0];
    self.hornLineLenght = 20;
    self.hornLineHeight = 2;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
#pragma mark =========   设置扫描框和扫描范围之外的背景颜色
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    /// 扫描边框frame
    CGRect frame = CGRectMake(view_X, view_Y, heightAndHeight, heightAndHeight);
    
    // 设置view 背景色
    [[[UIColor blackColor] colorWithAlphaComponent:.4] setFill];
    UIRectFill(rect);
    
    // 获取上下文并设置混合模式
    CGContextRef contex = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(contex, kCGBlendModeDestinationOut);
    
    // 设置空白区域
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
    [path fill];
    // 执行混合模式
    CGContextSetBlendMode(contex, kCGBlendModeNormal);
    
    // 划线框
    UIBezierPath *boxPath = [UIBezierPath bezierPathWithRect:frame];
    boxPath.lineWidth = self.lineWidth;
    boxPath.lineCapStyle = kCGLineCapButt;
    [[UIColor whiteColor] set];
    [boxPath stroke];
    
    UIColor *hornColor = self.hornLineColor;
    // 左上角
    UIBezierPath *leftTopPath = [UIBezierPath bezierPath];
    [leftTopPath moveToPoint:CGPointMake(view_X, view_Y+self.hornLineLenght)];
    [leftTopPath addLineToPoint:CGPointMake(view_X, view_Y)];
    [leftTopPath addLineToPoint:CGPointMake(view_X+self.hornLineLenght, view_Y)];
    leftTopPath.lineWidth = self.hornLineHeight;
    [hornColor set];
    [leftTopPath stroke];
    
    // 右上角
    UIBezierPath *rightTopPath = [UIBezierPath bezierPath];
    [rightTopPath moveToPoint:CGPointMake(view_X+heightAndHeight-self.hornLineLenght, view_Y)];
    [rightTopPath addLineToPoint:CGPointMake(view_X+heightAndHeight, view_Y)];
    [rightTopPath addLineToPoint:CGPointMake(view_X+heightAndHeight, view_Y+self.hornLineLenght)];
    rightTopPath.lineWidth = self.hornLineHeight;
    [hornColor set];
    [rightTopPath stroke];
    
    // 左下角
    UIBezierPath *leftBottomPath = [UIBezierPath bezierPath];
    [leftBottomPath moveToPoint:CGPointMake(view_X, view_Y+heightAndHeight-self.hornLineLenght)];
    [leftBottomPath addLineToPoint:CGPointMake(view_X, view_Y+heightAndHeight)];
    [leftBottomPath addLineToPoint:CGPointMake(view_X+self.hornLineLenght, view_Y+heightAndHeight)];
    leftBottomPath.lineWidth = self.hornLineHeight;
    [hornColor set];
    [leftBottomPath stroke];
    
    // 右下角
    UIBezierPath *rightBottomPath = [UIBezierPath bezierPath];
    [rightBottomPath moveToPoint:CGPointMake(view_X+heightAndHeight-self.hornLineLenght, view_Y+ heightAndHeight)];
    [rightBottomPath addLineToPoint:CGPointMake(view_X+heightAndHeight, view_Y+heightAndHeight)];
    [rightBottomPath addLineToPoint:CGPointMake(view_X+heightAndHeight, view_Y+heightAndHeight-self.hornLineLenght)];
    rightBottomPath.lineWidth = self.hornLineHeight;
    [hornColor set];
    [rightBottomPath stroke];
    
    [self addSubview:self.lapmOFF_ONView];
    [self addSubview:self.promptLabel];
    
    
}

#pragma mark ========   添加扫描线和动画执行
- (void)addTime
{
    
    self.scanningLine.frame = CGRectMake(view_X, view_Y, heightAndHeight-5, 10);
    [self addSubview:self.scanningLine];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(changeScanningLineFrame) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
#pragma mark   ====  停止timer
- (void)stopTime
{
    [self.timer invalidate];
    self.timer = nil;
    
}

#pragma mark  ========  改变扫描线的frame
- (void)changeScanningLineFrame
{
    __block CGRect frame = self.scanningLine.frame;
    [UIView animateWithDuration:0.02 animations:^{
        frame.origin.y += 2;
        self.scanningLine.frame = frame;
        
    }];
    
    if (frame.origin.y > view_Y+heightAndHeight-10) {
        self.scanningLine.frame = CGRectMake(view_X, view_Y, heightAndHeight, 10);
    }
    
}

#pragma mark ======   手电筒开关
- (UIView *)lapmOFF_ONView
{
    if (!_lapmOFF_ONView) {
        _lapmOFF_ONView = [[UIView alloc] initWithFrame:CGRectMake((Size.width-60)/2, view_Y+heightAndHeight-70, 60, 60)];
        _lapmOFF_ONView.backgroundColor = [UIColor clearColor];
        
        [_lapmOFF_ONView addSubview:self.lapmImg];
        [_lapmOFF_ONView addSubview:self.alerLabel];
        _lapmOFF_ONView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLapmView:)];
        [_lapmOFF_ONView addGestureRecognizer:tap];
        
    }
    return _lapmOFF_ONView;
}

#pragma mark   ====   是否打开手电筒
- (void)tapLapmView:(UITapGestureRecognizer *)tap
{
    //    _isShowLapmView = !_isShowLapmView;
    if (!_isShowLapmView) {
        _lapmImg.image = [UIImage imageNamed:@"SGQRCodeFlashlightCloseImage"];
        _alerLabel.text = @"轻触关闭";
        [self YY_openFlashlight];
        _isShowLapmView = YES;
        _lapmOFF_ONView.hidden = NO;
    }
    else
    {
        _lapmImg.image = [UIImage imageNamed:@"SGQRCodeFlashlightOpenImage"];
        _alerLabel.text = @"轻触点亮";
        _isShowLapmView = NO;
        [self YY_CloseFlashlight];
    }
}

#pragma Mark========  显示手电筒开关
- (void)showLapmView{
    
    _lapmOFF_ONView.hidden = NO;
    
}

#pragma mark ======  隐藏手电筒开关
- (void)hiddenLapmView
{
    _lapmOFF_ONView.hidden = !_isShowLapmView;
}

- (UIImageView *)lapmImg
{
    if (!_lapmImg) {
        _lapmImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
        _lapmImg.image = [UIImage imageNamed:@"SGQRCodeFlashlightOpenImage"];
    }
    return _lapmImg;
}

- (UILabel *)alerLabel
{
    if (!_alerLabel) {
        _alerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 60, 20)];
        _alerLabel.textAlignment = NSTextAlignmentCenter;
        _alerLabel.textColor = [UIColor whiteColor];
        _alerLabel.text = @"轻触点亮";
        _alerLabel.font = [UIFont systemFontOfSize:13];
    }
    return _alerLabel;
}

- (UILabel *)promptLabel
{
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, view_Y+heightAndHeight+20, Size.width, 20)];
        _promptLabel.font = [UIFont systemFontOfSize:15];
        _promptLabel.text = @"将二维码/条码放入框内,即可自动扫描";
        _promptLabel.textColor = [UIColor whiteColor];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _promptLabel;
}

/// 添加移动条
- (UIImageView *)scanningLine
{
    if (!_scanningLine) {
        _scanningLine = [[UIImageView alloc] init];
        _scanningLine.image = [UIImage imageNamed:@"QRCodeScanningLine"];
    }
    return _scanningLine;
}


/** 打开手电筒 */
- (void)YY_openFlashlight {
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    if ([captureDevice hasTorch]) {
        BOOL locked = [captureDevice lockForConfiguration:&error];
        if (locked) {
            captureDevice.torchMode = AVCaptureTorchModeOn;
            [captureDevice unlockForConfiguration];
        }
    }
}
/** 关闭手电筒 */
- (void)YY_CloseFlashlight {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode: AVCaptureTorchModeOff];
        [device unlockForConfiguration];
    }
}


@end

//////////////////////////////////////////////我是分割线 扫面二维码//////////////////////////////////////////////
@interface YYQRCodeManager ()<AVCaptureMetadataOutputObjectsDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,copy) void (^metadataObjectBlock) (NSString *metadata);
@property (nonatomic,copy) void (^brightnessValueBlock) (float brigness);
@property (nonatomic,copy) void (^didFinishPickingQRCodeMedia) (NSString *code);
/// 连接对象（回话对象）
@property (nonatomic,strong) AVCaptureSession *session;
/// 预览图层
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic,weak) UIViewController *weakVC;
@end

@implementation YYQRCodeManager
static YYQRCodeManager *manager;
+ (YYQRCodeManager *)sharedYYQRCodeManager
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [YYQRCodeManager new];
    });
    
    return manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
    });
    return manager;
}


#pragma 设置扫描属性

- (void)setupScanningARCodeToViewController:(__weak UIViewController *)VC MetadataObjectBlock:(void (^)(NSString *metadata))metadata BrightnessValueBlock:(void(^)(float brighnessValue))brighness
{
    
    self.weakVC = VC;
    self.metadataObjectBlock = metadata;
    self.brightnessValueBlock = brighness;
    
    // 1.获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 2.创建设备输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    // 3.创建设备输出流
    AVCaptureVideoDataOutput *VideoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [VideoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    // 4.创建数据输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // 5.设置代理 在主线程里面刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    // 6.设置扫描范围（每个取值在 0 ~ 1 以屏幕右上角为坐标原点）
    
    
    //AVCapture输出的图片大小都是横着的，而iPhone的屏幕是竖着的，那么我把它旋转90°呢
    //    output.rectOfInterest = CGRectMake(view_Y/Size.height, view_X/Size.width, heightAndHeight/Size.width, heightAndHeight/Size.height);
    //AVCapture输出图片的长宽比和手机屏幕不是一样的
    CGRect cropRect = CGRectMake(view_X, view_Y, heightAndHeight, heightAndHeight);
    CGFloat p1 = Size.height/Size.width;
    CGFloat p2 = 1920./1080.;  //使用了1080p的图像输出
    if (p1 < p2) {
        CGFloat fixHeight = Size.width * 1920. / 1080.;
        CGFloat fixPadding = (fixHeight - Size.height)/2;
        output.rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
                                           cropRect.origin.x/Size.width,
                                           cropRect.size.height/fixHeight,
                                           cropRect.size.width/Size.width);
    } else {
        CGFloat fixWidth = Size.height * 1080. / 1920.;
        CGFloat fixPadding = (fixWidth - Size.width)/2;
        output.rectOfInterest = CGRectMake(cropRect.origin.y/Size.height,
                                           (cropRect.origin.x + fixPadding)/fixWidth,
                                           cropRect.size.height/Size.height,
                                           cropRect.size.width/fixWidth);
    }
    
    //    NSLog(@"%@",NSStringFromCGRect(output.rectOfInterest));
    // 7.初始化连接对象(回话对象)
    self.session = [[AVCaptureSession alloc] init];
    // 高质量采集
    [self.session setSessionPreset:AVCaptureSessionPreset1920x1080];
    // 添加回话输入
    [self.session addInput:input];
    // 添加回话输出
    [self.session addOutput:output];
    // 添加设备输出流到会话对象；与 3(1) 构成识别光线强弱
    [_session addOutput:VideoDataOutput];
    // 设置输出数据类型 需要将元数据输出添加到回话后 才能制定数据类型 否则会报错
    // 8.设置扫码支持的编码格式(如下设置条形码和二维码)
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode128Code];
    // 9.实例化插入当前图层 传递_session是为了告诉图层未来显示什么内容
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame = VC.view.layer.bounds;
    // 将图层加入当前试图
    [_weakVC.view.layer insertSublayer:self.previewLayer above:0];
    
    // 10.启动会话
    [self.session startRunning];
    
    // 添加扫描框
    [_weakVC.view addSubview:self.QRCodeView];
    self.QRCodeView.frame = _weakVC.view.frame;
    
    
}

#pragma 添加扫描View

- (UIView *)QRCodeView
{
    if (!_QRCodeView) {
        _QRCodeView = [[YYQRCodeView alloc] init];
    }
    return _QRCodeView;
}

- (void)addTime
{
    [self.QRCodeView addTime];
}

- (void)cleanSomeObj{
    if (_QRCodeView) {
        [self.QRCodeView stopTime];
        [self.QRCodeView removeFromSuperview];
    }
    [self stopSessionRunning];
}


#pragma ================================= AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *metadataString = @"";
    if (metadataObjects != nil && metadataObjects.count > 0) {
        
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        metadataString = [obj stringValue];
        [self YY_palySoundName:@"sound.caf"];
        [_session stopRunning];
        if (self.metadataObjectBlock) {
            self.metadataObjectBlock(metadataString);
        }
    }
    
}

#pragma mark - - - AVCaptureVideoDataOutputSampleBufferDelegate的方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    // 这个方法会时时调用，但内存很稳定
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    if (brightnessValue < 0) {
        [self.QRCodeView showLapmView];
    }
    else
    {
        [self.QRCodeView hiddenLapmView];
    }
    // 光照强度
    if (self.brightnessValueBlock) {
        self.brightnessValueBlock(brightnessValue);
    }
    
    
}

- (void)stopSessionRunning
{
    if (_previewLayer) {
        [_previewLayer removeFromSuperlayer];
    }
    if (_weakVC) {
       self.weakVC = nil;
    }
    if (_session) {
        _session = nil;
    }
}




#pragma 扫描成功提示音
- (void)YY_palySoundName:(NSString *)name {
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    AudioServicesPlaySystemSound(soundID); // 播放音效
}

void soundCompleteCallback(SystemSoundID soundID, void *clientData){
    
}


/**///////////////////////////////////我是分割线  从相册里面识别二维码/////////////////////////////////////////////////*/

- (void)getPhontolQRCodeFromAlbumWithCurrentController:(__weak UIViewController *)vc didFinishPickingQRCodeMediaBlock:(void(^)(NSString *code))block
{
    self.weakVC = vc;
    self.didFinishPickingQRCodeMedia = block;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    if (device) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) {
            // 第一次进来
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status1) {
                if (status1 == PHAuthorizationStatusAuthorized) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self enterImagePickerController];
                    });
                }
                else
                {
                    
                }
            }];
        }
        else if (status == PHAuthorizationStatusAuthorized){
            // 已经获取到访问相册权限
            [self enterImagePickerController];
        }
        else if (status == PHAuthorizationStatusDenied)
        {  // 已经拒绝访问相册权限
            [self showAlertController:@"已经拒绝访问相册权限  请到设置中打开此权限"];
        }
        else
        {
            // 访问不了相册
            [self showAlertController:@"由于系统原因, 无法访问相册"];
        }
    }
    
}

- (void)enterImagePickerController
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.weakVC presentViewController:picker animated:YES completion:nil];
}
#pragma UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0)
{
    [self.weakVC dismissViewControllerAnimated:YES completion:^{
        if (self.didFinishPickingQRCodeMedia) {
            self.didFinishPickingQRCodeMedia(@"返回");
        }
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 对选取照片的处理，如果选取的图片尺寸过大，则压缩选取图片，否则不作处理
    UIImage *image = [UIImage imageSizeWithScreenImage:info[UIImagePickerControllerOriginalImage]];
    // CIDetector(CIDetector可用于人脸识别)进行图片解析，从而使我们可以便捷的从相册中获取到二维码
    // 声明一个 CIDetector，并设定识别类型 CIDetectorTypeQRCode
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    
    // 取得识别结果
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    NSString *resultStr = @"";
    if (features.count > 0) {
        for (int index = 0; index < [features count]; index ++) {
            CIQRCodeFeature *feature = [features objectAtIndex:index];
            resultStr = feature.messageString;
            
        }
        [self.weakVC dismissViewControllerAnimated:YES completion:^{
            if (self.didFinishPickingQRCodeMedia) {
                self.didFinishPickingQRCodeMedia(resultStr);
            }
        }];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.weakVC dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)showAlertController:(NSString *)mesage
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:mesage preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:alertA];
    [self.weakVC presentViewController:alertC animated:YES completion:nil];
}

@end
