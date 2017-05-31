//
//  ParkingRecordTableViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 16/8/12.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "ParkingRecordTableViewController.h"
#import "ParkingRecordTableViewCell.h"
#import "NKDataManager.h"
#import "NKStopDetailRecord.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "EvaluateViewController.h"
#import "NKTimeManager.h"
#import "NKAlertView.h"
#import "MJRefresh.h"
#import "NKEvaluateView.h"
#import "ChargeDetailSubView.h"
#import "EvaluatComplaintViewController.h"
#import "NKColorManager.h"  

@interface ParkingRecordTableViewController ()

@property (nonatomic, strong)NSMutableArray *detailRecordArray;
@property (nonatomic, strong)NSString *token;
@property (nonatomic, strong)NKDataManager *dataManager;
@property (nonatomic, strong)NSMutableArray *starImageArray;
@property (nonatomic, assign)NSInteger pageNo;
@property (nonatomic, assign)NSInteger pageSize;
@property (nonatomic, strong)NKAlertView *alertView;

@property (nonatomic, strong)NKStopDetailRecord *currentStopDetailRecord;
@property (nonatomic, assign)NSInteger currentPageIndex;

@property (nonatomic, retain) UIImageView *emptyView;

//判断是否是随后一条记录
@property (nonatomic, assign)BOOL isLastRecord;

@end

