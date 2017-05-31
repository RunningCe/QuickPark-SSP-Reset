//
//  AddCarsViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 16/8/16.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "AddCarsViewController.h"
#import "NKDataManager.h"
#import "NKCar.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "KeyBoardView.h"
#import "NKCarCertificateView.h"
#import "CarCertificateViewController.h"
#import "CarBrandTableViewController.h"
#import "Masonry.h"
#import "NKColorManager.h"
//键盘的一些定义宏
#define KWIDTH [UIScreen mainScreen].bounds.size.width
#define KHEIGHT [UIScreen mainScreen].bounds.size.height
#define ButtonWidth (KWIDTH - 25)/9
#define ButtonHeight (KWIDTH/9/7*8)
#define KEYBOARD_HEIGHT ((ButtonHeight+1)*4)
#define KEYBOARD_WIDTH (KWIDTH - 16)

@interface AddCarsViewController ()<KeyBoardViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
//文本框背景
@property (weak, nonatomic) IBOutlet UIView *textFieldBacgroundView;
//7个textfield
@property (weak, nonatomic) IBOutlet UITextField *textField_0;
@property (weak, nonatomic) IBOutlet UITextField *textField_1;
@property (weak, nonatomic) IBOutlet UITextField *textField_2;
@property (weak, nonatomic) IBOutlet UITextField *textField_3;
@property (weak, nonatomic) IBOutlet UITextField *textField_4;
@property (weak, nonatomic) IBOutlet UITextField *textField_5;
@property (weak, nonatomic) IBOutlet UITextField *textField_6;
//分割线
@property (weak, nonatomic) IBOutlet UIView *cutLine_0;
@property (weak, nonatomic) IBOutlet UIView *cutLine_1;
@property (weak, nonatomic) IBOutlet UIView *cutLine_2;
@property (weak, nonatomic) IBOutlet UIView *cutLine_3;
@property (weak, nonatomic) IBOutlet UIView *cutLine_4;
@property (weak, nonatomic) IBOutlet UIView *cutLine_5;
@property (nonatomic, strong)NSMutableArray *cutLineMutableArray;

//省份简称键盘
@property (nonatomic, strong)KeyBoardView *provinceKeyBoardView;
//数字字母键盘
@property (nonatomic, strong)KeyBoardView *numberKeyBoardView;

@property (nonatomic, assign)NSInteger currentTextFieldCount;
/*********新增*********/
//提示信息
@property (weak, nonatomic) IBOutlet UIView *msgBaseView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgBaseViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UILabel *magSubLabel; 
//确定按钮
@property (weak, nonatomic) IBOutlet UIButton *leftSureButton;
//两个切换按钮
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
//左右两个切换页面
@property (weak, nonatomic) IBOutlet UIView *leftview;
//底部的base View
@property (weak, nonatomic) IBOutlet UIView *bottomView;
//判断是否可以添加为新车
@property (nonatomic, assign) BOOL isExistCar;
//判断是否已经认证
@property (nonatomic, assign) BOOL isCertificate;
//****右侧界面****
@property (nonatomic, strong) UIAlertController *alertController;
@property (nonatomic, strong) NKCarCertificateView *rightview;
@property (nonatomic, strong) NSArray *carColorButtonArray;

@property (nonatomic, copy) NSString *carColor;
@property (nonatomic, strong) NSString *license;
@property (nonatomic, strong) NSString *carseries;
@property (nonatomic, strong) NSString *carseriesPic;

@end

