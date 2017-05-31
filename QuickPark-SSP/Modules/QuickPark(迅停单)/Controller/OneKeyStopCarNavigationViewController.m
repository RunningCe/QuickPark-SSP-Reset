
//
//  OneKeyStopCarNavigationViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 2016/10/9.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "OneKeyStopCarNavigationViewController.h"
#import "NKDataManager.h"
#import "NKGuidePageData.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "NKAlertView.h"
#import "MainTabbarViewController.h"


@interface OneKeyStopCarNavigationViewController ()<AMapNaviDriveManagerDelegate, AMapNaviDriveViewDelegate>
{
    dispatch_source_t _timer;//创建一个全局的定时器，监控15*60s的订单状态
    __block int _timeout; //倒计时时间
}

@property (nonatomic, strong)AMapNaviPoint *startPoint;
@property (nonatomic, strong)AMapNaviPoint *endPoint;
@property (nonatomic, strong)AMapNaviDriveManager *driveManager;
@property (nonatomic, strong)AMapNaviDriveView *driveView;
@property (nonatomic, strong)NKDataManager *dataManager;
@property (nonatomic, strong)NSString *orderNumber;
@property (nonatomic, strong)NKSspOrderParameters *parameters;
@property (nonatomic, strong)NKGuidePageData *guidePageData;

@property (nonatomic, strong)UILabel *naviTitleLabel;

@property (nonatomic, strong)UILabel *parkLabel;
@property (nonatomic, strong)UILabel *locationLabel;
@property (nonatomic, strong)UILabel *tollLabel;
@property (nonatomic, strong)UILabel *moneyLabel;

@property (nonatomic, strong)NKAlertView *alertView;

@end

@implementation OneKeyStopCarNavigationViewController
-(instancetype)initWithParameters:(NKSspOrderParameters *)parameters andStarPoint:(AMapNaviPoint *)startPoint andCountDownTime:(NSInteger) countDownTime
{
    self = [super init];
    if (self)
    {
        _parameters = parameters;
        _orderNumber = parameters.orderNo;
        _startPoint = startPoint;
        _timeout = countDownTime;
    }
    return self;
}
#pragma mark - 创建计时器
-(void)createTimer
{
    //_timeout = 15*60;//初始化倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(_timeout == 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            _timer = nil;
            [self cancelOrder];//取消订单
            dispatch_async(dispatch_get_main_queue(), ^{
                //倒计时结束，弹出超时提示
                UIWindow *mainWindow = [[UIApplication sharedApplication].windows lastObject];
                self.alertView = [[NKAlertView alloc] initWithAlertViewType:NKAlertViewTypeOrderTimeOut];
                [mainWindow addSubview:self.alertView.bGView];
                [mainWindow addSubview:self.alertView];
                [self.alertView show:YES];
            });
        }else{
            _timeout--;
            dispatch_async(dispatch_get_main_queue(), ^{
                _naviTitleLabel.text = [NSString stringWithFormat:@"%02d:%02d", _timeout / 60, _timeout % 60];
            });
        }
    });
    dispatch_resume(_timer);
}
#pragma mark - Life Cycle(控制器生命周期)
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self initSubViews];
    [self createTimer];
    [self saveDataToResume];
    
    //注册监听的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getGTMsg:) name:@"berthReservedFaild" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parkingSuccess) name:@"parkingSuccess" object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self sendPostToGetInitData];
}
- (void)viewWillLayoutSubviews
{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        interfaceOrientation = self.interfaceOrientation;
    }
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
    {
        [self.driveView setIsLandscape:NO];
    }
    else if (UIInterfaceOrientationIsLandscape(interfaceOrientation))
    {
        [self.driveView setIsLandscape:YES];
    }
}
-(void)dealloc
{
    //关闭定时器
    if (_timer != nil)
    {
        [self stopTimer];
    }
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)stopTimer
{
    dispatch_source_cancel(_timer);
    _timer = nil;
}
- (void)dismissNaviController
{
    if (self.navigationController.childViewControllers.count == 1)
    {
        //导航控制器没有子控制器，直接推出tabbarController
        NSString *str = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
        NSString *path = [NSString stringWithFormat:@"%@/LoginMsg.txt", str];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NKLogin *LoginMsg = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        MainTabbarViewController *mainTabbarController = [[MainTabbarViewController alloc] initWithLoginMsg:LoginMsg];
        UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
        mainWindow.rootViewController = mainTabbarController;
        [mainWindow makeKeyAndVisible];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//隐藏状态栏
//- (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}
#pragma mark -初始化导航栏
- (void)setNavigationBar
{
    UIView *titleBaseView = [[UIView alloc] initWithFrame:CGRectMake((WIDTH_VIEW - 70)/2, 11, 70, 22)];
    //titleBaseView.backgroundColor = [UIColor redColor];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navimap_倒计时"]];
    titleImageView.frame = CGRectMake(3, 3, 16, 16);
    _naviTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, 70 - 20, 22)];
    _naviTitleLabel.font = [UIFont systemFontOfSize:18.0];
    _naviTitleLabel.textColor = COLOR_TITLE_WHITE;
    _naviTitleLabel.textAlignment = NSTextAlignmentCenter;
    _naviTitleLabel.text = @"15:00";
    [titleBaseView addSubview:titleImageView];
    [titleBaseView addSubview:_naviTitleLabel];
    
    //设置导航栏标题视图
    self.navigationItem.titleView = titleBaseView;
    [self.navigationItem setHidesBackButton:YES];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_TITLE_WHITE}];
    
    self.navigationController.navigationBar.barTintColor = COLOR_NAVI_BLACK;
    self.navigationController.navigationBar.backgroundColor = COLOR_NAVI_BLACK;
}
#pragma mark - 初始化界面
-(void)initSubViews
{
    //导航地图View
    [self initDriveView];
    [self initDriveManager];
    [self initBottomView];
}
#pragma mark - Initalization（初始化）

