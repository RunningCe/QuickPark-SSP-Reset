//
//  OneKeyStopCarViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 16/9/26.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "OneKeyStopCarViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "OneKeyStopCarNavigationViewController.h"
#import "AddCarsViewController.h"
#import "NKCar.h"
#import "NKDataManager.h"
#import "NKAlertView.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "NKOneKeyStopCarBottomView.h"

@interface OneKeyStopCarViewController ()<MAMapViewDelegate, UIScrollViewDelegate>
{
    dispatch_source_t _timer;
}
//底部视图
@property (nonatomic, strong)NKOneKeyStopCarBottomView *bottomView;
//弹出框
@property (nonatomic, strong)NKAlertView *alertView;

//地图
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) AMapLocationReGeocode *reGeoCode;
@property (nonatomic, strong) NSString *userLatitude;
@property (nonatomic, strong) NSString *userLongitude;

//@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, strong) UIBarButtonItem *leftItem;
@property (nonatomic, strong) UIButton *naviTitleButton;
//推出呼叫界面
@property (nonatomic, strong) UIView *callingBackView;
@property (nonatomic, strong) UIView *topCallingView;
@property (nonatomic, strong) UILabel *countDownLabel;
@property (nonatomic, retain) NSTimer* rotateTimer;
@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic, strong) UILabel *totalMoneyLabel;
//呼叫界面的三个价格
@property (nonatomic, assign) NSInteger totalPrice;
@property (nonatomic, assign) NSInteger basicPrice;
@property (nonatomic, assign) NSInteger tipPrice;
@property (nonatomic, assign) NSInteger orderType;//订单类型,0一口价,1竞拍价
//得到车辆的数组
@property (nonatomic, strong) NSMutableArray *carMutableArray;
@property (nonatomic, strong) NKCar *currentCar;

//迅停单下单参数
@property (nonatomic, strong) NSString *orderRadius;
@property (nonatomic, assign) NSInteger orderTip;
@property (nonatomic, assign) NSInteger orderFee;
@property (nonatomic, strong) NSString *orderNo;
//网络请求
@property (nonatomic, strong) NKDataManager *dataManager;
@property (nonatomic, strong) NKSspOrderBasicData *basicData;

@property (nonatomic, strong) __block MBProgressHUD *hud;

@end

@implementation OneKeyStopCarViewController

