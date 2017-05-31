//
//  BindLocalPassportViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 2017/5/4.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "BindLocalPassportViewController.h"
#import "Masonry.h"
#import "MBProgressHUD.h"
#import "NKAlertView.h"
#import "NKDataManager.h"
#import "NKLocalPassportUnbindDto.h"

@interface BindLocalPassportViewController ()
{
    dispatch_source_t _timer;
}

@property (nonatomic, strong) MBProgressHUD *HUD;

@property (nonatomic, strong) UITextField *phoneTextField;

@property (nonatomic, strong) UITextField *smsCodeTextField;

@property (nonatomic, strong) UIButton *smsCodeButton;

@property (nonatomic, strong) NSString *naviTitle;

@property (nonatomic, strong) NKLocalPassportUnbindDto *bindDto;

@end

@implementation BindLocalPassportViewController

-(instancetype)initWithLocalPassport:(NKLocalPassportUnbindDto *)bindDto
{
    if (self = [super init])
    {
        _naviTitle = bindDto.cityName;
        _bindDto = bindDto;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self initSubViews];
}

- (void)dealloc
{
    [_HUD removeFromSuperViewOnHide];
    _HUD = nil;
    
    if (_timer)
    {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

#pragma mark - 界面初始化
- (void)setNavigationBar
{
    self.navigationItem.title = [NSString stringWithFormat:@"绑定%@账户", _naviTitle];
    UIImage *leftItemImage = [UIImage imageNamed:@"左箭头"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[leftItemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_TITLE_WHITE}];
    self.navigationController.navigationBar.barTintColor = COLOR_NAVI_BLACK;
    [self.navigationController.navigationBar setTintColor:COLOR_NAVI_BLACK];
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextField *phoneTextField = [[UITextField alloc] init];
    [self.view addSubview:phoneTextField];
    _phoneTextField = phoneTextField;
    phoneTextField.placeholder = @"输入独山账户注册手机号";
    phoneTextField.layer.cornerRadius = CORNERRADIUS;
    phoneTextField.backgroundColor = BACKGROUND_COLOR;
    phoneTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(phoneTextField.frame.origin.x, phoneTextField.frame.origin.y, 12, phoneTextField.frame.size.height)];
    phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(74);
        make.left.equalTo(self.view.mas_left).offset(12);
        make.right.equalTo(self.view.mas_right).offset(-12);
        make.height.equalTo(@45);
    }];
    
    UIButton *smsCodeButton = [[UIButton alloc] init];
    _smsCodeButton = smsCodeButton;
    [self.view addSubview:smsCodeButton];
    [smsCodeButton setTitle:@"验证码" forState:UIControlStateNormal];
    [smsCodeButton setTitleColor:COLOR_TITLE_RED forState:UIControlStateNormal];
    smsCodeButton.layer.cornerRadius = CORNERRADIUS;
    smsCodeButton.layer.masksToBounds = YES;
    smsCodeButton.layer.borderColor = COLOR_TITLE_RED.CGColor;
    smsCodeButton.layer.borderWidth = 1;
    [smsCodeButton addTarget:self action:@selector(clickSmsCodeButton) forControlEvents:UIControlEventTouchUpInside];
    [smsCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneTextField.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-12);
        make.height.equalTo(@43);
        make.width.equalTo(@80);
    }];
    
    UITextField *smsCodeTextfield = [[UITextField alloc] init];
    _smsCodeTextField = smsCodeTextfield;
    [self.view addSubview:smsCodeTextfield];
    smsCodeTextfield.placeholder = @"输入验证码";
    smsCodeTextfield.layer.cornerRadius = CORNERRADIUS;
    smsCodeTextfield.backgroundColor = BACKGROUND_COLOR;
    smsCodeTextfield.leftView = [[UIView alloc] initWithFrame:CGRectMake(smsCodeTextfield.frame.origin.x, smsCodeTextfield.frame.origin.y, 12, smsCodeTextfield.frame.size.height)];
    smsCodeTextfield.leftViewMode = UITextFieldViewModeAlways;
    smsCodeTextfield.keyboardType = UIKeyboardTypeNumberPad;
    [smsCodeTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneTextField.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(12);
        make.right.equalTo(smsCodeButton.mas_left).offset(-8);
        make.height.equalTo(@45);
    }];
    
    UIButton *sureButton = [[UIButton alloc] init];
    [self.view addSubview:sureButton];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:COLOR_TITLE_WHITE forState:UIControlStateNormal];
    [sureButton setBackgroundColor:COLOR_BUTTON_RED];
    sureButton.layer.cornerRadius = CORNERRADIUS;
    sureButton.layer.masksToBounds = YES;
    [sureButton addTarget:self action:@selector(clickSureButton) forControlEvents:UIControlEventTouchUpInside];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(smsCodeTextfield.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-12);
        make.height.equalTo(@45);
        make.left.equalTo(self.view.mas_left).offset(12);
    }];
    
    _HUD = [[MBProgressHUD alloc] init];
    _HUD.center = self.view.center;
    [self.view addSubview:_HUD];
}

