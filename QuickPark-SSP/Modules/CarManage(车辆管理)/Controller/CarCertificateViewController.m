//
//  CarCertificateViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 2016/12/29.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "CarCertificateViewController.h"
#import "NKCarCertificateView.h"
#import "NKCar.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "NKDataManager.h"
#import "CarBrandTableViewController.h"
#import "NKColorManager.h"

@interface CarCertificateViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSArray *carColorButtonArray;
@property (nonatomic, strong) NKCarCertificateView *certificateView;
@property (nonatomic, strong) UIAlertController *alertController;

@property (nonatomic, copy) NSString *carColor;

@end

@implementation CarCertificateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self initSubViews];
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    //注册通知中心
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter addObserver:self selector:@selector(receiveNotification:) name:@"CarBrandDidSelect" object:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 接收通知
- (void)receiveNotification:(NSNotification *)noti
{
    self.certificateView.carTypeLabel.textColor = COLOR_TITLE_BLACK;
    self.certificateView.carTypeLabel.text = noti.userInfo[@"carTypeStr"];
    self.currentCar.carseries = noti.userInfo[@"carTypeStr"];
    self.currentCar.carseriespic = noti.userInfo[@"logoPicUrl"];
}
#pragma 界面初始化
- (NSArray *)carColorButtonArray
{
    if (_carColorButtonArray == nil)
    {
        _carColorButtonArray = [NSArray arrayWithArray:self.certificateView.carColorButtonArray];
    }
    return _carColorButtonArray;
}