- (void)initDriveManager
{
    if (self.driveManager == nil)
    {
        self.driveManager = [[AMapNaviDriveManager alloc] init];
        [self.driveManager setDelegate:self];
        
        //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
        [self.driveManager addDataRepresentative:self.driveView];
    }
}

- (void)initDriveView
{
    if (self.driveView == nil)
    {
        self.driveView = [[AMapNaviDriveView alloc] initWithFrame:CGRectMake(0, 64, WIDTH_VIEW, HEIGHT_VIEW - 184)];
        self.driveView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.driveView setDelegate:self];
        //设置导航视图
        self.driveView.showMoreButton = NO;
        self.driveView.showTrafficButton = NO;
        
        [self.view addSubview:self.driveView];
    }
}
- (void)initBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT_VIEW - 120, WIDTH_VIEW, 120)];
    bottomView.backgroundColor = BACKGROUND_COLOR;
    [self.view addSubview:bottomView];
    
    UIImageView *parkImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 12, 12)];
    parkImage.image = [UIImage imageNamed:@"navimap_停车场"];
    [bottomView addSubview:parkImage];
    _parkLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 12, WIDTH_VIEW - 36, 12)];
    _parkLabel.text = @"科陆大厦停车场（2元/小时）";
    _parkLabel.textColor = COLOR_TITLE_GRAY;
    _parkLabel.font = [UIFont systemFontOfSize:12.0];
    [bottomView addSubview:_parkLabel];
    
    UIImageView *locationImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 36, 12, 12)];
    locationImage.image = [UIImage imageNamed:@"navimap_地址"];
    [bottomView addSubview:locationImage];
    _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 36, WIDTH_VIEW - 36, 12)];
    _locationLabel.text = @"南山区科技园北区宝深路科陆大厦B1层";
    _locationLabel.textColor = COLOR_TITLE_GRAY;
    _locationLabel.font = [UIFont systemFontOfSize:12.0];
    [bottomView addSubview:_locationLabel];
    
    UIImageView *tollImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 60, 12, 12)];
    tollImage.image = [UIImage imageNamed:@"navimap_收费员"];
    [bottomView addSubview:tollImage];
    _tollLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 60, WIDTH_VIEW - 36, 12)];
    _tollLabel.text = @"谢师傅  总分：4.8";
    _tollLabel.textColor = COLOR_TITLE_GRAY;
    _tollLabel.font = [UIFont systemFontOfSize:12.0];
    [bottomView addSubview:_tollLabel];
    
    UIImageView *moneyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH_VIEW / 2, 60, 12, 12)];
    moneyImageView.image = [UIImage imageNamed:@"navimap_小费金额"];
    [bottomView addSubview:moneyImageView];
    _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH_VIEW / 2 + 24, 60, WIDTH_VIEW / 2, 12)];
    _moneyLabel.text = @"0元";
    _moneyLabel.textColor = COLOR_TITLE_GRAY;
    _moneyLabel.font = [UIFont systemFontOfSize:12.0];
    [bottomView addSubview:_moneyLabel];
    
    UIView *cutline_H = [[UIView alloc] initWithFrame:CGRectMake(0, 84, WIDTH_VIEW, 1)];
    cutline_H.backgroundColor = COLOR_TITLE_GRAY;
    [bottomView addSubview:cutline_H];
    UIView *cutline_V = [[UIView alloc] initWithFrame:CGRectMake(WIDTH_VIEW / 2, 84, 1, 36)];
    cutline_V.backgroundColor = COLOR_TITLE_GRAY;
    [bottomView addSubview:cutline_V];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 85, WIDTH_VIEW / 2 - 1, 35)];
    [cancelButton addTarget:self action:@selector(clickCancelOrderButton) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
    [cancelButton setTitleColor:COLOR_TITLE_GRAY forState:UIControlStateNormal];
    [bottomView addSubview:cancelButton];
    
    UIButton *callTollButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH_VIEW / 2, 85, WIDTH_VIEW / 2 - 1, 35)];
    [callTollButton addTarget:self action:@selector(clickCallMepButton) forControlEvents:UIControlEventTouchUpInside];
    [callTollButton setTitle:@"联系收费员" forState:UIControlStateNormal];
    [callTollButton setTitleColor:COLOR_BUTTON_RED forState:UIControlStateNormal];
    [bottomView addSubview:callTollButton];
}
-(void)updateBottomViewWithData:(NKGuidePageData *)guidePageData
{
    _parkLabel.text = [NSString stringWithFormat:@"%@ (%d元/小时)", guidePageData.parkingName, guidePageData.parkingFee.intValue / 100];
    _locationLabel.text = [NSString stringWithFormat:@"%@", guidePageData.parkingAddress];
    _tollLabel.text = [NSString stringWithFormat:@"%@ 总分%.2f", guidePageData.mepPersonnelName, guidePageData.mepPersonnelScore];
    _moneyLabel.text = [NSString stringWithFormat:@"%d", _parameters.bookingFee + _parameters.tip];
}
//- (void)initMoreMenu
//{
//    if (self.moreMenu == nil)
//    {
//        self.moreMenu = [[MoreMenuView alloc] init];
//        self.moreMenu.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//        
//        [self.moreMenu setDelegate:self];
//    }
//}
#pragma mark - Route Plan(路线规划)

