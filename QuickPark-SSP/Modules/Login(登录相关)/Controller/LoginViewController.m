//
//  LoginViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 16/8/18.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "LoginViewController.h"
#import "MainTabbarViewController.h"
#import "BoundPhoneViewController.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "NKMask.h"
#import "NKLogin.h"
#import "MJExtension.h"
#import "NKDataManager.h"
#import "NKCar.h"
#import "NKBerth.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "NKDataManager.h"

#import "WXApiManager.h"
#import "QQApiManager.h"

#import "AliyPayApiManager.h"



@interface LoginViewController ()
{
    dispatch_source_t _timer;
}

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *maskTextField;
@property (weak, nonatomic) IBOutlet UIView *cutLineView_0;
@property (weak, nonatomic) IBOutlet UIView *cutLineView_1;
@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (weak, nonatomic) IBOutlet UIButton *maskButton;

@property (weak, nonatomic) IBOutlet UIButton *wechatButton;
@property (weak, nonatomic) IBOutlet UIButton *qqButton;
//@property (weak, nonatomic) IBOutlet UIButton *aliypayButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qqButtonCenterX;

@property (nonatomic, strong)TencentOAuth *tencentOAuth;
@property (nonatomic, strong)NSString *qqOpenId;

@property (weak, nonatomic) IBOutlet UILabel *protocolLabel;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatDidLoginNotification:) name:@"wechatDidLoginNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(qqDidLoginNotification:) name:@"qqDidLoginNotification" object:nil];
}
//改变状态栏颜色
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    if (_timer)
    {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initSubViews
{
    
    self.phoneTextField.textColor = CUTLINE_COLOR;
    self.phoneTextField.borderStyle = UITextBorderStyleNone;
    self.phoneTextField.placeholder = @"输入手机号";
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.phoneTextField setValue:CUTLINE_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    
    self.maskTextField.textColor = CUTLINE_COLOR;
    self.maskTextField.borderStyle = UITextBorderStyleNone;
    self.maskTextField.placeholder = @"输入验证码";
    self.maskTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.maskTextField setValue:CUTLINE_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    
    self.cutLineView_0.backgroundColor = CUTLINE_COLOR;
    self.cutLineView_1.backgroundColor = CUTLINE_COLOR;
    
    [self.maskButton setTitleColor:CUTLINE_COLOR forState:UIControlStateNormal];
    self.maskButton.layer.cornerRadius = CORNERRADIUS;
    self.maskButton.layer.masksToBounds = YES;
    self.maskButton.layer.borderColor = CUTLINE_COLOR.CGColor;
    self.maskButton.layer.borderWidth = 1;
    
    self.orLabel.textColor = CUTLINE_COLOR;
    
    self.loginButton.backgroundColor = COLOR_BUTTON_RED;
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginButton.layer.cornerRadius = CORNERRADIUS;
    self.loginButton.layer.masksToBounds = YES;
    
    self.protocolLabel.textColor = COLOR_TITLE_GRAY;

    //判断手机上有没有装微信
    if(![WXApi isWXAppInstalled])
    {
        self.wechatButton.hidden = YES;
        [self.wechatButton removeFromSuperview];
        [self.view removeConstraint:self.qqButtonCenterX];
        NSLayoutConstraint *myConstraint =[NSLayoutConstraint
                                           constraintWithItem:self.qqButton //子试图
                                           attribute:NSLayoutAttributeCenterX //子试图的约束属性
                                           relatedBy:NSLayoutRelationEqual //属性间的关系
                                           toItem:self.view//相对于父试图
                                           attribute:NSLayoutAttributeCenterX//父试图的约束属性
                                           multiplier:1.0
                                           constant:0.0];// 固定距离
        [self.view addConstraint: myConstraint];//为iSinaButton重新添加一个约束
    }
}
#pragma mark -界面button方法
- (IBAction)clickMaskButton:(UIButton *)sender
{
    NSLog(@"发送验证码！");
    if (self.phoneTextField.text.length == 0)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请输入手机号";
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            [hud removeFromSuperViewOnHide];
        });
        return;
    }
    [_maskTextField becomeFirstResponder];
    /******************发送网络请求*****************/
    // 启动系统风火轮
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //假如需要提交给服务器的参数是key＝1,class_id=100
    //创建一个可变字典
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    //往字典里面添加需要提交的参数
    [parametersDic setObject:_phoneTextField.text forKey:@"mobileNum"];
    //[parametersDic setObject:@"" forKey:@"type"];
    
    NKDataManager *dataManager = [NKDataManager sharedDataManager];
    [dataManager POSTMaskDataWithParameters:parametersDic Success:^(NKMask *mask) {
        NSLog(@"请求成功！！！");
        NSLog(@"%@", mask.msg);
    } Failure:^(NSError *error) {
        NSLog(@"请求失败！");
        NSLog(@"%@", error);
    }];

    /***********************************************/
    __block int timeout=59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                [_maskButton setTitleColor:CUTLINE_COLOR forState:UIControlStateNormal];
                [_maskButton setTitle:@"验证码" forState:UIControlStateNormal];
                _maskButton.layer.cornerRadius = CORNERRADIUS;
                _maskButton.layer.masksToBounds = YES;
                _maskButton.layer.borderColor = CUTLINE_COLOR.CGColor;
                _maskButton.layer.borderWidth = 1;
                
                _maskButton.userInteractionEnabled = YES;
                
            });
            
        }else{
            
            //            int minutes = timeout / 60;
            
            int seconds = timeout % 60;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                NSLog(@"____%@",strTime);
                
                [_maskButton setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                
                _maskButton.backgroundColor = [UIColor clearColor];
                
                _maskButton.userInteractionEnabled = NO;
                
            });
            
            timeout--;
            
        }
        
    });
    
    dispatch_resume(_timer);
}
- (IBAction)clickUserProtocalButton:(UIButton *)sender
{
    NSString *urlStr = [NSString stringWithFormat:@"http://www.quickpark.com.cn/privacy.html"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
}

#pragma mark - 微信登录
- (IBAction)clickWechatButton:(UIButton *)sender
{
    NSLog(@"微信登录");
    if ([WXApiManager isWXAPPInstall])
    {
        //已经安装微信
        WXApiManager *wxManager = [WXApiManager sharedManager];
        [wxManager loginWechat];
    }
    else
    {
        [self setupAlertController];
    }
}
-(void)wechatDidLoginNotification:(NSNotification *)notification
{
    //发送网络请求给本地服务器
    [self POSTToServiceWithDictionary:notification.userInfo];
}
#pragma mark - QQ登录
- (IBAction)clickQQButton:(UIButton *)sender
{
    NSLog(@"QQ登录");
    QQApiManager *qqManager = [QQApiManager sharedManager];
    [qqManager loginQQ];
}
-(void)qqDidLoginNotification:(NSNotification *)notification
{
    //发送网络请求给本地服务器
    [self POSTToServiceWithDictionary:notification.userInfo];
}
#pragma mark - 支付宝登录
//- (IBAction)clickAliypayButton:(UIButton *)sender
//{
//    NSLog(@"支付宝登录");
//    [AliyPayApiManager doAlipayAuth];
//}
#pragma mark - 第三方登录网络接口
- (void)POSTToServiceWithDictionary:(NSDictionary *)dictionary
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"Loding";
    NSString *openId = [dictionary objectForKey:@"TpOpenId"];
    
    /*//根据openid查询用户
     private String TpOpenId;//第三方openId
     private String refreshToken; //是否刷新token:值为“false”时才不刷新，否则都刷新
     private int type;  //第三方类型：0微信，1qq，2支付宝
     //绑定
     private String mobile;// 手机号
     //注册
     private String nickName;// 昵称
     private String sex;  //0和1
     private String email;// 邮箱
     private String realName;// 真实姓名
     private String headImgUrl;// 用户头像
     private String address;*/
    
    NKDataManager *dataManager = [NKDataManager sharedDataManager];
    [dataManager POSTTPLoginDataWithParameters:dictionary Success:^(NKLogin *loginMsg) {
        if ([loginMsg.msg isEqualToString:@"ok"])
        {
            //将新用户注册的flag写到userdefault中
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"newUserFlag"];
            
            NKUser *user = [NKUser mj_objectWithKeyValues:loginMsg.user];
            NSLog(@"%@", user);
            //将用户数据写到plist文件中
            [NKDataManager writeDataToTextWith:loginMsg];
            dispatch_async(dispatch_get_main_queue(), ^{
                //回到主线程更新界面
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [hud removeFromSuperViewOnHide];
                
                MainTabbarViewController *mainTabbarController = [[MainTabbarViewController alloc] initWithLoginMsg:loginMsg];
                //跳转事件
                [self presentViewController:mainTabbarController animated:YES completion:nil];
            });
        }
        else if ([loginMsg.msg isEqualToString:@"User no exist!"])
        {
            //将新用户注册的flag写到userdefault中
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"newUserFlag"];
            dispatch_async(dispatch_get_main_queue(), ^{
                //回到主线程更新界面
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [hud removeFromSuperViewOnHide];
            });
            //推出绑定手机号界面
            //获得storyBored中的
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            BoundPhoneViewController *bpvc = [storyboard instantiateViewControllerWithIdentifier:@"BoundPhoneViewController"];
            bpvc.parametersDic = dictionary;
            bpvc.openId = openId;
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:bpvc];
            [self presentViewController:navi animated:YES completion:nil];
            
        }
        else
        {
            NSLog(@"%@", loginMsg.msg);
            dispatch_async(dispatch_get_main_queue(), ^{
                //回到主线程更新界面
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [hud removeFromSuperViewOnHide];
            });
            [self showHUDWith:loginMsg.msg];
        }
        
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //回到主线程更新界面
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [hud removeFromSuperViewOnHide];
        });
        [self showHUDWith:@"网络异常"];
    }];
}

