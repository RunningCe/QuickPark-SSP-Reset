//
//  EvaluateSuccessViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 2017/3/13.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "EvaluateSuccessViewController.h"
#import "Masonry.h"

@interface EvaluateSuccessViewController ()

@end

@implementation EvaluateSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setNavigationBar];
    [self initSubViews];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
#pragma  mark - 初始化界面
- (void)setNavigationBar
{
    self.navigationItem.title = @"点评成功";
    UIImage *leftItemImage = [UIImage imageNamed:@"backarrow_black"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[leftItemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_TITLE_BLACK}];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}
-(void)goBack
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)initSubViews
{
    UIView *topView = [[UIView alloc] init];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).offset(64);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(HEIGHT_VIEW / 3);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"evaluate_success"]];
    [topView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView.mas_centerX);
        make.top.equalTo(topView.mas_top).offset(20);
    }];
    
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 16)];
    msgLabel.textColor = COLOR_TITLE_BLACK;
    msgLabel.font = [UIFont systemFontOfSize:16.0];
    msgLabel.text = @"分享即可获取优惠券";
    [topView addSubview:msgLabel];
    [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(20);
        make.centerX.equalTo(imageView.mas_centerX);
        make.height.equalTo(@16);
    }];
    
    UIButton *shareButton = [[UIButton alloc] init];
    [topView addSubview:shareButton];
    shareButton.backgroundColor = COLOR_BUTTON_RED;
    [shareButton setTitle:@"分享领券" forState:UIControlStateNormal];
    [shareButton setTitleColor:COLOR_TITLE_WHITE forState:UIControlStateNormal];
    shareButton.layer.cornerRadius = CORNERRADIUS;
    shareButton.layer.masksToBounds = YES;
    [shareButton addTarget:self action:@selector(clickShareButton) forControlEvents:UIControlEventTouchUpInside];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(msgLabel.mas_bottom).offset(20);
        make.centerX.equalTo(msgLabel.mas_centerX);
        make.left.equalTo(topView.mas_left).offset(12);
        make.right.equalTo(topView.mas_right).offset(-12);
    }];
    
}

- (void)clickShareButton
{
    NSLog(@"分享获取优惠券");
}

@end