- (void)calculateRoute
{
//    self.startPoint = [AMapNaviPoint locationWithLatitude:22.561028 longitude:113.941405];
//    self.endPoint   = [AMapNaviPoint locationWithLatitude:39.908791 longitude:116.321257];
    //进行路径规划
    [self.driveManager calculateDriveRouteWithStartPoints:@[self.startPoint]
                                                endPoints:@[self.endPoint]
                                                wayPoints:nil
                                          drivingStrategy:17];
}

#pragma mark - AMapNaviDriveManager Delegate(driveManager 代理方法)

- (void)driveManager:(AMapNaviDriveManager *)driveManager error:(NSError *)error
{
    NSLog(@"error:{%ld - %@}", (long)error.code, error.localizedDescription);
}

- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"onCalculateRouteSuccess");
    
    //算路成功后开始GPS导航
    [self.driveManager startGPSNavi];
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteFailure:(NSError *)error
{
    NSLog(@"onCalculateRouteFailure:{%ld - %@}", (long)error.code, error.localizedDescription);
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager didStartNavi:(AMapNaviMode)naviMode
{
    NSLog(@"didStartNavi");
}

- (void)driveManagerNeedRecalculateRouteForYaw:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"needRecalculateRouteForYaw");
}

- (void)driveManagerNeedRecalculateRouteForTrafficJam:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"needRecalculateRouteForTrafficJam");
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager onArrivedWayPoint:(int)wayPointIndex
{
    NSLog(@"onArrivedWayPoint:%d", wayPointIndex);
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
    
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:soundString];
}