-(NSMutableArray *)carMutableArray
{
    if (!_carMutableArray)
    {
        _carMutableArray = [NSMutableArray array];
        NSArray *carDataArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"carArray"];
        if (!carDataArray)
        {
            NSLog(@"没有车辆！！！");
            return _carMutableArray;
        }
        for (NSData *carData in carDataArray)
        {
            NKCar *car = [NSKeyedUnarchiver unarchiveObjectWithData:carData];
            [_carMutableArray addObject:car];
            if (car.isDefaultCar)
            {
                //有默认车辆设置默认车辆车牌号
                self.currentCar = car;
            }
        }
    }
    if (_carMutableArray.count > 0)
    {
        if (!_currentCar)
        {
            //没有默认车辆，设置车牌号为第一个车辆
            NKCar *car = _carMutableArray[0];
            _currentCar = car;
        }
    }
    return _carMutableArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self initMapView];
    [self initBottomView];
    //注册监听的通知
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getGTMsg:) name:@"orderCreateSuccess" object:nil];
    //初始化设置
    self.view.backgroundColor = BACKGROUND_COLOR;
    _orderRadius = _basicData.parkingRadiu1;
    _orderType = 0;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getCurrentLocationPOIName];
    [self reloadCarMutableArray];
    [self sendPostToGetOrderBasicData];
}
- (void)viewDidAppear:(BOOL)animated
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isContinueCreateOrder"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isContinueCreateOrder"];
        [self continueCreateOrder];
        return;
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isSystemSendBerth"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isSystemSendBerth"];
        [self systemSendOrder];
        return;
    }
    NSString *orderNo = [[NSUserDefaults standardUserDefaults] objectForKey:@"orderNo"];
    if (orderNo.length > 0)
    {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"naviParametersData"];
        NKSspOrderParameters *parameters = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        float lng = [[NSUserDefaults standardUserDefaults] floatForKey:@"startPoint_lng"];
        float lat = [[NSUserDefaults standardUserDefaults] floatForKey:@"startPoint_lat"];
        AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:lat longitude:lng];
        NSInteger leftTime = [[NSUserDefaults standardUserDefaults] integerForKey:@"leftTime"];
        OneKeyStopCarNavigationViewController *oscnVC = [[OneKeyStopCarNavigationViewController alloc] initWithParameters:parameters andStarPoint:startPoint andCountDownTime:leftTime];
        [self.navigationController pushViewController:oscnVC animated:YES];
        return;
    }
}
- (void)dealloc
{
    if (_timer)
    {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    if (_rotateTimer)
    {
        [_rotateTimer invalidate];
    }
    //停止定位
    [_locationManager stopUpdatingLocation];
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 重新加载车辆数组
- (void)reloadCarMutableArray
{
    NSArray *carDataArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"carArray"];
    [self.carMutableArray removeAllObjects];
    if (carDataArray.count == 0)
    {
        NSLog(@"没有车辆！！！");
        return;
    }
    for (NSData *carData in carDataArray)
    {
        NKCar *car = [NSKeyedUnarchiver unarchiveObjectWithData:carData];
        [_carMutableArray addObject:car];
        if (car.isDefaultCar)
        {
            //有默认车辆设置默认车辆车牌号
            self.currentCar = car;
        }
    }
    if (!_currentCar)
    {
        //没有默认车辆，设置车牌号为第一个车辆
        NKCar *car = _carMutableArray[0];
        _currentCar = car;
    }
}
#pragma mark -初始化导航栏
- (void)setNavigationBar
{
    if (self.carMutableArray.count == 0)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 22)];
        [button setTitle:@"添加车辆" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [button setTitleColor:COLOR_TITLE_WHITE forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickAddCarButton) forControlEvents:UIControlEventTouchUpInside];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((WIDTH_VIEW - 70) / 2, 11, 70, 22)];
        [view addSubview:button];
        self.navigationItem.titleView = view;
    }
    else
    {
        _naviTitleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 22)];
        [_naviTitleButton setTitle:[NSString stringWithFormat:@"%@ ▼", _currentCar.license] forState:UIControlStateNormal];
        [_naviTitleButton.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_naviTitleButton setTitleColor:COLOR_TITLE_WHITE forState:UIControlStateNormal];
        [_naviTitleButton addTarget:self action:@selector(clickChooseCarItemButton) forControlEvents:UIControlEventTouchUpInside];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((WIDTH_VIEW - 200) / 2, 11, 200, 22)];
        [view addSubview:_naviTitleButton];
        self.navigationItem.titleView = view;
    }
    UIImage *leftItemImage = [UIImage imageNamed:@"左箭头"];
    _leftItem = [[UIBarButtonItem alloc] initWithImage:[leftItemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = _leftItem;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_TITLE_WHITE}];
    
    self.navigationController.navigationBar.barTintColor = COLOR_NAVI_BLACK;
    self.navigationController.navigationBar.backgroundColor = COLOR_NAVI_BLACK;
}
-(void)goBack
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 初始化底部视图
- (void)initBottomView
{
    _bottomView = [NKOneKeyStopCarBottomView bottomView];
    _bottomView.frame = CGRectMake(12, HEIGHT_VIEW * 0.61, WIDTH_VIEW - 24, HEIGHT_VIEW * 0.385);
    _bottomView.backgroundColor = COLOR_VIEW_WHITE;
    _bottomView.layer.cornerRadius = CORNERRADIUS;
    _bottomView.layer.masksToBounds = YES;
    [_bottomView.quickParkButton addTarget:self action:@selector(clickQuickParkButton) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView.moneySlider addTarget:self action:@selector(moneySliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_bottomView.distanceSlider addTarget:self action:@selector(distanceSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    _bottomView.totalMoneyLabel_0.layer.cornerRadius = CORNERRADIUS;
    _bottomView.totalMoneyLabel_0.layer.masksToBounds = YES;
    _bottomView.totalMoneyLabel_0.backgroundColor = COLOR_VIEW_GRAY;
    _bottomView.totalMoneyLabel_0.textColor = COLOR_TITLE_WHITE;
    _bottomView.totalMoneyLabel_1.layer.cornerRadius = CORNERRADIUS;
    _bottomView.totalMoneyLabel_1.layer.masksToBounds = YES;
    _bottomView.totalMoneyLabel_1.backgroundColor = COLOR_VIEW_GRAY;
    _bottomView.totalMoneyLabel_1.textColor = COLOR_TITLE_WHITE;
    
    _bottomView.moneySlider.value = 0;
    _bottomView.distanceLabel_0.font = [UIFont systemFontOfSize:12.0];
    _bottomView.distanceLabel_0.textColor = COLOR_TITLE_RED;
    _bottomView.distanceSlider.value = 0;
    
    //更改两个约束
    _bottomView.constraintFirst.constant = HEIGHT_VIEW * 0.385 * 0.15;
    _bottomView.constraintSecond.constant = HEIGHT_VIEW * 0.385 * 0.15;
    
    [_bottomView.topButton addTarget:self action:@selector(clickGetCurrentLocationButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_bottomView];
}
#pragma mark - 点击按钮切换界面  定位按钮 选择车辆 添加车辆 下单按钮 slider方法
- (void)moneySliderValueChanged:(NKSlider *)sender
{
    if (_basicPrice == 0)
    {
        _basicPrice = 2;
    }
    float centerMoney = 30;
    float basicMoney = _basicPrice;
    NSInteger total;
    if (sender.value > 0.5 && (sender.value < 1 || sender.value == 1))
    {
        total = (((99 - basicMoney - centerMoney) * 4) / 3) * sender.value * sender.value + (4 * centerMoney + basicMoney - 99) / 3 + basicMoney;
        _bottomView.totalMoneyLabel_0.text = [NSString stringWithFormat:@"%ld", (long)total / 10];
        _bottomView.totalMoneyLabel_1.text = [NSString stringWithFormat:@"%ld", (long)total % 10];
    }
    else
    {
        total = centerMoney * 2 * sender.value + _basicPrice;
        _bottomView.totalMoneyLabel_0.text = [NSString stringWithFormat:@"%ld", (long)total / 10];
        _bottomView.totalMoneyLabel_1.text = [NSString stringWithFormat:@"%ld", (long)total % 10];
    }
    
    _orderFee = _basicPrice;
    _orderTip = total - _basicPrice;
    NSLog(@"%ld, %ld", (long)_orderFee, _orderTip);
}
- (void)distanceSliderValueChanged:(NKSlider *)sender
{
    _bottomView.distanceLabel_0.font = [UIFont systemFontOfSize:10.0];
    _bottomView.distanceLabel_0.textColor = COLOR_TITLE_GRAY;
    _bottomView.distanceLabel_1.font = [UIFont systemFontOfSize:10.0];
    _bottomView.distanceLabel_1.textColor = COLOR_TITLE_GRAY;
    _bottomView.distanceLabel_2.font = [UIFont systemFontOfSize:10.0];
    _bottomView.distanceLabel_2.textColor = COLOR_TITLE_GRAY;
    _bottomView.distanceLabel_3.font = [UIFont systemFontOfSize:10.0];
    _bottomView.distanceLabel_3.textColor = COLOR_TITLE_GRAY;
    
    if (sender.value == 0 || (sender.value > 0 && sender.value < 0.17))
    {
        sender.value = 0;
        _orderRadius = _basicData.parkingRadiu1;
        _mapView.zoomLevel = 19.0;
        _bottomView.distanceLabel_0.font = [UIFont systemFontOfSize:12.0];
        _bottomView.distanceLabel_0.textColor = COLOR_TITLE_RED;
    }
    else if (sender.value == 0.17 || (sender.value > 0.17 && sender.value < 0.5))
    {
        sender.value = 0.33;
        _orderRadius = _basicData.parkingRadiu2;
        _mapView.zoomLevel = 17.0;
        _bottomView.distanceLabel_1.font = [UIFont systemFontOfSize:12.0];
        _bottomView.distanceLabel_1.textColor = COLOR_TITLE_RED;
    }
    else if (sender.value == 0.5 || (sender.value > 0.5 && sender.value < 0.83))
    {
        sender.value = 0.67;
        _orderRadius = _basicData.parkingRadiu3;
        _mapView.zoomLevel = 15.76;
        _bottomView.distanceLabel_2.font = [UIFont systemFontOfSize:12.0];
        _bottomView.distanceLabel_2.textColor = COLOR_TITLE_RED;
    }
    else
    {
        sender.value = 1;
        _orderRadius = _basicData.parkingRadiu4;
        _mapView.zoomLevel = 14.79;
        _bottomView.distanceLabel_3.font = [UIFont systemFontOfSize:12.0];
        _bottomView.distanceLabel_3.textColor = COLOR_TITLE_RED;
    }
    
}
//点击定位按钮
- (void)clickGetCurrentLocationButton
{
    NSLog(@"定位");
    [self getCurrentLocationPOIName];
}
//选择车辆
- (void)clickChooseCarItemButton
{
    NSLog(@"选择车辆！");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择车辆" message:@"请选择您要停放的车辆" preferredStyle:UIAlertControllerStyleAlert];
    NSMutableArray *actionMutableArray = [NSMutableArray array];
    for (NKCar *car in self.carMutableArray)
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:car.license style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _currentCar = car;
            [_naviTitleButton setTitle:[NSString stringWithFormat:@"%@ ▼", car.license] forState:UIControlStateNormal];
        }];
        [actionMutableArray addObject:action];
    }
    UIAlertAction *action_cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    if (actionMutableArray)
    {
        for (int i = 0; i < actionMutableArray.count; i++)
        {
            [alert addAction:actionMutableArray[i]];
        }
    }
    [alert addAction:action_cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)clickAddCarButton
{
    NSLog(@"添加车辆");
    AddCarsViewController *acVC = [[AddCarsViewController alloc] initWithNibName:@"AddCarsViewController" bundle:nil];
    [self.navigationController pushViewController:acVC animated:YES];
}
-(void)clickQuickParkButton
{
    double accountBalance = [[NSUserDefaults standardUserDefaults] integerForKey:@"balance"] / 100;
    double needMoney = _orderFee + _orderTip;
    if (self.carMutableArray.count == 0)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请先添加车辆！";
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            [hud removeFromSuperViewOnHide];
        });
        return;
    }
    else if (needMoney > accountBalance)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"余额不足！";
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            [hud removeFromSuperViewOnHide];
        });
        return;
    }
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    
    [self sendPostToCreateOrder];
    
    NSLog(@"创建呼叫界面");
}
-(void)resumeTheStartView
{
    //还原原来的界面
    self.navigationItem.leftBarButtonItem = _leftItem;
    //self.navigationItem.rightBarButtonItem = _rightItem;
    self.navigationItem.title = _currentCar.license;
    
    _topCallingView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _callingBackView.frame;
        frame.size.width = 0;
        frame.size.height = 0;
        _callingBackView.frame = frame;
        [_callingBackView removeFromSuperview];
    }];
}
#pragma mark 正在呼叫的相关方法
-(void)createTopScrollView
{
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW, 6)];
    [_topCallingView addSubview:_topScrollView];
    _topScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame)*3, CGRectGetHeight(self.view.frame));
    _topScrollView.pagingEnabled = NO;
    _topScrollView.showsHorizontalScrollIndicator = NO;
    
    //添加三个子视图  UIImageView类型
    for (int i = 0; i< 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)*i, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        imageView.image = [UIImage imageNamed:@"滚动条"];
        [_topScrollView addSubview:imageView];
    }
    [_topCallingView addSubview:_topScrollView];
    
    //启动定时器
    _rotateTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeView) userInfo:nil repeats:YES];
    //为滚动视图指定代理
    _topScrollView.delegate = self;
}
//定时器的回调方法   切换界面
- (void)changeView
{
    if (_topScrollView.contentOffset.x > WIDTH_VIEW)
    {
        CGPoint point = CGPointMake(0, _topScrollView.contentOffset.y);
        [_topScrollView setContentOffset:point];
    }
    float OffSet_x = _topScrollView.contentOffset.x;
    OffSet_x++;
    CGPoint point = CGPointMake(OffSet_x, _topScrollView.contentOffset.y);
    [_topScrollView setContentOffset:point];
}
-(void)addCallingViewToSuperView
{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.title = @"正在呼叫";
    /***********************************倒计时******************************************/
    __block int timeout = 150; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout < 0 || timeout == 0)
        {
            //倒计时结束，没有获取到车位，取消订单
            [self sendPostToCancelOrderWithTimeOut:0 andCancelType:0];
            if (_timer)
            {
                dispatch_source_cancel(_timer);
                _timer = nil;
            }
            [_rotateTimer invalidate];//关闭滚动条定时器
            dispatch_async(dispatch_get_main_queue(), ^{
                [self resumeTheStartView];
                //倒计时结束，没有获取到车位，取消订单，弹出提示
                UIWindow *mainWindow = [[UIApplication sharedApplication].windows lastObject];
                self.alertView = [[NKAlertView alloc] initWithAlertViewType:NKAlertViewTypeFailedToCallCar];
                [mainWindow addSubview:self.alertView.bGView];
                [mainWindow addSubview:self.alertView];
                [self.alertView show:YES];
            });
        }else{
            int seconds = timeout % 151;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];

            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                _countDownLabel.text = [NSString stringWithFormat:@"%@s", strTime];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    /**********************************************************************************/
    
    if (_callingBackView == nil)
    {
        _callingBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, WIDTH_VIEW, HEIGHT_VIEW - 64)];
        _callingBackView.backgroundColor = [UIColor blackColor];
        _callingBackView.alpha = 0.5;
        [self.view addSubview:_callingBackView];
    }
    else
    {
        _callingBackView.frame = CGRectMake(0, 64, WIDTH_VIEW, HEIGHT_VIEW - 64);
        _callingBackView.backgroundColor = [UIColor blackColor];
        _callingBackView.alpha = 0.5;
        [self.view addSubview:_callingBackView];
    }
    
    
    _topCallingView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, WIDTH_VIEW, 90)];
    _topCallingView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_topCallingView];
    
    UIView *topScrollView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW, 6)];
    topScrollView.backgroundColor = [UIColor redColor];
    [_topCallingView addSubview:topScrollView];
    
    _totalMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 18, WIDTH_VIEW / 2, 16)];
    float totalMoney = _orderTip + _orderFee;
    _totalMoneyLabel.text = [NSString stringWithFormat:@"费用合计%.2f", totalMoney];
    _totalMoneyLabel.textColor = COLOR_TITLE_BLACK;
    _totalMoneyLabel.font = [UIFont systemFontOfSize:16.0];
    [_topCallingView addSubview:_totalMoneyLabel];
    
    UILabel *basicMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 46, WIDTH_VIEW / 3 *2, 12)];
    basicMoneyLabel.text = [NSString stringWithFormat:@"基本费用：%d元  小费：%d元", _orderFee, _orderTip];
    basicMoneyLabel.textColor = COLOR_TITLE_BLACK;
    basicMoneyLabel.font = [UIFont systemFontOfSize:12.0];
    [_topCallingView addSubview:basicMoneyLabel];
    