- (void)setNavigationBar
{
    self.navigationItem.title = @"车辆认证";
    UIImage *leftItemImage = [UIImage imageNamed:@"左箭头"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[leftItemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_TITLE_WHITE}];
    
    self.navigationController.navigationBar.barTintColor = COLOR_NAVI_BLACK;
    self.navigationController.navigationBar.backgroundColor = COLOR_NAVI_BLACK;
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
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, WIDTH_VIEW, 72)];
    topView.backgroundColor = BACKGROUND_COLOR_LIGHT;
    [self.view addSubview:topView];
    UILabel *licenseLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH_VIEW / 3, 21, WIDTH_VIEW / 3, 30)];
    licenseLabel.text = self.currentCar.license;
    licenseLabel.textAlignment = NSTextAlignmentCenter;
    licenseLabel.font = [UIFont systemFontOfSize:16.0];
    licenseLabel.backgroundColor = COLOR_BACK_BLUE;
    licenseLabel.textColor = COLOR_TITLE_WHITE;
    licenseLabel.layer.cornerRadius = CORNERRADIUS;
    licenseLabel.layer.masksToBounds = YES;
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = COLOR_TITLE_WHITE.CGColor;
    border.fillColor = nil;
    border.path = [UIBezierPath bezierPathWithRect:licenseLabel.bounds].CGPath;
    border.frame = licenseLabel.bounds;
    border.lineWidth = 1.5f;
    border.lineCap = @"square";
    border.lineDashPattern = @[@4, @6];
    [licenseLabel.layer addSublayer:border];
    [topView addSubview:licenseLabel];
    
    _certificateView = [NKCarCertificateView carCertificateView];
    _certificateView.frame = CGRectMake(0, 137, WIDTH_VIEW, HEIGHT_VIEW - 137);
    [self.view addSubview:_certificateView];
    //右侧页面
    //创建右侧页面
    //品牌型号
    [_certificateView.chooseCarTypeButton addTarget:self action:@selector(clickChooseCarTypeButton) forControlEvents:UIControlEventTouchUpInside];
    //车身颜色
    for (int i = 0; i < self.carColorButtonArray.count; i++)
    {
        UIButton *button = self.carColorButtonArray[i];
        [button addTarget:self action:@selector(clickCarColorButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 900 + i;
    }
    //照片
    [_certificateView.cardImageButton addTarget:self action:@selector(clickToTakePhoto:) forControlEvents:UIControlEventTouchUpInside];
    _certificateView.cardImageButton.tag = 1000;
    [_certificateView.handleCardImageButton addTarget:self action:@selector(clickToTakePhoto:) forControlEvents:UIControlEventTouchUpInside];
    _certificateView.handleCardImageButton.tag = 1001;
    //认证button
    [_certificateView.certificateButton addTarget:self action:@selector(clickCertificateButton) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark - 点击界面按钮相关方法
- (void)clickChooseCarTypeButton
{
    //改变字体内容和颜色
    self.certificateView.carTypeLabel.text = @"点击选择";
    self.certificateView.carTypeLabel.textColor = COLOR_TITLE_GRAY;
    
    CarBrandTableViewController *cbTVC = [[CarBrandTableViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:cbTVC];
    [self.navigationController presentViewController:navi animated:YES completion:nil];
}
- (void)clickCarColorButton:(UIButton *)sender
{
    for (int i = 0; i < self.carColorButtonArray.count; i++)
    {
        UIButton *button = self.carColorButtonArray[i];
        button.selected = NO;
    }
    sender.selected = YES;
    self.carColor = [NKColorManager stringWithUIColor:sender.backgroundColor];
}
- (void)clickToTakePhoto:(UIButton *)sender
{
    if (sender.tag == 1000)
    {
        //行驶证照片
        NSLog(@"1000");
        self.certificateView.cardImageButton.selected = YES;
        self.certificateView.handleCardImageButton.selected = NO;
    }
    else
    {
        NSLog(@"1001");
        self.certificateView.cardImageButton.selected = NO;
        self.certificateView.handleCardImageButton.selected = YES;
    }
    [self createAlertController];
}
- (void)clickCertificateButton
{
    NSLog(@"提交认证！");
    if (!self.certificateView.cardImageButton.imageView.image || !self.certificateView.handleCardImageButton.imageView.image)
    {
        [self showHUDWithText:@"照片不能为空"];
        return;
    }
    [self postToCertificateCar];
}
#pragma mark - 拍照相关方法
-(void)createAlertController
{
    self.alertController = [UIAlertController alertControllerWithTitle:@"选择照片" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    //创建action
    UIAlertAction *action_camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhotoFromCamera];
        NSLog(@"拍照。");
    }];
    UIAlertAction *action_album = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhotoFromAlbum];
        NSLog(@"从相册选择照片。");
    }];
    UIAlertAction *action_cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消。");
    }];
    [self.alertController addAction:action_album];
    [self.alertController addAction:action_camera];
    [self.alertController addAction:action_cancel];
    
    [self presentViewController:self.alertController animated:YES completion:nil];
}
-(void)takePhotoFromCamera
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];//进入照相界面
}
-(void)takePhotoFromAlbum
{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = YES;
    [self presentViewController:pickerImage animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if (self.certificateView.cardImageButton.isSelected)
    {
        [self.certificateView.cardImageButton setImage:info[UIImagePickerControllerEditedImage] forState:UIControlStateNormal];
    }
    if (self.certificateView.handleCardImageButton.isSelected)
    {
        [self.certificateView.handleCardImageButton setImage:info[UIImagePickerControllerEditedImage] forState:UIControlStateNormal];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"取消选取照片");
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -网络请求
- (void)postToCertificateCar
{
    //发送网络请求
    MBProgressHUD *waithud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    waithud.mode = MBProgressHUDModeIndeterminate;
    waithud.label.text = @"Loding";
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"myToken"];
    NSString *sspId = [[NSUserDefaults standardUserDefaults] objectForKey:@"sspId"];
    //提交照片
    NKDataManager *dataManager = [NKDataManager sharedDataManager];
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    [parametersDic setObject:@1 forKey:@"appType"];
    [parametersDic setObject:@0 forKey:@"ext2"];
    [parametersDic setObject:sspId forKey:@"sspId"];
    [parametersDic setObject:token forKey:@"token"];
    
    NSMutableArray *imageArray = [NSMutableArray array];
    
    [imageArray addObject:self.certificateView.cardImageButton.imageView.image];
    [imageArray addObject:self.certificateView.handleCardImageButton.imageView.image];
    [parametersDic setObject:imageArray forKey:@"imageArray"];
    
    NSString __block *driveUrlStr;
    NSString __block *idCardUrlStr;
    [dataManager POSTUploadImagesWithParameters:parametersDic Success:^(NKFile *file) {
        
        if (file.ret == 0)
        {
            if (!driveUrlStr)
            {
                driveUrlStr = file.url;
            }
            else
            {
                idCardUrlStr = file.url;
                if (driveUrlStr && idCardUrlStr)
                {
                    //发送车辆验证请求
                    [parametersDic removeAllObjects];
                    [parametersDic setValue:sspId forKey:@"username"];
                    [parametersDic setValue:self.currentCar.license forKey:@"license"];
                    [parametersDic setValue:driveUrlStr forKey:@"drivinglicese"];
                    [parametersDic setValue:idCardUrlStr forKey:@"idcard"];
                    [parametersDic setValue:self.carColor forKey:@"color"];
                    [parametersDic setValue:self.currentCar.carseries forKey:@"carseries"];
                    [parametersDic setValue:self.currentCar.carseriespic forKey:@"carseriespic"];
                    [parametersDic setValue:token forKey:@"token"];
                    //新增参数
                    [parametersDic setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"] forKey:@"clientId"];
                    [parametersDic setValue:@"2" forKey:@"mobileType"];
                    [dataManager POSTToCertificateCarWithParameters:parametersDic Success:^(NKBase *base) {
                        if (base.ret == 0)
                        {
                            //返回数据中只有一个carId添加车牌号为了显示
                            self.currentCar.license = [parametersDic objectForKey:@"license"];
                            self.currentCar.carseries = [parametersDic objectForKey:@"carseries"];
                            self.currentCar.carseriespic = [parametersDic objectForKey:@"carseriespic"];
                            self.currentCar.auditFlag = 1;
                            //在车辆的数组中找到该认证车辆，并将其转码存储
                            NSMutableArray *carDataArray = [NSMutableArray array];
                            for (NKCar *car in self.carsArray) {
                                if ([car.license isEqualToString:self.currentCar.license]) {
                                    car.carseries = self.currentCar.carseries;
                                    car.carseriespic = self.currentCar.carseriespic;
                                    car.auditFlag = self.currentCar.auditFlag;
                                }
                                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:car];
                                [carDataArray addObject:data];
                            }
                            [[NSUserDefaults standardUserDefaults] setObject:carDataArray forKey:@"carArray"];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [waithud hideAnimated:YES];
                                [waithud removeFromSuperViewOnHide];
                                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                            });
                            [self showHUDWithText:@"提交成功，等待系统审核"];
                        }
                        else
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [waithud hideAnimated:YES];
                                [waithud removeFromSuperViewOnHide];
                            });
                            [self showHUDWithText:base.msg];
                        }
                    } Failure:^(NSError *error) {
                        [self showHUDWithText:@"网络异常"];
                    }];
                }
            }
        }
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showHUDWithText:@"网络异常"];
        });
    }];
}

- (void) showHUDWithText:(NSString *)str
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = str;
    [hud hideAnimated:YES afterDelay:2.0];
    [hud removeFromSuperViewOnHide];
}
@end