#pragma mark - 设置弹出提示语
- (void)setupAlertController {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.phoneTextField resignFirstResponder];
    [self.maskTextField resignFirstResponder];
}
- (IBAction)clickLoginButton:(UIButton *)sender
{
    NSLog(@"登录！");
    /******************发送网络请求*****************/
    if (self.phoneTextField.text.length == 0)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请输入手机号";
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            [hud removeFromSuperViewOnHide];
        });
        return;
    }
    if (self.maskTextField.text.length < 4)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请输入验证码";
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            [hud removeFromSuperViewOnHide];
        });
        return;
    }
    //登录界面
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"Loding";

    //创建一个可变字典
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    //往字典里面添加需要提交的参数
    [parametersDic setObject:_phoneTextField.text forKey:@"user"];
    [parametersDic setObject:_maskTextField.text forKey:@"smsCode"];
    NSLog(@"%@, %@", _phoneTextField.text, _maskTextField.text);
    
    NKDataManager *dataManager = [NKDataManager sharedDataManager];
    [dataManager POSTLoginDataWithParameters:parametersDic Success:^(NKLogin *loginMsg) {
        if ([loginMsg.msg isEqualToString:@"ok"])
        {
            NSLog(@"登录成功!");
            //将老用户的flag写到userdefault中 0 是新用户 1是老用户
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"newUserFlag"];
            NKUser *user = [NKUser mj_objectWithKeyValues:loginMsg.user];
            NSLog(@"%@", user);
            //将用户数据写到plist文件中
            [NKDataManager writeDataToTextWith:loginMsg];
            dispatch_async(dispatch_get_main_queue(), ^{
                //回到主线程更新界面
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [hud removeFromSuperViewOnHide];
                MainTabbarViewController *mainTabbarController = [[MainTabbarViewController alloc] initWithLoginMsg:loginMsg];
                //跳转事件
                [self presentViewController:mainTabbarController animated:YES completion:nil];
            });
        }
        else if ([loginMsg.msg isEqualToString:@"User register success!"])
        {
            NSLog(@"新用户注册成功！");
            //将新用户注册的flag写到userdefault中
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"newUserFlag"];
            
            //将用户数据写到plist文件中
            [NKDataManager writeDataToTextWith:loginMsg];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //回到主线程更新界面
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [hud removeFromSuperViewOnHide];
                //跳转界面
                MainTabbarViewController *mainTabbarController = [[MainTabbarViewController alloc] initWithLoginMsg:loginMsg];
                [self presentViewController:mainTabbarController animated:YES completion:nil];
                
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //回到主线程更新界面
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [hud removeFromSuperViewOnHide];
            });
            [self showHUDWith:loginMsg.msg];
        }
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //回到主线程更新界面
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [hud removeFromSuperViewOnHide];
        });
        [self showHUDWith:@"网络异常"];
    }];
    
}
- (void)showHUDWith:(NSString *)str
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = str;
        [hud showAnimated:YES];
        [hud hideAnimated:YES afterDelay:1.5];
        [hud removeFromSuperViewOnHide];
    });
}
#pragma mask - 界面文本框方法

- (IBAction)maskTextFieldValueChanged:(UITextField *)sender
{
    if (sender.text.length == 6)
    {
        NSLog(@"可以确认登录了！");
    }
}



@end