@implementation AddCarsViewController
#pragma setter && getter
- (NSMutableArray *)textFieldMuatableArray
{
    if (_textFieldMuatableArray == nil)
    {
        self.textFieldMuatableArray = [NSMutableArray arrayWithObjects:self.textField_0, self.textField_1, self.textField_2, self.textField_3, self.textField_4, self.textField_5, self.textField_6, nil];
    }
    return _textFieldMuatableArray;
}
- (NSMutableArray *)cutLineMutableArray
{
    if (_cutLineMutableArray == nil)
    {
        _cutLineMutableArray = [NSMutableArray arrayWithObjects:self.cutLine_0, self.cutLine_1, self.cutLine_2, self.cutLine_3, self.cutLine_4, self.cutLine_5, nil];
    }
    return _cutLineMutableArray;
}
- (NSArray *)carColorButtonArray
{
    if (_carColorButtonArray == nil)
    {
        _carColorButtonArray = [NSArray arrayWithArray:self.rightview.carColorButtonArray];
    }
    return _carColorButtonArray;
}
#pragma mark -控制器生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    _currentTextFieldCount = 0;
    [self setNavigationBar];
    [self initSubViews];
    
    //创建省份键盘
    _provinceKeyBoardView = [[KeyBoardView alloc] initWithFrame:CGRectMake(8, KHEIGHT-KEYBOARD_HEIGHT, KEYBOARD_WIDTH, KEYBOARD_HEIGHT) andType:NKKeyBoardProvinceName];
    _provinceKeyBoardView.backgroundColor = BACKGROUND_COLOR;
    _provinceKeyBoardView.delegate = self;
    _provinceKeyBoardView.hidden = NO;
    [self.view addSubview:_provinceKeyBoardView];
    //创建数字键盘
    _numberKeyBoardView = [[KeyBoardView alloc] initWithFrame:CGRectMake(8, KHEIGHT-KEYBOARD_HEIGHT, KEYBOARD_WIDTH, KEYBOARD_HEIGHT) andType:NKKeyBoardNumber];
    _numberKeyBoardView.backgroundColor = BACKGROUND_COLOR;
    _numberKeyBoardView.delegate = self;
    _numberKeyBoardView.hidden = YES;
    [self.view addSubview:_numberKeyBoardView];
    
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
    self.rightview.carTypeLabel.textColor = COLOR_TITLE_BLACK;
    self.rightview.carTypeLabel.text = noti.userInfo[@"carTypeStr"];
    self.carseries = noti.userInfo[@"carTypeStr"];
    self.carseriesPic = noti.userInfo[@"logoPicUrl"];
}
#pragma mark 初始化界面控件
- (void)setNavigationBar
{
    self.navigationItem.title = @"添加车辆";
    UIImage *leftItemImage = [UIImage imageNamed:@"左箭头"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[leftItemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_TITLE_WHITE}];
    
    self.navigationController.navigationBar.barTintColor = COLOR_NAVI_BLACK;
    self.navigationController.navigationBar.backgroundColor = COLOR_NAVI_BLACK;
    
}
-(void)goBack
{
    if (self.navigationController.childViewControllers.count == 1)
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void) initSubViews
{
    for (UITextField *textfield in self.textFieldMuatableArray)
    {
        textfield.borderStyle = UITextBorderStyleNone;
        textfield.delegate = self;
    }
    for (UIView *view in self.cutLineMutableArray)
    {
        view.backgroundColor = BACKGROUND_COLOR_LIGHT;
    }
    self.textFieldBacgroundView.layer.cornerRadius = CORNERRADIUS;
    self.textFieldBacgroundView.layer.masksToBounds = YES;
    self.textFieldBacgroundView.layer.borderColor = CUTLINE_COLOR.CGColor;
    self.textFieldBacgroundView.layer.borderWidth = 1;
    for (UIView *cutlin in self.cutLineMutableArray)
    {
        cutlin.backgroundColor = CUTLINE_COLOR;
    }
    
    //页面的初始状态
    self.leftview.hidden = NO;
    self.msgBaseView.backgroundColor = BACKGROUND_COLOR;
    self.msgBaseViewHeight.constant = 0;
    self.msgBaseView.hidden = YES;
    
    self.leftSureButton.backgroundColor = COLOR_BUTTON_GRAY_DEEP;
    self.leftSureButton.userInteractionEnabled = NO;
    
    [self.leftButton setBackgroundColor:BACKGROUND_COLOR_LIGHT];
    [self.rightButton setBackgroundColor:BACKGROUND_COLOR];
    [self.leftButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton setTitleColor:COLOR_TITLE_BLACK forState:UIControlStateNormal];
    [self.rightButton setTitleColor:COLOR_TITLE_BLACK forState:UIControlStateNormal];
    [self.leftButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -8, 0.0, 0.0)];
    [self.rightButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -8, 0.0, 0.0)];
    
    //右侧页面
    //创建右侧页面
    _rightview = [NKCarCertificateView carCertificateView];
    [self.bottomView addSubview:_rightview];
    self.bottomView.hidden = YES;
    self.rightview.hidden = YES;
    [_rightview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView.mas_right);
        make.left.equalTo(self.bottomView.mas_left);
        make.top.equalTo(self.bottomView.mas_top).offset(36);
        make.bottom.equalTo(self.bottomView.mas_bottom);
     }];
    //品牌型号
    [_rightview.chooseCarTypeButton addTarget:self action:@selector(clickChooseCarTypeButton) forControlEvents:UIControlEventTouchUpInside];
    //车身颜色
    for (int i = 0; i < self.carColorButtonArray.count; i++)
    {
        UIButton *button = self.carColorButtonArray[i];
        [button addTarget:self action:@selector(clickCarColorButton:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *carSelectImage = [UIImage imageNamed:@"addCar_车身颜色选中"];
        [button setImage:[carSelectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
        button.tag = 900 + i;
    }
    //照片
    [_rightview.cardImageButton addTarget:self action:@selector(clickToTakePhoto:) forControlEvents:UIControlEventTouchUpInside];
    _rightview.cardImageButton.tag = 1000;
    [_rightview.handleCardImageButton addTarget:self action:@selector(clickToTakePhoto:) forControlEvents:UIControlEventTouchUpInside];
    _rightview.handleCardImageButton.tag = 1001;
    //认证button
    [_rightview.certificateButton addTarget:self action:@selector(clickCertificateButton) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark - KeyBoardViewDelegate
-(void)passValueWithButton:(UIButton *)button
{
    if (self.msgBaseView.hidden){
        self.msgBaseViewHeight.constant = 0;
        self.msgBaseView.hidden = YES;
    }
    
    UITextField *currentTextFeild = self.textFieldMuatableArray[_currentTextFieldCount];
    currentTextFeild.text = [NSString stringWithFormat:@"%@", button.titleLabel.text];
    if (button.tag == 5036){
        //判断点击的是删除键
        //清空单元格，设置第一个文本框为焦点
        for (UITextField *textField in self.textFieldMuatableArray)
        {
            textField.text = @"";
            [self.textField_0 becomeFirstResponder];
            _currentTextFieldCount = 0;
            _numberKeyBoardView.hidden = YES;
            _provinceKeyBoardView.hidden = NO;
        }
    }
    else{
        if ([currentTextFeild isEqual:self.textField_0])
        {
            [self.textField_1 becomeFirstResponder];
            _currentTextFieldCount = 1;
        }
        if ([currentTextFeild isEqual:self.textField_1])
        {
            [self.textField_2 becomeFirstResponder];
            _currentTextFieldCount = 2;
        }
        if ([currentTextFeild isEqual:self.textField_2])
        {
            [self.textField_3 becomeFirstResponder];
            _currentTextFieldCount = 3;
        }
        if ([currentTextFeild isEqual:self.textField_3])
        {
            [self.textField_4 becomeFirstResponder];
            _currentTextFieldCount = 4;
        }
        if ([currentTextFeild isEqual:self.textField_4])
        {
            [self.textField_5 becomeFirstResponder];
            _currentTextFieldCount = 5;
        }
        if ([currentTextFeild isEqual:self.textField_5])
        {
            [self.textField_6 becomeFirstResponder];
            _currentTextFieldCount = 6;
        }
        if ([currentTextFeild isEqual:self.textField_6])
        {
            _numberKeyBoardView.hidden = YES;
            _currentTextFieldCount = 0;
        }

    }
    //判断输入车牌的长度，够7位后设置确定按钮为可点击
    NSString *license = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",self.textField_0.text, self.textField_1.text, self.textField_2.text, self.textField_3.text, self.textField_4.text, self.textField_5.text, self.textField_6.text];
    self.license = license;
    if (license.length == 7)
    {
        self.bottomView.hidden = NO;
        [self sentPostToCheckCarExistWithLicense:license];
    }
    else
    {
        self.bottomView.hidden = YES;
        self.rightview.cardImageButton.imageView.image = nil;
        self.rightview.handleCardImageButton.imageView.image = nil;
    }
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //判断第一个textField是否为空
    if (![textField isEqual:_textField_0] && [_textField_0.text isEqualToString:@""])
    {
        [_textField_0 becomeFirstResponder];
        for (UITextField *textField in self.textFieldMuatableArray)
        {
            textField.text = @"";
        }
        _numberKeyBoardView.hidden = YES;
        _provinceKeyBoardView.hidden = NO;
        return NO;
    }
    //清空
    if ([textField isEqual:self.textField_0])
    {
        for (UITextField *textField in self.textFieldMuatableArray)
        {
            textField.text = @"";
        }
        _numberKeyBoardView.hidden = YES;
        _provinceKeyBoardView.hidden = NO;
    }
    else
    {
        _provinceKeyBoardView.hidden =YES;
        _numberKeyBoardView.hidden = NO;
    }
    return NO;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.provinceKeyBoardView.hidden = YES;
    self.numberKeyBoardView.hidden = YES;
}
#pragma mark - 点击界面按钮相关方法
- (void)clickLeftButton
{
    self.leftButton.backgroundColor = BACKGROUND_COLOR_LIGHT;
    self.rightButton.backgroundColor = BACKGROUND_COLOR;
    
    self.leftview.hidden = NO;
    self.rightview.hidden = YES;
}
- (void)clickRightButton
{
    self.leftButton.backgroundColor = BACKGROUND_COLOR;
    self.rightButton.backgroundColor = BACKGROUND_COLOR_LIGHT;
    
    self.leftview.hidden = YES;
    self.rightview.hidden = NO;
}
- (IBAction)clickLeftSureButton:(UIButton *)sender
{
    //提交按钮
    NSString *license = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",self.textField_0.text, self.textField_1.text, self.textField_2.text, self.textField_3.text, self.textField_4.text, self.textField_5.text, self.textField_6.text];
    if (license.length == 7 && self.isExistCar == NO)
    {
        [self sentPostToAddCarWithLicense:license];
    }
    else
    {
        return;
    }
}
- (void)clickChooseCarTypeButton
{
    //改变字体内容和颜色
    self.rightview.carTypeLabel.text = @"点击选择";
    self.rightview.carTypeLabel.textColor = COLOR_TITLE_GRAY;
    
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
        self.rightview.cardImageButton.selected = YES;
        self.rightview.handleCardImageButton.selected = NO;
    }
    else
    {
        self.rightview.cardImageButton.selected = NO;
        self.rightview.handleCardImageButton.selected = YES;
    }
    [self createAlertController];
}
- (void)clickCertificateButton
{
    NSLog(@"提交认证！");
    if (!self.rightview.cardImageButton.imageView.image || !self.rightview.handleCardImageButton.imageView.image)
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
    if (self.rightview.cardImageButton.isSelected)
    {
        [self.rightview.cardImageButton setImage:info[UIImagePickerControllerEditedImage] forState:UIControlStateNormal];
    }
    if (self.rightview.handleCardImageButton.isSelected)
    {
        [self.rightview.handleCardImageButton setImage:info[UIImagePickerControllerEditedImage] forState:UIControlStateNormal];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"取消选取照片");
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 发送网络请求
//查询车辆是否存在
- (void)sentPostToCheckCarExistWithLicense:(NSString *)license
{
    //发送网络请求
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"Loding";
    
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    [parametersDic setValue:license forKey:@"license"];
    
    NKDataManager *dataManager = [NKDataManager sharedDataManager];
    [dataManager POSTTOCheckCarExistWithParameters:parametersDic Success:^(NKBase *base) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (base.ret == 0){
            //车辆已经添加，已经认证
            self.isExistCar = YES;
            self.isCertificate = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.leftButton setTitle:@"暂不申请" forState:UIControlStateNormal];
                [self.rightButton setTitle:@"申请授权" forState:UIControlStateNormal];
                [self.rightButton setImage:[UIImage imageNamed:@"addcar_申请授权"] forState:UIControlStateNormal];
                self.msgLabel.text = @"该车辆已有车主认证";
                self.magSubLabel.text = @"您可以向车主申请授权使用车辆";
                self.rightview.msgLabel.hidden = YES;
                self.rightview.firstSubView.hidden = NO;
                self.rightview.secondSubView.hidden = NO;
                self.rightview.thirdSubView.hidden = NO;
                self.msgBaseViewHeight.constant = 36;
                self.msgBaseView.hidden = NO;
            });
        }
        else if (base.ret == -1){
            //车辆已添加未认证
            self.isExistCar = YES;
            self.isCertificate = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.leftButton setTitle:@"放弃认证" forState:UIControlStateNormal];
                self.msgBaseViewHeight.constant = 36;
                self.msgBaseView.hidden = NO;
                
            });
        }
        else if (base.ret == -2){
        //车辆未添加
            self.isExistCar = NO;
            self.isCertificate = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.msgBaseViewHeight.constant = 0;
                self.msgBaseView.hidden = YES;
                //更改左侧添加车辆按钮的状态
                self.leftSureButton.backgroundColor = COLOR_BUTTON_BLACK;
                self.leftSureButton.userInteractionEnabled = YES;
            });
        }
        else if (base.ret == -20){
            self.isExistCar = YES;
            self.isCertificate = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.msgBaseViewHeight.constant = 0;
                self.msgBaseView.hidden = YES;
            });
        //参数错误
            [self showHUDWithText:@"参数错误"];
        }
        else{
        //其他错误
            self.isExistCar = YES;
            self.isCertificate = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.msgBaseViewHeight.constant = 0;
                self.msgBaseView.hidden = YES;
            });
            [self showHUDWithText:@"未知错误"];
        }
        
    } Failure:^(NSError *error) {
        self.isExistCar = YES;
        self.isCertificate = NO;
        [self showHUDWithText:@"网络异常"];
    }];
}
//发送网络请求
- (void)sentPostToAddCarWithLicense:(NSString *)license
{
    //发送网络请求
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"Loding";
    
    //从文本框获得车牌号
    
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    
    [parametersDic setObject:license forKey:@"license"];
    [parametersDic setObject:self.user.token forKey:@"token"];
    [parametersDic setObject:self.user.id forKey:@"ownerId"];
    
    NKDataManager *manager = [NKDataManager sharedDataManager];
    [manager POSTAddCarWithParameters:parametersDic Success:^(NKCar *car) {
        if (car.ret == 0)
        {
            //返回数据中只有一个carId添加车牌号为了显示
            car.license = [parametersDic objectForKey:@"license"];
            car.carseries = [parametersDic objectForKey:@"carseries"];
            car.carseriespic = [parametersDic objectForKey:@"carseriespic"];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            NSMutableArray *carArray = [NSMutableArray arrayWithArray:[userDefault objectForKey:@"carArray"]];
            NSData *carData = [NSKeyedArchiver archivedDataWithRootObject:car];
            [carArray addObject:carData];
            [userDefault setObject:carArray forKey:@"carArray"];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            });
            [self showHUDWithText:@"添加车辆成功"];
        }
        else
        {
            [self showHUDWithText:car.msg];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            });
        }
        
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self showHUDWithText:@"网络异常"];
        });
    }];
}
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
    //[parametersDic setObject:self.carID forKey:@"ext1"];
    [parametersDic setObject:@0 forKey:@"ext2"];
    //[parametersDic setObject:[NSNumber numberWithInteger:self.carSegment.selectedSegmentIndex] forKey:@"carType"];
    [parametersDic setObject:sspId forKey:@"sspId"];
    [parametersDic setObject:token forKey:@"token"];
    
    NSMutableArray *imageArray = [NSMutableArray array];
    
    [imageArray addObject:self.rightview.cardImageButton.imageView.image];
    [imageArray addObject:self.rightview.handleCardImageButton.imageView.image];
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
                    [parametersDic setValue:self.license forKey:@"license"];
                    [parametersDic setValue:driveUrlStr forKey:@"drivinglicese"];
                    [parametersDic setValue:idCardUrlStr forKey:@"idcard"];
                    [parametersDic setValue:self.carColor forKey:@"color"];
                    [parametersDic setValue:self.carseries forKey:@"carseries"];
                    [parametersDic setValue:self.carseriesPic forKey:@"carseriespic"];
                    [parametersDic setValue:token forKey:@"token"];
                    //[parametersDic setValue:@"" forKey:@"ownerId"];
                    //新增参数
                    [parametersDic setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"] forKey:@"clientId"];
                    [parametersDic setValue:@"2" forKey:@"mobileType"];
                    
                    [dataManager POSTToCertificateCarWithParameters:parametersDic Success:^(NKBase *base) {
                        if (base.ret == 0)
                        {
                            //返回数据中只有一个carId添加车牌号为了显示
                            //得到所有的车辆
                            NSArray *carDataArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"carArray"];
                            NSMutableArray *carArray = [NSMutableArray array];
                            for (NSData *data in carDataArray) {
                                NKCar *car = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                                [carArray addObject:car];
                            }
                            //将car存到本地
                            NSMutableArray *carDataMutableArray = [NSMutableArray array];
                            NKCar *certificateCar;
                            for (NKCar *car in carArray)
                            {
                                if ([car.license isEqualToString:[parametersDic objectForKey:@"license"]]) {
                                    certificateCar = car;
                                    car.carseries = [parametersDic objectForKey:@"carseries"];
                                    car.carseriespic = [parametersDic objectForKey:@"carseriespic"];
                                }
                                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:car];
                                [carDataMutableArray addObject:data];
                            }
                            if (certificateCar)
                            {
                                //车辆已存在
                                [[NSUserDefaults standardUserDefaults] setObject:carDataMutableArray forKey:@"carArray"];
                            }
                            else
                            {
                                //不存在添加新的
                                certificateCar = [[NKCar alloc] init];
                                certificateCar.license = [parametersDic objectForKey:@"license"];
                                certificateCar.carseries = [parametersDic objectForKey:@"carseries"];
                                certificateCar.carseriespic = [parametersDic objectForKey:@"carseriespic"];
                                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:certificateCar];
                                [carDataMutableArray addObject:data];
                                [[NSUserDefaults standardUserDefaults] setObject:carDataMutableArray forKey:@"carArray"];
                            }
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [waithud hideAnimated:YES];
                                [waithud removeFromSuperViewOnHide];
                                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                            });
                            [self showHUDWithText:@"提交成功，等待系统验证"];
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
#pragma mark - HUD
- (void) showHUDWithText:(NSString *)str
{
    UIWindow *mainWindow = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = str;
    [hud hideAnimated:YES afterDelay:2.0];
    [hud removeFromSuperViewOnHide];
}


@end
