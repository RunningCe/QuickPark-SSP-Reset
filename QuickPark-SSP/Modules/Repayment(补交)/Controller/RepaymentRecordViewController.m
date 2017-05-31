//
//  RepaymentRecordViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 2017/5/17.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "RepaymentRecordViewController.h"
#import "Masonry.h"
#import "RepaymentRecordTableViewCell.h"
#import "NKStopDetailRecord.h"
#import "NKCar.h"
#import "NKTimeManager.h"
#import "NKColorManager.h"
#import "NKDataManager.h"
#import "MBProgressHUD.h"
#import "NKAlertView.h"
#import "ChargeDetailSubView.h"
#import "EvaluatComplaintViewController.h"
#import "PayViewController.h"
#import "ResetPasswordViewController.h"

@interface RepaymentRecordViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger totalMoney;

@property (nonatomic, strong) NSMutableArray *repaymentRecordArray;

@property (nonatomic, strong) NKDataManager *dataManager;

@property (nonatomic, strong) MBProgressHUD *HUD;

@property (nonatomic, strong) UILabel *allMoneyLabel;

@property (nonatomic, strong) UIButton *allSelectButton;

@property (nonatomic, strong) NKAlertView *alertView;

@property (nonatomic, assign)NSInteger currentPageIndex;

@property (nonatomic, strong) NKStopDetailRecord *currentStopDetailRecord;

@property (nonatomic, strong) NSMutableArray *stopRecordIdList;

@end

@implementation RepaymentRecordViewController

#pragma mark - setter && getter
- (NSMutableArray *)repaymentRecordArray
{
    if (!_repaymentRecordArray)
    {
        _repaymentRecordArray = [NSMutableArray array];
    }
    return _repaymentRecordArray;
}

-(NKDataManager *)dataManager
{
    if (_dataManager == nil)
    {
        _dataManager = [NKDataManager sharedDataManager];
    }
    return _dataManager;
}

- (NSMutableArray *)stopRecordIdList
{
    if (!_stopRecordIdList)
    {
        _stopRecordIdList = [NSMutableArray array];
    }
    return _stopRecordIdList;
}
#pragma mark - circle of controller
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setNavigationBar];
    [self initSubviews];
    
    _totalMoney = 0;
    
    _HUD = [[MBProgressHUD alloc] init];
    _HUD.center = self.view.center;
    [self.view addSubview:_HUD];
    
    [self postToGetRepaymentRecord];
}