- (void)driveManagerDidEndEmulatorNavi:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"didEndEmulatorNavi");
}

- (void)driveManagerOnArrivedDestination:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"onArrivedDestination");
}
#pragma mark - AMapNaviWalkViewDelegate
//点击取消按钮回调方法
- (void)driveViewCloseButtonClicked:(AMapNaviDriveView *)driveView
{
    
//    [self.navigationController popViewControllerAnimated:YES];
    //取消订单
    UIWindow *mainWindow = [[UIApplication sharedApplication].windows lastObject];
    self.alertView = [[NKAlertView alloc] initWithAlertViewType:NKAlertViewTypeCancelOrder];
    float deductMoney = _parameters.tip + _parameters.bookingFee;
    self.alertView.deductLabel.text = [NSString stringWithFormat:@"现在取消订单，将扣除您%.2f元手续费", deductMoney];
    [mainWindow addSubview:self.alertView.bGView];
    [mainWindow addSubview:self.alertView];
    [self.alertView show:YES];
    
    [self.alertView.sureButton addTarget:self action:@selector(clickAlertSureButton) forControlEvents:UIControlEventTouchUpInside];
    [self.alertView.cancelButton addTarget:self action:@selector(clickAlertCancelButton) forControlEvents:UIControlEventTouchUpInside];
}
//点击...按钮回调方法
- (void)driveViewMoreButtonClicked:(AMapNaviDriveView *)driveView
{
    //配置MoreMenu状态
//    [self.moreMenu setTrackingMode:self.driveView.trackingMode];
//    [self.moreMenu setShowNightType:self.driveView.showStandardNightType];
//    
//    [self.moreMenu setFrame:self.view.bounds];
//    [self.view addSubview:self.moreMenu];
}

- (void)driveViewTrunIndicatorViewTapped:(AMapNaviDriveView *)driveView
{
    NSLog(@"TrunIndicatorViewTapped");
}