//    UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 66, WIDTH_VIEW / 3 * 2, 12)];
//    float subMoney = _orderTip / 4;
//    noticeLabel.text = [NSString stringWithFormat:@"每等待30秒，定时费用即减去%.2f元", subMoney];
//    noticeLabel.textColor = TITLE_COLOR_LIGHT;
//    noticeLabel.font = [UIFont systemFontOfSize:10.0];
//    [_topCallingView addSubview:noticeLabel];
    
    _countDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH_VIEW - 92, 18, 80, 16)];
    _countDownLabel.text = @"150s";
    _countDownLabel.textColor = COLOR_TITLE_BLACK;
    _countDownLabel.font = [UIFont systemFontOfSize:16.0];
    _countDownLabel.textAlignment = NSTextAlignmentRight;
    [_topCallingView addSubview:_countDownLabel];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH_VIEW - 92, 48, 80, 28)];
    [cancelButton addTarget:self action:@selector(clickCallingCancelButton) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton setTitle:@"取消呼叫" forState:UIControlStateNormal];
    [cancelButton setTitleColor:COLOR_BUTTON_RED forState:UIControlStateNormal];
    cancelButton.layer.cornerRadius = CORNERRADIUS;
    cancelButton.layer.masksToBounds = YES;
    cancelButton.layer.borderColor = COLOR_BUTTON_RED.CGColor;
    cancelButton.layer.borderWidth = 1;
    [_topCallingView addSubview:cancelButton];
    
    [self createTopScrollView];
}
-(void)clickCallingCancelButton
{
    UIWindow *mainWindow = [[UIApplication sharedApplication].windows lastObject];
    self.alertView = [[NKAlertView alloc] initWithAlertViewType:NKAlertViewTypeCancelCallingCar];
    [mainWindow addSubview:self.alertView.bGView];
    [mainWindow addSubview:self.alertView];
    [self.alertView show:YES];
    
    [self.alertView.sureButton addTarget:self action:@selector(clickCallingAlertSureButton) forControlEvents:UIControlEventTouchUpInside];
    [self.alertView.cancelButton addTarget:self action:@selector(clickCallingAlertCancelButton) forControlEvents:UIControlEventTouchUpInside];
}
-(void)clickCallingAlertSureButton
{
    //取消订单
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    
    [self sendPostToCancelOrderWithTimeOut:0 andCancelType:0];
    [self.alertView hide:YES];
}
-(void)clickCallingAlertCancelButton
{
    [self.alertView hide:YES];
}
#pragma mark - 地图相关的方法
- (void) initMapView
{
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW, HEIGHT_VIEW)];
    _mapView.delegate = self;
    _mapView.mapType = MAMapTypeStandard;
    _mapView.showsCompass= NO;
    _mapView.showsScale = NO;
    //设置显示当前位置
    _mapView.showsUserLocation = YES;
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];
    //设置地图的手势
    _mapView.zoomEnabled = NO;
    _mapView.scrollEnabled = NO;
    _mapView.rotateEnabled = NO;
    _mapView.rotateCameraEnabled = NO;
    //设置地图可见范围
    _mapView.zoomLevel = 19.0;
    //设置定位
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    _locationManager = [[AMapLocationManager alloc] init];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    _locationManager.locationTimeout = 10;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    _locationManager.reGeocodeTimeout = 10;
    
    [self.view addSubview:_mapView];
}
//定位点变化后的回调
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        _userLatitude = [NSString stringWithFormat:@"%f", userLocation.coordinate.latitude];
        _userLongitude = [NSString stringWithFormat:@"%f", userLocation.coordinate.longitude];
        _mapView.centerCoordinate = userLocation.coordinate;
    }
}
-(void)getCurrentLocationPOIName
{
    [_locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        NSLog(@"location:%@", location);
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
            _bottomView.poiNameLabel.text = regeocode.POIName;
            _bottomView.poiAddressLabel.text = [NSString stringWithFormat:@"%@%@%@", regeocode.city, regeocode.district, regeocode.street];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"定位成功！";
            [hud hideAnimated:YES afterDelay:1.2];
            [hud removeFromSuperViewOnHide];
        }
    }];
}
#pragma mark - 网络请求相关方法
//下单前获取订单基本信息
- (void)sendPostToGetOrderBasicData
{
    _dataManager = [NKDataManager sharedDataManager];
    [_dataManager POSTGetOneKeyOrderBaseDataWithParameters:nil Success:^(NKSspOrderBackValue *backValue) {
        if (backValue.ret == 0)
        {
            NSLog(@"请求成功！！");
            _basicData = [NKSspOrderBasicData mj_objectWithKeyValues:backValue.obj];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _bottomView.callMoneyLabel.text = [NSString stringWithFormat:@"%ld", (long)_basicData.parkingBasicPrice];
                _bottomView.distanceLabel_0.text = [NSString stringWithFormat:@"%@m", _basicData.parkingRadiu1];
                _bottomView.distanceLabel_1.text = [NSString stringWithFormat:@"%@m", _basicData.parkingRadiu2];
                _bottomView.distanceLabel_2.text = [NSString stringWithFormat:@"%@m", _basicData.parkingRadiu3];
                _bottomView.distanceLabel_3.text = [NSString stringWithFormat:@"%@m", _basicData.parkingRadiu4];
                
                _basicPrice = _basicData.parkingBasicPrice;
                _bottomView.totalMoneyLabel_0.text = [NSString stringWithFormat:@"%ld", (long)_basicPrice / 10];
                _bottomView.totalMoneyLabel_1.text = [NSString stringWithFormat:@"%ld", (long)_basicPrice % 10];
                
                _orderRadius = _basicData.parkingRadiu1;
                _orderFee = _basicData.parkingBasicPrice;
                //_orderTip = _basicData.auctionPrice1;
            });
        }
        else
        {
            NSLog(@"%@", backValue.msg);
        }
    } Failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}