- (void)clickSmsCodeButton
{
    if (_phoneTextField.text.length != 11)
    {
        _HUD.mode = MBProgressHUDModeText;
        _HUD.label.text = @"请输入正确的手机号";
        [_HUD showAnimated:YES];
        [_HUD hideAnimated:YES afterDelay:2.0];
        return;
    }
    
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    //往字典里面添加需要提交的参数
    [parametersDic setObject:_phoneTextField.text forKey:@"mobileNum"];
    NKDataManager *dataManager = [NKDataManager sharedDataManager];
    [dataManager POSTUserCenterMaskDataWithParameters:parametersDic Success:^(NKMask *mask) {
        NSLog(@"请求成功！！！");
        NSLog(@"%@", mask.msg);
    } Failure:^(NSError *error) {
        NSLog(@"请求失败！");
        NSLog(@"%@", error);
    }];
    __block int timeout=59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_smsCodeButton setTitleColor:COLOR_TITLE_RED forState:UIControlStateNormal];
                [_smsCodeButton setTitle:@"验证码" forState:UIControlStateNormal];
                _smsCodeButton.layer.cornerRadius = CORNERRADIUS;
                _smsCodeButton.layer.masksToBounds = YES;
                _smsCodeButton.layer.borderColor = COLOR_TITLE_RED.CGColor;
                _smsCodeButton.layer.borderWidth = 1;
                
                _smsCodeButton.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                [_smsCodeButton setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                _smsCodeButton.backgroundColor = [UIColor clearColor];
                [_smsCodeButton setTitleColor:CUTLINE_COLOR forState:UIControlStateNormal];
                _smsCodeButton.layer.borderColor = CUTLINE_COLOR.CGColor;
                _smsCodeButton.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}

- (void)clickSureButton
{
    if (_phoneTextField.text.length != 11)
    {
        _HUD.mode = MBProgressHUDModeText;
        _HUD.label.text = @"请输入正确的手机号";
        [_HUD showAnimated:YES];
        [_HUD hideAnimated:YES afterDelay:2.0];
        return;
    }
    if (_smsCodeTextField.text.length != 4)
    {
        _HUD.mode = MBProgressHUDModeText;
        _HUD.label.text = @"请输入正确的验证码";
        [_HUD showAnimated:YES];
        [_HUD hideAnimated:YES afterDelay:2.0];
        return;
    }
    _HUD.mode = MBProgressHUDModeIndeterminate;
    [_HUD showAnimated:YES];
    
    NSString *sspId = [[NSUserDefaults standardUserDefaults] objectForKey:@"sspId"];
    NSString *areaCode = [NSString stringWithFormat:@"%li", (long)_bindDto.areaCode];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:sspId forKey:@"userId"];
    [parameters setValue:_phoneTextField.text forKey:@"loginNameOrMobile"];
    [parameters setValue:_smsCodeTextField.text forKey:@"smscode"];
    [parameters setValue:areaCode forKey:@"areaCode"];
    
    NKDataManager *dataManager = [NKDataManager sharedDataManager];
    [dataManager POSTToBindLocalPassportWithParameters:parameters Success:^(NKBase *base) {
        if (base.ret == 0)
        {
            [self showHUDWith:@"绑定账户成功"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSelector:@selector(goBack) withObject:nil afterDelay:2.2];
            });
        }
        else
        {
            [self showHUDWith:@"绑定账户失败"];
        }
    } Failure:^(NSError *error) {
        [self showHUDWith:@"网络异常"];
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)showHUDWith:(NSString *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _HUD.mode = MBProgressHUDModeText;
        _HUD.label.text = msg;
        [_HUD showAnimated:YES];
        [_HUD hideAnimated:YES afterDelay:2.0];
    });
}

@end
