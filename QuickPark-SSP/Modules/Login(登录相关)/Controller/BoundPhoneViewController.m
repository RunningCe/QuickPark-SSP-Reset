//
//  BoundPhoneViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 16/8/19.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "BoundPhoneViewController.h"
#import "NKDataManager.h"
#import "MBProgressHUD.h"
#import "MainTabbarViewController.h"

@interface BoundPhoneViewController ()

@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_0;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_2;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *maskTextField;
@property (weak, nonatomic) IBOutlet UIView *cutLine_0;
@property (weak, nonatomic) IBOutlet UIView *cutLine_1;
@property (weak, nonatomic) IBOutlet UIButton *boundButton;
@property (weak, nonatomic) IBOutlet UIButton *maskButton;
@property (weak, nonatomic) IBOutlet UILabel *protocolLabel;

@end

@implementation BoundPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    [self setNavigationBar];
}
- (void)setNavigationBar
{
    self.navigationItem.title = @"绑定手机号";
    UIImage *itemImage = [UIImage imageNamed:@"左箭头"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[itemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    leftItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_TITLE_WHITE}];
    
    self.navigationController.navigationBar.barTintColor = COLOR_NAVI_BLACK;
    self.navigationController.navigationBar.backgroundColor = COLOR_NAVI_BLACK;
}
-(void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)initSubViews
{
    int type = [[self.parametersDic valueForKey:@"type"] intValue];
    if (type == 0)
    {
        self.imageView_0.image = [UIImage imageNamed:@"wechat_bound"];
    }
    else if (type == 1)
    {
        self.imageView_0.image = [UIImage imageNamed:@"qq_bound"];
    }
    else
    {
        self.imageView_0.image = [UIImage imageNamed:@"aliypay_bound"];
    }
        
    self.imageView_1.image = [UIImage imageNamed:@"quickpark_bound"];
    self.imageView_2.image = [UIImage imageNamed:@"关联_bound"];
    
    self.phoneTextField.textColor = CUTLINE_COLOR;
    self.phoneTextField.borderStyle = UITextBorderStyleNone;
    self.phoneTextField.placeholder = @"输入手机号";
    [self.phoneTextField setValue:CUTLINE_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    
    self.maskTextField.textColor = CUTLINE_COLOR;
    self.maskTextField.borderStyle = UITextBorderStyleNone;
    self.maskTextField.placeholder = @"输入验证码";
    [self.maskTextField setValue:CUTLINE_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    
    self.cutLine_0.backgroundColor = CUTLINE_COLOR;
    self.cutLine_1.backgroundColor = CUTLINE_COLOR;
    
    [self.maskButton setTitleColor:CUTLINE_COLOR forState:UIControlStateNormal];
    self.maskButton.layer.cornerRadius = CORNERRADIUS;
    self.maskButton.layer.masksToBounds = YES;
    self.maskButton.layer.borderColor = CUTLINE_COLOR.CGColor;
    self.maskButton.layer.borderWidth = 1;

    
    self.boundButton.backgroundColor = COLOR_BUTTON_RED;
    [self.boundButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.boundButton.layer.cornerRadius = CORNERRADIUS;
    self.boundButton.layer.masksToBounds = YES;
    
    self.protocolLabel.textColor = COLOR_TITLE_GRAY;
    
}
- (IBAction)clickMaskButton:(UIButton *)sender
{
    NSLog(@"发送验证码！");
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
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
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
- (IBAction)clickBoundButton:(UIButton *)sender
{
    //发送登录请求
    MBProgressHUD *waithud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    waithud.mode = MBProgressHUDModeIndeterminate;
    waithud.label.text = @"Loding";
    
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
    //取出要传的参数
    NSString *nickName = [self.parametersDic objectForKey:@"nickName"];
    NSString *sex = [self.parametersDic objectForKey:@"sex"];
    NSString *headImageUrl = [self.parametersDic objectForKey:@"headImgUrl"];
    NSInteger type = [[self.parametersDic objectForKey:@"type"] integerValue];
    NSString *openId = [self.parametersDic objectForKey:@"TpOpenId"];
    //创建一个可变字典
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    //往字典里面添加需要提交的参数
    [parametersDic setObject:openId forKey:@"TpOpenId"];
    [parametersDic setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    [parametersDic setObject:sex forKey:@"sex"];
    [parametersDic setObject:nickName forKey:@"nickName"];
    [parametersDic setObject:headImageUrl forKey:@"headImgUrl"];
    [parametersDic setObject:self.phoneTextField.text forKey:@"mobile"];
    [parametersDic setObject:self.maskTextField.text forKey:@"smsCode"];
    
    NKDataManager *dataManager = [NKDataManager sharedDataManager];
    [dataManager POSTTPBindLoginDataWithParameters:parametersDic Success:^(NKLogin *loginMsg) {
        if (loginMsg.ret == 0 || loginMsg.ret == -5092)//ret == 0 绑定成功， ret == -5092第一次注册成功
        {
            //更改登录状态
            [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"liginFlag"];
            //将用户数据写到plist文件中
            [NKDataManager writeDataToTextWith:loginMsg];
            dispatch_async(dispatch_get_main_queue(), ^{
                //回到主线程更新界面
                [waithud hideAnimated:YES];
                [waithud removeFromSuperViewOnHide];
                
                MainTabbarViewController *mainTabbarController = [[MainTabbarViewController alloc] initWithLoginMsg:loginMsg];
                //跳转事件
                [self presentViewController:mainTabbarController animated:YES completion:nil];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //回到主线程更新界面
                [waithud hideAnimated:YES];
                [waithud removeFromSuperViewOnHide];
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = loginMsg.msg;
                [hud hideAnimated:YES afterDelay:2.0];
                [hud removeFromSuperViewOnHide];
            });
        }
    } Failure:^(NSError *error) {
        NSLog(@"%@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            //回到主线程更新界面
            [waithud hideAnimated:YES];
            [waithud removeFromSuperViewOnHide];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"网络异常";
            [hud hideAnimated:YES afterDelay:2.0];
            [hud removeFromSuperViewOnHide];
        });
    }];
    //将验证码输入框变为第一响应
    [_maskTextField becomeFirstResponder];
}

- (IBAction)clickUserProtocalButton:(UIButton *)sender
{
    NSString *urlStr = [NSString stringWithFormat:@"http://www.quickpark.com.cn/privacy.html"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.phoneTextField resignFirstResponder];
    [self.maskTextField resignFirstResponder];
}


@end