//请求下单
- (void)sendPostToCreateOrder
{
    //SspOrderVo
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_currentCar.license forKey:@"license"];//车牌号
    [parameters setValue:_bottomView.poiNameLabel.text forKey:@"destination"];//当前位置
    [parameters setValue:_orderRadius forKey:@"radius"];//半径:m
    [parameters setValue:[NSNumber numberWithInteger:_orderFee * 100] forKey:@"bookingFee"];//预约费(服务费) 分
    [parameters setValue:[NSNumber numberWithInteger:_orderTip * 100] forKey:@"tip"];//小费 分
    [parameters setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userType"] forKey:@"cuslevel"];//会籍
    [parameters setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"sspId"] forKey:@"sspId"];//sspid
    [parameters setValue:[NSNumber numberWithInteger:_orderType] forKey:@"orderType"];//订单类型,0一口价,1竞拍价
    [parameters setValue:_userLongitude forKey:@"lng"];//经度
    [parameters setValue:_userLatitude forKey:@"lat"];//纬度
    [parameters setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"] forKey:@"clientId"];//推送服务令牌（设备唯一标识），用于标识推送信息接收者身份
    [parameters setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"sex"] forKey:@"cusSex"];//用户性别 0 男 1 女
    [parameters setValue:@10 forKey:@"carChargeType"];//10 不确定 11 小型车（默认）  12 中型车 13 大型车
    [parameters setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"realName"] forKey:@"cusName"];//用户姓名
    [parameters setValue:@"2" forKey:@"clientType"];//客户端类型 1 Android 2 iOS
    [parameters setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"] forKey:@"cusMob"];//手机号
    
    [[NSUserDefaults standardUserDefaults] setObject:parameters forKey:@"createOrderParameters"];
    
    _dataManager = [NKDataManager sharedDataManager];
    [_dataManager POSTCreateOneKeyOrderWithParameters:parameters Success:^(NKSspOrderBackValue *backValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_hud hideAnimated:YES];
            [_hud removeFromSuperViewOnHide];
        });
        if (backValue.ret == 0)
        {
            NSLog(@"订单创建成功！");
#warning to do 扣钱的时机待定
            double accountBalance = [[NSUserDefaults standardUserDefaults] integerForKey:@"balance"] / 100;
            accountBalance = accountBalance - _orderTip - _orderFee;
            [[NSUserDefaults standardUserDefaults] setInteger:accountBalance * 100 forKey:@"balance"];
            //订单创建成功，获取订单号，等待推送
            _orderNo = [NSString stringWithFormat:@"%@", backValue.obj];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"订单创建成功，等待MEP抢单！";
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:2.0];
                [hud removeFromSuperViewOnHide];
                //推出等待界面
                [self addCallingViewToSuperView];
            });
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = backValue.msg;
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:2.0];
                [hud removeFromSuperViewOnHide];
            });
        }
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_hud hideAnimated:YES];
            [_hud removeFromSuperViewOnHide];
        });
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"网络异常";
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:2.0];
            [hud removeFromSuperViewOnHide];
        });
        NSLog(@"%@", error);
    }];
}
//取消下单
-(void)sendPostToCancelOrderWithTimeOut:(int)timeout andCancelType:(int)type
{
    
    //SspOrderVo
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_currentCar.license forKey:@"license"];//车牌号
    [parameters setValue:[NSNumber numberWithInteger:_orderFee * 100] forKey:@"bookingFee"];//预约费(服务费) 分
    [parameters setValue:[NSNumber numberWithInteger:_orderTip * 100] forKey:@"tip"];//小费 分
    [parameters setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"sspId"] forKey:@"sspId"];//sspid
    [parameters setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"] forKey:@"clientId"];//推送服务令牌（设备唯一标识），用于标识推送信息接收者身份
    [parameters setValue:_orderNo forKey:@"orderNo"];//订单号
    [parameters setValue:@"用户取消订单" forKey:@"cancelReason"];//取消原因
    [parameters setValue:[NSNumber numberWithInt:timeout] forKey:@"isOvertime"];//订单是否超时,0-未超时,1-超时
    [parameters setValue:[NSNumber numberWithInt:type] forKey:@"cancelType"];//取消类型,  0-取消呼叫,1-终止呼叫,2-超时取消
    //取消订单
    _dataManager = [NKDataManager sharedDataManager];
    [_dataManager POSTCancelOneKeyOrderWithParameters:parameters Success:^(NKSspOrderBackValue *backValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_hud hideAnimated:YES];
            [_hud removeFromSuperViewOnHide];
        });
        
        if (backValue.ret == 0)
        {
            NSLog(@"取消订单成功！");
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"orderNo"];
            //还原界面
            //还原原来的界面
            dispatch_async(dispatch_get_main_queue(), ^{
                [self resumeTheStartView];
            });
            
            //释放定时器
            if (_timer)
            {
                dispatch_source_cancel(_timer);
                _timer = nil;
            }
            if (_rotateTimer)
            {
                [_rotateTimer invalidate];
            }
            
            //提示抢单信息
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"取消订单成功！";
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:2.0];
                [hud removeFromSuperViewOnHide];
            });
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = backValue.msg;
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:2.0];
                [hud removeFromSuperViewOnHide];
            });
        }
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_hud hideAnimated:YES];
            [_hud removeFromSuperViewOnHide];
        });
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"服务器异常";
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:2.0];
            [hud removeFromSuperViewOnHide];
        });
    }];

}
//应急处理继续下单
- (void)continueCreateOrder
{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    //获取到之前下单的参数，发送给
    NSMutableDictionary *parameters = [[NSUserDefaults standardUserDefaults] objectForKey:@"createOrderParameters"];
    _dataManager = [NKDataManager sharedDataManager];
    [_dataManager POSTContinueCreateOrderWithParameters:parameters Success:^(NKSspOrderBackValue *backValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_hud hideAnimated:YES];
            [_hud removeFromSuperViewOnHide];
        });
        if (backValue.ret == 0)
        {
            NSLog(@"订单创建成功！");
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isSystemSendBerth"];

            //订单创建成功，获取订单号，等待推送
            _orderNo = [NSString stringWithFormat:@"%@", backValue.obj];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"订单创建成功，等待MEP抢单！";
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:2.0];
                [hud removeFromSuperViewOnHide];
                //推出等待界面
                [self addCallingViewToSuperView];
            });
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = backValue.msg;
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:2.0];
                [hud removeFromSuperViewOnHide];
            });
        }
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_hud hideAnimated:YES];
            [_hud removeFromSuperViewOnHide];
        });
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"网络异常";
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:2.0];
            [hud removeFromSuperViewOnHide];
        });
        NSLog(@"%@", error);
    }];
}
//应急处理-系统指派车位
- (void)systemSendOrder
{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    //SspOrderVo
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableDictionary *oldParameters = [[NSUserDefaults standardUserDefaults] objectForKey:@"createOrderParameters"];
    [parameters setObject:[oldParameters objectForKey:@"sspId"] forKey:@"sspId"];
    [parameters setObject:[oldParameters objectForKey:@"radius"] forKey:@"radius"];
    [parameters setObject:[oldParameters objectForKey:@"lng"] forKey:@"lng"];
    [parameters setObject:[oldParameters objectForKey:@"lat"] forKey:@"lat"];
    [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"orderNo"] forKey:@"orderNo"];
    
    _dataManager = [NKDataManager sharedDataManager];
    [_dataManager POSTSystemSendBerthWithParameters:parameters Success:^(NKSspOrderBackValue *backValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_hud hideAnimated:YES];
            [_hud removeFromSuperViewOnHide];
        });
        if (backValue.ret == 0)
        {
            NSLog(@"订单创建成功！");
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isContinueCreateOrder"];
            
            //订单创建成功，获取订单号，等待推送
            _orderNo = [NSString stringWithFormat:@"%@", backValue.obj];
//            //将订单号保存
//            [[NSUserDefaults standardUserDefaults] setObject:_orderNo forKey:@"orderNo"];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"订单创建成功，等待MEP抢单！";
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:2.0];
                [hud removeFromSuperViewOnHide];
                //推出等待界面
                [self addCallingViewToSuperView];
            });
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = backValue.msg;
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:2.0];
                [hud removeFromSuperViewOnHide];
            });
        }
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_hud hideAnimated:YES];
            [_hud removeFromSuperViewOnHide];
        });
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"网络异常";
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:2.0];
            [hud removeFromSuperViewOnHide];
        });
        NSLog(@"%@", error);
    }];
}
#pragma mark - 收到推送消息
-(void)getGTMsg:(NSNotification *)notification
{
    //关闭定时器
    if (_rotateTimer)
    {
        [_rotateTimer invalidate];   
    }
    if (_timer)
    {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    [self resumeTheStartView];

    //推出导航界面
    NSString *orderNumber = _orderNo;
    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:_userLatitude.floatValue longitude:_userLongitude.floatValue];
    NKSspOrderParameters *parameters = [[NKSspOrderParameters alloc] init];
    parameters.license = _currentCar.license;
    parameters.bookingFee = _orderFee;
    parameters.tip = _orderTip;
    parameters.sspId = [[NSUserDefaults standardUserDefaults] objectForKey:@"sspId"];
    parameters.clientId = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"];
    parameters.orderNo = orderNumber;
    
    OneKeyStopCarNavigationViewController *naviVC = [[OneKeyStopCarNavigationViewController alloc] initWithParameters:parameters andStarPoint:startPoint andCountDownTime:900];
    [self.navigationController pushViewController:naviVC animated:YES];
    
}


@end
