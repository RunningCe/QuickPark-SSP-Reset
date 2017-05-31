//
//  ResetPasswordNextViewController.m
//  QuickPark-SSP
//
//  Created by Jack on 16/8/28.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "ResetPasswordNextViewController.h"
#import "NKDataManager.h"

@interface ResetPasswordNextViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *topLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *topRightLabel;
@property (weak, nonatomic) IBOutlet UILabel *resetPwdLabel;
@property (weak, nonatomic) IBOutlet UILabel *surePwdLabel;



@property (weak, nonatomic) IBOutlet UIView *firstPasswordBackView;
@property (weak, nonatomic) IBOutlet UIView *firstCutLineView_0;
@property (weak, nonatomic) IBOutlet UIView *firstCutLineView_1;
@property (weak, nonatomic) IBOutlet UIView *firstCutLineView_2;
@property (weak, nonatomic) IBOutlet UIView *firstCutLineView_3;
@property (weak, nonatomic) IBOutlet UIView *firstCutLineView_4;
@property (weak, nonatomic) IBOutlet UITextField *firstTextField_0;
@property (weak, nonatomic) IBOutlet UITextField *firstTextField_1;
@property (weak, nonatomic) IBOutlet UITextField *firstTextField_2;
@property (weak, nonatomic) IBOutlet UITextField *firstTextField_3;
@property (weak, nonatomic) IBOutlet UITextField *firstTextField_4;
@property (weak, nonatomic) IBOutlet UITextField *firstTextField_5;

@property (weak, nonatomic) IBOutlet UIView *secondPassWordBackView;
@property (weak, nonatomic) IBOutlet UIView *secondCutLineView_0;
@property (weak, nonatomic) IBOutlet UIView *secondCutLineView_1;
@property (weak, nonatomic) IBOutlet UIView *secondCutLineView_2;
@property (weak, nonatomic) IBOutlet UIView *secondCutLineView_3;
@property (weak, nonatomic) IBOutlet UIView *secondCutLineView_4;
@property (weak, nonatomic) IBOutlet UITextField *secondTextField_0;
@property (weak, nonatomic) IBOutlet UITextField *secondTextField_1;
@property (weak, nonatomic) IBOutlet UITextField *secondTextField_2;
@property (weak, nonatomic) IBOutlet UITextField *secondTextField_3;
@property (weak, nonatomic) IBOutlet UITextField *secondTextField_4;
@property (weak, nonatomic) IBOutlet UITextField *secondTextField_5;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (nonatomic, strong)NSMutableArray *textFieldArray;

@end