- (void)driveView:(AMapNaviDriveView *)driveView didChangeShowMode:(AMapNaviDriveViewShowMode)showMode
{
    NSLog(@"didChangeShowMode:%ld", (long)showMode);
}
#pragma mark - 点击button相关方法
-(void)clickCancelOrderButton
{
    UIWindow *mainWindow = [[UIApplication sharedApplication].windows lastObject];
    self.alertView = [[NKAlertView alloc] initWithAlertViewType:NKAlertViewTypeCancelOrder];
    float deductMoney = _parameters.tip + _parameters.bookingFee;
    self.alertView.deductLabel.text = [NSString stringWithFormat:@"现在取消订单，将扣除您%.2f元手续费", deductMoney];
    [mainWindow addSubview:self.alertView.bGView];
    [mainWindow addSubview:self.alertView];
    [self.alertView show:YES];
    
    [self.alertView.sureButton addTarget:self action:@selector(clickAlertSureButton) forControlEvents:UIControlEventTouchUpInside];
    [self.alertView.cancelButton addTarget:self action:@selector(clickAlertCancelButton) forControlEvents:UIControlEventTouchUpInside];
}
-(void)clickCallMepButton
{
    [self callMepByPhoneNumber];
}
-(void)clickAlertSureButton
{
    //隐藏弹框
    [_alertView hide:YES];
    //取消订单
    [self cancelOrder];
    //停止导航
    [self.driveManager stopNavi];
    [self.driveManager removeDataRepresentative:self.driveView];
    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
}
-(void)clickAlertCancelButton
{
    [self.alertView hide:YES];
}
#pragma mark - 调用通话功能
- (void)callMepByPhoneNumber
{
    
    UIWebView *callWebview =[[UIWebView alloc] init];
    //NSURL *telURL =[NSURL URLWithString:@"tel:10086"];// 貌似tel:// 或者 tel: 都行
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", _guidePageData.mepPersonnelPhone]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    //记得添加到view上
    [self.view addSubview:callWebview];
}
#pragma mark - 网络请求方法
- (void)sendPostToGetInitData
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:_orderNumber forKey:@"orderNo"];
    _dataManager = [NKDataManager sharedDataManager];
    [_dataManager POSTGetOneKeyOrderNaviViewDataWithParameters:parameters Success:^(NKSspOrderBackValue *backValue) {
        if (backValue.ret == 0)
        {
            NSLog(@"获取导航页面数据成功");
            _guidePageData = [NKGuidePageData mj_objectWithKeyValues:backValue.obj];
            _endPoint = [AMapNaviPoint locationWithLatitude:_guidePageData.lat longitude:_guidePageData.lng];
            //开始导航,路线规划
            //保存下起点坐标
            NSData *pointData = [NSKeyedArchiver archivedDataWithRootObject:self.startPoint];
            [[NSUserDefaults standardUserDefaults] setObject:pointData forKey:@"NaviStartPoint"]
            ;
            NSData *parametrsData = [NSKeyedArchiver archivedDataWithRootObject:self.parameters];
            [[NSUserDefaults standardUserDefaults] setObject:parametrsData forKey:@"SspOrderParameters"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateBottomViewWithData:_guidePageData];
                //获取到终点停车场后开始规划路线
                [self calculateRoute];
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
-(void)cancelOrder
{
    //根据时间计算相关参数
    NSString *cancelReason;
    NSInteger isOverTime;
    NSInteger cancelType;
    if (_timeout >= 13 * 60)
    {
        //在两分钟内取消
        cancelReason = @"用户2分钟内取消订单";
        isOverTime = 0;
        cancelType = 1;
    }
    else if (_timeout >= 0 && _timeout < 13 * 60)
    {
        //超过两分钟，在15分钟内取消
        cancelReason = @"用户2分钟后取消订单";
        isOverTime = 1;
        cancelType = 1;
    }
    else
    {
        //超过15分钟
        cancelReason = @"超时取消订单";
        isOverTime = 1;
        cancelType = 2;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_parameters.license forKey:@"license"];//车牌号
    [parameters setValue:[NSNumber numberWithInteger:_parameters.bookingFee * 100] forKey:@"bookingFee"];//预约费(服务费) 分
    [parameters setValue:[NSNumber numberWithInteger:_parameters.tip * 100] forKey:@"tip"];//小费 分
    [parameters setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"sspId"] forKey:@"sspId"];//sspid
    [parameters setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"] forKey:@"clientId"];//推送服务令牌（设备唯一标识），用于标识推送信息接收者身份
    [parameters setValue:_orderNumber forKey:@"orderNo"];//订单号
    [parameters setValue:cancelReason forKey:@"cancelReason"];//取消原因
    [parameters setValue:[NSNumber numberWithInteger:isOverTime] forKey:@"isOvertime"];//订单是否超时,0-未超时,1-超时
    [parameters setValue:[NSNumber numberWithInteger:cancelType] forKey:@"cancelType"];//取消类型,  0-取消呼叫,1-终止呼叫,2-超时取消
    
    [[NSUserDefaults standardUserDefaults] setObject:parameters forKey:@"cancelOrderParameters"];
    //取消订单
    _dataManager = [NKDataManager sharedDataManager];
    [_dataManager POSTCancelOneKeyOrderWithParameters:parameters Success:^(NKSspOrderBackValue *backValue) {
        if (backValue.ret == 0)
        {
            NSLog(@"取消订单成功！");
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"orderNo"];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"取消订单成功！";
            if (_timer != nil)
            {
                [self stopTimer];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:2.0];
                [hud removeFromSuperViewOnHide];
                [_alertView hide:YES];
                //停止导航
                [self.driveManager stopNavi];
                [self.driveManager removeDataRepresentative:self.driveView];
                //停止语音
                [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
                //界面消失
                [self dismissNaviController];
                
            });
        }
        else
        {
            NSLog(@"%@", backValue.msg);
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = backValue.msg;
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:2.0];
                [hud removeFromSuperViewOnHide];
            });
        }
    } Failure:^(NSError *error) {
        NSLog(@"%@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"网络连接失败！";
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:2.0];
            [hud removeFromSuperViewOnHide];
        });
    }];

}
//应急处理-停止呼叫
- (void)endCallBerth
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:_parameters.sspId forKey:@"sspId"];
    _dataManager = [NKDataManager sharedDataManager];
    [_dataManager POSTEndCallWithParameters:parameters Success:^(NKSspOrderBackValue *backValue) {
        if (backValue.ret == 0)
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = backValue.msg;
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:2.0];
                [hud removeFromSuperViewOnHide];
                [self dismissNaviController];
            });
        }
        else
        {
            NSLog(@"%@", backValue.msg);
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = backValue.msg;
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:2.0];
                [hud removeFromSuperViewOnHide];
            });
        }
    } Failure:^(NSError *error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"网络连接失败！";
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:2.0];
            [hud removeFromSuperViewOnHide];
        });
    }];
}
#pragma mark - 存储推出该导航界面的信息，用于恢复
- (void)saveDataToResume
{
    //存储订单号，参数，用来重新登录时检测订单存在
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_parameters];
    [[NSUserDefaults standardUserDefaults] setObject:_orderNumber forKey:@"orderNo"];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"naviParametersData"];
    [[NSUserDefaults standardUserDefaults] setFloat:(float)_startPoint.latitude forKey:@"startPoint_lat"];
    [[NSUserDefaults standardUserDefaults] setFloat:(float)_startPoint.longitude forKey:@"startPoint_lng"];
}
#pragma mark - 收到推送消息
- (void)parkingSuccess
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"orderNo"];
    [self dismissNaviController];
}
-(void)getGTMsg:(NSNotification *)notification
{
    if (_timer)
    {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    NSString *alertStr = [notification.userInfo objectForKey:@"payloadMsg"];

    if ([alertStr hasSuffix:@"1003"])
    {
        //车位预留失败
        UIWindow *mainWindow = [[UIApplication sharedApplication].windows lastObject];
        _alertView = [[NKAlertView alloc] initWithAlertViewType:NKAlertViewTypeFailedToReserveBerth];
        [mainWindow addSubview:self.alertView.bGView];
        [mainWindow addSubview:self.alertView];
        [self.alertView show:YES];
        [_alertView.continueCreateOrderButton addTarget:self action:@selector(clickContinueCreateOrderButton) forControlEvents:UIControlEventTouchUpInside];
//        [_alertView.systemSendOrderButton addTarget:self action:@selector(clickSystemSendBerthButton) forControlEvents:UIControlEventTouchUpInside];
        [_alertView.endCallButton addTarget:self action:@selector(clickEndCallButton) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ([alertStr hasSuffix:@"1002"])
    {
        //停车成功
        UIWindow *mainWindow = [[UIApplication sharedApplication].windows lastObject];
        self.alertView = [[NKAlertView alloc] initWithAlertViewType:NKAlertViewTypeSuccessToPark];
        [mainWindow addSubview:self.alertView.bGView];
        [mainWindow addSubview:self.alertView];
        [self.alertView show:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - 弹框相关方法
- (void)clickContinueCreateOrderButton
{
    [_alertView hide:YES];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isContinueCreateOrder"];
    [self dismissNaviController];
}
//- (void)clickSystemSendBerthButton
//{
////    [_alertView hide:YES];
////    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isSystemSendBerth"];
////    [self dismiss];
//    [_alertView hide:YES];
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isContinueCreateOrder"];
//    [self dismissNaviController];
//}
- (void)clickEndCallButton
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"orderNo"];
    [_alertView hide:YES];
    [self endCallBerth];
    [self dismissNaviController];
}

@end