@implementation ParkingRecordTableViewController
-(NSMutableArray *)starImageArray
{
    if (_starImageArray == nil)
    {
        _starImageArray = [NSMutableArray array];
    }
    return _starImageArray;
}
-(NSMutableArray *)detailRecordArray
{
    if (_detailRecordArray == nil)
    {
        _detailRecordArray = [NSMutableArray array];
    }
    return _detailRecordArray;
}
-(instancetype)initWithToken:(NSString *)token
{
    if (self = [super init])
    {
        self.token = token;
    }
    return self;
}
-(UIImageView *)emptyView
{
    if (!_emptyView)
    {
        _emptyView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty_bg"]];
        _emptyView.center = CGPointMake(self.view.center.x, self.view.center.y - 32);
        [self.view addSubview:_emptyView];
    }
    return _emptyView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.tableView.backgroundColor = COLOR_VIEW_BLACK;
    [self.tableView registerNib:[UINib nibWithNibName:@"ParkingRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"ParkingRecordTableViewCell"];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(sendPostToService)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _pageNo = 1;
    _pageSize = 5;
    _isLastRecord = NO;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //页面加载前，设置导航栏
    [self sendPostToService];
    [self setNavigationBar];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.detailRecordArray removeAllObjects];
    [self.tableView reloadData];
    _pageNo = 1;
    _pageSize = 5;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.detailRecordArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ParkingRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParkingRecordTableViewCell" forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[ParkingRecordTableViewCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //更改cell数据
    NKStopDetailRecord *detailRecord = self.detailRecordArray[indexPath.row];
    //将cell上的imageView添加到数组中
    [self.starImageArray removeAllObjects];
    [self.starImageArray addObject:cell.starImageView_0];
    [self.starImageArray addObject:cell.starImageView_1];
    [self.starImageArray addObject:cell.starImageView_2];
    [self.starImageArray addObject:cell.starImageView_3];
    [self.starImageArray addObject:cell.starImageView_4];
    for (UIImageView *imageView in self.starImageArray)
    {
        imageView.image = [UIImage imageNamed:@"star_defualt"];
    }
    if ([detailRecord.commentStatus isEqualToString:@"1"])
    {
        //已评价
        cell.commentButton.hidden = YES;
        cell.starBaseView.hidden = NO;
        NSInteger starCount = (detailRecord.toCarEvaluateStar.integerValue + detailRecord.parkingEvaluateStar.integerValue ) / 2;
        if (starCount > 5)
        {
            starCount = 5;
        }
        for (int i = 0; i < starCount; i++)
        {
            UIImageView *starImage = self.starImageArray[i];
            starImage.image = [UIImage imageNamed:@"star_selected"];
        }
    }
    else
    {
        //未评价
        cell.starBaseView.hidden = YES;
        cell.commentButton.hidden = NO;
        cell.commentButton.tag = indexPath.row;
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

    cell.totalMoneyLabel.text = [NSString stringWithFormat:@"%.1lf", (float)(detailRecord.fee + detailRecord.bookingfee + detailRecord.tip - detailRecord.couponMoney) / 100];
    [cell.ruleButton addTarget:self action:@selector(clickCellRuleButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.ruleButton.tag = 1000 + indexPath.row;
    [cell.chargeDetailButton addTarget:self action:@selector(clickCellChargeButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.chargeDetailButton.tag = 2000 + indexPath.row;
    [cell.starTopButton addTarget:self action:@selector(clickCellStarTopButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.starTopButton.tag = 3000 + indexPath.row;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 126;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = BACKGROUND_COLOR;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    ParkingRecordDetailViewController *pvdc = [[ParkingRecordDetailViewController alloc] initWithNibName:@"ParkingRecordDetailViewController" bundle:nil];
//    //推出视图的同时将NKStopDetailRecord对象传给VC
//    pvdc.stopDetailRecord = self.detailRecordArray[indexPath.section];
//    pvdc.token = self.token;
//    [self.navigationController pushViewController:pvdc animated:YES];
}
#pragma mark - 点击cell 中按钮方法
- (void)clickCellCommentButton:(UIButton *)sender
{
    EvaluateViewController *emmcv = [[EvaluateViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:emmcv];
    emmcv.stopDetailRecord = self.detailRecordArray[sender.tag];
    [self.navigationController presentViewController:navi animated:YES completion:nil];
}
- (void)clickCellRuleButton:(UIButton *)sender
{
    //推出计价规则弹窗
    NKStopDetailRecord *record = self.detailRecordArray[sender.tag - 1000];
    [self PostTogetChargingRuleWithRecord:record];
    _currentPageIndex = 1;
}
- (void)clickCellChargeButton:(UIButton *)sender
{
    NKStopDetailRecord *record = self.detailRecordArray[sender.tag - 2000];
    [self PostTogetChargingRuleWithRecord:record];
    _currentPageIndex = 0;
}
- (void)clickCellStarTopButton:(UIButton *)sender
{
    NKStopDetailRecord *detailRecord = self.detailRecordArray[sender.tag - 3000];
    [self postToGetEvaluateRecordWith:detailRecord.stopRecordId];
}
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
#pragma mark - 设置视图
//页面加载时设置导航栏
-(void)setNavigationBar
{
    self.navigationItem.title = @"停车记录";
    UIImage *itemImage = [UIImage imageNamed:@"左箭头"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[itemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    //获取当前时间
//    NSDate *currentDate = [NSDate date];//获取当前时间，日期
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"YYYY年MM月"];
//    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSString *titleString = [NSString stringWithFormat:@"最近停车记录▼"];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:titleString style:UIBarButtonItemStylePlain target:self action:@selector(choseDate)];
    [rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12],NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
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
-(void)choseDate
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择停车月份" message:@"获取三个月内的停车记录" preferredStyle:UIAlertControllerStyleAlert];
    //拼接月份字符串
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY年MM月"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSString *monthString = [dateString substringWithRange:(NSRange){5, 2}];
    NSString *yearString = [dateString substringWithRange:(NSRange){0, 4}];
    NSInteger monthInt = monthString.integerValue;
    NSString *currentMonthString = dateString;
    NSString *lastMonthString = [NSString stringWithFormat:@"%@年%02ld月", yearString, (long)monthInt - 1];
    NSString *last2MonthString = [NSString stringWithFormat:@"%@年%02ld月", yearString, (long)monthInt - 2];
    //判断是否为年初
    if (monthInt == 1)
    {
        yearString = [NSString stringWithFormat:@"%d", yearString.integerValue - 1];
        lastMonthString = [NSString stringWithFormat:@"%@年12月", yearString];
        last2MonthString = [NSString stringWithFormat:@"%@年11月", yearString];
    }
    if (monthInt == 2)
    {
        lastMonthString = [NSString stringWithFormat:@"%@年1月", yearString];
        yearString = [NSString stringWithFormat:@"%d", yearString.integerValue - 1];
        last2MonthString = [NSString stringWithFormat:@"%@年12月", yearString];
    }
    UIAlertAction *action_0 = [UIAlertAction actionWithTitle:currentMonthString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //发送网络请求
        [self sendPostToService:currentMonthString];
        self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"%@▼", currentMonthString];
    }];
    UIAlertAction *action_1 = [UIAlertAction actionWithTitle:lastMonthString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //发送网络请求
        [self sendPostToService:lastMonthString];
        self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"%@▼", lastMonthString];
    }];
    UIAlertAction *action_2 = [UIAlertAction actionWithTitle:last2MonthString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //发送网络请求
        [self sendPostToService:last2MonthString];
        self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"%@▼", last2MonthString];
    }];
    UIAlertAction *action_3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:action_0];
    [alertController addAction:action_1];
    [alertController addAction:action_2];
    [alertController addAction:action_3];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
#pragma mark - 发送网路请求，获取停车信息
//发送网络请求，获取某个月的停车信息
- (void)sendPostToService:(NSString *)date
{
    // 启动风火轮
    MBProgressHUD *waithud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    waithud.mode = MBProgressHUDModeIndeterminate;
    waithud.label.text = @"Loding";
    
    //创建一个可变字典
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    //往字典里面添加需要提交的参数
    [parametersDic setObject:self.token forKey:@"token"];
    NSString *yearString = [date substringWithRange:(NSRange){0, 4}];
    NSString *monthString = [date substringWithRange:(NSRange){5, 2}];
    NSString *time = [NSString stringWithFormat:@"%@-%@-01 11:11:11", yearString, monthString];
    [parametersDic setObject:time forKey:@"queryTime"];
    [parametersDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"sspId"] forKey:@"sspid"];
    
    self.dataManager = [NKDataManager sharedDataManager];
    [self.dataManager POSTGetStopRecordWithParameters:parametersDic Success:^(NSMutableArray *mutableArray) {
        if (mutableArray.count == 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [waithud hideAnimated:YES];
                [waithud removeFromSuperViewOnHide];
                [self.detailRecordArray removeAllObjects];
                [self.tableView reloadData];
            });
            [self showEmptyBgToView];
        }
        else
        {
            [self.detailRecordArray removeAllObjects];
            self.detailRecordArray = [NSMutableArray arrayWithArray:mutableArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [waithud hideAnimated:YES];
                [waithud removeFromSuperview];
                [self.tableView reloadData];
            });
            [self hideEmptyBgFromView];
        }
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [waithud hideAnimated:YES];
            [waithud removeFromSuperview];
        });
        [self showHUDWithString:@"网络异常"];
        [self showEmptyBgToView];
    }];
}
//发送网络请求，获取全部停车信息
- (void)sendPostToService
{
    if (_isLastRecord)
    {
        [self showHUDWithString:@"没有更多数据了！"];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    // 启动风火轮
    MBProgressHUD __block *hud;
    dispatch_async(dispatch_get_main_queue(), ^{
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = @"Loding";
    });
    //创建一个可变字典
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    //往字典里面添加需要提交的参数
    [parametersDic setObject:self.token forKey:@"token"];
    [parametersDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"sspId"] forKey:@"sspid"];
    [parametersDic setValue:[NSNumber numberWithInteger:_pageSize] forKey:@"pageSize"];
    [parametersDic setValue:[NSNumber numberWithInteger:_pageNo] forKey:@"pageNo"];
    
    self.dataManager = [NKDataManager sharedDataManager];
    [self.dataManager POSTGetStopRecordWithParameters:parametersDic Success:^(NSMutableArray *mutableArray) {
        if (mutableArray.count == 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                [hud removeFromSuperViewOnHide];
                [self.detailRecordArray removeAllObjects];
                [self.tableView reloadData];
            });
            [self showEmptyBgToView];
        }
        else
        {
            [self.detailRecordArray addObjectsFromArray:mutableArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                [hud removeFromSuperViewOnHide];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
                _pageNo++;
                if (mutableArray.count < 5) {
                    _isLastRecord = YES;
                }
            });
            [self hideEmptyBgFromView];
        }
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            [hud removeFromSuperViewOnHide];
            [self.tableView.mj_footer endRefreshing];
        });
        [self showEmptyBgToView];
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
            NSArray *tagArray;
            if (record.tocarevaluatetag.length > 0)
            {
                tagArray = [record.tocarevaluatetag componentsSeparatedByString:@"-"];
            }
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
            if (record.parkingevaluatetag.length > 0)
            {
                tagArray = [record.parkingevaluatetag componentsSeparatedByString:@"-"];
            }
            for (int i = 0; i <tagArray.count; i++)
            {
                UILabel *label = alertView.secondEvaluatView.tagLabelArray[i];
                label.text = [NSString stringWithFormat:@"  %@  ", tagArray[i]];
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
- (void)showHUDWithString:(NSString *)str
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = str;
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES afterDelay:1.0];
        [hud removeFromSuperViewOnHide];
    });
}
#pragma mark 更新弹出界面的数据
- (void)didGetImageURL:(NSString *)url andUpdateRecord:(NKStopDetailRecord *)record
{
    //收费详情
    _currentStopDetailRecord = record;
    NKStopDetailRecord *detailRecord = record;
    UIWindow *mainWindow = [[UIApplication sharedApplication].windows lastObject];
    _alertView = [[NKAlertView alloc] initWithAlertViewType:NKPopViewTypeParkingRuleAndChargeDetail Height:380 andWidth:WIDTH_VIEW * 0.8];
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
//无数据时添加背景图到界面上
- (void)showEmptyBgToView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.emptyView.hidden = NO;
    });
}
- (void)hideEmptyBgFromView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.emptyView.hidden = YES;
    });
}
@end
