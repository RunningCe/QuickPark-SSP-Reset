//
//  StopFineViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 2016/12/22.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "StopFineViewController.h"
#import "LatestParkingTableViewCell.h"
#import "IsParkingTableViewCell.h"
#import "Masonry.h"
#import "NKDataManager.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "NKIsParkingRecordInfo.h"
#import "NKTimeManager.h"
#import "NKAlertView.h"
#import "ParkingRecordTableViewController.h"
#import "ComplaintTableViewController.h"
#import "MJRefresh.h"
#import "EvaluateViewController.h"
#import "NKColorManager.h"
#import "ChargeDetailSubView.h"
#import "EvaluatComplaintViewController.h"
#import "NKEvaluateView.h"
#import "UIScrollView+JElasticPullToRefresh.h"
#import "NKLatestParkingView.h"
#import "Udesk.h"
#import "RepaymentRecordViewController.h"
#import "NKRedPointButton.h"

@interface StopFineViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *isParkingRecordsMutableArray;
@property (nonatomic, strong) NSMutableArray *latestParkingRecordsMutableArray;
@property (nonatomic, strong) NKDataManager *dataManager;
@property (nonatomic, strong) NKAlertView *alertView;
@property (nonatomic, strong) NSMutableArray *starMutableArray;
@property (nonatomic, strong) NKStopDetailRecord *currentStopDetailRecord;
@property (nonatomic, assign) NSInteger currentPageIndex;

@property (nonatomic, strong) NKRedPointButton *topRepaymentButton;

@end

@implementation StopFineViewController

