//
//  WalletViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 2017/2/18.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "WalletViewController.h"
#import "PayViewController.h"
#import "ConsumerDetailsTableViewController.h"
#import "CouponViewController.h"
#import "Masonry.h"
#import "NKAlertView.h"

#define ButtonColorGray [UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:189.0/255.0 alpha:1.0];
@interface WalletViewController ()

@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self createSubviews];
    self.view.backgroundColor = BACKGROUND_COLOR;
}
- (void)viewWillAppear:(BOOL)animated{
    [self setNavigationBar];
}
-(void)setNavigationBar
{
    self.navigationItem.title = @"钱包";
    UIImage *itemImage = [UIImage imageNamed:@"左箭头"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[itemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_TITLE_WHITE}];

    //设置导航栏的背景为透明再设置颜色，保证颜色不失真
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.barTintColor = COLOR_NAVI_BLACK;
    self.navigationController.navigationBar.backgroundColor = COLOR_NAVI_BLACK;
    //设置statusBar颜色，不设置会变成白色
    UIView *statusBar = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
    statusBar.backgroundColor = COLOR_NAVI_BLACK;
    [self.navigationController.navigationBar addSubview:statusBar];
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
#pragma mark - 创建界面
- (void)createSubviews
{
    //topView
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = COLOR_VIEW_BLACK;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(220);
    }];
    //圆圈图
    UIImageView *circleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallet_circleBase"]];
    [topView addSubview:circleImageView];
    [circleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(topView.center);
    }];
    //三个label
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    [topView addSubview:moneyLabel];
    double money = [[NSUserDefaults standardUserDefaults] integerForKey:@"balance"] / 100;
    moneyLabel.text = [NSString stringWithFormat:@"%.2lf", money];
    moneyLabel.textColor = COLOR_TITLE_WHITE;
    moneyLabel.font = [UIFont systemFontOfSize:30.0];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.backgroundColor = [UIColor clearColor];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(topView.center);
        make.height.equalTo(@30);
    }];
    UILabel *moneyTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 12)];
    [topView addSubview:moneyTitleLabel];
    moneyTitleLabel.text = @"余额";
    moneyTitleLabel.textColor = COLOR_TITLE_WHITE;
    moneyTitleLabel.font = [UIFont systemFontOfSize:12.0];
    moneyTitleLabel.textAlignment = NSTextAlignmentCenter;
    moneyTitleLabel.backgroundColor = [UIColor clearColor];
    [moneyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(moneyLabel.mas_top).offset(-16);
        make.centerX.equalTo(moneyLabel.mas_centerX);
        make.height.equalTo(@12);
    }];
    UILabel *moneyDetaileLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 12)];
    [topView addSubview:moneyDetaileLabel];
    moneyDetaileLabel.text = @"(元)";
    moneyDetaileLabel.textColor = COLOR_TITLE_WHITE;
    moneyDetaileLabel.font = [UIFont systemFontOfSize:12.0];
    moneyDetaileLabel.textAlignment = NSTextAlignmentCenter;
    moneyDetaileLabel.backgroundColor = [UIColor clearColor];
    [moneyDetaileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyLabel.mas_bottom).offset(16);
        make.centerX.equalTo(moneyLabel.mas_centerX);
        make.height.equalTo(@12);
    }];
    //三个buttonbaseView
    UIView *bottomBaseView = [[UIView alloc] init];
    [self.view addSubview:bottomBaseView];
    bottomBaseView.backgroundColor = BACKGROUND_COLOR;
    [bottomBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(self.view.mas_width).multipliedBy(0.333333);
    }];
    //畅停卡、优惠券、明细
    //获取button位置
    CGFloat spc = 12;
    //优惠券
    UIButton *couponButton = [[UIButton alloc] init];
    [bottomBaseView addSubview:couponButton];
    [couponButton setImage:[UIImage imageNamed:@"wallet_coupon"] forState:UIControlStateNormal];
    [couponButton setBackgroundColor:[UIColor whiteColor]];
    [couponButton setTitle:@"优惠券" forState:UIControlStateNormal];
    [couponButton setTitleColor:COLOR_TITLE_BLACK forState:UIControlStateNormal];
    couponButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    couponButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [couponButton addTarget:self action:@selector(clickMoneyCouponButton) forControlEvents:UIControlEventTouchUpInside];
    [couponButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(bottomBaseView.center);
        make.top.equalTo(bottomBaseView.mas_top);
        make.bottom.equalTo(bottomBaseView.mas_bottom);
        make.width.mas_equalTo(bottomBaseView.mas_width).multipliedBy(0.333333);
    }];
    couponButton.titleEdgeInsets = UIEdgeInsetsMake(couponButton.imageView.frame.size.height + spc, -couponButton.imageView.bounds.size.width, 0, 0);
    couponButton.imageEdgeInsets = UIEdgeInsetsMake(0, couponButton.titleLabel.frame.size.width/2, couponButton.titleLabel.frame.size.height + spc, -couponButton.titleLabel.frame.size.width/2);
    //畅停卡
    UIButton *cardButton = [[UIButton alloc] init];
    [bottomBaseView addSubview:cardButton];
    [cardButton setImage:[UIImage imageNamed:@"wallet_stopCard"] forState:UIControlStateNormal];
    [cardButton setBackgroundColor:[UIColor whiteColor]];
    [cardButton setTitle:@"畅停卡" forState:UIControlStateNormal];
    [cardButton setTitleColor:COLOR_TITLE_BLACK forState:UIControlStateNormal];
    cardButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    cardButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cardButton addTarget:self action:@selector(clickMoneyStopCardButton) forControlEvents:UIControlEventTouchUpInside];
    [cardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomBaseView.mas_top);
        make.left.equalTo(bottomBaseView.mas_left);
        make.bottom.equalTo(bottomBaseView.mas_bottom);
        make.right.equalTo(couponButton.mas_left).offset(-1);
    }];
    cardButton.titleEdgeInsets = UIEdgeInsetsMake(cardButton.imageView.frame.size.height + spc, -cardButton.imageView.bounds.size.width, 0, 0);
    cardButton.imageEdgeInsets = UIEdgeInsetsMake(0, cardButton.titleLabel.frame.size.width/2, cardButton.titleLabel.frame.size.height + spc, -cardButton.titleLabel.frame.size.width/2);
    //明细
    UIButton *detailButton = [[UIButton alloc] init];
    [bottomBaseView addSubview:detailButton];
    [detailButton setImage:[UIImage imageNamed:@"wallet_detail"] forState:UIControlStateNormal];
    [detailButton setBackgroundColor:[UIColor whiteColor]];
    [detailButton setTitle:@"明细" forState:UIControlStateNormal];
    [detailButton setTitleColor:COLOR_TITLE_BLACK forState:UIControlStateNormal];
    detailButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    detailButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [detailButton addTarget:self action:@selector(clickMoneyDetailButton) forControlEvents:UIControlEventTouchUpInside];
    [detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomBaseView.mas_top);
        make.right.equalTo(bottomBaseView.mas_right);
        make.bottom.equalTo(bottomBaseView.mas_bottom);
        make.left.equalTo(couponButton.mas_right).offset(1);
    }];
    detailButton.titleEdgeInsets = UIEdgeInsetsMake(detailButton.imageView.frame.size.height + spc, -detailButton.imageView.bounds.size.width, 0, 0);
    detailButton.imageEdgeInsets = UIEdgeInsetsMake(0, detailButton.titleLabel.frame.size.width/2, detailButton.titleLabel.frame.size.height+spc, -detailButton.titleLabel.frame.size.width/2);
    //充值button
    UIButton *chargeButton = [[UIButton alloc] init];
    [self.view addSubview:chargeButton];
    [chargeButton setTitle:@"充值" forState:UIControlStateNormal];
    [chargeButton setBackgroundColor:COLOR_BUTTON_RED];
    [chargeButton setTitleColor:COLOR_TITLE_WHITE forState:UIControlStateNormal];
    [chargeButton addTarget:self action:@selector(clickChargeButton) forControlEvents:UIControlEventTouchUpInside];
    chargeButton.layer.cornerRadius = 22.5;
    chargeButton.layer.masksToBounds = YES;
    [chargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomBaseView.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.height.equalTo(@45);
    }];
    //提现button
    UIButton *withdrawButton = [[UIButton alloc] init];
    [self.view addSubview:withdrawButton];
    [withdrawButton setTitle:@"提现" forState:UIControlStateNormal];
    [withdrawButton setTitleColor:COLOR_TITLE_WHITE forState:UIControlStateNormal];
    withdrawButton.backgroundColor = ButtonColorGray;
    [withdrawButton addTarget:self action:@selector(clickWithdrawButton) forControlEvents:UIControlEventTouchUpInside];
    withdrawButton.layer.cornerRadius = 22.5;
    withdrawButton.layer.masksToBounds = YES;
    [withdrawButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(chargeButton.mas_bottom).offset(12);
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.height.equalTo(@45);
    }];
    
}

#pragma mark - 点击按钮方法
//明细
- (void)clickMoneyDetailButton
{
    ConsumerDetailsTableViewController *cdvc = [[ConsumerDetailsTableViewController alloc] init];
    [self.navigationController pushViewController:cdvc animated:YES];
}
//畅停卡
- (void)clickMoneyStopCardButton
{
    NKAlertView *alertView = [[NKAlertView alloc] initWithAlertViewType:NKAlertViewTypeInfomation Height:172 andWidth:WIDTH_VIEW - 60];
    [alertView show:YES];
}
//优惠券
- (void)clickMoneyCouponButton
{
    CouponViewController *cvc = [[CouponViewController alloc] init];
    [self.navigationController pushViewController:cvc animated:YES];
}
//充值
- (void)clickChargeButton
{
    NSLog(@"充值");
    PayViewController *pvc = [[PayViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:pvc];
    [self.navigationController presentViewController:navi animated:YES completion:nil];
}
//提现
- (void)clickWithdrawButton
{
    NSLog(@"提现");
}
@end
