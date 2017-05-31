//
//  ChangePhoneNumberViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 16/8/17.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "ChangePhoneNumberViewController.h"
#import "NKDataManager.h"
#import "MBProgressHUD/MBProgressHUD.h"

#define HEIGHT_OF_NAVIGATIONBAR 64

@interface ChangePhoneNumberViewController ()

@property (nonatomic, strong)UIView *phoneNuberView;
@property (nonatomic, strong)UITextField *phoneTextField;
@property (nonatomic, strong)UITextField *maskNumberTextField;
@property (nonatomic, strong)UIButton *getMaskNumberButton;
@property (nonatomic, strong)UILabel *notificationLabel;
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UIButton *sureButton;
@property (nonatomic, strong)UIView *lineView;


@end

@implementation ChangePhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createSubviews];
    [self setNavigationBar];
}
-(void)setNavigationBar
{
    self.navigationItem.title = @"更改手机号";
    UIImage *leftItemImage = [UIImage imageNamed:@"左箭头"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[leftItemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
}
-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createSubviews
{
    _phoneNuberView = [[UIView alloc] initWithFrame:CGRectMake(12, HEIGHT_OF_NAVIGATIONBAR + 12, WIDTH_VIEW - 24, 88)];
    _phoneNuberView.layer.cornerRadius = CORNERRADIUS;
    _phoneNuberView.layer.masksToBounds = YES;
    _phoneNuberView.layer.borderColor = COLOR_TITLE_GRAY.CGColor;
    _phoneNuberView.layer.borderWidth = 1;
    [self.view addSubview:_phoneNuberView];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, HEIGHT_OF_NAVIGATIONBAR + 116, 12, 12)];
    _imageView.image = [UIImage imageNamed:@"错误"];
    [self.view addSubview:_imageView];
    _notificationLabel = [[UILabel alloc]initWithFrame:CGRectMake(36, HEIGHT_OF_NAVIGATIONBAR + 116, WIDTH_VIEW / 2, 12)];
    _notificationLabel.textColor = COLOR_TITLE_GRAY;
    _notificationLabel.font = [UIFont systemFontOfSize:13.0];
    _notificationLabel.text = @"啥都没有...";
    [self.view addSubview:_notificationLabel];
    
    _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(12, HEIGHT_OF_NAVIGATIONBAR + 116  + 12 + 16, WIDTH_VIEW - 24, 44)];
    [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [_sureButton addTarget:self action:@selector(clickSureButton) forControlEvents:UIControlEventTouchUpInside];
    _sureButton.layer.cornerRadius = CORNERRADIUS;
    _sureButton.layer.masksToBounds = YES;
    _sureButton.backgroundColor = COLOR_BUTTON_RED;
    [self.view addSubview:_sureButton];
    
    //增加上面两个View子控件
    _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, 14, WIDTH_VIEW / 2, 16)];
    _phoneTextField.placeholder = @"请输入手机号";
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_phoneNuberView addSubview:_phoneTextField];
    
    _getMaskNumberButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH_VIEW - 24 - 6 - 112, 4, 112, 36)];
    _getMaskNumberButton.layer.cornerRadius = CORNERRADIUS;
    _getMaskNumberButton.layer.masksToBounds = YES;
    [_getMaskNumberButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getMaskNumberButton setBackgroundColor:COLOR_BUTTON_RED];
    [_getMaskNumberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_getMaskNumberButton addTarget:self action:@selector(clickGetMaskNumberButton) forControlEvents:UIControlEventTouchUpInside];
    [_phoneNuberView addSubview:_getMaskNumberButton];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, WIDTH_VIEW - 24, 1)];
    _lineView.backgroundColor = COLOR_TITLE_GRAY;
    [_phoneNuberView addSubview:_lineView];
    
    
    _maskNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, 14 + 44, WIDTH_VIEW / 2, 16)];
    _maskNumberTextField.placeholder = @"请输入验证码";
    _maskNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_phoneNuberView addSubview:_maskNumberTextField];
    
}

- (void)clickGetMaskNumberButton
{
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
    [self.maskNumberTextField becomeFirstResponder];
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
    
    /******************************************************************************/
    __block int timeout=59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                [_getMaskNumberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_getMaskNumberButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                _getMaskNumberButton.layer.cornerRadius = CORNERRADIUS;
                _getMaskNumberButton.layer.masksToBounds = YES;
                _getMaskNumberButton.layer.borderColor = [UIColor whiteColor].CGColor;
                _getMaskNumberButton.layer.borderWidth = 1;
                
                _getMaskNumberButton.userInteractionEnabled = YES;
                
            });
            
        }
        else
        {
            
            //            int minutes = timeout / 60;
            
            int seconds = timeout % 60;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                NSLog(@"____%@",strTime);
                
                [_getMaskNumberButton setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                
                _getMaskNumberButton.userInteractionEnabled = NO;
                
            });
            
            timeout--;
            
        }
        
    });
    
    dispatch_resume(_timer);

}
- (void)clickSureButton
{
    //发送网络请求
    MBProgressHUD *waithud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    waithud.mode = MBProgressHUDModeIndeterminate;
    waithud.label.text = @"Loding";
    
    NKDataManager *dataManager = [NKDataManager sharedDataManager];
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"myToken"];
    
    [parametersDic setObject:self.maskNumberTextField.text forKey:@"smsCode"];
    [parametersDic setObject:self.phoneTextField.text forKey:@"mobile"];
    [parametersDic setObject:token forKey:@"token"];
    
    /*
     -13:token错误
     -5090:昵称重复
     -5073:smsCode is error!
     -14:mobile already exist!
     */
    [dataManager POSTUpdateMyInfoWithParameters:parametersDic Success:^(NKBase *base) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [waithud hideAnimated:YES];
            [waithud removeFromSuperViewOnHide];
        });
        if ([base.msg isEqualToString:@"ok"])
        {
            //将数据写入本地
            //..............
            NSUserDefaults *userDefualt = [NSUserDefaults standardUserDefaults];
            [userDefualt setObject:self.phoneTextField.text forKey:@"mobile"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //界面消失
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"手机号更改成功";
                [hud hideAnimated:YES afterDelay:2.0];
                [hud removeFromSuperViewOnHide];
                [NSThread sleepForTimeInterval:2.0];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else if ([base.msg isEqualToString:@"smsCode is error!"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                _notificationLabel.text = @"验证码错误";
            });
        }
        else if ([base.msg isEqualToString:@"mobile already exist!"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                _notificationLabel.text = @"手机号已存在";
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                _notificationLabel.text = base.msg;
            });
        }
        
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [waithud hideAnimated:YES];
            [waithud removeFromSuperViewOnHide];
            _notificationLabel.text = @"网络连接失败";
        });
    }];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
