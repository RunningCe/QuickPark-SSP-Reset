//
//  NKAlertView.m
//  PopAlertView_test
//
//  Created by Jack on 16/8/28.
//  Copyright © 2016年 Jack. All rights reserved.
//

#import "NKAlertView.h"

#define MAINSCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define MAINSCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define MAIN_WINDOW        [[[UIApplication sharedApplication] windows] firstObject]
#define RGBa(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define ALERTVIEW_INTERVAL 19.5

@interface NKAlertView()
@property (nonatomic, assign) NKAlertViewType type;
@end

@implementation NKAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
static NKAlertView *sharedAlerView = nil;
+ (NKAlertView *)sharedAlertViewByType:(NKAlertViewType)type
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if (sharedAlerView == nil)
        {
            sharedAlerView = [[self alloc] initWithAlertViewType:type];
        }
    }); 
    return sharedAlerView;
}
- (NSMutableArray *)passwordTextFieldArray
{
    if (_passwordTextFieldArray == nil)
    {
        _passwordTextFieldArray = [NSMutableArray array];
    }
    return _passwordTextFieldArray;
}
-(NSMutableArray *)setPasswordTextFieldArray
{
    if (_setPasswordTextFieldArray == nil)
    {
        _setPasswordTextFieldArray = [NSMutableArray array];
    }
    return _setPasswordTextFieldArray;
}
-(NSMutableArray *)resetPasswordTExtFieldArray
{
    if (_resetPasswordTExtFieldArray == nil)
    {
        _resetPasswordTExtFieldArray = [NSMutableArray array];
    }
    return _resetPasswordTExtFieldArray;
}
- (instancetype)initWithAlertViewType:(NKAlertViewType)type
{
    _type = type;
    self = [super init];
    if (self)
    {
        if (self.bGView == nil)
        {
            //设置背景遮盖
            _bGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT)];
            _bGView.backgroundColor = [UIColor blackColor];
            _bGView.alpha = 0.5;
            [MAIN_WINDOW addSubview:_bGView];
            _bGButton = [[UIButton alloc] initWithFrame:_bGView.frame];
            [_bGButton addTarget:self action:@selector(clickBackViewButton) forControlEvents:UIControlEventTouchUpInside];
            [self.bGView addSubview:_bGButton];
        }
        //输入密码弹出框
        if (type == NKAlertViewTypePassword)
        {
            CGFloat alertViewHeight = 208;
            CGFloat alertViewWidth = MAINSCREEN_WIDTH * 0.8;
            //设置弹窗视图的推出位置及大小
            self.center = CGPointMake(MAINSCREEN_WIDTH/2, MAINSCREEN_HEIGHT/2);
            self.bounds = CGRectMake(0, 0, MAINSCREEN_WIDTH * 0.8, alertViewHeight);
            self.backgroundColor = BACKGROUND_COLOR;
            self.layer.cornerRadius = CORNERRADIUS;
            self.layer.masksToBounds = YES;
            [MAIN_WINDOW addSubview:self];
            //设置最上面的标题视图
            UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertViewWidth, 36)];
            topView.backgroundColor = POPVIEW_BACKCOLOR;
            //设置title
            UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, alertViewWidth, 16)];
            topLabel.text = @"请输入支付密码";
            topLabel.textAlignment = NSTextAlignmentCenter;
            [topLabel setFont:[UIFont systemFontOfSize:15.0]];
            topLabel.textColor = [UIColor whiteColor];
            [topView addSubview:topLabel];
            
            [self addSubview:topView];
            
            //设置密码框
            UIView *pwdView = [[UIView alloc]initWithFrame:CGRectMake(16, 68, alertViewWidth - 32.5, 44)];
            //pwdView.backgroundColor = [UIColor grayColor];
            pwdView.backgroundColor = [UIColor whiteColor];
            pwdView.layer.cornerRadius = CORNERRADIUS;
            pwdView.layer.masksToBounds = YES;
            pwdView.layer.borderWidth = 1;
            pwdView.layer.borderColor = CUTLINE_COLOR_LIGHT.CGColor;
            //添加5条分割线
            CGFloat textFieldWidth = (alertViewWidth - 32) / 6;
            for (int i = 0; i < 5; i++)
            {
                UIView *cutline = [[UIView alloc] initWithFrame:CGRectMake(textFieldWidth * (i+1), 0, 1, 44)];
                cutline.backgroundColor = CUTLINE_COLOR_LIGHT;
                [pwdView addSubview:cutline];
            }
            //添加密码输入框
            for (int i = 0; i < 6; i++)
            {
                UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(textFieldWidth * i, 0, textFieldWidth, 44)];
                textField.textAlignment = NSTextAlignmentCenter;
                textField.secureTextEntry = YES;
                textField.keyboardType = UIKeyboardTypeNumberPad;
                textField.tag = 1000+i;
                [textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
                [pwdView addSubview:textField];
                [self.passwordTextFieldArray addObject:textField];
            }
            
            [self addSubview:pwdView];
            
            //设置忘记密码按钮
            UIButton *forgetPwdButton = [[UIButton alloc] initWithFrame:CGRectMake(alertViewWidth - 16 - 76, 128, 76, 16)];
            self.forgetPasswordButton = forgetPwdButton;
            [forgetPwdButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
            [forgetPwdButton setTitleColor:BUTTON_COLOR_RED forState:UIControlStateNormal];
            forgetPwdButton.titleLabel.textAlignment = NSTextAlignmentRight;
            forgetPwdButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
            [self addSubview:forgetPwdButton];
            
            //添加分割线
            UIView *cutlineView_H = [[UIView alloc] initWithFrame:CGRectMake(0, 164, alertViewWidth, 1)];
            cutlineView_H.backgroundColor = [UIColor grayColor];
            [self addSubview:cutlineView_H];
            UIView *cutlineView_V = [[UIView alloc] initWithFrame:CGRectMake(alertViewWidth / 2, 164, 1, 44)];
            cutlineView_V.backgroundColor = [UIColor grayColor];
            [self addSubview:cutlineView_V];
            
            //添加确认和取消按钮
            UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 165, alertViewWidth / 2 - 1, 43)];
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            [cancelButton setTitleColor:BUTTON_COLOR_RED forState:UIControlStateNormal];
            [cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            cancelButton.backgroundColor = BACKGROUND_COLOR;
            [self addSubview:cancelButton];
            
            UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(alertViewWidth / 2 + 1, 165, alertViewWidth / 2 - 1, 43)];
            self.passwordSureButton = sureButton;
            [sureButton setTitle:@"确定" forState:UIControlStateNormal];
            [sureButton setTitleColor:BUTTON_COLOR_RED forState:UIControlStateNormal];
            sureButton.backgroundColor = BACKGROUND_COLOR;
            [self addSubview:sureButton];
            
        }
        //设置密码弹出框
        else if (type == NKAlertViewTypeSetPayPassword)
        {
            CGFloat alertViewHeight = 280;
            CGFloat alertViewWidth = MAINSCREEN_WIDTH * 0.8;
            //设置弹窗视图的推出位置及大小
            self.center = CGPointMake(MAINSCREEN_WIDTH/2, MAINSCREEN_HEIGHT/2);
            self.bounds = CGRectMake(0, 0, MAINSCREEN_WIDTH * 0.8, alertViewHeight);
            self.backgroundColor = BACKGROUND_COLOR;
            self.layer.cornerRadius = CORNERRADIUS;
            self.layer.masksToBounds = YES;
            [MAIN_WINDOW addSubview:self];
            //设置最上面的标题视图
            UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertViewWidth, 36)];
            topView.backgroundColor = POPVIEW_BACKCOLOR;
            //设置title
            UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, alertViewWidth, 16)];
            topLabel.text = @"请设置支付密码";
            topLabel.textAlignment = NSTextAlignmentCenter;
            [topLabel setFont:[UIFont systemFontOfSize:15.0]];
            topLabel.textColor = [UIColor whiteColor];
            [topView addSubview:topLabel];
            
            [self addSubview:topView];
            
            //********************************设置密码框--1*********************************//
            UIView *pwdView_0 = [[UIView alloc]initWithFrame:CGRectMake(16, 68, alertViewWidth - 32.5, 44)];
            pwdView_0.backgroundColor = BACKGROUND_COLOR;
            pwdView_0.layer.borderColor = CUTLINE_COLOR_LIGHT.CGColor;
            pwdView_0.layer.borderWidth = 1;
            //添加5条分割线
            CGFloat textFieldWidth = (alertViewWidth - 32) / 6;
            for (int i = 0; i < 5; i++)
            {
                UIView *cutline = [[UIView alloc] initWithFrame:CGRectMake(textFieldWidth * (i+1), 0, 1, 44)];
                cutline.backgroundColor = CUTLINE_COLOR_LIGHT;
                [pwdView_0 addSubview:cutline];
            }
            //添加密码输入框
            for (int i = 0; i < 6; i++)
            {
                UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(textFieldWidth * i, 0, textFieldWidth, 44)];
                textField.textAlignment = NSTextAlignmentCenter;
                textField.secureTextEntry = YES;
                textField.keyboardType = UIKeyboardTypeNumberPad;
                textField.tag = 2000+i;
                [textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
                [pwdView_0 addSubview:textField];
                [self.setPasswordTextFieldArray addObject:textField];
            }
            
            [self addSubview:pwdView_0];
            //********************************设置密码框--1*********************************//
            
            //********************************设置密码框--2*********************************//
            UIView *pwdView_1 = [[UIView alloc]initWithFrame:CGRectMake(16, 68 + 88, alertViewWidth - 32.5, 44)];
            pwdView_1.backgroundColor = BACKGROUND_COLOR;
            pwdView_1.layer.borderColor = CUTLINE_COLOR_LIGHT.CGColor;
            pwdView_1.layer.borderWidth = 1;
            //添加5条分割线
            textFieldWidth = (alertViewWidth - 32) / 6;
            for (int i = 0; i < 5; i++)
            {
                UIView *cutline = [[UIView alloc] initWithFrame:CGRectMake(textFieldWidth * (i+1), 0, 1, 44)];
                cutline.backgroundColor = CUTLINE_COLOR_LIGHT;
                [pwdView_1 addSubview:cutline];
            }
            //添加密码输入框
            for (int i = 0; i < 6; i++)
            {
                UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(textFieldWidth * i, 0, textFieldWidth, 44)];
                textField.textAlignment = NSTextAlignmentCenter;
                textField.secureTextEntry = YES;
                textField.keyboardType = UIKeyboardTypeNumberPad;
                textField.tag = 3000+i;
                [textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
                [pwdView_1 addSubview:textField];
                [self.resetPasswordTExtFieldArray addObject:textField];
            }
            
            [self addSubview:pwdView_1];
            //********************************设置密码框--2*********************************//
            
            
            
            //添加分割线
            UIView *cutlineView_H = [[UIView alloc] initWithFrame:CGRectMake(0, 236, alertViewWidth, 1)];
            cutlineView_H.backgroundColor = CUTLINE_COLOR_LIGHT;
            [self addSubview:cutlineView_H];
            UIView *cutlineView_V = [[UIView alloc] initWithFrame:CGRectMake(alertViewWidth / 2, 236, 1, 44)];
            cutlineView_V.backgroundColor = CUTLINE_COLOR_LIGHT;
            [self addSubview:cutlineView_V];
            
            //添加确认和取消按钮
            UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 237, alertViewWidth / 2 - 1, 43)];
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            [cancelButton setTitleColor:TITLE_COLOR_LIGHT forState:UIControlStateNormal];
            [cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            cancelButton.backgroundColor = [UIColor whiteColor];
            [self addSubview:cancelButton];
            
            UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(alertViewWidth / 2 + 1, 237, alertViewWidth / 2 - 1, 43)];
            self.setPasswordSureButton = sureButton;
            [sureButton setTitle:@"确定" forState:UIControlStateNormal];
            [sureButton setTitleColor:BUTTON_COLOR_RED forState:UIControlStateNormal];
            sureButton.backgroundColor = [UIColor whiteColor];
            [self addSubview:sureButton];
        }
        //车辆认证弹出框
        else if (type == NKAlertViewTypeCarCertificate)
        {
            CGFloat alertViewHeight = 208;
            CGFloat alertViewWidth = MAINSCREEN_WIDTH * 0.8;
            //设置弹窗视图的推出位置及大小
            self.center = CGPointMake(MAINSCREEN_WIDTH/2, MAINSCREEN_HEIGHT/2);
            self.bounds = CGRectMake(0, 0, MAINSCREEN_WIDTH * 0.8, alertViewHeight);
            self.backgroundColor = BACKGROUND_COLOR;
            self.layer.cornerRadius = CORNERRADIUS;
            self.layer.masksToBounds = YES;
            [MAIN_WINDOW addSubview:self];
            //设置最上面的标题视图
            UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertViewWidth, 36)];
            topView.backgroundColor = POPVIEW_BACKCOLOR;
            //设置title
            UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, alertViewWidth, 16)];
            topLabel.text = @"车牌号。。。。";
            topLabel.textAlignment = NSTextAlignmentCenter;
            [topLabel setFont:[UIFont systemFontOfSize:15.0]];
            topLabel.textColor = [UIColor whiteColor];
            self.titleLable = topLabel;
            [topView addSubview:topLabel];
            [self addSubview:topView];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((alertViewWidth - MAINSCREEN_WIDTH * 0.4) / 2, 68, MAINSCREEN_WIDTH * 0.4, alertViewHeight * 0.3)];
            imageView.image = [UIImage imageNamed:@"car"];
            //imageView.backgroundColor = [UIColor redColor];
            [self addSubview:imageView];
            
            UILabel *msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 78, alertViewWidth - 32.5, 44)];
            //msgLabel.backgroundColor = [UIColor grayColor];
            msgLabel.text = @"请选择要对车辆进行的操作";
            msgLabel.textColor = TITLE_COLOR_LIGHT;
            msgLabel.textAlignment = NSTextAlignmentCenter;
            msgLabel.font = [UIFont systemFontOfSize:13.0];
            [self addSubview:msgLabel];
            
            //添加分割线
            UIView *cutlineView_H = [[UIView alloc] initWithFrame:CGRectMake(0, alertViewHeight - 44, alertViewWidth, 1)];
            cutlineView_H.backgroundColor = CUTLINE_COLOR_LIGHT;
            [self addSubview:cutlineView_H];
            UIView *cutlineView_V = [[UIView alloc] initWithFrame:CGRectMake(alertViewWidth / 2, alertViewHeight - 44, 1, 44)];
            cutlineView_V.backgroundColor = CUTLINE_COLOR_LIGHT;
            [self addSubview:cutlineView_V];
            
            //添加底部两个按钮
            UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 165, alertViewWidth / 2 - 1, 43)];
            [cancelButton setTitle:@"删除车辆" forState:UIControlStateNormal];
            cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [cancelButton setTitleColor:TITLE_COLOR_LIGHT forState:UIControlStateNormal];
            [cancelButton setTitleColor:BUTTON_COLOR_RED forState:UIControlStateHighlighted];
            self.deleteCarButton = cancelButton;
            [self addSubview:cancelButton];
            
            UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(alertViewWidth / 2 + 1, 165, alertViewWidth / 2 - 1, 43)];
            [sureButton setTitle:@"认证车辆" forState:UIControlStateNormal];
            sureButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [sureButton setTitleColor:BUTTON_COLOR_RED forState:UIControlStateNormal];
            [sureButton setTitleColor:BUTTON_COLOR_RED forState:UIControlStateHighlighted];
            self.certificateCarButton = sureButton;
            [self addSubview:sureButton];
            
        }
        //实名认证弹出框
        else if (type == NKAlertViewTypeRealNameCertificate)
        {
            CGFloat alertViewHeight = 208;
            CGFloat alertViewWidth = MAINSCREEN_WIDTH * 0.8;
            //设置弹窗视图的推出位置及大小
            self.center = CGPointMake(MAINSCREEN_WIDTH/2, MAINSCREEN_HEIGHT/2);
            self.bounds = CGRectMake(0, 0, MAINSCREEN_WIDTH * 0.8, alertViewHeight);
            self.backgroundColor = BACKGROUND_COLOR;
            self.layer.cornerRadius = CORNERRADIUS;
            self.layer.masksToBounds = YES;
            [MAIN_WINDOW addSubview:self];
            //设置最上面的标题视图
            UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertViewWidth, 36)];
            topView.backgroundColor = POPVIEW_BACKCOLOR;
            //设置title
            UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, alertViewWidth, 16)];
            topLabel.text = @"实名认证";
            topLabel.textAlignment = NSTextAlignmentCenter;
            [topLabel setFont:[UIFont systemFontOfSize:15.0]];
            topLabel.textColor = [UIColor whiteColor];
            [topView addSubview:topLabel];
            [self addSubview:topView];
            //添加图片
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(44, 80, 44, 44)];
            imageView.image = [UIImage imageNamed:@"实名认证_gray"];
            [self addSubview:imageView];
            //添加中间的标签信息
            UILabel *msgLabel_0 = [[UILabel alloc]initWithFrame:CGRectMake(120, 80, alertViewWidth - 120, 16)];
            //msgLabel_0.backgroundColor = [UIColor grayColor];
            msgLabel_0.text = @"您还未进行实名认证";
            msgLabel_0.textColor = TITLE_COLOR_LIGHT;
            msgLabel_0.textAlignment = NSTextAlignmentLeft;
            msgLabel_0.font = [UIFont systemFontOfSize:13.0];
            [self addSubview:msgLabel_0];
            UILabel *msgLabel_1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 108, alertViewWidth - 120, 16)];
            msgLabel_1.textColor = TITLE_COLOR_LIGHT;
            msgLabel_1.text = @"请先进行实名认证";
            msgLabel_1.textAlignment = NSTextAlignmentLeft;
            msgLabel_1.font = [UIFont systemFontOfSize:13.0];
            [self addSubview:msgLabel_1];
            
            //添加分割线
            UIView *cutlineView_H = [[UIView alloc] initWithFrame:CGRectMake(0, alertViewHeight - 44, alertViewWidth, 1)];
            cutlineView_H.backgroundColor = CUTLINE_COLOR_LIGHT;
            [self addSubview:cutlineView_H];
            UIView *cutlineView_V = [[UIView alloc] initWithFrame:CGRectMake(alertViewWidth / 2, alertViewHeight - 44, 1, 44)];
            cutlineView_V.backgroundColor = CUTLINE_COLOR_LIGHT;
            [self addSubview:cutlineView_V];
            
            //添加底部两个按钮
            UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 165, alertViewWidth / 2 - 1, 43)];
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            [cancelButton setTitleColor:TITLE_COLOR_LIGHT forState:UIControlStateNormal];
            [cancelButton setTitleColor:BUTTON_COLOR_RED forState:UIControlStateHighlighted];
            cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:cancelButton];
            
            UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(alertViewWidth / 2 + 1, 165, alertViewWidth / 2 - 1, 43)];
            self.sureButton = sureButton;
            [sureButton setTitle:@"确认" forState:UIControlStateNormal];
            [sureButton setTitleColor:TITLE_COLOR_LIGHT forState:UIControlStateNormal];
            [sureButton setTitleColor:BUTTON_COLOR_RED forState:UIControlStateHighlighted];
            sureButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [self addSubview:sureButton];
        }
        //提示信息
        else if (type == NKAlertViewTypeInfomation)
        {
            CGFloat alertViewHeight = 172;
            CGFloat alertViewWidth = MAINSCREEN_WIDTH * 0.8;
            //设置弹窗视图的推出位置及大小
            self.center = CGPointMake(MAINSCREEN_WIDTH/2, MAINSCREEN_HEIGHT/2);
            self.bounds = CGRectMake(0, 0, MAINSCREEN_WIDTH * 0.8, alertViewHeight);
            self.backgroundColor = BACKGROUND_COLOR;
            self.layer.cornerRadius = CORNERRADIUS;
            self.layer.masksToBounds = YES;
            [MAIN_WINDOW addSubview:self];
            //设置最上面的标题视图
            UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertViewWidth, 36)];
            topView.backgroundColor = POPVIEW_BACKCOLOR;
            //设置title
            UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, alertViewWidth, 16)];
            topLabel.text = @"提示";
            topLabel.textAlignment = NSTextAlignmentCenter;
            [topLabel setFont:[UIFont systemFontOfSize:15.0]];
            topLabel.textColor = [UIColor whiteColor];
            [topView addSubview:topLabel];
            [self addSubview:topView];
            //设置背景图
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((alertViewWidth - MAINSCREEN_WIDTH * 0.4) / 2, 36, MAINSCREEN_WIDTH * 0.4, 72)];
            imageView.image = [UIImage imageNamed:@"暂未开放"];
            //imageView.backgroundColor = [UIColor redColor];
            [self addSubview:imageView];
            //提示信息label
            UILabel *msgLabel_0 = [[UILabel alloc]initWithFrame:CGRectMake(0, 108, alertViewWidth, 16)];
            msgLabel_0.textColor = TITLE_COLOR_LIGHT;
            msgLabel_0.text = @"该功能暂未开放";
            msgLabel_0.textAlignment = NSTextAlignmentCenter;
            msgLabel_0.font = [UIFont systemFontOfSize:13.0];
            [self addSubview:msgLabel_0];
            
            UILabel *msgLabel_1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 136, alertViewWidth, 16)];
            msgLabel_1.textColor = TITLE_COLOR_LIGHT;
            msgLabel_1.text = @"敬请期待";
            msgLabel_1.textAlignment = NSTextAlignmentCenter;
            msgLabel_1.font = [UIFont systemFontOfSize:13.0];
            [self addSubview:msgLabel_1];
            
        }
        //新用户优惠券
        else if (type == NKAlertViewTypeNewUserCoupon)
        {
            CGFloat alertViewHeight = 255;
            CGFloat alertViewWidth = MAINSCREEN_WIDTH * 0.8;
            //设置弹窗视图的推出位置及大小
            self.center = CGPointMake(MAINSCREEN_WIDTH/2, MAINSCREEN_HEIGHT/2);
            self.bounds = CGRectMake(0, 0, MAINSCREEN_WIDTH * 0.8, alertViewHeight);
            self.backgroundColor = BACKGROUND_COLOR;
            self.layer.cornerRadius = CORNERRADIUS;
            self.layer.masksToBounds = YES;
            [MAIN_WINDOW addSubview:self];
            
            //添加上面视图的BaseView
            UIView *topBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertViewWidth, 205)];
            //topBaseView.backgroundColor = [UIColor greenColor];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((alertViewWidth - 200)/2, 0, 200, 200)];
            imageView.image = [UIImage imageNamed:@"注册成功弹窗"];
            [topBaseView addSubview:imageView];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((alertViewWidth - 200)/2 + 200 - 35, 0, 35, 35)];
            [button addTarget:self action:@selector(clickBackViewButton) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"删除_red"] forState:UIControlStateNormal];
            [topBaseView addSubview:button];
            UILabel *label_first = [[UILabel alloc] initWithFrame:CGRectMake((alertViewWidth - 80)/2 - 20, 45, 80, 80)];
            _UserNewRegisterCouponMoneyLabel = label_first;
            //label_first.backgroundColor = [UIColor grayColor];
            label_first.text = @"30";
            label_first.font = [UIFont systemFontOfSize:50.0];
            label_first.textColor = [UIColor colorWithRed:255.0 / 255.0 green:240.0 / 255.0 blue:0 alpha:1.0];
            label_first.textAlignment = NSTextAlignmentCenter;
            UILabel *label_second = [[UILabel alloc] initWithFrame:CGRectMake((alertViewWidth - 80)/2 + 50, 78, 27, 27)];
            //label_second.backgroundColor = [UIColor grayColor];
            label_second.text = @"元";
            label_second.font = [UIFont systemFontOfSize:27.0];
            label_second.textColor = [UIColor colorWithRed:255.0 / 255.0 green:240.0 / 255.0 blue:0 alpha:1.0];
            label_second.textAlignment = NSTextAlignmentCenter;
            [topBaseView addSubview:label_first];
            [topBaseView addSubview:label_second];
            //添加中间的imageview
            [self addSubview:topBaseView];
            //添加下面的两个button
            UIButton *chargeCouponButton = [[UIButton alloc] initWithFrame:CGRectMake(0, alertViewHeight - 36, (alertViewWidth - 24) / 2, 36)];
            _chargeCouponButton = chargeCouponButton;
            [chargeCouponButton setTitle:@"查看优惠券" forState:UIControlStateNormal];
            [chargeCouponButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            chargeCouponButton.backgroundColor = [UIColor redColor];
            chargeCouponButton.layer.cornerRadius = CORNERRADIUS;
            chargeCouponButton.layer.masksToBounds = YES;
            UIButton *sharedCouponButton = [[UIButton alloc] initWithFrame:CGRectMake((alertViewWidth - 24) / 2 + 24, alertViewHeight - 36, (alertViewWidth - 24) / 2, 36)];
            [sharedCouponButton setTitle:@"分享得优惠券" forState:UIControlStateNormal];
            [sharedCouponButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            sharedCouponButton.backgroundColor = [UIColor redColor];
            sharedCouponButton.layer.cornerRadius = CORNERRADIUS;
            sharedCouponButton.layer.masksToBounds = YES;
            _sharedCouponButton = sharedCouponButton;
            
            self.backgroundColor = [UIColor clearColor];
            [self addSubview:chargeCouponButton];
            [self addSubview: sharedCouponButton];
        }
        //分享成功获取优惠券
        else if (type == NKAlertViewTypeSharedCouponSuccess)
        {
            CGFloat alertViewHeight = 255;
            CGFloat alertViewWidth = MAINSCREEN_WIDTH * 0.8;
            //设置弹窗视图的推出位置及大小
            self.center = CGPointMake(MAINSCREEN_WIDTH/2, MAINSCREEN_HEIGHT/2);
            self.bounds = CGRectMake(0, 0, MAINSCREEN_WIDTH * 0.8, alertViewHeight);
            self.backgroundColor = BACKGROUND_COLOR;
            self.layer.cornerRadius = CORNERRADIUS;
            self.layer.masksToBounds = YES;
            [MAIN_WINDOW addSubview:self];
            
            //添加上面视图的BaseView
            UIView *topBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertViewWidth, 205)];
            //topBaseView.backgroundColor = [UIColor greenColor];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((alertViewWidth - 200)/2, 0, 200, 200)];
            imageView.image = [UIImage imageNamed:@"分享成功弹窗"];
            //imageView.backgroundColor = [UIColor yellowColor];
            [topBaseView addSubview:imageView];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((alertViewWidth - 200)/2 + 200 - 35, 0, 35, 35)];
            [button addTarget:self action:@selector(clickBackViewButton) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"删除_red"] forState:UIControlStateNormal];
            [topBaseView addSubview:button];
            UILabel *label_first = [[UILabel alloc] initWithFrame:CGRectMake((alertViewWidth - 80)/2 - 20, 45, 80, 80)];
            _sharedCouponMoneyLabel = label_first;
            //label_first.backgroundColor = [UIColor grayColor];
            label_first.text = @"2";
            label_first.font = [UIFont systemFontOfSize:50.0];
            label_first.textColor = [UIColor colorWithRed:255.0 / 255.0 green:240.0 / 255.0 blue:0 alpha:1.0];
            label_first.textAlignment = NSTextAlignmentCenter;
            UILabel *label_second = [[UILabel alloc] initWithFrame:CGRectMake((alertViewWidth - 80)/2 + 50, 78, 27, 27)];
            //label_second.backgroundColor = [UIColor grayColor];
            label_second.text = @"元";
            label_second.font = [UIFont systemFontOfSize:27.0];
            label_second.textColor = [UIColor colorWithRed:255.0 / 255.0 green:240.0 / 255.0 blue:0 alpha:1.0];
            label_second.textAlignment = NSTextAlignmentCenter;
            [topBaseView addSubview:label_first];
            [topBaseView addSubview:label_second];
            //添加中间的imageview
            [self addSubview:topBaseView];
            //添加下面的两个button
            UIButton *chargeCouponButton = [[UIButton alloc] initWithFrame:CGRectMake((alertViewWidth - 200)/2, alertViewHeight - 36, 200, 36)];
            _chargeCouponButton = chargeCouponButton;
            [chargeCouponButton setTitle:@"查看优惠券" forState:UIControlStateNormal];
            [chargeCouponButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            chargeCouponButton.backgroundColor = [UIColor redColor];
            chargeCouponButton.layer.cornerRadius = CORNERRADIUS;
            chargeCouponButton.layer.masksToBounds = YES;
            
            self.backgroundColor = [UIColor clearColor];
            [self addSubview:chargeCouponButton];
        }
        //分享到微信
        else if (type == NKAlertViewTypeSharedToWeChat)
        {
            CGFloat alertViewHeight = 90;
            CGFloat alertViewWidth = MAINSCREEN_WIDTH * 0.8;
            //设置弹窗视图的推出位置及大小
            self.center = CGPointMake(MAINSCREEN_WIDTH/2, MAINSCREEN_HEIGHT/2);
            self.bounds = CGRectMake(0, 0, MAINSCREEN_WIDTH * 0.8, alertViewHeight);
            self.backgroundColor = BACKGROUND_COLOR;
            self.layer.cornerRadius = CORNERRADIUS;
            self.layer.masksToBounds = YES;
            [MAIN_WINDOW addSubview:self];
            
            UIButton *sharedToWechatButton = [[UIButton alloc] initWithFrame:CGRectMake(alertViewWidth / 6, 14, 36, 36)];
            [sharedToWechatButton setImage:[UIImage imageNamed:@"微信_shared"] forState:UIControlStateNormal];
            _sharedToWeChatButton = sharedToWechatButton;
            UIButton *sharedToFriendCircleButton = [[UIButton alloc] initWithFrame:CGRectMake(alertViewWidth / 6 * 4, 14, 36, 36)];
            [sharedToFriendCircleButton setImage:[UIImage imageNamed:@"朋友圈"] forState:UIControlStateNormal];
            _sharedToFriendCircleButton = sharedToFriendCircleButton;
            UILabel *wechatLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, alertViewWidth / 2, 12)];
            wechatLabel.text = @"微信好友";
            wechatLabel.textColor = TITLE_COLOR_LIGHT;
            wechatLabel.textAlignment = NSTextAlignmentCenter;
            UILabel *friendCircleLabel = [[UILabel alloc] initWithFrame:CGRectMake(alertViewWidth / 2, 64, alertViewWidth / 2, 12)];
            friendCircleLabel.text = @"微信朋友圈";
            friendCircleLabel.textColor = TITLE_COLOR_LIGHT;
            friendCircleLabel.textAlignment = NSTextAlignmentCenter;
            
            [self addSubview:sharedToWechatButton];
            [self addSubview:sharedToFriendCircleButton];
            [self addSubview:wechatLabel];
            [self addSubview:friendCircleLabel];
            
        }
        //二维码
        else if (type == NKAlertViewType2DCode)
        {
            CGFloat alertViewHeight = 350;
            CGFloat alertViewWidth = MAINSCREEN_WIDTH * 0.8;
            //设置弹窗视图的推出位置及大小
            self.center = CGPointMake(MAINSCREEN_WIDTH/2, MAINSCREEN_HEIGHT/2);
            self.bounds = CGRectMake(0, 0, MAINSCREEN_WIDTH * 0.8, alertViewHeight);
            self.backgroundColor = BACKGROUND_COLOR;
            self.layer.cornerRadius = CORNERRADIUS;
            self.layer.masksToBounds = YES;
            [MAIN_WINDOW addSubview:self];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH * 0.1, 44, MAINSCREEN_WIDTH * 0.6, MAINSCREEN_WIDTH * 0.6)];
            _twoDCodeImageView = imageView;
            imageView.layer.borderColor = BUTTON_COLOR_RED.CGColor;
            imageView.layer.borderWidth = 1;
            imageView.layer.cornerRadius = CORNERRADIUS;
            imageView.layer.masksToBounds = YES;
            [self addSubview:imageView];
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH * 0.1, MAINSCREEN_WIDTH * 0.6 + 68, MAINSCREEN_WIDTH * 0.6, 44)];
            _twoDCodeButton = button;
            button.backgroundColor = BUTTON_COLOR_RED;
            [button setTitle:@"申请车贴" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.layer.cornerRadius = CORNERRADIUS;
            button.layer.masksToBounds = YES;
            [self addSubview:button];
        }
        //呼叫结束，未找到车位
        else if (type == NKAlertViewTypeFailedToCallCar)
        {
            CGFloat alertViewHeight = 172;
            CGFloat alertViewWidth = MAINSCREEN_WIDTH * 0.8;
            //设置弹窗视图的推出位置及大小
            self.center = CGPointMake(MAINSCREEN_WIDTH/2, MAINSCREEN_HEIGHT/2);
            self.bounds = CGRectMake(0, 0, MAINSCREEN_WIDTH * 0.8, alertViewHeight);
            self.backgroundColor = BACKGROUND_COLOR;
            self.layer.cornerRadius = CORNERRADIUS;
            self.layer.masksToBounds = YES;
            [MAIN_WINDOW addSubview:self];
            //设置最上面的标题视图
            UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertViewWidth, 36)];
            topView.backgroundColor = POPVIEW_BACKCOLOR;
            //设置title
            UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, alertViewWidth, 16)];
            topLabel.text = @"呼叫结束";
            topLabel.textAlignment = NSTextAlignmentCenter;
            [topLabel setFont:[UIFont systemFontOfSize:15.0]];
            topLabel.textColor = [UIColor whiteColor];
            [topView addSubview:topLabel];
            [self addSubview:topView];
            
            //提示信息label
            UILabel *msgLabel_0 = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, alertViewWidth, 16)];
            msgLabel_0.textColor = TITLE_COLOR_LIGHT;
            msgLabel_0.text = @"抱歉，未找到停车位";
            msgLabel_0.textAlignment = NSTextAlignmentCenter;
            msgLabel_0.font = [UIFont systemFontOfSize:13.0];
            [self addSubview:msgLabel_0];
            
            UILabel *msgLabel_1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 78, alertViewWidth, 16)];
            msgLabel_1.textColor = TITLE_COLOR_LIGHT;
            msgLabel_1.text = @"您可以尝试重新呼叫";
            msgLabel_1.textAlignment = NSTextAlignmentCenter;
            msgLabel_1.font = [UIFont systemFontOfSize:13.0];
            [self addSubview:msgLabel_1];
            
            UILabel *msgLabel_2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 148, alertViewWidth, 12)];
            msgLabel_2.textColor = TITLE_COLOR_LIGHT;
            msgLabel_2.text = @"（尝试扩大范围，增加小费，更易呼叫成功）";
            msgLabel_2.textAlignment = NSTextAlignmentCenter;
            msgLabel_2.font = [UIFont systemFontOfSize:12.0];
            [self addSubview:msgLabel_2];
        }
        //取消呼叫
        else if (type == NKAlertViewTypeCancelCallingCar)
        {
            CGFloat alertViewHeight = 208;
            CGFloat alertViewWidth = MAINSCREEN_WIDTH * 0.8;
            //设置弹窗视图的推出位置及大小
            self.center = CGPointMake(MAINSCREEN_WIDTH/2, MAINSCREEN_HEIGHT/2);
            self.bounds = CGRectMake(0, 0, MAINSCREEN_WIDTH * 0.8, alertViewHeight);
            self.backgroundColor = BACKGROUND_COLOR;
            self.layer.cornerRadius = CORNERRADIUS;
            self.layer.masksToBounds = YES;
            [MAIN_WINDOW addSubview:self];
            //设置最上面的标题视图
            UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertViewWidth, 36)];
            topView.backgroundColor = POPVIEW_BACKCOLOR;
            //设置title
            UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, alertViewWidth, 16)];
            topLabel.text = @"取消呼叫";
            topLabel.textAlignment = NSTextAlignmentCenter;
            [topLabel setFont:[UIFont systemFontOfSize:15.0]];
            topLabel.textColor = [UIColor whiteColor];
            [topView addSubview:topLabel];
            [self addSubview:topView];
    
            //添加中间的标签信息
            UILabel *msgLabel_0 = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, alertViewWidth, 16)];
            //msgLabel_0.backgroundColor = [UIColor grayColor];
            msgLabel_0.text = @"订单发送过程中取消";
            msgLabel_0.textColor = TITLE_COLOR_LIGHT;
            msgLabel_0.textAlignment = NSTextAlignmentCenter;
            msgLabel_0.font = [UIFont systemFontOfSize:13.0];
            [self addSubview:msgLabel_0];
            UILabel *msgLabel_1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 108, alertViewWidth, 16)];
            msgLabel_1.textColor = TITLE_COLOR_LIGHT;
            msgLabel_1.text = @"不收取任何手续费";
            msgLabel_1.textAlignment = NSTextAlignmentCenter;
            msgLabel_1.font = [UIFont systemFontOfSize:13.0];
            [self addSubview:msgLabel_1];
            
            //添加分割线
            UIView *cutlineView_H = [[UIView alloc] initWithFrame:CGRectMake(0, alertViewHeight - 44, alertViewWidth, 1)];
            cutlineView_H.backgroundColor = CUTLINE_COLOR_LIGHT;
            [self addSubview:cutlineView_H];
            UIView *cutlineView_V = [[UIView alloc] initWithFrame:CGRectMake(alertViewWidth / 2, alertViewHeight - 44, 1, 44)];
            cutlineView_V.backgroundColor = CUTLINE_COLOR_LIGHT;
            [self addSubview:cutlineView_V];
            
            //添加底部两个按钮
            UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 165, alertViewWidth / 2 - 1, 43)];
            _cancelButton = cancelButton;
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            [cancelButton setTitleColor:TITLE_COLOR_LIGHT forState:UIControlStateNormal];
            [cancelButton setTitleColor:BUTTON_COLOR_RED forState:UIControlStateHighlighted];
            cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:cancelButton];
            
            UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(alertViewWidth / 2 + 1, 165, alertViewWidth / 2 - 1, 43)];
            _sureButton = sureButton;
            [sureButton setTitle:@"确认" forState:UIControlStateNormal];
            [sureButton setTitleColor:TITLE_COLOR_LIGHT forState:UIControlStateNormal];
            [sureButton setTitleColor:BUTTON_COLOR_RED forState:UIControlStateHighlighted];
            sureButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [self addSubview:sureButton];
        }
        //取消订单
        else if (type == NKAlertViewTypeCancelOrder)
        {
            CGFloat alertViewHeight = 208;
            CGFloat alertViewWidth = MAINSCREEN_WIDTH * 0.8;
            //设置弹窗视图的推出位置及大小
            self.center = CGPointMake(MAINSCREEN_WIDTH/2, MAINSCREEN_HEIGHT/2);
            self.bounds = CGRectMake(0, 0, MAINSCREEN_WIDTH * 0.8, alertViewHeight);
            self.backgroundColor = BACKGROUND_COLOR;
            self.layer.cornerRadius = CORNERRADIUS;
            self.layer.masksToBounds = YES;
            [MAIN_WINDOW addSubview:self];
            //设置最上面的标题视图
            UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertViewWidth, 36)];
            topView.backgroundColor = POPVIEW_BACKCOLOR;
            //设置title
            UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, alertViewWidth, 16)];
            topLabel.text = @"取消呼叫";
            topLabel.textAlignment = NSTextAlignmentCenter;
            [topLabel setFont:[UIFont systemFontOfSize:15.0]];
            topLabel.textColor = [UIColor whiteColor];
            [topView addSubview:topLabel];
            [self addSubview:topView];
            
            //添加中间的标签信息
            UILabel *msgLabel_0 = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, alertViewWidth, 16)];
            _deductLabel = msgLabel_0;
            //msgLabel_0.backgroundColor = [UIColor grayColor];
            msgLabel_0.text = [NSString stringWithFormat:@"现在取消订单，将扣除您0元手续费"];
            msgLabel_0.textColor = TITLE_COLOR_LIGHT;
            msgLabel_0.textAlignment = NSTextAlignmentCenter;
            msgLabel_0.font = [UIFont systemFontOfSize:13.0];
            [self addSubview:msgLabel_0];
            UILabel *msgLabel_1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 108, alertViewWidth, 16)];
            msgLabel_1.textColor = TITLE_COLOR_LIGHT;
            msgLabel_1.text = @"（2分钟内取消订单不收取任何手续费）";
            msgLabel_1.textAlignment = NSTextAlignmentCenter;
            msgLabel_1.font = [UIFont systemFontOfSize:13.0];
            [self addSubview:msgLabel_1];
            
            //添加分割线
            UIView *cutlineView_H = [[UIView alloc] initWithFrame:CGRectMake(0, alertViewHeight - 44, alertViewWidth, 1)];
            cutlineView_H.backgroundColor = CUTLINE_COLOR_LIGHT;
            [self addSubview:cutlineView_H];
            UIView *cutlineView_V = [[UIView alloc] initWithFrame:CGRectMake(alertViewWidth / 2, alertViewHeight - 44, 1, 44)];
            cutlineView_V.backgroundColor = CUTLINE_COLOR_LIGHT;
            [self addSubview:cutlineView_V];
            
            //添加底部两个按钮
            UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 165, alertViewWidth / 2 - 1, 43)];
            _cancelButton = cancelButton;
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            [cancelButton setTitleColor:TITLE_COLOR_LIGHT forState:UIControlStateNormal];
            [cancelButton setTitleColor:BUTTON_COLOR_RED forState:UIControlStateHighlighted];
            cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:cancelButton];
            
            UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(alertViewWidth / 2 + 1, 165, alertViewWidth / 2 - 1, 43)];
            _sureButton = sureButton;
            self.sureButton = sureButton;
            [sureButton setTitle:@"确认" forState:UIControlStateNormal];
            [sureButton setTitleColor:TITLE_COLOR_LIGHT forState:UIControlStateNormal];
            [sureButton setTitleColor:BUTTON_COLOR_RED forState:UIControlStateHighlighted];
            sureButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [self addSubview:sureButton];
        }
        //车位预留失败
        else if (type == NKAlertViewTypeFailedToReserveBerth)
        {
            CGFloat alertViewHeight = 280;
            CGFloat alertViewWidth = MAINSCREEN_WIDTH * 0.8;
            //设置弹窗视图的推出位置及大小
            self.center = CGPointMake(MAINSCREEN_WIDTH/2, MAINSCREEN_HEIGHT/2);
            self.bounds = CGRectMake(0, 0, MAINSCREEN_WIDTH * 0.8, alertViewHeight);
            self.backgroundColor = BACKGROUND_COLOR;
            self.layer.cornerRadius = CORNERRADIUS;
            self.layer.masksToBounds = YES;
            [MAIN_WINDOW addSubview:self];
            //设置最上面的标题视图
            UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertViewWidth, 36)];
            topView.backgroundColor = POPVIEW_BACKCOLOR;
            //设置title
            UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, alertViewWidth, 16)];
            topLabel.text = @"车位预留失败";
            topLabel.textAlignment = NSTextAlignmentCenter;
            [topLabel setFont:[UIFont systemFontOfSize:15.0]];
            topLabel.textColor = [UIColor whiteColor];
            [topView addSubview:topLabel];
            [self addSubview:topView];
            
            //提示信息label
            UILabel *msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, alertViewWidth, 16)];
            msgLabel.textColor = TITLE_COLOR_LIGHT;
            msgLabel.text = @"抱歉，您呼叫的车位预留失败";
            msgLabel.textAlignment = NSTextAlignmentCenter;
            msgLabel.font = [UIFont systemFontOfSize:13.0];
            [self addSubview:msgLabel];
            
            UIButton *button_0 = [[UIButton alloc] initWithFrame:CGRectMake(40, 100, alertViewWidth - 80, 36)];
            _continueCreateOrderButton = button_0;
            [button_0 setTitle:@"继续呼叫" forState:UIControlStateNormal];
            [button_0 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button_0.backgroundColor = BUTTON_COLOR_RED;
            button_0.layer.cornerRadius = button_0.bounds.size.height / 2;
            button_0.layer.masksToBounds = YES;
            [self addSubview:button_0];
            
            UIButton *button_1 = [[UIButton alloc] initWithFrame:CGRectMake(40, 150, alertViewWidth - 80, 36)];
            _systemSendOrderButton = button_1;
            [button_1 setTitle:@"系统指派车位" forState:UIControlStateNormal];
            [button_1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button_1.backgroundColor = BUTTON_COLOR_RED;
            button_1.layer.cornerRadius = button_0.bounds.size.height / 2;
            button_1.layer.masksToBounds = YES;
            [self addSubview:button_1];
            
            UIButton *button_2 = [[UIButton alloc] initWithFrame:CGRectMake(40, 200, alertViewWidth - 80, 36)];
            _endCallButton = button_2;
            [button_2 setTitle:@"结束呼叫" forState:UIControlStateNormal];
            [button_2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button_2.backgroundColor = BUTTON_COLOR_RED;
            button_2.layer.cornerRadius = button_0.bounds.size.height / 2;
            button_2.layer.masksToBounds = YES;
            [self addSubview:button_2];
        }
        //停车成功
        else if (type == NKAlertViewTypeSuccessToPark)
        {
            CGFloat alertViewHeight = 208;
            CGFloat alertViewWidth = MAINSCREEN_WIDTH * 0.8;
            //设置弹窗视图的推出位置及大小
            self.center = CGPointMake(MAINSCREEN_WIDTH/2, MAINSCREEN_HEIGHT/2);
            self.bounds = CGRectMake(0, 0, MAINSCREEN_WIDTH * 0.8, alertViewHeight);
            self.backgroundColor = BACKGROUND_COLOR;
            self.layer.cornerRadius = CORNERRADIUS;
            self.layer.masksToBounds = YES;
            [MAIN_WINDOW addSubview:self];
            //设置最上面的标题视图
            UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertViewWidth, 36)];
            topView.backgroundColor = POPVIEW_BACKCOLOR;
            //设置title
            UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, alertViewWidth, 16)];
            topLabel.text = @"取消呼叫";
            topLabel.textAlignment = NSTextAlignmentCenter;
            [topLabel setFont:[UIFont systemFontOfSize:15.0]];
            topLabel.textColor = [UIColor whiteColor];
            [topView addSubview:topLabel];
            [self addSubview:topView];
            
            //添加中间的标签信息
            UILabel *msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (alertViewHeight - 16) / 2, alertViewWidth, 16)];
            //msgLabel_0.backgroundColor = [UIColor grayColor];
            msgLabel.text = @"收费员已登记您的车牌信息";
            msgLabel.textColor = TITLE_COLOR_LIGHT;
            msgLabel.textAlignment = NSTextAlignmentCenter;
            msgLabel.font = [UIFont systemFontOfSize:16.0];
            [self addSubview:msgLabel];
            
            //添加分割线
            UIView *cutlineView_H = [[UIView alloc] initWithFrame:CGRectMake(0, alertViewHeight - 44, alertViewWidth, 1)];
            cutlineView_H.backgroundColor = CUTLINE_COLOR_LIGHT;
            [self addSubview:cutlineView_H];
            UIView *cutlineView_V = [[UIView alloc] initWithFrame:CGRectMake(alertViewWidth / 2, alertViewHeight - 44, 1, 44)];
            cutlineView_V.backgroundColor = CUTLINE_COLOR_LIGHT;
            [self addSubview:cutlineView_V];
            
            //添加底部两个按钮
            UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 165, alertViewWidth / 2 - 1, 43)];
            [cancelButton setTitle:@"未停车" forState:UIControlStateNormal];
            [cancelButton setTitleColor:TITLE_COLOR_LIGHT forState:UIControlStateNormal];
            [cancelButton setTitleColor:BUTTON_COLOR_RED forState:UIControlStateHighlighted];
            cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
            //[cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:cancelButton];
            
            UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(alertViewWidth / 2 + 1, 165, alertViewWidth / 2 - 1, 43)];
            self.sureButton = sureButton;
            [sureButton setTitle:@"确认" forState:UIControlStateNormal];
            [sureButton setTitleColor:TITLE_COLOR_LIGHT forState:UIControlStateNormal];
            [sureButton setTitleColor:BUTTON_COLOR_RED forState:UIControlStateHighlighted];
            sureButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [self addSubview:sureButton];
        }
        //订单超时
        else if (type == NKAlertViewTypeOrderTimeOut)
        {
            CGFloat alertViewHeight = 120;
            CGFloat alertViewWidth = MAINSCREEN_WIDTH * 0.8;
            //设置弹窗视图的推出位置及大小
            self.center = CGPointMake(MAINSCREEN_WIDTH/2, MAINSCREEN_HEIGHT/2);
            self.bounds = CGRectMake(0, 0, MAINSCREEN_WIDTH * 0.8, alertViewHeight);
            self.backgroundColor = BACKGROUND_COLOR;
            self.layer.cornerRadius = CORNERRADIUS;
            self.layer.masksToBounds = YES;
            [MAIN_WINDOW addSubview:self];
            //设置最上面的标题视图
            UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertViewWidth, 36)];
            topView.backgroundColor = POPVIEW_BACKCOLOR;
            //设置title
            UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, alertViewWidth, 16)];
            topLabel.text = @"倒计时结束";
            topLabel.textAlignment = NSTextAlignmentCenter;
            [topLabel setFont:[UIFont systemFontOfSize:15.0]];
            topLabel.textColor = [UIColor whiteColor];
            [topView addSubview:topLabel];
            [self addSubview:topView];
            
            //提示信息label
            UILabel *msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 54, alertViewWidth, 16)];
            msgLabel.textColor = TITLE_COLOR_DEEP;
            msgLabel.text = @"您已超时，订单关闭";
            msgLabel.textAlignment = NSTextAlignmentCenter;
            msgLabel.font = [UIFont systemFontOfSize:13.0];
            [self addSubview:msgLabel];
        }
        //泊乐预约车位
        else if (type == NKAlertViewTypeHappyParkingBerthAppointment)
        {
            CGFloat alertViewHeight = 208;
            CGFloat alertViewWidth = MAINSCREEN_WIDTH * 0.8;
            //设置弹窗视图的推出位置及大小
            self.center = CGPointMake(MAINSCREEN_WIDTH/2, MAINSCREEN_HEIGHT/2);
            self.bounds = CGRectMake(0, 0, MAINSCREEN_WIDTH * 0.8, alertViewHeight);
            self.backgroundColor = BACKGROUND_COLOR;
            self.layer.cornerRadius = CORNERRADIUS;
            self.layer.masksToBounds = YES;
            [MAIN_WINDOW addSubview:self];
            //设置最上面的标题视图
            UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertViewWidth, 36)];
            topView.backgroundColor = POPVIEW_BACKCOLOR;
            //设置title
            UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, alertViewWidth, 16)];
            topLabel.text = @"车位预定";
            topLabel.textAlignment = NSTextAlignmentCenter;
            [topLabel setFont:[UIFont systemFontOfSize:15.0]];
            topLabel.textColor = [UIColor whiteColor];
            [topView addSubview:topLabel];
            [self addSubview:topView];
            
            //添加中间的标签信息
            UIImageView *tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 54, 12, 12)];
            tipImageView.image = [UIImage imageNamed:@"小费金额"];
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 54, alertViewWidth - 42, 16)];
            tipLabel.text = @"2元";
            tipLabel.textColor = TITLE_COLOR_DEEP;
            tipLabel.font = [UIFont systemFontOfSize:16.0];
            [self addSubview:tipImageView];
            [self addSubview:tipLabel];
            
            UIImageView *parkingPlaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 82, 12, 12)];
            parkingPlaceImageView.image = [UIImage imageNamed:@"停车场-1"];
            UILabel *parkingPlaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 82, alertViewWidth - 42, 16)];
            parkingPlaceLabel.text = @"万达东山苑（5元/小时）";
            parkingPlaceLabel.textColor = TITLE_COLOR_DEEP;
            parkingPlaceLabel.font = [UIFont systemFontOfSize:16.0];
            [self addSubview:parkingPlaceImageView];
            [self addSubview:parkingPlaceLabel];
            
            UIImageView *locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 106, 12, 12)];
            locationImageView.image = [UIImage imageNamed:@"地址"];
            UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 106, alertViewWidth - 42, 16)];
            locationLabel.text = @"深圳市南山区科技园科陆大厦B座10层";
            locationLabel.textColor = TITLE_COLOR_DEEP;
            locationLabel.font = [UIFont systemFontOfSize:12.0];
            [self addSubview:locationImageView];
            [self addSubview:locationLabel];
            
            UILabel *promptMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 140, alertViewWidth, 12)];
            promptMessageLabel.text = @"车位预定成功后，为您保留15分钟";
            promptMessageLabel.font = [UIFont systemFontOfSize:12.0];
            promptMessageLabel.textAlignment = NSTextAlignmentCenter;
            promptMessageLabel.textColor = TITLE_COLOR_LIGHT;
            [self addSubview:promptMessageLabel];
            
            //添加分割线
            UIView *cutlineView_H = [[UIView alloc] initWithFrame:CGRectMake(0, alertViewHeight - 44, alertViewWidth, 1)];
            cutlineView_H.backgroundColor = CUTLINE_COLOR_LIGHT;
            [self addSubview:cutlineView_H];
            UIView *cutlineView_V = [[UIView alloc] initWithFrame:CGRectMake(alertViewWidth / 2, alertViewHeight - 44, 1, 44)];
            cutlineView_V.backgroundColor = CUTLINE_COLOR_LIGHT;
            [self addSubview:cutlineView_V];
            
            //添加底部两个按钮
            UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 165, alertViewWidth / 2 - 1, 43)];
            _cancelButton = cancelButton;
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            [cancelButton setTitleColor:TITLE_COLOR_LIGHT forState:UIControlStateNormal];
            [cancelButton setTitleColor:BUTTON_COLOR_RED forState:UIControlStateHighlighted];
            cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:cancelButton];
            
            UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(alertViewWidth / 2 + 1, 165, alertViewWidth / 2 - 1, 43)];
            _sureButton = sureButton;
            self.sureButton = sureButton;
            [sureButton setTitle:@"预订" forState:UIControlStateNormal];
            [sureButton setTitleColor:BUTTON_COLOR_RED forState:UIControlStateNormal];
            sureButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [self addSubview:sureButton];
        }
    }
    return self;
}
-(void)buttonClick:(UIButton*)button
{
    [self hide:YES];
}
- (void)show:(BOOL)animated
{
    if (animated)
    {
        self.transform = CGAffineTransformScale(self.transform,0,0);
        __weak NKAlertView *weakSelf = self;
        [UIView animateWithDuration:.3 animations:^{
            weakSelf.transform = CGAffineTransformScale(weakSelf.transform,1.2,1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.3 animations:^{
                weakSelf.transform = CGAffineTransformIdentity;
            }];
        }];
    }
}
- (void)hide:(BOOL)animated
{
    [self endEditing:YES];
    if (self.bGView != nil) {
        __weak NKAlertView *weakSelf = self;
        
        [UIView animateWithDuration:animated ?0.3: 0 animations:^{
            weakSelf.transform = CGAffineTransformScale(weakSelf.transform,1,1);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration: animated ?0.3: 0 animations:^{
                weakSelf.transform = CGAffineTransformScale(weakSelf.transform,0.2,0.2);
            } completion:^(BOOL finished) {
                [weakSelf.bGView removeFromSuperview];
                [weakSelf removeFromSuperview];
                weakSelf.bGView=nil;
            }];
        }];
    }
    
}
- (void)textFieldValueChanged:(UITextField *)sender
{
    if (sender.tag < 1999)
    {
        if(sender.tag == 1005)
        {
            [sender resignFirstResponder];
        }
        else
        {
            UITextField *textField = self.passwordTextFieldArray[sender.tag - 1000 + 1];
            [textField becomeFirstResponder];
        }
    }
    if (sender.tag < 2999 && sender.tag > 1999)
    {
        if(sender.tag == 2005)
        {
            [sender resignFirstResponder];
        }
        else
        {
            UITextField *textField = self.setPasswordTextFieldArray[sender.tag - 2000 + 1];
            [textField becomeFirstResponder];
        }
    }
    if (sender.tag > 2999)
    {
        if(sender.tag == 3005)
        {
            [sender resignFirstResponder];
        }
        else
        {
            UITextField *textField = self.resetPasswordTExtFieldArray[sender.tag - 3000 + 1];
            [textField becomeFirstResponder];
        }
    }
    
}
-(void)clickBackViewButton
{
    if (_type == NKAlertViewTypeFailedToReserveBerth)
    {
        return;
    }
    [self hide:YES];
}

@end
