//
//  ChangeNameViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 16/8/17.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "ChangeNameViewController.h"
#import "NKDataManager.h"
#import "MBProgressHUD/MBProgressHUD.h"

#define HEIGHT_OF_NAVIGATIONBAR 64

@interface ChangeNameViewController ()

@property (nonatomic, strong)UILabel *Label;
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, strong)UIButton *button;
@property (nonatomic, strong)UIView *lineView;

@end

@implementation ChangeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"更改昵称";
    [self createSubViews];
    [self setNavigationBar];
}
-(void)setNavigationBar
{
    UIImage *leftItemImage = [UIImage imageNamed:@"左箭头"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[leftItemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
}
-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createSubViews
{
    _Label = [[UILabel alloc] initWithFrame:CGRectMake(12, HEIGHT_OF_NAVIGATIONBAR, 56, 44)];
    _Label.text = @"昵称：";
    _Label.textColor = COLOR_TITLE_GRAY;
    [self.view addSubview:_Label];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(68, HEIGHT_OF_NAVIGATIONBAR + 6, WIDTH_VIEW - 68, 34)];
    _textField.placeholder = @"请输入昵称";
    _textField.textColor = COLOR_TITLE_GRAY;
    [self.view addSubview:_textField];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(56, HEIGHT_OF_NAVIGATIONBAR + 6 + 34, WIDTH_VIEW - 56 - 12, 1)];
    _lineView.backgroundColor = COLOR_TITLE_GRAY;
    [self.view addSubview:_lineView];
    
    _button = [[UIButton alloc]initWithFrame:CGRectMake(12, HEIGHT_OF_NAVIGATIONBAR + 56, WIDTH_VIEW - 24, 44)];
    _button.backgroundColor = COLOR_BUTTON_RED;
    _button.layer.cornerRadius = CORNERRADIUS;
    _button.layer.masksToBounds = YES;
    [_button setTitle:@"确定" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    
    
}

- (void) clickButton
{
    //发送网络请求
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"Loding";
    
    NKDataManager *dataManager = [NKDataManager sharedDataManager];
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"myToken"];
    
    [parametersDic setObject:self.textField.text forKey:@"niName"];
    [parametersDic setObject:token forKey:@"token"];
    [dataManager POSTUpdateMyInfoWithParameters:parametersDic Success:^(NKBase *base) {
        //将数据写入本地
        NSUserDefaults *userDefualt = [NSUserDefaults standardUserDefaults];
        [userDefualt setObject:self.textField.text forKey:@"niName"];
        dispatch_async(dispatch_get_main_queue(), ^{
            //界面消失
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        });
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }];
    
}


@end