-(NSMutableArray *)starMutableArray
{
    if (_starMutableArray == nil)
    {
        _starMutableArray = [NSMutableArray array];
    }
    return _starMutableArray;
}
-(NSMutableArray *)isParkingRecordsMutableArray
{
    if (!_isParkingRecordsMutableArray)
    {
        _isParkingRecordsMutableArray = [NSMutableArray array];
    }
    return _isParkingRecordsMutableArray;
}
-(NSMutableArray *)latestParkingRecordsMutableArray
{
    if (!_latestParkingRecordsMutableArray)
    {
        _latestParkingRecordsMutableArray = [NSMutableArray array];
    }
    return _latestParkingRecordsMutableArray;
}
- (NKDataManager *)dataManager
{
    if (_dataManager == nil)
    {
        _dataManager = [NKDataManager sharedDataManager];
    }
    return _dataManager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *topView = [self createTopView];
    [self.view addSubview:topView];
    self.tableView = [self createTableView];
    [self.view addSubview:self.tableView];
    
    [self refreshData];
}
- (void)viewWillAppear:(BOOL)animated
{
    //[self postToGetIsParkingRecord];
    [self sendPostToGetLatestParkingRecord];
    [self postToGetRepaymentNum];
}
- (void)dealloc
{
    [self.tableView removeJElasticPullToRefreshView];
}
#pragma mrak -创建界面
- (UITableView *)createTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 92, WIDTH_VIEW, HEIGHT_VIEW - 140)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    tableView.backgroundColor = COLOR_VIEW_BLACK;
    tableView.showsVerticalScrollIndicator = NO;
    UIImageView *backImageView=[[UIImageView alloc]initWithFrame:tableView.bounds];
    [backImageView setImage:[UIImage imageNamed:@"cityImage.jpg"]];
    tableView.backgroundView=backImageView;
    
    [tableView registerNib:[UINib nibWithNibName:@"LatestParkingTableViewCell" bundle:nil] forCellReuseIdentifier:@"LatestParkingTableViewCell"];
    [tableView registerNib:[UINib nibWithNibName:@"IsParkingTableViewCell" bundle:nil] forCellReuseIdentifier:@"IsParkingTableViewCell"];
    return tableView;
}
- (UIView *)createTopView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW, 92)];
    headerView.backgroundColor = COLOR_MAIN_RED;
    
    for (int i = 0; i <  4; i++)
    {
        NKRedPointButton *button = [[NKRedPointButton alloc] init];
        if (i == 2)
        {
            _topRepaymentButton = button;
        }
        [headerView addSubview:button];
        UILabel *label = [[UILabel alloc] init];
        [headerView addSubview:label];
        UIImage *image;
        switch (i)
        {
            case 0:
                image = [UIImage imageNamed:@"stopfine_扫码"];
                label.text = @"扫码";
                break;
            case 1:
                image = [UIImage imageNamed:@"stopfine_记录"];
                label.text = @"记录";
                break;
            case 2:
                image = [UIImage imageNamed:@"stopfine_补交"];
                label.text = @"补交";
                break;
            case 3:
                image = [UIImage imageNamed:@"stopfine_客服"];
                label.text = @"客服";
                break;
            default:
                break;
        }
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickTopButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100 + i;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerView.mas_top).offset(36);
            make.centerX.equalTo(headerView.mas_centerX).multipliedBy(0.25 * (2*i+1));
            make.height.equalTo(@24);
            make.width.equalTo(@24);
        }];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12.0];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button.mas_bottom).offset(12);
            make.centerX.equalTo(button.mas_centerX);
            make.height.equalTo(@12);
        }];
    }
    
    return headerView;
}
#pragma mark - Table view data source && delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0)
    {
        return self.isParkingRecordsMutableArray.count;
    }
    else
    {
        return self.latestParkingRecordsMutableArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120 + 24;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0)
    {
        IsParkingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IsParkingTableViewCell" forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[IsParkingTableViewCell alloc] init];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        //判断数组是否为空
        NKIsParkingRecordInfo *isParkingRecord;
        if (self.isParkingRecordsMutableArray.count > 0)
        {
            isParkingRecord = self.isParkingRecordsMutableArray[indexPath.row];
        }
        UIImage *berthLogoImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:isParkingRecord.parkingLogoUrl]]];
        if (berthLogoImage)
        {
            cell.berthIconImageView.image = berthLogoImage;
        }
        NSArray *strArray = [isParkingRecord.fullAddress componentsSeparatedByString:@"-"];
        cell.berthNameLabel.text = [strArray firstObject];
        cell.berthNameDetailLabel.text = [strArray lastObject];
        cell.berthIdLabel.text = [isParkingRecord.berthNo substringWithRange:NSMakeRange(isParkingRecord.berthNo.length - 2, 2)];
        cell.mepNameLabel.text = isParkingRecord.mepName;
        [cell.ruleButton addTarget:self action:@selector(clickCellRuleButton:) forControlEvents:UIControlEventTouchUpInside];
        cell.ruleButton.tag = 100 + indexPath.row;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:isParkingRecord.startTime];
        NSString *timeStr = [NKTimeManager dateToString:date withDateFormat:@"yyyy年MM月dd日 HH时mm分ss秒"];
        cell.comingTimeLabel.text = [timeStr substringWithRange:NSMakeRange(12, 6)];
        cell.comingDateLabel.text = [timeStr substringWithRange:NSMakeRange(5, 6)];
        cell.comingWeekLabel.text = [NKTimeManager weekdayStringFromDate:date];
        cell.licenseLabel.text = isParkingRecord.license;
        if (isParkingRecord.colourCard)
        {
            cell.tagImageViwe.tintColor = [NKColorManager colorWithStr:isParkingRecord.colourCard alpha:1.0];
        }
        //计算已经停车时间
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
        int diffrentTime = currentTime - isParkingRecord.startTime;
        cell.timeLabel_3.text = [NSString stringWithFormat:@"%d", diffrentTime / 60 % 60 % 10];
        cell.timeLabel_2.text = [NSString stringWithFormat:@"%d", diffrentTime / 60 % 60 / 10];
        cell.timeLabel_1.text = [NSString stringWithFormat:@"%d", diffrentTime / 3600 % 10];
        cell.timeLabel_0.text = [NSString stringWithFormat:@"%d", diffrentTime / 3600 / 10 % 10];
        return cell;
    }
    else
    {
        LatestParkingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LatestParkingTableViewCell" forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[LatestParkingTableViewCell alloc] init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //更改cell数据
        //判断数组是否为空
        NKStopDetailRecord *detailRecord;
        if (self.latestParkingRecordsMutableArray.count > 0)
        {
            detailRecord = self.latestParkingRecordsMutableArray[0];
        }
        //判断是否超过48小时
        NSString *leavingTimeStr = detailRecord.leave ? detailRecord.leave : detailRecord.carBalanceTime;
        NSDate *leavingDate = [NKTimeManager stringToDate:leavingTimeStr withDateFormat:@"yyyy-MM-dd HH:mm:SS"];
        NSDate *currentDate = [NSDate date];
        long interval = [currentDate timeIntervalSinceReferenceDate] - [leavingDate timeIntervalSinceReferenceDate];
        //设置cell投标题
        if (interval > 172800)
        {
            cell.topTitleLabel.text = @"最近泊车";
        }
        else
        {
            cell.topTitleLabel.text = @"刚刚驶离";
        }
        //将cell上的imageView添加到数组中
        [self.starMutableArray removeAllObjects];
        [self.starMutableArray addObject:cell.starImageView_0];
        [self.starMutableArray addObject:cell.starImageView_1];
        [self.starMutableArray addObject:cell.starImageView_2];
        [self.starMutableArray addObject:cell.starImageView_3];
        [self.starMutableArray addObject:cell.starImageView_4];
        if ([detailRecord.commentStatus isEqualToString:@"1"])
        {
            //已评价
            cell.commentButton.hidden = YES;
            cell.starBaseView.hidden = NO;
            NSInteger starCount = (detailRecord.toCarEvaluateStar.integerValue + detailRecord.parkingEvaluateStar.integerValue) / 2;
            if (starCount > 5)
            {
                starCount = 5;
            }
            for (int i = 0; i < starCount; i++)
            {
                UIImageView *starImage = self.starMutableArray[i];
                starImage.image = [UIImage imageNamed:@"star_selected"];
            }
        }
        else
        {
            //未评价
            cell.starBaseView.hidden = YES;
            cell.commentButton.hidden = NO;
            [cell.commentButton addTarget:self action:@selector(clickCellCommentButton:) forControlEvents:UIControlEventTouchUpInside];
        }
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
        UIImage *berthLogoImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:detailRecord.parkingLogoUrl]]];
        if (berthLogoImage)
        {
            cell.berthIconImageView.image = berthLogoImage;
        }
        NSArray *strArray = [detailRecord.fullAddress componentsSeparatedByString:@"-"];
        cell.berthNameLabel.text = [strArray firstObject];
        cell.berthNameDetailLabel.text = [strArray lastObject];
        //来车时间
        if (detailRecord.arrive || detailRecord.carRegTime)
        {
            NSString *arriveTimeStr = detailRecord.arrive ? detailRecord.arrive : detailRecord.carRegTime;
            arriveTimeStr = detailRecord.arrive;
            NSDate *arriveDate = [NKTimeManager stringToDate:arriveTimeStr withDateFormat:@"yyyy-MM-dd HH:mm:SS"];
            NSString *timeStr = [NKTimeManager dateToString:arriveDate withDateFormat:@"yyyy年MM月dd日 HH时mm分SS秒"];
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
        
        cell.totalMoneyLabel.text = [NSString stringWithFormat:@"%.1lf", (float)(detailRecord.fee + detailRecord.bookingfee + detailRecord.tip - detailRecord.couponMoney) / 100];
        [cell.ruleButton addTarget:self action:@selector(clickCellRuleButton:) forControlEvents:UIControlEventTouchUpInside];
        cell.ruleButton.tag = 1000 + indexPath.row;
        [cell.chargeDetailButton addTarget:self action:@selector(clickCellChargeButton:) forControlEvents:UIControlEventTouchUpInside];
        cell.chargeDetailButton.tag = 2000 + indexPath.row;
        [cell.starTopButton addTarget:self action:@selector(clickCellTopStarButton:) forControlEvents:UIControlEventTouchUpInside];
        cell.starTopButton.tag = 3000 + indexPath.row;
        return cell;
    }
}
#pragma mark - 点击button的方法
- (void)clickTopButton:(UIButton *)sender
{
    if (sender.tag == 100)
    {
        NSLog(@"扫码");
    }
    if (sender.tag == 101)
    {
        //记录
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"myToken"];
        ParkingRecordTableViewController *prtVC = [[ParkingRecordTableViewController alloc] initWithToken:token];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:prtVC];
        [self.tabBarController presentViewController:navi animated:YES completion:nil];
    }
    if (sender.tag == 102)
    {
        RepaymentRecordViewController *rrTVC = [[RepaymentRecordViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:rrTVC];
        [self.tabBarController presentViewController:navi animated:YES completion:nil];
    }
    if (sender.tag == 103)
    {
        //客服
        [self popUdesk];
    }
    
}
- (void)clickCellRuleButton:(UIButton *)sender
{
    //获取计费规则
    if (sender.tag < 1000)
    {
        //正在泊车
        NKIsParkingRecordInfo *record = self.isParkingRecordsMutableArray[sender.tag - 100];
        NSString *berth;
        if (record.berthNo.length > 13)
        {
            berth = [record.berthNo substringWithRange:NSMakeRange(0, 13)];
        }
        else
        {
            berth = @"0";
        }
        [self PostTogetChargingRuleWithParkingNo:berth];
    }
    else
    {
        //刚刚离开（最近泊车）
        NKStopDetailRecord *record = self.latestParkingRecordsMutableArray[sender.tag - 1000];
        [self PostTogetChargingRuleWithRecord:record];
        _currentPageIndex = 1;
    }
}
- (void)clickCellChargeButton:(UIButton *)sender
{
    NKStopDetailRecord *record = self.latestParkingRecordsMutableArray[sender.tag - 2000];
    [self PostTogetChargingRuleWithRecord:record];
    _currentPageIndex = 0;
}
//点击星星按钮
- (void)clickCellTopStarButton:(UIButton *)sender
{
    NKStopDetailRecord *detailRecord = self.latestParkingRecordsMutableArray[sender.tag - 3000];
    [self postToGetEvaluateRecordWith:detailRecord.stopRecordId];
}
//点击评价按钮
- (void)clickCellCommentButton:(UIButton *)sender
{
    if (self.latestParkingRecordsMutableArray.count == 0)
    {
        return;
    }
    EvaluateViewController *emmVC = [[EvaluateViewController alloc] init];
    emmVC.stopDetailRecord = self.latestParkingRecordsMutableArray[0];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:emmVC];
    [self.tabBarController presentViewController:navi animated:YES completion:nil];
    
}
//点击弹窗投诉按钮
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
//点击弹窗button
- (void)clickAlertViewButtonToPushEvaluateView
{
    [_alertView hide:YES];
    EvaluateViewController *emmcv = [[EvaluateViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:emmcv];
    emmcv.stopDetailRecord = self.latestParkingRecordsMutableArray.lastObject;
    [self presentViewController:navi animated:YES completion:nil];
}
#pragma mark - 网络请求相关方法
//正在停车的停车记录
- (void)postToGetIsParkingRecord
{
    //清空缓存
    [self.isParkingRecordsMutableArray removeAllObjects];
    
    NSString *sspId = [[NSUserDefaults standardUserDefaults] objectForKey:@"sspId"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:sspId forKey:@"sspid"];
    
    [self.dataManager POSTToGetIsParkingRecordWithParameters:parameters Success:^(NSArray *records) {
        if (records.count > 0)
        {
            [self.isParkingRecordsMutableArray removeAllObjects];
            self.isParkingRecordsMutableArray = [NSMutableArray arrayWithArray:records];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.tableView stopLoading];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView stopLoading];
            });
        }
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView stopLoading];
        });
    }];
}
- (void)sendPostToGetLatestParkingRecord
{
    //清空缓存
    [self.latestParkingRecordsMutableArray removeAllObjects];
    
    //创建一个可变字典
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    //往字典里面添加需要提交的参数
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"myToken"];
    [parametersDic setValue:token forKey:@"token"];
    [parametersDic setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"sspId"] forKey:@"sspid"];
    [parametersDic setValue:@1 forKey:@"pageSize"];
    [parametersDic setValue:@1 forKey:@"pageNo"];
    
    [self.dataManager POSTGetStopRecordWithParameters:parametersDic Success:^(NSMutableArray *mutableArray) {
        //停车记录获取成功
        [self postToGetIsParkingRecord];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView stopLoading];
        });
        if (mutableArray.count > 0)
        {
            [self.latestParkingRecordsMutableArray removeAllObjects];
            self.latestParkingRecordsMutableArray = [NSMutableArray arrayWithArray:mutableArray];
            //判断是否已经评价,没有评价推出点评领券窗口
//            NKStopDetailRecord *record = self.latestParkingRecordsMutableArray.firstObject;
//            if ([record.commentStatus isEqualToString:@"0"])
//            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self popLatestAlertViewIfNotEvaluate];
//                });
//            }
        }
        else
        {
            return;
        }
    } Failure:^(NSError *error) {
        //请求停车记录失败
        NSLog(@"error:%@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView.mj_header endRefreshing];
            [self.tableView stopLoading];
        });
    }];
    
}
//政府收费规则
- (void)PostTogetChargingRuleWithParkingNo:(NSString *)parkingNo
{
    MBProgressHUD *waithud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    waithud.mode = MBProgressHUDModeIndeterminate;
    waithud.label.text = @"Loding";
    waithud.bezelView.color = COLOR_HUD_BLACK;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:parkingNo forKey:@"parkingNo"];
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
                _alertView = [[NKAlertView alloc] initWithAlertViewType:NKAlertViewTypeParkingRule Height:380 andWidth:WIDTH_VIEW * 0.8];
                _alertView.parkingPriceRuleImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:pictureURL]]];
                [_alertView show:YES];
            });
        }
        else
        {
            [self showHUDWithString:@"无计价规则"];
        }
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [waithud hideAnimated:YES];
            [waithud removeFromSuperViewOnHide];
        });
        [self showHUDWithString:@"网络异常"];
    }];
}
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
            [self showHUDWithString:@"无计价规则"];
        }
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [waithud hideAnimated:YES];
            [waithud removeFromSuperViewOnHide];
        });
        [self showHUDWithString:@"网络异常"];
    }];
}
//获取评价详情
- (void)postToGetEvaluateRecordWith:(NSString *)stopRecordId
{
    MBProgressHUD *waitHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    waitHUD.mode = MBProgressHUDModeIndeterminate;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary]; 
    [parameters setValue:stopRecordId forKey:@"stopRecordId"];
    
    [self.dataManager POSTToGetEvaluateRecordWithParameters:parameters Success:^(NKEvaluateRecord *record) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [waitHUD hideAnimated:YES];
            [waitHUD removeFromSuperViewOnHide];
            
            NKAlertView *alertView = [[NKAlertView alloc] initWithAlertViewType:NKAlertViewTypeEvaluatDetailRecord Height:380 andWidth:WIDTH_VIEW * 0.85];
            //Mep评价
            alertView.firstEvaluatView.nameLabel.text = record.mepName;
            alertView.firstEvaluatView.backgroundColor = [UIColor redColor];
            [alertView.secondEvaluatView.totalPointButton setTitle:[NSString stringWithFormat:@"%.1f", record.mepScore.floatValue] forState:UIControlStateNormal];
            alertView.firstEvaluatView.parkingTypeLabel.hidden = YES;
            for (int i = 0; i < record.tocarevaluatestar.integerValue; i++)
            {
                UIImageView *imageView = alertView.firstEvaluatView.starImageArray[i];
                imageView.image = [UIImage imageNamed:@"星星selected"];
            }
            NSArray *tagArray = [record.tocarevaluatetag componentsSeparatedByString:@"-"];
            for (int i = 0; i <tagArray.count; i++)
            {
                UILabel *label = alertView.firstEvaluatView.tagLabelArray[i];
                label.text = [NSString stringWithFormat:@"  %@  ", tagArray[i]];
            }
            //车场评价
            alertView.secondEvaluatView.nameLabel.text = record.parkingName;
            alertView.secondEvaluatView.iconImageView.image = [UIImage imageNamed:@"stopfine_defualtberth"];
            [alertView.secondEvaluatView.totalPointButton setTitle:[NSString stringWithFormat:@"%.1f", record.parkingScore.floatValue] forState:UIControlStateNormal];
            alertView.secondEvaluatView.parkingTypeLabel.hidden = NO;
            for (int i = 0; i < record.parkingevaluatestar.integerValue; i++)
            {
                UIImageView *imageView = alertView.secondEvaluatView.starImageArray[i];
                imageView.image = [UIImage imageNamed:@"星星selected"];
            }
            tagArray = [record.parkingevaluatetag componentsSeparatedByString:@"-"];
            for (int i = 0; i <tagArray.count; i++)
            {
                UILabel *label = alertView.secondEvaluatView.tagLabelArray[i];
                label.text = [NSString stringWithFormat:@" %@ ", tagArray[i]];
            }
            [alertView show:YES];
        });
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [waitHUD hideAnimated:YES];
            [waitHUD removeFromSuperViewOnHide];
        });
        [self showHUDWithString:@"网络异常"];
    }];
}
//获取未缴费的数据个数
- (void)postToGetRepaymentNum
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"sspId"] forKey:@"sspid"];
    
    [self.dataManager POSTToGetRepaymentRecordNumberWithParameters:parameters Success:^(NKBase *base) {
        if (base.ret == 0 && base.obj.intValue > 0)
        {
            if (base.obj.intValue > 99)
            {
                [_topRepaymentButton showBadgeOnButtonWithNumber:99];
            }
            else
            {
                [_topRepaymentButton showBadgeOnButtonWithNumber:base.obj.intValue];
            }
        }
    } Failure:^(NSError *error) {
        [self showHUDWithString:@"网络异常"];
    }];
}
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
#pragma mark - 下拉刷新数据
-(void)refreshData
{
    JElasticPullToRefreshLoadingViewCircle *loadingViewCircle = [[JElasticPullToRefreshLoadingViewCircle alloc] init];
    loadingViewCircle.tintColor = [UIColor whiteColor];
    __weak __typeof(self)weakSelf = self;
    [self.tableView addJElasticPullToRefreshViewWithActionHandler:^{
        [weakSelf sendPostToGetLatestParkingRecord];
    } LoadingView:loadingViewCircle];
    [self.tableView setJElasticPullToRefreshFillColor:COLOR_MAIN_RED];
    [self.tableView setJElasticPullToRefreshBackgroundColor:[UIColor clearColor]];
    
}
#pragma mark 更新弹出界面的数据
- (void)didGetImageURL:(NSString *)url andUpdateRecord:(NKStopDetailRecord *)record
{
    //收费详情
    _currentStopDetailRecord = record;
    NKStopDetailRecord *detailRecord = record;
    _alertView = [[NKAlertView alloc] initWithAlertViewType:NKPopViewTypeParkingRuleAndChargeDetail Height:390 andWidth:WIDTH_VIEW * 0.8];
    _alertView.pageControl.currentPage = self.currentPageIndex;
    //设置界面滑动的位置
    _alertView.chargeAndRuleScrollView.contentOffset = CGPointMake(_alertView.chargeAndRuleScrollView.frame.size.width * self.currentPageIndex, 0);
    
    _alertView.chargeDetailSubView.moneyLabel_0.text = [NSString stringWithFormat:@"%.1f", (float)(detailRecord.fee + detailRecord.bookingfee + detailRecord.tip) / 100];
    _alertView.chargeDetailSubView.moneyLabel_1.text = [NSString stringWithFormat:@"%.1f", (float)detailRecord.fee / 100];
    _alertView.chargeDetailSubView.moneyLabel_2.text = [NSString stringWithFormat:@"%.1f", (float)detailRecord.bookingfee / 100];
    _alertView.chargeDetailSubView.moneyLabel_3.text = [NSString stringWithFormat:@"%.1f", (float)detailRecord.tip / 100];
    _alertView.chargeDetailSubView.moneyLabel_9.text = [NSString stringWithFormat:@"%.1f", (float)(detailRecord.fee + detailRecord.bookingfee + detailRecord.tip - detailRecord.couponMoney) / 100];
    
    _alertView.chargeDetailSubView.licenseLabel.text = detailRecord.license;
    [_alertView.chargeDetailSubView.complainButton addTarget:self action:@selector(clickPopComplaintButton) forControlEvents:UIControlEventTouchUpInside];
    if ([record.complaintstatus isEqualToString:@"1"])
    {
        //不允许投诉
        [_alertView.chargeDetailSubView.complainButton setTitle:@"已投诉" forState:UIControlStateNormal];
        [_alertView.chargeDetailSubView.complainButton setTitleColor:COLOR_TITLE_GRAY forState:UIControlStateNormal];
    }
    else if ([record.complaintstatus isEqualToString:@"2"])
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
- (void)popLatestAlertViewIfNotEvaluate
{
    _alertView = [[NKAlertView alloc] initWithAlertViewType:NKPopViewTypeLatestParking Height:350 andWidth:WIDTH_VIEW * 0.8];
    NKStopDetailRecord *detailRecord = self.latestParkingRecordsMutableArray.firstObject;
    _alertView.latestParkingView.licenseLabel.text = detailRecord.license;
    _alertView.latestParkingView.parkingNameLabel.text = detailRecord.parking;
    _alertView.latestParkingView.totalMoneyLabel.text = [NSString stringWithFormat:@"%.1lf", (float)detailRecord.fee / 100];
    NSString *arriveStr;
    NSString *leaveStr;
    //来车时间
    if (detailRecord.arrive || detailRecord.carRegTime)
    {
        NSString *arriveTimeStr = detailRecord.arrive ? detailRecord.arrive : detailRecord.carRegTime;
        arriveStr = arriveTimeStr;
        arriveTimeStr = detailRecord.arrive;
        NSDate *arriveDate = [NKTimeManager stringToDate:arriveTimeStr withDateFormat:@"yyyy-MM-dd HH:mm:SS"];
        NSString *timeStr = [NKTimeManager dateToString:arriveDate withDateFormat:@"yyyy年MM月dd日 HH时mm分SS秒"];
        _alertView.latestParkingView.arrivingTimeLabel.text = [timeStr substringWithRange:NSMakeRange(12, 6)];
        _alertView.latestParkingView.arrivingDateLabel.text = [timeStr substringWithRange:NSMakeRange(5, 6)];
    }
    //走车时间
    if (detailRecord.leave || detailRecord.carBalanceTime)
    {
        NSString *leavingTimeStr = detailRecord.leave ? detailRecord.leave : detailRecord.carBalanceTime;
        leaveStr = leavingTimeStr;
        NSDate *leavingDate = [NKTimeManager stringToDate:leavingTimeStr withDateFormat:@"yyyy-MM-dd HH:mm:SS"];
        NSString *timeStr = [NKTimeManager dateToString:leavingDate withDateFormat:@"yyyy年MM月dd日 HH时mm分ss秒"];
        _alertView.latestParkingView.leavingTimeLabel.text = [timeStr substringWithRange:NSMakeRange(12, 6)];
        _alertView.latestParkingView.leavingDateLabel.text = [timeStr substringWithRange:NSMakeRange(5, 6)];
    }
    _alertView.latestParkingView.parkingTimeLabel.text = [NKTimeManager dateTimeDifferenceWithStartTime:arriveStr endTime:leaveStr];
    [_alertView.latestParkingView.evaluateButton addTarget:self action:@selector(clickAlertViewButtonToPushEvaluateView) forControlEvents:UIControlEventTouchUpInside];
    
    [_alertView show:YES];
}
#pragma mark - UDesk
- (void)popUdesk
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"myToken"];
    NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:@"niName"];
    NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    NSString *description = [[NSUserDefaults standardUserDefaults] objectForKey:@"userType"];
    NSString *cellPhone = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
    NSMutableDictionary *user = [NSMutableDictionary dictionary];
    [user setValue:token forKey:@"sdk_token"];
    [user setValue:nickName forKey:@"nick_name"];
    if (email.length == 0)
    {
        [user setValue:@"quickpark@qq.com" forKey:@"email"];
    }
    else
    {
        [user setValue:email forKey:@"email"];
    }
    [user setValue:description forKey:@"description"];
    [user setValue:cellPhone forKey:@"cellphone"];
    NSDictionary *parameters = [NSDictionary dictionaryWithObject:user forKey:@"user"];
    
    //    NSDictionary *parameters = @{
    //                                 @"user": @{
    //                                         @"nick_name": @"Nick",
    //                                         @"cellphone":@"18888888777",
    //                                         @"email":@"xiaoming@qq.com",
    //                                         @"description":@"用户描述",
    //                                         @"sdk_token":@"xxxxxxxxxxxx"
    //                                         }
    //                                 };
    
    
    [UdeskManager createCustomerWithCustomerInfo:parameters];
    
    UdeskSDKStyle *sdkStyle = [UdeskSDKStyle customStyle];
    sdkStyle.navigationColor = COLOR_MAIN_RED;
    sdkStyle.titleColor = COLOR_TITLE_WHITE;
    sdkStyle.navBackButtonColor = COLOR_TITLE_WHITE;
    UdeskSDKManager *manager = [[UdeskSDKManager alloc] initWithSDKStyle:sdkStyle];
    //推出帮助中心界面
    //[manager presentUdeskViewControllerWithType:UdeskFAQ viewController:self];
    //推出客服导航界面
    //manager presentUdeskViewControllerWithType:UdeskMenu viewController:self];
    //推出机器人客服界面
    //[manager presentUdeskViewControllerWithType:UdeskRobot viewController:self];
    //推出聊天界面
    [manager pushUdeskViewControllerWithType:UdeskIM viewController:self completion:nil];
}

@end
