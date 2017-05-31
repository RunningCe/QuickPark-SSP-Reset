//
//  ResetPasswordViewController.m
//  QuickPark-SSP
//
//  Created by Jack on 16/8/28.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "NKDataManager.h"
#import "ResetPasswordNextViewController.h"
#import "MBProgressHUD.h"
@interface ResetPasswordViewController()
@property (weak, nonatomic) IBOutlet UILabel *topLabel_left;
@property (weak, nonatomic) IBOutlet UILabel *topLabel_right;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *maskTextField;
@property (weak, nonatomic) IBOutlet UIView *cutLineView;
@property (weak, nonatomic) IBOutlet UIButton *maskButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;


@end


@interface ResetPasswordViewController ()

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubViews];
}
- (void)initSubViews{
    self.topLabel_left.textColor = COLOR_BUTTON_RED;
    self.topLabel_right.textColor = COLOR_TITLE_GRAY;
    
    self.phoneNumberLabel.textColor = COLOR_TITLE_GRAY;
    NSString *phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
    NSString *leadNumber = [phoneNumber substringWithRange:(NSRange){0, 3}];
    NSString *tailNumber = [phoneNumber substringWithRange:(NSRange){7, 4}];
    self.phoneNumberLabel.text = [NSString stringWithFormat:@"%@****%@", leadNumber, tailNumber];
    
    self.maskTextField.textColor = COLOR_TITLE_GRAY;
    self.maskTextField.borderStyle = UITextBorderStyleNone;
    self.maskTextField.placeholder = @"输入验证码";
    [self.maskTextField setValue:COLOR_TITLE_GRAY forKeyPath:@"_placeholderLabel.textColor"];
    self.maskTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.cutLineView.backgroundColor = COLOR_TITLE_GRAY;
    
    [self.maskButton setTitleColor:COLOR_TITLE_GRAY forState:UIControlStateNormal];
    self.maskButton.layer.cornerRadius = CORNERRADIUS;
    self.maskButton.layer.masksToBounds = YES;
    self.maskButton.layer.borderColor = COLOR_TITLE_GRAY.CGColor;
    self.maskButton.layer.borderWidth = 1;
    
    self.nextButton.backgroundColor = COLOR_BUTTON_RED;
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextButton.layer.cornerRadius = CORNERRADIUS;
    self.nextButton.layer.masksToBounds = YES;
}
- (IBAction)clickMaskButton:(UIButton *)sender {
    NSLog(@"发送验证码");
    [_maskTextField becomeFirstResponder];
    /******************发送网络请求*****************/
    
    //假如需要提交给服务器的参数是key＝1,class_id=100
    //创建一个可变字典
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    //往字典里面添加需要提交的参数
    [parametersDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"] forKey:@"mobileNum"];
    //[parametersDic setObject:@"" forKey:@"type"];
    
    NKDataManager *dataManager = [NKDataManager sharedDataManager];
    [dataManager POSTMaskDataWithParameters:parametersDic Success:^(NKMask *mask) {
        NSLog(@"验证码发送成功！！");
    } Failure:^(NSError *error) {
        NSLog(@"验证码发送失败！");
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
                
                [_maskButton setTitleColor:COLOR_TITLE_GRAY forState:UIControlStateNormal];
                [_maskButton setTitle:@"验证码" forState:UIControlStateNormal];
                _maskButton.layer.cornerRadius = CORNERRADIUS;
                _maskButton.layer.masksToBounds = YES;
                _maskButton.layer.borderColor = COLOR_TITLE_GRAY.CGColor;
                _maskButton.layer.borderWidth = 1;
                
                _maskButton.userInteractionEnabled = YES;
                
            });
            
        }else{
            
            //            int minutes = timeout / 60;
            
            int seconds = timeout % 60;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                //NSLog(@"____%@",strTime);
                
                [_maskButton setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                
                _maskButton.backgroundColor = [UIColor clearColor];
                
                _maskButton.userInteractionEnabled = NO;
                
            });
            
            timeout--;
            
        }
        
    });
    
    dispatch_resume(_timer);
    
}
                                      
- (IBAction)clickNextButton:(UIButton *)sender {
    NSLog(@"下一步");
    //校验验证码
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    NKDataManager *dataManager = [NKDataManager sharedDataManager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.maskTextField.text forKey:@"smscode"];
    [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"] forKey:@"mobile"];
    [dataManager POSTToCheckSmsCodeWithParameters:parameters Success:^(NKBase *base) {
        if (base.ret == 0)
        {
            //成功推出重设密码界面
            ResetPasswordNextViewController *rpnVC = [[ResetPasswordNextViewController alloc] initWithNibName:@"ResetPasswordNextViewController" bundle:nil];
            [self.navigationController pushViewController:rpnVC animated:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [hud removeFromSuperViewOnHide];
            });
        }
        else
        {
            hud.mode = MBProgressHUDModeText;
            hud.label.text = base.msg;
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                [hud removeFromSuperViewOnHide];
            });
        }
    } Failure:^(NSError *error) {
        NSLog(@"%@",error);
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"网络异常";
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            [hud removeFromSuperViewOnHide];
        });
    }];
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
