//
//  PassCardViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 2017/3/6.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "PassCardViewController.h"
#import "Masonry.h"
#import "NKUser.h"
#import "NKDataManager.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "NKCarTotalExpendAndTime.h"

@interface PassCardViewController ()

@property (nonatomic, strong) UILabel *parktimeLabel;
@property (nonatomic, strong) UILabel *parkcashLabel;
@property (nonatomic, strong) UILabel *parkpointLabel;
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) NKCarTotalExpendAndTime *carExpendAndTime;

@end

@implementation PassCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBar];
    [self initSubViews];
    [self postGetUserTotalExpendAndTime];
}
#pragma mark - 界面初始化
- (void)setNavigationBar
{
    self.navigationItem.title = @"通行证";
    UIImage *itemImage = [UIImage imageNamed:@"左箭头"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[itemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_TITLE_WHITE}];
    
    self.navigationController.navigationBar.barTintColor = COLOR_MAIN_RED;
    self.navigationController.navigationBar.backgroundColor = COLOR_MAIN_RED;
}
- (void)goBack
{
    if (self.navigationController.viewControllers.count == 1)
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)initSubViews
{
    //获取用户基本数据
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:@"userData"];
    NKUser *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    //获取头像image
    NSString *iconUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"];
    NSData *iconImageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"iconImageData"];
    UIImage *image;
    if (iconImageData == nil)
    {
        iconImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:iconUrl]];
        if (iconImageData == nil)
        {
            image = [UIImage imageNamed:@"头像"];
        }
        else
        {
            image = [UIImage imageWithData:iconImageData];
        }
    }
    else
    {
        image = [UIImage imageWithData:iconImageData];
    }
    //头像
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(80);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.height.mas_equalTo(44);
        make.size.width.mas_equalTo(44);
    }];
    iconImageView.layer.cornerRadius = 22;
    iconImageView.layer.masksToBounds = YES;
    iconImageView.layer.borderWidth = 2;
    iconImageView.layer.borderColor = [UIColor colorWithRed:199.0 / 255.0 green:159.0 / 255.0 blue:98.0 / 255.0 alpha:1.0].CGColor;
    
    //昵称
    UILabel *niNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW, 16)];
    [self.view addSubview:niNameLabel];
    [niNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView.mas_bottom).offset(10);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    niNameLabel.text = user.niName;
    niNameLabel.font = [UIFont systemFontOfSize:16.0];
    niNameLabel.textColor = COLOR_TITLE_BLACK;
    niNameLabel.textAlignment = NSTextAlignmentCenter;
    //会籍
    UILabel *membershipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW, 14)];
    [self.view addSubview:membershipLabel];
    [membershipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(niNameLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    membershipLabel.text = user.userType;
    membershipLabel.font = [UIFont systemFontOfSize:14.0];
    membershipLabel.textColor = COLOR_TITLE_BLACK;
    membershipLabel.textAlignment = NSTextAlignmentCenter;

    //会籍信息
    UILabel *membershipDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW, 12)];
    [self.view addSubview:membershipDetailLabel];
    [membershipDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(membershipLabel.mas_bottom).offset(16);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    membershipDetailLabel.text = @"";
    membershipDetailLabel.font = [UIFont systemFontOfSize:12.0];
    membershipDetailLabel.textColor = COLOR_TITLE_GRAY;
    membershipDetailLabel.textAlignment = NSTextAlignmentCenter;

    //会籍进度条
    UIProgressView *membershipProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW, 6)];
    [self.view addSubview:membershipProgressView];
    [membershipProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(membershipDetailLabel.mas_bottom).offset(6);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    membershipProgressView.progressTintColor = [UIColor colorWithRed:199.0 / 255.0 green:159.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
    membershipProgressView.progress = 0.5;
    membershipProgressView.hidden = YES;
    
    //二维码
    UIImageView *QRCodeImageView = [[UIImageView alloc] init];
    [self.view addSubview:QRCodeImageView];
    [QRCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(membershipProgressView.mas_bottom).offset(44);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.height.equalTo(@210);
        make.size.with.equalTo(@210);
    }];
    QRCodeImageView.image = [self getQRCodeImageWithStr:[NSString stringWithFormat:@"%@-%@", user.realName, user.mobile]];

    //隐藏按钮
    UIButton *eyeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 18)];
    [self.view addSubview:eyeButton];
    [eyeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(QRCodeImageView.mas_bottom).offset(40);
        make.size.mas_equalTo(CGSizeMake(24, 12));
    }];
    [eyeButton setImage:[UIImage imageNamed:@"passCard_eye_open"] forState:UIControlStateNormal];
    [eyeButton setImage:[UIImage imageNamed:@"passCard_eye_close"] forState:UIControlStateSelected];
    [eyeButton addTarget:self action:@selector(clickEyeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //基本信息PARKCASH PARKPOINT PARKTIME
    CGFloat labelW = WIDTH_VIEW / 3 - 20;
    //PARKCASH
    UIImageView *parkcashImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"passCard_parkcash"]];
    [self.view addSubview:parkcashImageView];
    [parkcashImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(eyeButton.mas_bottom).offset(16);
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(0.5);
    }];
    
    _parkcashLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelW, 12)];
    [self.view addSubview:_parkcashLabel];
    [_parkcashLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(parkcashImageView.mas_bottom).offset(2);
        make.centerX.mas_equalTo(parkcashImageView.mas_centerX);
    }];
    _parkcashLabel.text = [NSString stringWithFormat:@"%.2f", (float)([[NSUserDefaults standardUserDefaults] integerForKey:@"balance"] / 100)];
    _parkcashLabel.font = [UIFont systemFontOfSize:12.0];
    _parkcashLabel.textColor = COLOR_TITLE_BLACK;
    _parkcashLabel.textAlignment = NSTextAlignmentCenter;
    
    //PARKPOINT
    UIImageView *parkpointImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"passCard_parkpoint"]];
    [self.view addSubview:parkpointImageView];
    [parkpointImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(eyeButton.mas_bottom).offset(16);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    _parkpointLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelW, 12)];
    [self.view addSubview:_parkpointLabel];
    [_parkpointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(parkpointImageView.mas_bottom).offset(2);
        make.centerX.mas_equalTo(parkpointImageView.mas_centerX);
    }];
    NSInteger point = [[NSUserDefaults standardUserDefaults] integerForKey:@"points"];
    _parkpointLabel.text = [NSString stringWithFormat:@"%d", point];
    _parkpointLabel.font = [UIFont systemFontOfSize:12.0];
    _parkpointLabel.textColor = COLOR_TITLE_BLACK;
    _parkpointLabel.textAlignment = NSTextAlignmentCenter;

    //PARKTIME
    UIImageView *parktimeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"passCard_parktime"]];
    [self.view addSubview:parktimeImageView];
    [parktimeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(eyeButton.mas_bottom).offset(16);
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(1.5);
    }];
    
    _parktimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelW, 12)];
    [self.view addSubview:_parktimeLabel];
    [_parktimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(parktimeImageView.mas_bottom).offset(2);
        make.centerX.mas_equalTo(parktimeImageView.mas_centerX);
    }];
    _parktimeLabel.text = @"0";
    _parktimeLabel.font = [UIFont systemFontOfSize:12.0];
    _parktimeLabel.textColor = COLOR_TITLE_BLACK;
    _parktimeLabel.textAlignment = NSTextAlignmentCenter;
    
}
#pragma mark - 生成二维码方法
- (UIImage *)getQRCodeImageWithStr:(NSString *)msgStr
{
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    // 3.给过滤器添加数据(正则表达式/账号和密码)
    NSString *dataString = msgStr;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    // 5.将CIImage转换成UIImage，并放大显示
    UIImage *image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
    return image;
}
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
#pragma mark - 点击button方法
- (void)clickEyeButton:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.isSelected)
    {
        _parkcashLabel.text = @"*****";
        _parkpointLabel.text = @"*****";
        _parktimeLabel.text = @"*****";
    }
    else
    {
        _parkcashLabel.text = [NSString stringWithFormat:@"%.2f", (float)([[NSUserDefaults standardUserDefaults] integerForKey:@"balance"] / 100)];
        _parkpointLabel.text = @"0";
        _parktimeLabel.text = [NSString stringWithFormat:@"%ld", _carExpendAndTime.totalTime / 3600];
    }
}
#pragma mark - 网络请求
- (void)postGetUserTotalExpendAndTime
{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *sspid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sspId"];
    NKDataManager *dataManager = [NKDataManager sharedDataManager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:sspid forKey:@"sspid"];
    [dataManager POSTGetCarTotalExpendAndTimeWithParameters:parameters Success:^(NKCarTotalExpendAndTime *carExpendAndTime) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.HUD hideAnimated:YES];
            [self.HUD removeFromSuperViewOnHide];
        });
        self.carExpendAndTime = carExpendAndTime;
        if (carExpendAndTime.ret == 0)
        {
            //更新界面
            //success
            dispatch_async(dispatch_get_main_queue(), ^{
                _parktimeLabel.text = [NSString stringWithFormat:@"%ld", carExpendAndTime.totalTime / 3600];
            });
        }
        else
        {
            [self popHUDWithString:carExpendAndTime.msg];
        }
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.HUD hideAnimated:YES];
            [self.HUD removeFromSuperViewOnHide];
            [self popHUDWithString:@"网络异常"];
        });
    }];
}
- (void)popHUDWithString:(NSString *)str
{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.mode = MBProgressHUDModeText;
    self.HUD.label.text = str;
    [self.HUD hideAnimated:YES afterDelay:2.0];
    [self.HUD removeFromSuperViewOnHide];
}

@end
