//
//  PayViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 16/8/15.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "PayViewController.h"
#import "NKButton.h"
#import "AliyPayApiManager.h"
#import "WXApiManager.h"
#import "NKPay.h"
#import "NKDataManager.h"
#import "NKAlertView.h"
#import "NKRechargeRule.h"
#import "MBProgressHUD/MBProgressHUD.h"

#define BUTTON_WIDTH (WIDTH_VIEW - 4 * 12) / 3
#define BUTTON_HEIGHT 60

@interface PayViewController ()

@property (nonatomic, strong)UIView *amountOfMoneyView;
@property (nonatomic, strong)UIView *buttonBaseView;
@property (nonatomic, strong)UIView *AlipayView;
@property (nonatomic, strong)UIView *WechatPayView;

@property (nonatomic, strong)UIButton *AlipayButton_allView;
@property (nonatomic, strong)UIButton *WechatPayButton_allView;
@property (nonatomic, strong)UIButton *aliypayButton;
@property (nonatomic, strong)UIButton *wechatPayButton;

@property (nonatomic, strong)NSMutableArray *buttonsArray;
@property (nonatomic, strong)UIButton *payButton;

@property (nonatomic, strong)UILabel *topMoneyLabel;
@property (nonatomic, strong)UILabel *buttomBaseViewLabel;

@property (nonatomic, assign)double payTotalFee;
@property (nonatomic, assign)double payAmount;

@property (nonatomic, strong)NKAlertView *alertView;
@property (nonatomic, assign)int passwdFlag;

@property (nonatomic, strong)NSArray *rechargeRuleArray;

//6个button按钮
@property (nonatomic, strong)NKButton *button_0;
@property (nonatomic, strong)NKButton *button_1;
@property (nonatomic, strong)NKButton *button_2;
@property (nonatomic, strong)NKButton *button_3;
@property (nonatomic, strong)NKButton *button_4;
@property (nonatomic, strong)NKButton *button_5;

@end

