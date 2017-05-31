//
//  ChangeSignatureViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 2017/4/1.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "ChangeSignatureViewController.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "NKDataManager.h"

@interface ChangeSignatureViewController ()

@property (nonatomic, strong) UITextField *signTextField;
@property (nonatomic, strong) MBProgressHUD *HUD;

@end

@implementation ChangeSignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setNavigationBar];
    [self initSubViews];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_HUD removeFromSuperview];
}

- (void)setNavigationBar
{
    self.navigationItem.title = @"更改签名";
    UIImage *leftItemImage = [UIImage imageNamed:@"左箭头"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[leftItemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initSubViews
{
    _signTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 76, WIDTH_VIEW, 64)];
    _signTextField.placeholder = @"在这里写下您的个性签名吧...";
    _signTextField.backgroundColor = [UIColor whiteColor];
    
    //光标右移
    UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(_signTextField.frame.origin.x, _signTextField.frame.origin.y, 15.0, _signTextField.frame.size.height)];
    _signTextField.leftView = blankView;
    _signTextField.leftViewMode =UITextFieldViewModeAlways;
    
    [self.view addSubview:_signTextField];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(12, 152, WIDTH_VIEW - 24, 44)];
    button.backgroundColor = COLOR_BUTTON_RED;
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.layer.cornerRadius = CORNERRADIUS;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(clickSureButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark - 点击button方法
- (void)clickSureButton
{
    if (self.signTextField.text.length == 0)
    {
        [self popHUDWithString:@"签名不能为空"];
        return;
    }
    NSString *parameterSignature = self.signTextField.text;
    [self postToChangeSignatureWith:parameterSignature];
}
#pragma mark - 网络请求方法
- (void)postToChangeSignatureWith:(NSString *)signature
{
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD = MBProgressHUDModeIndeterminate;
    _HUD.label.text = @"Loding";
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:signature forKey:@"signature"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"myToken"];
    [parameter setObject:token forKey:@"token"];
    
    NKDataManager *dataManager = [NKDataManager sharedDataManager];
    [dataManager POSTUpdateMyInfoWithParameters:parameter Success:^(NKBase *base) {
        //将数据写入本地
        NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userData"];
        NKUser *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        user.signature = signature;
        userData = [NSKeyedArchiver archivedDataWithRootObject:user];
        [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"userData"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //界面消失
            [_HUD hideAnimated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        });
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_HUD hideAnimated:YES];
            [self popHUDWithString:@"网络异常"];
        });
    }];
    
}
- (void)popHUDWithString:(NSString *)str
{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.mode = MBProgressHUDModeText;
    self.HUD.label.text = str;
    [self.HUD hideAnimated:YES afterDelay:2.0];
    [self.HUD removeFromSuperViewOnHide];
}



@end