@implementation ResetPasswordNextViewController
-(NSMutableArray *)textFieldArray
{
    if (_textFieldArray == nil)
    {
        _textFieldArray = [NSMutableArray array];
    }
    return _textFieldArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.textFieldArray addObject:_firstTextField_0];
    [self.textFieldArray addObject:_firstTextField_1];
    [self.textFieldArray addObject:_firstTextField_2];
    [self.textFieldArray addObject:_firstTextField_3];
    [self.textFieldArray addObject:_firstTextField_4];
    [self.textFieldArray addObject:_firstTextField_5];
    [self.textFieldArray addObject:_secondTextField_0];
    [self.textFieldArray addObject:_secondTextField_1];
    [self.textFieldArray addObject:_secondTextField_2];
    [self.textFieldArray addObject:_secondTextField_3];
    [self.textFieldArray addObject:_secondTextField_4];
    [self.textFieldArray addObject:_secondTextField_5];
    
    
    [self initSubViews];
}
#pragma mark - 初始化子视图
- (void)initSubViews{
    self.topLeftLabel.textColor = COLOR_TITLE_GRAY;
    self.topRightLabel.textColor = COLOR_BUTTON_RED;
    
    self.resetPwdLabel.textColor = COLOR_TITLE_GRAY;
    self.surePwdLabel.textColor = COLOR_TITLE_GRAY;
    
    self.firstPasswordBackView.layer.borderWidth = 1;
    self.firstPasswordBackView.layer.borderColor = COLOR_TITLE_GRAY.CGColor;
    self.firstPasswordBackView.layer.cornerRadius = CORNERRADIUS;
    self.firstPasswordBackView.layer.masksToBounds = YES;
    self.firstCutLineView_0.backgroundColor = COLOR_TITLE_GRAY;
    self.firstCutLineView_1.backgroundColor = COLOR_TITLE_GRAY;
    self.firstCutLineView_2.backgroundColor = COLOR_TITLE_GRAY;
    self.firstCutLineView_3.backgroundColor = COLOR_TITLE_GRAY;
    self.firstCutLineView_4.backgroundColor = COLOR_TITLE_GRAY;
    
    self.secondPassWordBackView.layer.borderWidth = 1;
    self.secondPassWordBackView.layer.borderColor = COLOR_TITLE_GRAY.CGColor;
    self.secondPassWordBackView.layer.cornerRadius = CORNERRADIUS;
    self.secondPassWordBackView.layer.masksToBounds = YES;
    self.secondCutLineView_0.backgroundColor = COLOR_TITLE_GRAY;
    self.secondCutLineView_1.backgroundColor = COLOR_TITLE_GRAY;
    self.secondCutLineView_2.backgroundColor = COLOR_TITLE_GRAY;
    self.secondCutLineView_3.backgroundColor = COLOR_TITLE_GRAY;
    self.secondCutLineView_4.backgroundColor = COLOR_TITLE_GRAY;

    //统一设置textfield
    for (int i = 0; i < 12; i++)
    {
        UITextField *textField = self.textFieldArray[i];
        textField.borderStyle = UITextBorderStyleNone;
        textField.secureTextEntry = YES;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        if (i < 6)
        {
            textField.tag = 1000 + i;
        }
        else
        {
            textField.tag = 2000 + (i-6);
        }
    }
    
    
    self.sureButton.backgroundColor = COLOR_BUTTON_RED;
    [self.sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sureButton.layer.cornerRadius = CORNERRADIUS;
    self.sureButton.layer.masksToBounds = YES;
    
    
}
#pragma mark - textField相关方法
- (IBAction)first_OR_secondTextFieldEditChanged:(UITextField *)sender {
    if (sender.text.length > 0)
    {
        if (sender.tag == 1005)
        {
            [self.secondTextField_0 becomeFirstResponder];
            return;
        }
        if (sender.tag == 2005)
        {
            [sender resignFirstResponder];
            return;
        }
        if (sender.tag < 2000)
        {
            UITextField *nextTextField = self.textFieldArray[sender.tag - 1000 + 1];
            [nextTextField becomeFirstResponder];
        }
        if (sender.tag > 1999)
        {
            UITextField *nextTextField = self.textFieldArray[sender.tag - 2000 + 6 + 1];
            [nextTextField becomeFirstResponder];
        }
        
    }
    //清空密码
    if (sender.text.length == 0)
    {
        if (sender.tag < 2000)
        {
            for (int i = 0; i < 6; i++)
            {
                UITextField *textField = self.textFieldArray[i];
                textField.text = @"";
                [self.firstTextField_0 becomeFirstResponder];
            }
        }
        if (sender.tag > 1999)
        {
            for (int i = 6; i < 12; i++)
            {
                UITextField *textField = self.textFieldArray[i];
                textField.text = @"";
                [self.secondTextField_0 becomeFirstResponder];
            }
        }
    }
}



#pragma mark - 确定按钮提交验证密码正确性
- (IBAction)clickSureButton:(UIButton *)sender
{
    NSString *firstPWD = [NSString stringWithFormat:@"%@%@%@%@%@%@", self.firstTextField_0.text, self.firstTextField_1.text, self.firstTextField_2.text, self.firstTextField_3.text, self.firstTextField_4.text, self.firstTextField_5.text];
    NSString *secondPWD = [NSString stringWithFormat:@"%@%@%@%@%@%@", self.secondTextField_0.text, self.secondTextField_1.text, self.secondTextField_2.text, self.secondTextField_3.text, self.secondTextField_4.text, self.secondTextField_5.text];
    if ([firstPWD isEqualToString:secondPWD])
    {
        NSLog(@"密码相同!!");
        /******************网络请求***********************/
        //发送网络请求重置密码
        NKDataManager *dataManager = [NKDataManager sharedDataManager];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *token = [userDefault objectForKey:@"myToken"];
        
        [parameters setObject:token forKey:@"token"];
        [parameters setObject:firstPWD forKey:@"password"];
        
        [dataManager POSTUpdateUserPasswordWithParameters:parameters Success:^(NSString *backStr) {
            if ([backStr isEqualToString:@"success"])
            {
                NSLog(@"更改密码成功！！！！！！");
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
            if ([backStr isEqualToString:@"fail"])
            {
                NSLog(@"更改密码失败！！！！！！");
            }
        } Failure:^(NSError *error) {
            NSLog(@"网络请求失败！");
        }];
        /************************************************/
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



@end