@implementation PayViewController
-(NSArray *)rechargeRuleArray
{
    if (!_rechargeRuleArray)
    {
        _rechargeRuleArray = [NSArray array];
    }
    return _rechargeRuleArray;
}
-(NSMutableArray *)buttonsArray
{
    if (!_buttonsArray)
    {
        _buttonsArray = [NSMutableArray array];
    }
    return _buttonsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BACKGROUND_COLOR];
    //设置导航栏
    [self setNavigationBar];
    [self addSubViewsToPayView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //添加监听的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPaySuccessNotification) name:@"WeChatPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPaySuccessNotification) name:@"AliyPaySuccess" object:nil];
    //发送网络请求，请求密码状态
    [self isSetPassWD];
    //请求充值规则
    [self postForRechargeRule];
}
//页面加载时设置导航栏
- (void)setNavigationBar
{
    self.navigationItem.title = @"充值";
    UIImage *itemImage = [UIImage imageNamed:@"左箭头"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[itemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_TITLE_WHITE}];
    
    self.navigationController.navigationBar.barTintColor = COLOR_NAVI_BLACK;
    self.navigationController.navigationBar.backgroundColor = COLOR_NAVI_BLACK;
    
}
-(void)goBack
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
//添加子界面UIView到superView上面
- (void)addSubViewsToPayView
{
    //上方的金额view
    self.amountOfMoneyView = [[UIView alloc] initWithFrame:CGRectMake(0, 12 + 64, WIDTH_VIEW, 44)];
    self.amountOfMoneyView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 14, 70, 16)];
    label.text = @"金额(元）";
    [label setFont:[UIFont systemFontOfSize:15.0]];
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(82, 14, WIDTH_VIEW - 72, 16)];
    moneyLabel.text = [NSString stringWithFormat:@"%.2f", [[NSUserDefaults standardUserDefaults] doubleForKey:@"balance"] / 100];
    [moneyLabel setFont:[UIFont systemFontOfSize:16.0]];
    self.topMoneyLabel = moneyLabel;
    [self.amountOfMoneyView addSubview:label];
    [self.amountOfMoneyView addSubview:moneyLabel];
    
    //中间的6个button
    self.buttonBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 68 + 64, WIDTH_VIEW, 184)];
    self.buttonBaseView.backgroundColor = [UIColor whiteColor];
    //1
    _button_0 = [[NKButton alloc] initWithFrame:CGRectMake(12, 12, BUTTON_WIDTH, BUTTON_HEIGHT) buttonTitle:@"100元" buttonDetaileTitle:@"送5元"];
    _button_0.label.textColor = COLOR_BUTTON_RED;
    _button_0.detailLabel.textColor = COLOR_BUTTON_RED;
    [self.buttonBaseView addSubview: _button_0];
    _button_0.layer.cornerRadius = CORNERRADIUS;
    _button_0.layer.masksToBounds = YES;
    _button_0.layer.borderColor = COLOR_BUTTON_RED.CGColor;
    _button_0.layer.borderWidth = 2;
    _button_0.tag = 1000;
    [_button_0 addTarget:self action:@selector(clickMoneyButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonsArray addObject:_button_0];
    [self.buttonBaseView addSubview: _button_0];
    //2
    _button_1 = [[NKButton alloc] initWithFrame:CGRectMake(12*2 + BUTTON_WIDTH, 12, BUTTON_WIDTH, BUTTON_HEIGHT) buttonTitle:@"200元" buttonDetaileTitle:@"送15元"];
    _button_1.label.textColor = COLOR_BUTTON_RED;
    _button_1.detailLabel.textColor = COLOR_BUTTON_RED;
    [self.buttonBaseView addSubview: _button_1];
    _button_1.layer.cornerRadius = CORNERRADIUS;
    _button_1.layer.masksToBounds = YES;
    _button_1.layer.borderColor = COLOR_BUTTON_RED.CGColor;
    _button_1.layer.borderWidth = 2;
    _button_1.tag = 1001;
    [_button_1 addTarget:self action:@selector(clickMoneyButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonsArray addObject:_button_1];
    [self.buttonBaseView addSubview: _button_1];
    //3
    _button_2 = [[NKButton alloc] initWithFrame:CGRectMake(12*3 + BUTTON_WIDTH * 2, 12, BUTTON_WIDTH, BUTTON_HEIGHT) buttonTitle:@"300元" buttonDetaileTitle:@"送30元"];
    _button_2.label.textColor = COLOR_BUTTON_RED;
    _button_2.detailLabel.textColor = COLOR_BUTTON_RED;
    [self.buttonBaseView addSubview: _button_2];
    _button_2.layer.cornerRadius = CORNERRADIUS;
    _button_2.layer.masksToBounds = YES;
    _button_2.layer.borderColor = COLOR_BUTTON_RED.CGColor;
    _button_2.layer.borderWidth = 2;
    _button_2.tag = 1002;
    [_button_2 addTarget:self action:@selector(clickMoneyButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonsArray addObject:_button_2];
    [self.buttonBaseView addSubview: _button_2];
    //4
    _button_3 = [[NKButton alloc] initWithFrame:CGRectMake(12, 12*2 + BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT) buttonTitle:@"500元" buttonDetaileTitle:@"送80元"];
    _button_3.label.textColor = COLOR_BUTTON_RED;
    _button_3.detailLabel.textColor = COLOR_BUTTON_RED;
    [self.buttonBaseView addSubview: _button_3];
    _button_3.layer.cornerRadius = CORNERRADIUS;
    _button_3.layer.masksToBounds = YES;
    _button_3.layer.borderColor = COLOR_BUTTON_RED.CGColor;
    _button_3.layer.borderWidth = 2;
    _button_3.tag = 1003;
    [_button_3 addTarget:self action:@selector(clickMoneyButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonsArray addObject:_button_3];
     [self.buttonBaseView addSubview: _button_3];
    //5
    _button_4 = [[NKButton alloc]initWithFrame:CGRectMake(12*2 + BUTTON_WIDTH, 12*2 + BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT) buttonTitle:@"1000元" buttonDetaileTitle:@"送200元"];
    _button_4.label.textColor = COLOR_BUTTON_RED;
    _button_4.detailLabel.textColor = COLOR_BUTTON_RED;
    [self.buttonBaseView addSubview: _button_4];
    _button_4.layer.cornerRadius = CORNERRADIUS;
    _button_4.layer.masksToBounds = YES;
    _button_4.layer.borderColor = COLOR_BUTTON_RED.CGColor;
    _button_4.layer.borderWidth = 2;
    _button_4.tag = 1004;
    [_button_4 addTarget:self action:@selector(clickMoneyButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonsArray addObject:_button_4];
    [self.buttonBaseView addSubview: _button_4];
    //6
    _button_5 = [[NKButton alloc] initWithFrame:CGRectMake(12*3 + BUTTON_WIDTH*2, 12*2 + BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT) buttonTitle:@"2000元" buttonDetaileTitle:@"送500元"];
    _button_5.label.textColor = COLOR_BUTTON_RED;
    _button_5.detailLabel.textColor = COLOR_BUTTON_RED;
    [self.buttonBaseView addSubview: _button_5];
    _button_5.layer.cornerRadius = CORNERRADIUS;
    _button_5.layer.masksToBounds = YES;
    _button_5.layer.borderColor = COLOR_BUTTON_RED.CGColor;
    _button_5.layer.borderWidth = 2;
    _button_5.tag = 1005;
    [_button_5 addTarget:self action:@selector(clickMoneyButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonsArray addObject:_button_5];
    [self.buttonBaseView addSubview: _button_5];
    
    UIImageView *image_voice = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12*3 + BUTTON_HEIGHT*2, 16, 16)];
    image_voice.image = [UIImage imageNamed:@"喇叭"];
    [self.buttonBaseView addSubview:image_voice];
    //消息label
    _buttomBaseViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(12+16, 12*3 + BUTTON_HEIGHT*2, WIDTH_VIEW - 40, 16)];
    _buttomBaseViewLabel.text = @"充1000送200，共到账1200元";
    [_buttomBaseViewLabel setTextColor:COLOR_TITLE_YELLOW];
    [self.buttonBaseView addSubview:_buttomBaseViewLabel];
    
    //支付View
    self.AlipayView = [[UIView alloc] initWithFrame:CGRectMake(0, 264 + 64, WIDTH_VIEW, 44)];
    self.AlipayView.backgroundColor = [UIColor whiteColor];
    self.AlipayButton_allView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW, 44)];
    [self.AlipayButton_allView addTarget:self action:@selector(clickAliPayButton) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *aliyPayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 20, 20)];
    aliyPayImageView.image = [UIImage imageNamed:@"支付宝"];
    UILabel *aliyPayLabel = [[UILabel alloc] initWithFrame:CGRectMake(12 + 20 + 12, 14, WIDTH_VIEW - 88, 16)];
    aliyPayLabel.text = @"支付宝支付";
    self.aliypayButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH_VIEW - 12 - 20, 12, 20, 20)];
    [self.aliypayButton setImage:[UIImage imageNamed:@"勾选框-未勾选"] forState:UIControlStateNormal];
    [self.aliypayButton setImage:[UIImage imageNamed:@"勾选框-已勾选"] forState:UIControlStateSelected];
    [self.AlipayView addSubview:aliyPayImageView];
    [self.AlipayView addSubview:aliyPayLabel];
    [self.AlipayView addSubview:self.aliypayButton];
    [self.AlipayView addSubview:self.AlipayButton_allView];
    
    self.WechatPayView = [[UIView alloc] initWithFrame:CGRectMake(0, 309 + 64, WIDTH_VIEW, 44)];
    self.WechatPayView.backgroundColor = [UIColor whiteColor];
    self.WechatPayButton_allView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW, 44)];
    [self.WechatPayButton_allView addTarget:self action:@selector(clickWechatPayButton) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *wechatPayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 20, 20)];
    wechatPayImageView.image = [UIImage imageNamed:@"微信"];
    UILabel *wechatPayLabel = [[UILabel alloc] initWithFrame:CGRectMake(12 + 20 + 12, 14, WIDTH_VIEW - 88, 16)];
    wechatPayLabel.text = @"微信支付";
    self.wechatPayButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH_VIEW - 12 - 20, 12, 20, 20)];
    [self.wechatPayButton setImage:[UIImage imageNamed:@"勾选框-未勾选"] forState:UIControlStateNormal];
    [self.wechatPayButton setImage:[UIImage imageNamed:@"勾选框-已勾选"] forState:UIControlStateSelected];
    [self.WechatPayView addSubview:wechatPayImageView];
    [self.WechatPayView addSubview:wechatPayLabel];
    [self.WechatPayView addSubview:self.wechatPayButton];
    [self.WechatPayView addSubview:self.WechatPayButton_allView];
    
    //确认支付Button
    self.payButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 309 + 64 + 56, WIDTH_VIEW - 24, 44)];
    self.payButton.backgroundColor = COLOR_BUTTON_RED;
    [self.payButton setTitle:@"确认支付" forState:UIControlStateNormal];
    [self.payButton addTarget:self action:@selector(clickPayButton) forControlEvents:UIControlEventTouchUpInside];
    self.payButton.layer.cornerRadius = CORNERRADIUS;
    self.payButton.layer.masksToBounds = YES;
    
    [self.view addSubview:self.payButton];
    [self.view addSubview:self.AlipayView];
    [self.view addSubview:self.WechatPayView];
    [self.view addSubview:self.buttonBaseView];
    [self.view addSubview:self.amountOfMoneyView];
}
#pragma mark 支付相关方法
//-(void)textFieldDidChangedMoney:(UITextField *)sender
//{
//    double my_total_fee = sender.text.doubleValue;
//    double my_amount = 0;
//    if (self.rechargeRuleArray.count == 0)
//    {
//        return;
//    }
//    NKRechargeRule *rule_0 = self.rechargeRuleArray[0];
//    NKRechargeRule *rule_1 = self.rechargeRuleArray[1];
//    NKRechargeRule *rule_2 = self.rechargeRuleArray[2];
//    NKRechargeRule *rule_3 = self.rechargeRuleArray[3];
//    NKRechargeRule *rule_4 = self.rechargeRuleArray[4];
//    NKRechargeRule *rule_5 = self.rechargeRuleArray[5];
//    
//    if (my_total_fee == rule_0.rechargeAmount / 100 || (my_total_fee > rule_0.rechargeAmount / 100 && my_total_fee < rule_1.rechargeAmount / 100))
//    {
//        my_amount = my_total_fee + rule_0.rechargeDonate / 100;
//    }
//    else if (my_total_fee == rule_1.rechargeAmount / 100 || (my_total_fee > rule_1.rechargeAmount / 100 && my_total_fee < rule_2.rechargeAmount / 100))
//    {
//        my_amount = my_total_fee + rule_1.rechargeDonate / 100;
//    }
//    else if (my_total_fee == rule_2.rechargeAmount / 100 || (my_total_fee > rule_2.rechargeAmount / 100 && my_total_fee < rule_3.rechargeAmount / 100))
//    {
//        my_amount = my_total_fee + rule_2.rechargeDonate / 100;
//    }
//    else if (my_total_fee == rule_3.rechargeAmount / 100 || (my_total_fee > rule_3.rechargeAmount / 100 && my_total_fee < rule_4.rechargeAmount / 100))
//    {
//        my_amount = my_total_fee + rule_3.rechargeDonate / 100;
//    }
//    else if (my_total_fee == rule_4.rechargeAmount / 100 || (my_total_fee > rule_4.rechargeAmount / 100 && my_total_fee < rule_5.rechargeAmount / 100))
//    {
//        my_amount = my_total_fee + rule_4.rechargeDonate / 100;
//    }
//    else if (my_total_fee == rule_5.rechargeAmount / 100 || my_total_fee > rule_5.rechargeAmount / 100)
//    {
//        my_amount = my_total_fee + rule_5.rechargeDonate / 100;
//    }
//    else
//    {
//        my_amount = my_total_fee;
//    }
//    _payTotalFee = my_total_fee;
//    _payAmount = my_amount;
//    _buttomBaseViewLabel.text = [NSString stringWithFormat:@"充%.2lf送%.0lf元，共到账%.2lf元", my_total_fee, my_amount - my_total_fee, my_amount];
//}
-(void)payMoney
{
    //密码存在，进行支付
    if (_payTotalFee < 0 || _payTotalFee == 0) {
        [self showHUDWithString:@"请选择充值金额"];
        return;
    }
    if (self.aliypayButton.isSelected)
    {
        //支付宝支付
        NKPay *pay = [[NKPay alloc] init];
        pay.amount = _payAmount;
        pay.total_fee = _payTotalFee;
        pay.body = @"支付宝充值";
        pay.subject = @"迅停支付优财宝充值";
        if (pay.total_fee > 0)
        {
            [AliyPayApiManager doAlipayPayWithParameters:pay];
        }
    }
    else if (self.wechatPayButton.isSelected)
    {
        //配置微信支付的相关参数
        WXApiManager *wxManager = [WXApiManager sharedManager];
        NKPay *pay = [[NKPay alloc] init];
        pay.amount = _payAmount;
        pay.total_fee = _payTotalFee;
        pay.body = @"迅停支付优财宝充值";
        if (pay.total_fee > 0)
        {
            [wxManager payWechatWithParameters:pay];
        }
    }
    else
    {
        [self showHUDWithString:@"请选择支付方式"];
    }

}
#pragma mark 按钮响应方法
-(void)clickAliPayButton
{
    NSLog(@"选择支付宝支付！！！");
    self.aliypayButton.selected = YES;
    self.wechatPayButton.selected = NO;
}
-(void)clickWechatPayButton
{
    NSLog(@"选择微信支付！！！");
    self.aliypayButton.selected = NO;
    self.wechatPayButton.selected = YES;
}
-(void)clickPayButton
{
    NSLog(@"确认支付！！！");
    //验证有没有支付密码
    if (_passwdFlag == 1)
    {
        //有密码，进行支付
        [self payMoney];
    }
    else if (_passwdFlag == 0)
    {
        //密码不存在，设置密码
        dispatch_async(dispatch_get_main_queue(), ^{
            self.alertView = [[NKAlertView alloc] initWithAlertViewType:NKAlertViewTypeSetPayPassword];
            [self.alertView.setPasswordSureButton addTarget:self action:@selector(clickAlertSetPwdSureButton) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.alertView.bGView];
            [self.view addSubview:self.alertView];
            [self.alertView show:YES];
        });
    }
    else
    {
        //未获取密码状态,再次连接获取
        [self isSetPassWD];
    }
}
-(void)clickMoneyButton:(NKButton *)sender
{
    for (NKButton *button in self.buttonsArray)
    {
        button.selected = NO;
        button.label.textColor = COLOR_BUTTON_RED;
        button.detailLabel.textColor = COLOR_BUTTON_RED;
        button.backgroundColor = [UIColor whiteColor];
    }
    NSLog(@"点击了button");
    NKButton *button = self.buttonsArray[sender.tag - 1000];
    button.selected = YES;
    button.label.textColor = [UIColor whiteColor];
    button.detailLabel.textColor = [UIColor whiteColor];
    button.backgroundColor = COLOR_BUTTON_RED;
    
    NSRange range = [button.labelTitle rangeOfString:@"元"];//匹配得到的下标
    NSInteger payMoney = [button.labelTitle substringWithRange:(NSRange){0, range.location}].integerValue;
    range = [button.detailTitle rangeOfString:@"元"];
    NSInteger freeMoney = [button.detailTitle substringWithRange:(NSRange){1, range.location}].integerValue;
    _buttomBaseViewLabel.text = [NSString stringWithFormat:@"充%@%@，共到账%ld元", button.labelTitle, button.detailTitle, payMoney + freeMoney];
    _payTotalFee = payMoney;
    _payAmount = payMoney + freeMoney;
}
#pragma mark 其他方法
-(void)getPaySuccessNotification
{
    //收到支付成功通知后，更改本地数据
    double balance = [[NSUserDefaults standardUserDefaults] integerForKey:@"balance"] / 100;
    balance = balance + _payAmount;
    [[NSUserDefaults standardUserDefaults] setInteger:(balance * 100) forKey:@"balance"];
    _payAmount = 0;
    _payTotalFee = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.topMoneyLabel.text = [NSString stringWithFormat:@"%.2f", [[NSUserDefaults standardUserDefaults] doubleForKey:@"balance"] / 100];
    });
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark 请求网络设置密码方法
-(void)isSetPassWD
{
    _passwdFlag = 888;
    //发送查询支付密码网络请求
    NKDataManager *dataManager = [NKDataManager sharedDataManager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefault objectForKey:@"myToken"];
    [parameters setObject:token forKey:@"token"];
    
    [dataManager POSTQueryUserPayPasswordWithParameters:parameters Success:^(NSString *backStr) {
        if ([backStr isEqualToString:@"success"])
        {
            _passwdFlag = 1;
        }
        else if([backStr isEqualToString:@"fail"])
        {
            _passwdFlag = 0;
            [self showHUDWithString:backStr];
        }
        else
        {
            _passwdFlag = 888;
            [self showHUDWithString:backStr];
        }
    } Failure:^(NSError *error) {
        [self showHUDWithString:@"网络异常"];
    }];
}
- (void)clickAlertSetPwdSureButton
{
    NSMutableString *password = [NSMutableString string];
    NSMutableString *resetPassword = [NSMutableString string];
    for (UITextField *textField in self.alertView.setPasswordTextFieldArray)
    {
        [password appendString:textField.text];
    }
    for (UITextField *textField in self.alertView.resetPasswordTExtFieldArray)
    {
        [resetPassword appendString:textField.text];
    }
    NSLog(@"%@---%@",password, resetPassword);
    if ([password isEqualToString:resetPassword])
    {
        //发送网络请求重置密码
        NKDataManager *dataManager = [NKDataManager sharedDataManager];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *token = [userDefault objectForKey:@"myToken"];
        
        [parameters setObject:token forKey:@"token"];
        [parameters setObject:password forKey:@"password"];
        
        [dataManager POSTUpdateUserPasswordWithParameters:parameters Success:^(NSString *backStr) {
            if ([backStr isEqualToString:@"success"])
            {
                //更改密码成功，进行付款
                [self showHUDWithString:@"密码设置成功"];
                [self payMoney];
            }
            if ([backStr isEqualToString:@"fail"])
            {
                [self showHUDWithString:@"密码设置失败"];
            }
        } Failure:^(NSError *error) {
            [self showHUDWithString:@"网络异常"];
        }];
        
    }
    
    [self.alertView hide:YES];
}
//请求充值规则
-(void)postForRechargeRule
{
    NKDataManager *dataManager = [NKDataManager sharedDataManager];
    [dataManager POSTGetRechargeRuleWithParameters:nil Success:^(NSArray *rechargeArray) {
        if (rechargeArray.count != 0)
        {
            self.rechargeRuleArray = [NSArray arrayWithArray:rechargeArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                //更新界面
                for (int i = 0; i < rechargeArray.count; i++)
                {
                    NKRechargeRule *rule = rechargeArray[i];
                    NKButton *button = self.buttonsArray[i];
                    button.labelTitle = [NSString stringWithFormat:@"%.0lf元", rule.rechargeAmount / 100];
                    button.detailTitle = [NSString stringWithFormat:@"送%.0lf元", rule.rechargeDonate / 100];
                }
            });
        }
        else
        {
            [self showHUDWithString:@"充值规则获取失败"];
        }
    } Failure:^(NSError *error) {
        [self showHUDWithString:@"网络异常"];
    }];
}
#pragma mark - MBHUD
- (void)showHUDWithString:(NSString *)str
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = str;
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES afterDelay:1.0];
        [hud removeFromSuperViewOnHide];
    });
}
@end