#pragma mark - 初始化界面
//页面加载时设置导航栏
-(void)setNavigationBar
{
    self.navigationItem.title = @"补交";
    UIImage *itemImage = [UIImage imageNamed:@"左箭头"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[itemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = COLOR_MAIN_RED;
    [self.navigationController.navigationBar setTintColor:COLOR_MAIN_RED];
    
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
- (void)initSubviews
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW, HEIGHT_VIEW - 45)];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = COLOR_VIEW_BLACK;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"RepaymentRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"RepaymentRecordTableViewCell"];
    
    //底部视图
    UIView *bottomBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT_VIEW - 45, WIDTH_VIEW, 45)];
    bottomBaseView.backgroundColor = COLOR_VIEW_BLACK;
    [self.view addSubview:bottomBaseView];
    
    UIButton *allSelectButton = [[UIButton alloc] init];
    _allSelectButton = allSelectButton;
    [bottomBaseView addSubview:allSelectButton];
    [allSelectButton setImage:[UIImage imageNamed:@"repayment_circle_normal"] forState:UIControlStateNormal];
    [allSelectButton setImage:[UIImage imageNamed:@"repayment_circle_selected"] forState:UIControlStateSelected];
    [allSelectButton addTarget:self action:@selector(clickAllSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    [allSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomBaseView.mas_left).offset(12);
        make.top.equalTo(bottomBaseView.mas_top).offset(15);
        make.height.equalTo(@16);
        make.width.equalTo(@16);
    }];
    
    UILabel *allSelectLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 16)];
    [bottomBaseView addSubview:allSelectLabel];
    allSelectLabel.text = @"全选";
    allSelectLabel.font = [UIFont systemFontOfSize:16.0];
    allSelectLabel.textColor = COLOR_TITLE_WHITE;
    allSelectLabel.textAlignment = NSTextAlignmentCenter;
    [allSelectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(allSelectButton.mas_right).offset(12);
        make.top.equalTo(allSelectButton.mas_top);
        make.height.mas_equalTo(16);
    }];

    UIButton *sureButton = [[UIButton alloc] init];
    [bottomBaseView addSubview:sureButton];
    [sureButton setTitle:@"确认" forState:UIControlStateNormal];
    [sureButton setTitleColor:COLOR_TITLE_WHITE forState:UIControlStateNormal];
    sureButton.backgroundColor = COLOR_MAIN_RED;
    [sureButton addTarget:self action:@selector(clickSureButton) forControlEvents:UIControlEventTouchUpInside];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomBaseView.mas_right);
        make.top.equalTo(bottomBaseView.mas_top);
        make.bottom.equalTo(bottomBaseView.mas_bottom);
        make.width.equalTo(@98);
    }];
    
    UILabel *allMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 22)];
    [bottomBaseView addSubview:allMoneyLabel];
    _allMoneyLabel = allMoneyLabel;
    allMoneyLabel.text = [NSString stringWithFormat:@"合计：¥%.2lf", (float)(_totalMoney / 100)];
    allMoneyLabel.font = [UIFont systemFontOfSize:16.0];
    allMoneyLabel.textColor = COLOR_TITLE_WHITE;
    allMoneyLabel.textAlignment = NSTextAlignmentCenter;
    [allMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomBaseView.mas_centerY);
        make.centerX.equalTo(bottomBaseView.mas_centerX);
        make.width.equalTo(@150);
        make.height.equalTo(@22);
    }];
    
    NSRange range;
    range = [allMoneyLabel.text rangeOfString:@"¥"];
    if (range.location != NSNotFound)
    {
        NSInteger startIndex = range.location;
        range = NSMakeRange(startIndex, allMoneyLabel.text.length - startIndex);
        UIFont *labelFont = [UIFont systemFontOfSize:22.0];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计：¥%.2lf", (float)(_totalMoney / 100)]];
        [str addAttribute:NSFontAttributeName value:labelFont range: range];
        allMoneyLabel.attributedText = str;
    }
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.repaymentRecordArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepaymentRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepaymentRecordTableViewCell" forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[RepaymentRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RepaymentRecordTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //更改cell数据
    NKStopDetailRecord *detailRecord = self.repaymentRecordArray[indexPath.row];
    //通过车牌号，获取车辆标签颜色
    NSString *colorStr;
    NSArray *carDataArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"carArray"];;
    for (NSData *carData in carDataArray) {
        NKCar *car = [NSKeyedUnarchiver unarchiveObjectWithData:carData];
        if ([car.license isEqualToString:detailRecord.license])
        {
            colorStr = car.colourCard;
        }
    }
    //如果获取到车辆颜色
    if (colorStr)
    {
        cell.tagImageViwe.tintColor = [NKColorManager colorWithStr:colorStr alpha:1.0];
    }
    cell.licenseLabel.text = detailRecord.license;
    if (detailRecord.berth.length == 17)
    {
        cell.berthIdLabel.text = [detailRecord.berth substringWithRange:NSMakeRange(detailRecord.berth.length - 2, 2)];
    }
    NSArray *strArray = [detailRecord.fullAddress componentsSeparatedByString:@"-"];
    cell.berthNameLabel.text = [strArray firstObject];
    cell.berthNameDetailLabel.text = [strArray lastObject];
    UIImage *berthLogoImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:detailRecord.parkingLogoUrl]]];
    if (berthLogoImage)
    {
        cell.berthIconImageView.image = berthLogoImage;
    }
    //来车时间
    if (detailRecord.arrive || detailRecord.carRegTime)
    {
        NSString *arriveTimeStr = detailRecord.arrive ? detailRecord.arrive : detailRecord.carRegTime;
        NSDate *arriveDate = [NKTimeManager stringToDate:arriveTimeStr withDateFormat:@"yyyy-MM-dd HH:mm:SS"];
        NSString *timeStr = [NKTimeManager dateToString:arriveDate withDateFormat:@"yyyy年MM月dd日 HH时mm分ss秒"];
        cell.comingTimeLabel.text = [timeStr substringWithRange:NSMakeRange(12, 6)];
        cell.comingDateLabel.text = [timeStr substringWithRange:NSMakeRange(5, 6)];
        cell.comingWeekLabel.text = [NKTimeManager weekdayStringFromDate:arriveDate];
    }
    //走车时间
    if (detailRecord.leave || detailRecord.carBalanceTime)
    {
        NSString *leavingTimeStr = detailRecord.leave ? detailRecord.leave : detailRecord.carBalanceTime;
        NSDate *leavingDate = [NKTimeManager stringToDate:leavingTimeStr withDateFormat:@"yyyy-MM-dd HH:mm:SS"];
        NSString *timeStr = [NKTimeManager dateToString:leavingDate withDateFormat:@"yyyy年MM月dd日 HH时mm分ss秒"];
        cell.leavingTimeLabel.text = [timeStr substringWithRange:NSMakeRange(12, 6)];
        cell.leavingDateLabel.text = [timeStr substringWithRange:NSMakeRange(5, 6)];
        cell.leavingWeekLabel.text = [NKTimeManager weekdayStringFromDate:leavingDate];
    }
    
    cell.totalMoneyLabel.text = [NSString stringWithFormat:@"%.1lf", (float)(detailRecord.escapeFee.intValue / 100)];
    [cell.ruleButton addTarget:self action:@selector(clickCellRuleButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.ruleButton.tag = 1000 + indexPath.row;
    [cell.chargeDetailButton addTarget:self action:@selector(clickCellChargeButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.chargeDetailButton.tag = 2000 + indexPath.row;
    [cell.selecteButton addTarget:self action:@selector(clickCellSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.selecteButton.tag = 3000 + indexPath.row;
    cell.selecteButton.selected = detailRecord.isSelected;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144;
}

#pragma mark - 点击界面上的button响应方法
- (void)clickAllSelectButton:(UIButton *)sender
{
    if (self.repaymentRecordArray.count == 0)
    {
        [self showHUDWith:@"无可补缴的记录"];
        return;
    }
    //全选
    _totalMoney = 0;
    sender.selected = !sender.selected;
    for (NKStopDetailRecord *detailRecord in self.repaymentRecordArray)
    {
        if (sender.selected)
        {
            detailRecord.isSelected = YES;
        }
        else
        {
            detailRecord.isSelected = NO;
        }
    }
    [self.tableView reloadData];
    for (NKStopDetailRecord *detailRecord in self.repaymentRecordArray)
    {
        if (sender.selected)
        {
            _totalMoney += detailRecord.fee + detailRecord.bookingfee + detailRecord.tip - detailRecord.couponMoney;
            [self.stopRecordIdList addObject:detailRecord.stopRecordId];
        }
        else
        {
            _totalMoney = 0;
            [self.stopRecordIdList removeAllObjects];
        }
    }
    _allMoneyLabel.text = [NSString stringWithFormat:@"合计：¥%.2lf", (float)(_totalMoney / 100)];
    NSRange range;
    range = [_allMoneyLabel.text rangeOfString:@"¥"];
    if (range.location != NSNotFound)
    {
        NSInteger startIndex = range.location;
        range = NSMakeRange(startIndex, _allMoneyLabel.text.length - startIndex);
        UIFont *labelFont = [UIFont systemFontOfSize:22.0];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计：¥%.2lf", (float)(_totalMoney / 100)]];
        [str addAttribute:NSFontAttributeName value:labelFont range: range];
        _allMoneyLabel.attributedText = str;
    }
}

- (void)clickSureButton
{
    NSLog(@"确认支付");
    if (self.repaymentRecordArray.count == 0)
    {
        [self showHUDWith:@"无可补缴的记录"];
        return;
    }
    if (self.stopRecordIdList.count == 0)
    {
        [self showHUDWith:@"请选择补交记录"];
        return;
    }
    [self postToGetBalance];
}

#pragma mark - 点击弹窗上的按钮响应方法
- (void)clickRechargeButton
{
    NSLog(@"充值！！");
    PayViewController *pVC = [[PayViewController alloc] init];
    [self.navigationController pushViewController:pVC animated:YES];
}
//确定密码
- (void)clickAlertPwdSureButton
{
    NSMutableString *password = [NSMutableString string];
    for (UITextField *textField in self.alertView.passwordTextFieldArray)
    {
        [password appendString:textField.text];
    }
    [self postToCheckPassword:password];
    [self.alertView hide:YES];
}
- (void)clickAlertForgetPwdButton
{
    NSLog(@"忘记密码！");
    [self.alertView hide:YES];
    ResetPasswordViewController *rpvc = [[ResetPasswordViewController alloc] initWithNibName:@"ResetPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:rpvc animated:YES];
}
#pragma mark - 点击单元格上的button
- (void)clickCellSelectButton:(UIButton *)sender
{
    //单选一个
    sender.selected = !sender.selected;
    NKStopDetailRecord *detailRecord = self.repaymentRecordArray[sender.tag - 3000];
    if (sender.selected)
    {
        _totalMoney += detailRecord.fee + detailRecord.bookingfee + detailRecord.tip - detailRecord.couponMoney;
        [self.stopRecordIdList addObject:detailRecord.stopRecordId];
    }
    else
    {
        _totalMoney -= detailRecord.fee + detailRecord.bookingfee + detailRecord.tip - detailRecord.couponMoney;
        [self.stopRecordIdList removeObject:detailRecord.stopRecordId];
        _allSelectButton.selected = NO;
    }
    _allMoneyLabel.text = [NSString stringWithFormat:@"合计：¥%.2lf", (float)(_totalMoney / 100)];
    NSRange range;
    range = [_allMoneyLabel.text rangeOfString:@"¥"];
    if (range.location != NSNotFound)
    {
        NSInteger startIndex = range.location;
        range = NSMakeRange(startIndex, _allMoneyLabel.text.length - startIndex);
        UIFont *labelFont = [UIFont systemFontOfSize:22.0];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计：¥%.2lf", (float)(_totalMoney / 100)]];
        [str addAttribute:NSFontAttributeName value:labelFont range: range];
        _allMoneyLabel.attributedText = str;
    }
}

- (void)clickCellRuleButton:(UIButton *)sender
{
    //推出计价规则弹窗
    NKStopDetailRecord *record = self.repaymentRecordArray[sender.tag - 1000];
    [self PostTogetChargingRuleWithRecord:record];
    _currentPageIndex = 1;
}
- (void)clickCellChargeButton:(UIButton *)sender
{
    //收费详情
    NKStopDetailRecord *record = self.repaymentRecordArray[sender.tag - 2000];
    [self PostTogetChargingRuleWithRecord:record];
    _currentPageIndex = 0;
}
#pragma mark - 网络请求
//请求未缴费记录
- (void)postToGetRepaymentRecord
{
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.label.text = @"loading";
    [_HUD showAnimated:YES];
    
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    [parametersDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"myToken"] forKey:@"token"];
    [parametersDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"sspId"] forKey:@"sspid"];
    
    [self.dataManager POSTToGetRepaymentRecordWithParameters:parametersDic Success:^(NSMutableArray *mutableArray) {
        if (mutableArray.count == 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_HUD hideAnimated:YES];
                [self.repaymentRecordArray removeAllObjects];
                [self.tableView reloadData];
            });
        }
        else
        {
            [self.repaymentRecordArray removeAllObjects];
            [self.repaymentRecordArray addObjectsFromArray:mutableArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_HUD hideAnimated:YES];
                [self.tableView reloadData];
            });
        }
    } Failure:^(NSError *error) {
        [self showHUDWith:@"网络异常"];
    }];
}
//查询余额是否充足
- (void)postToGetBalance
{
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.label.text = @"loading";
    [_HUD showAnimated:YES];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"sspId"] forKey:@"sspid"];
    
    [self.dataManager POSTToCheckBalanceWithParameters:parameters Success:^(NKBase *base) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_HUD hideAnimated:YES];
        });
        if (base.ret == 0)
        {
            if (base.obj.integerValue < _totalMoney)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.alertView = [[NKAlertView alloc] initWithAlertViewType:NKAlertViewTypeBalanceNotEnough Height:195 andWidth:WIDTH_VIEW - 72];
                    [self.alertView.rechargeButton addTarget:self action:@selector(clickRechargeButton) forControlEvents:UIControlEventTouchUpInside];
                    [self.alertView show:YES];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.alertView = [[NKAlertView alloc] initWithAlertViewType:NKAlertViewTypePassword];
                    [self.alertView.passwordSureButton addTarget:self action:@selector(clickAlertPwdSureButton) forControlEvents:UIControlEventTouchUpInside];
                    [self.alertView.forgetPasswordButton addTarget:self action:@selector(clickAlertForgetPwdButton) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:self.alertView.bGView];
                    [self.view addSubview:self.alertView];
                });
            }
        }
        else
        {
            [self showHUDWith:base.msg];
        }
    } Failure:^(NSError *error) {
        [self showHUDWith:@"网络异常"];
    }];
}
//校验密码
- (void)postToCheckPassword:(NSString *)pwd
{
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.label.text = @"loading";
    [_HUD showAnimated:YES];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"myToken"] forKey:@"token"];
    [parameters setObject:pwd forKey:@"pwd"];
    
    [self.dataManager POSTToCheckPassWordWithParameters:parameters Success:^(NKBase *base) {
        if (base.ret == 0)
        {
            [self postToRepayment];
        }
        else
        {
            [self showHUDWith:@"密码错误"];
        }
    } Failure:^(NSError *error) {
        [self showHUDWith:@"网络异常"];
    }];
}
//请求补交
- (void)postToRepayment
{
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.label.text = @"loading";
    [_HUD showAnimated:YES];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"sspId"] forKey:@"sspid"];
    [parameters setObject:[NSString stringWithFormat:@"%li", (long)_totalMoney] forKey:@"payTotalMoney"];
    [parameters setObject:[_stopRecordIdList componentsJoinedByString:@","] forKey:@"stopRecordIdList"];
    
    NSLog(@"%@", parameters);
    
    [self.dataManager POSTToRepayWithParameters:parameters Success:^(NKBase *base) {
        if (base.ret == 0)
        {
            [self postToGetRepaymentRecord];
        }
        else
        {
            [self showHUDWith:base.msg];
        }
    } Failure:^(NSError *error) {
        [self showHUDWith:@"网络异常"];
    }];
}
//请求收费规则
- (void)PostTogetChargingRuleWithRecord:(NKStopDetailRecord *)record
{
    MBProgressHUD *waithud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    waithud.mode = MBProgressHUDModeIndeterminate;
    waithud.label.text = @"Loding";
    waithud.bezelView.color = COLOR_HUD_BLACK;
    NSString *berth;
    if (record.berth.length > 13)
    {
        berth = [record.berth substringWithRange:NSMakeRange(0, 13)];
    }
    else
    {
        berth = @"0";
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:berth forKey:@"parkingNo"];
    //[parameters setObject:@"5227010610011" forKey:@"parkingNo"];
    
    [self.dataManager POSTToGetParkingPriceRuleWithParameters:parameters Success:^(NSString *pictureURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [waithud hideAnimated:YES];
            [waithud removeFromSuperViewOnHide];
        });
        if (pictureURL.length > 0)
        {
            //推出计价规则弹窗
            dispatch_async(dispatch_get_main_queue(), ^{
                [self didGetImageURL:pictureURL andUpdateRecord:record];
            });
        }
        else
        {
            [self showHUDWith:@"无计价规则"];
        }
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [waithud hideAnimated:YES];
            [waithud removeFromSuperViewOnHide];
        });
        [self showHUDWith:@"网络异常"];
    }];
}
- (void)showHUDWith:(NSString *)str
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_HUD hideAnimated:YES afterDelay:0.5];
        _HUD.mode = MBProgressHUDModeText;
        _HUD.label.text = str;
        [_HUD showAnimated:YES];
        [_HUD hideAnimated:YES afterDelay:1.5];
    });
}
#pragma mark - 弹窗相关方法
//弹出弹窗
- (void)didGetImageURL:(NSString *)url andUpdateRecord:(NKStopDetailRecord *)record
{
    //收费详情
    _currentStopDetailRecord = record;
    NKStopDetailRecord *detailRecord = record;
    _alertView = [[NKAlertView alloc] initWithAlertViewType:NKPopViewTypeParkingRuleAndChargeDetail Height:380 andWidth:WIDTH_VIEW * 0.8];
    _alertView.pageControl.currentPage = self.currentPageIndex;
    //设置界面滑动的位置
    _alertView.chargeAndRuleScrollView.contentOffset = CGPointMake(_alertView.chargeAndRuleScrollView.frame.size.width * self.currentPageIndex, 0);
    
    _alertView.chargeDetailSubView.moneyLabel_0.text = [NSString stringWithFormat:@"%.1f", (float)(detailRecord.fee + detailRecord.bookingfee + detailRecord.tip) / 100];
    _alertView.chargeDetailSubView.moneyLabel_1.text = [NSString stringWithFormat:@"%.1f", (float)detailRecord.fee / 100];
    _alertView.chargeDetailSubView.moneyLabel_2.text = [NSString stringWithFormat:@"%.1f", (float)detailRecord.bookingfee / 100];
    _alertView.chargeDetailSubView.moneyLabel_3.text = [NSString stringWithFormat:@"%.1f", (float)detailRecord.tip / 100];
    _alertView.chargeDetailSubView.moneyLabel_9.text = [NSString stringWithFormat:@"%.1f", (float)detailRecord.escapeFee.intValue / 100];
    
    _alertView.chargeDetailSubView.licenseLabel.text = detailRecord.license;
    [_alertView.chargeDetailSubView.complainButton addTarget:self action:@selector(clickPopComplaintButton) forControlEvents:UIControlEventTouchUpInside];
    if ([record.complaintstatus isEqualToString:@"1"])
    {
        //不允许投诉
        [_alertView.chargeDetailSubView.complainButton setTitle:@"已投诉" forState:UIControlStateNormal];
        [_alertView.chargeDetailSubView.complainButton setTitleColor:COLOR_TITLE_GRAY forState:UIControlStateNormal];
    }
    if ([record.complaintstatus isEqualToString:@"2"])
    {
        //不允许投诉
        [_alertView.chargeDetailSubView.complainButton setTitle:@"已过投诉时效" forState:UIControlStateNormal];
        [_alertView.chargeDetailSubView.complainButton setTitleColor:COLOR_TITLE_GRAY forState:UIControlStateNormal];
    }
    else
    {
        //可投诉
        [_alertView.chargeDetailSubView.complainButton setTitle:@"投诉" forState:UIControlStateNormal];
    }
    //来车时间
    if (detailRecord.arrive || detailRecord.carRegTime)
    {
        NSString *arriveTimeStr = detailRecord.arrive ? detailRecord.arrive : detailRecord.carRegTime;
        _alertView.chargeDetailSubView.comingTimeLabel.text = [arriveTimeStr substringWithRange:NSMakeRange(11, 8)];
        _alertView.chargeDetailSubView.comingDateLabel.text = [arriveTimeStr substringWithRange:NSMakeRange(0, 10)];
    }
    //走车时间
    if (detailRecord.leave || detailRecord.carBalanceTime)
    {
        NSString *leavingTimeStr = detailRecord.leave ? detailRecord.leave : detailRecord.carBalanceTime;
        _alertView.chargeDetailSubView.leavingTimeLabel.text = [leavingTimeStr substringWithRange:NSMakeRange(11, 8)];
        _alertView.chargeDetailSubView.leavingDateLabel.text = [leavingTimeStr substringWithRange:NSMakeRange(0, 10)];
    }
    if ((detailRecord.arrive || detailRecord.carRegTime) && (detailRecord.leave || detailRecord.carBalanceTime))
    {
        NSString *arriveTimeStr = detailRecord.arrive ? detailRecord.arrive : detailRecord.carRegTime;
        NSString *leavingTimeStr = detailRecord.leave ? detailRecord.leave : detailRecord.carBalanceTime;
        NSString *differentTime = [NKTimeManager dateTimeDifferenceWithStartTime:arriveTimeStr endTime:leavingTimeStr];
        _alertView.chargeDetailSubView.totalTimeAndMoneyLabel.text = differentTime;
    }
    
    //收费规则
    _alertView.parkingPriceRuleImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    
    [_alertView show:YES];
}
//点击投诉
- (void)clickPopComplaintButton
{
    if ([_currentStopDetailRecord.complaintstatus isEqualToString:@"1"])
    {
        //不允许投诉
        return;
    }
    if ([_currentStopDetailRecord.complaintstatus isEqualToString:@"2"])
    {
        //不允许投诉
        return;
    }
    else
    {
        //可投诉
        EvaluatComplaintViewController *ecVC = [[EvaluatComplaintViewController alloc] init];
        ecVC.stopDetailRecord = self.currentStopDetailRecord;
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:ecVC];
        [_alertView hide:YES];
        [self.tabBarController presentViewController:navi animated:YES completion:nil];
    }
}
@end
