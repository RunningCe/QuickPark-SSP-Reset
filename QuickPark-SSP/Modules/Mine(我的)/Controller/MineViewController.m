
//
//  MineViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 2016/11/15.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "MineViewController.h"
#import "NKCarView.h"
#import "NKBerthView.h"
#import "AddCarsViewController.h"
#import "PersonalInfoTableViewController.h"
#import "NKDataManager.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "ManageCarViewController.h"
#import "NKColorManager.h"
#import "PassCardViewController.h"
#import "MassageCenterTableViewController.h"
#import "PayViewController.h"
#import "CouponViewController.h"
#import "ParkingRecordTableViewController.h"
#import "LocalPassportViewController.h"
#import "NKPageControl.h"
#import "NKAlertView.h"
#import "NKImageManager.h"

@interface MineViewController ()
@property (weak, nonatomic) IBOutlet UIView *topBaseView;
@property (weak, nonatomic) IBOutlet UIView *carBaseView;
@property (weak, nonatomic) IBOutlet UIView *berthBaseView;
@property (weak, nonatomic) IBOutlet UIView *bottomBaseView;

//topView
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nilNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UIView *membershipBaseView;
@property (weak, nonatomic) IBOutlet UILabel *membershipLabel;
//bottomView
@property (weak, nonatomic) IBOutlet UILabel *rechargeLabel;
@property (weak, nonatomic) IBOutlet UILabel *billLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkingFans;
@property (weak, nonatomic) IBOutlet UILabel *achievementLabel;

@property (nonatomic, strong) NKCarView *defaultCarView;

//车辆,车场scrollView
@property (nonatomic, strong) UIScrollView *carScrollView;
@property (nonatomic, strong) UIScrollView *berthScrollView;

//小圆点
@property (nonatomic, strong)NKPageControl *carPageControl;
@property (nonatomic, strong)NKPageControl *berthPageControl;

//车辆数组
@property (nonatomic, strong) NSMutableArray *carMutableArray;
//车位数组
@property (nonatomic, strong) NSMutableArray *berthMutableArray;
//最近一次停车记录数组
@property (nonatomic, strong) NSMutableArray *recordMutableArray;

@end

@implementation MineViewController
- (NSMutableArray *)carMutableArray
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
        }
    }
    return _carMutableArray;
}
- (NSMutableArray *)berthMutableArray
{
    if (!_berthMutableArray)
    {
        _berthMutableArray = [NSMutableArray array];
        NSArray *berthDataArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"berthArray"];
        if(!berthDataArray)
        {
            NSLog(@"没有车位");
            return _berthMutableArray;
        }
        for (NSData *berthData in berthDataArray)
        {
            NKBerth *berth = [NSKeyedUnarchiver unarchiveObjectWithData:berthData];
            [_berthMutableArray addObject:berth];
        }
    }
    return _berthMutableArray;
}
- (NSMutableArray *)recordMutableArray
{
    if (!_recordMutableArray)
    {
        _recordMutableArray = [NSMutableArray array];
    }
    return _recordMutableArray;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self postToGetLatestRecords];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self createTopBaseView];
    [self createCarBaseView];
    //[self createBerthBaseView];
    [self createBottomBaseView];
    
    [self updateLatestCarRecord];
    
    [self.view layoutIfNeeded];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self configPageControl];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //每次界面消失时都清空车辆车位数组，保证每次进入都重新从内存中加载
    [self.carMutableArray removeAllObjects];
    self.carMutableArray = nil;
    [self.berthMutableArray removeAllObjects];
    self.berthMutableArray = nil;
    //将车辆滚动视图从界面上删除，方便之后重新加载
    [self.carScrollView removeFromSuperview];
    [self.berthScrollView removeFromSuperview];
}
#pragma mark - 界面的初始化
- (void)createTopBaseView
{
    _topBaseView.backgroundColor = COLOR_VIEW_BLACK;
    _membershipBaseView.layer.cornerRadius = CORNERRADIUS * 2;
    _membershipBaseView.layer.masksToBounds = YES;
    _membershipBaseView.layer.borderWidth = 1;
    _membershipBaseView.layer.borderColor = [UIColor colorWithRed:51.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:1.0].CGColor;
    
    _iconImageView.layer.cornerRadius = _iconImageView.frame.size.width / 2;
    _iconImageView.layer.masksToBounds = YES;
    _nilNameLabel.textColor = COLOR_TITLE_WHITE;
    _signLabel.textColor = COLOR_TITLE_WHITE;
    _membershipLabel.textColor = COLOR_TITLE_WHITE;
    
    //将loginMsg上的数据添加到界面上
    //头像
    NSString *iconUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"];
    NSData *imageData = [NKImageManager getImageDataWithUrl:iconUrl];
    UIImage *iconImage = [UIImage imageWithData:imageData];
    if (iconImage == nil)
    {
        _iconImageView.image = [UIImage imageNamed:@"头像"];
    }
    else
    {
        _iconImageView.image = iconImage;
    }
    //昵称
    NSString *nilName = [[NSUserDefaults standardUserDefaults] objectForKey:@"niName"];
    if (nilName.length == 0)
    {
        _nilNameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
    }
    else
    {
        _nilNameLabel.text = nilName;
    }
    //签名
    NSString *signatrue = [[NSUserDefaults standardUserDefaults] objectForKey:@"signature"];
    _signLabel.text = signatrue;
    //会籍
    NSString *membership = [[NSUserDefaults standardUserDefaults] objectForKey:@"userType"];
    if (membership.length == 0)
    {
        _membershipLabel.text = @"普通会籍";
    }
    else
    {
        _membershipLabel.text = membership;
    }
}
- (void)createCarBaseView
{
    if (self.carMutableArray.count == 0)
    {
        CGFloat btnW = 108;
        CGFloat btnH = 32;
        CGFloat baseViewH = HEIGHT_VIEW * 0.18;
        UIButton *carButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH_VIEW - btnW) / 2, (baseViewH - btnH) / 2, btnW, btnH)];
        [carButton setTitle:@"新增车辆" forState:UIControlStateNormal];
        [carButton setTitleColor:COLOR_TITLE_GRAY forState:UIControlStateNormal];
        carButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [carButton addTarget:self action:@selector(clickAddCarButton) forControlEvents:UIControlEventTouchUpInside];
        carButton.layer.cornerRadius = CORNERRADIUS;
        carButton.layer.masksToBounds = YES;
        //画虚线
        CAShapeLayer *border = [CAShapeLayer layer];
        border.strokeColor = COLOR_TITLE_GRAY.CGColor;
        border.fillColor = nil;
        border.path = [UIBezierPath bezierPathWithRect:carButton.bounds].CGPath;
        border.frame = carButton.bounds;
        border.lineWidth = 1.5f;
        border.lineCap = @"square";
        border.lineDashPattern = @[@4, @6];
        [carButton.layer addSublayer:border];
        
        [_carBaseView addSubview:carButton];
        _carBaseView.backgroundColor = COLOR_VIEW_BLACK;
        return;
    }
    else
    {
        UIScrollView *carScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW, HEIGHT_VIEW * 0.18)];
        self.carScrollView = carScrollView;
        carScrollView.tag = 1001;
        carScrollView.delegate = self;
        carScrollView.contentSize = CGSizeMake(carScrollView.frame.size.width * 2, carScrollView.frame.size.height);
        //1.创建添加车辆的baseView
        UIView *addCarBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, carScrollView.bounds.size.width, carScrollView.bounds.size.height)];
        CGFloat btnW = 108;
        CGFloat btnH = 32;
        CGFloat baseViewH = HEIGHT_VIEW * 0.18;
        UIButton *carButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH_VIEW - btnW) / 2, (baseViewH - btnH) / 2, btnW, btnH)];
        [carButton setTitle:@"新增车辆" forState:UIControlStateNormal];
        [carButton setTitleColor:COLOR_TITLE_GRAY forState:UIControlStateNormal];
        carButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [carButton addTarget:self action:@selector(clickAddCarButton) forControlEvents:UIControlEventTouchUpInside];
        carButton.layer.cornerRadius = CORNERRADIUS;
        carButton.layer.masksToBounds = YES;
        //画虚线
        CAShapeLayer *border = [CAShapeLayer layer];
        border.strokeColor = COLOR_TITLE_GRAY.CGColor;
        border.fillColor = nil;
        border.path = [UIBezierPath bezierPathWithRect:carButton.bounds].CGPath;
        border.frame = carButton.bounds;
        border.lineWidth = 1.5f;
        border.lineCap = @"square";
        border.lineDashPattern = @[@4, @6];
        [carButton.layer addSublayer:border];
        addCarBaseView.backgroundColor = COLOR_VIEW_BLACK;
        [addCarBaseView addSubview:carButton];
        [carScrollView addSubview:addCarBaseView];
        //2.1获取默认车辆
        NKCar *defaultCar;
        for (NKCar *car in self.carMutableArray)
        {
            if (car.isDefaultCar) {
                defaultCar = car;
                break;
            }
        }
        if (!defaultCar)
        {
            //没有设置默认车辆，选择第一辆车
            defaultCar = [self.carMutableArray firstObject];
        }
        //2.2根据车辆认证类型判断添加的界面
        NKCarView *carView;
        if (defaultCar.auditFlag == 0)
        {
            carView = [NKCarView carViewWithTypeWithType:NKCarViewTypeNew];
        }
        else if (defaultCar.auditFlag == 1)
        {
            carView = [NKCarView carViewWithTypeWithType:NKCarViewTypeIsCertificating];
            
            carView.tagImageView.image = [carView.tagImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            if (defaultCar.colourCard)
            {
                carView.tagImageView.tintColor = [NKColorManager colorWithStr:defaultCar.colourCard alpha:1.0];
            }
            if (defaultCar.carseries) {
                carView.carBrandLabel.text = defaultCar.carseries;
            }
            if (defaultCar.carseriespic) {
                carView.carLogoImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:defaultCar.carseriespic]]];
            }
        }
        else if (defaultCar.auditFlag == 2)
        {
            carView = [NKCarView carViewWithTypeWithType:NKCarViewTypeCertificateSuccess];
            
            carView.tagImageView.image = [carView.tagImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            if (defaultCar.colourCard)
            {
                carView.tagImageView.tintColor = [NKColorManager colorWithStr:defaultCar.colourCard alpha:1.0];
            }
            if (defaultCar.carseries) {
                carView.carBrandLabel.text = defaultCar.carseries;
            }
            if (defaultCar.carseriespic) {
                carView.carLogoImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:defaultCar.carseriespic]]];
            }
        }
        else if (defaultCar.auditFlag == 3)
        {
            carView = [NKCarView carViewWithTypeWithType:NKCarViewTypeCertificateFaile];
        }
        carView.frame = CGRectMake(carScrollView.frame.size.width, 0, carScrollView.frame.size.width, carScrollView.frame.size.height);
        carView.licenseLabel.text = defaultCar.license;
        [carView.topButton addTarget:self action:@selector(clickCarTopButton) forControlEvents:UIControlEventTouchUpInside];
        [carScrollView addSubview:carView];
        self.defaultCarView = carView;
        
        //3.设置scrossview
        [_carBaseView addSubview:carScrollView];
        _carBaseView.backgroundColor = COLOR_VIEW_BLACK;
        //到达边缘不弹跳
        carScrollView.bounces = NO;
        //整页滚动
        carScrollView.pagingEnabled = YES;
        //设置不显示水平滚动提示条
        carScrollView.showsHorizontalScrollIndicator = NO;
        //滚动一个屏显示第一个车
        carScrollView.contentOffset = CGPointMake(WIDTH_VIEW, 0);
    }
    
}
- (void)createBerthBaseView
{
    if (self.berthMutableArray.count == 0)
    {
        CGFloat btnW = 108;
        CGFloat btnH = 32;
        CGFloat baseViewH = HEIGHT_VIEW * 0.18;
        UIButton *berthButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH_VIEW - btnW) / 2, (baseViewH - btnH) / 2, btnW, btnH)];
        [berthButton setTitle:@"新增车位" forState:UIControlStateNormal];
        [berthButton setTitleColor:COLOR_TITLE_GRAY forState:UIControlStateNormal];
        berthButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [berthButton addTarget:self action:@selector(clickAddBerthButton) forControlEvents:UIControlEventTouchUpInside];
        berthButton.layer.cornerRadius = CORNERRADIUS;
        berthButton.layer.masksToBounds = YES;
        //画虚线
        CAShapeLayer *border = [CAShapeLayer layer];
        border.strokeColor = COLOR_TITLE_GRAY.CGColor;
        border.fillColor = nil;
        border.path = [UIBezierPath bezierPathWithRect:berthButton.bounds].CGPath;
        border.frame = berthButton.bounds;
        border.lineWidth = 1.5f;
        border.lineCap = @"square";
        border.lineDashPattern = @[@4, @6];
        [berthButton.layer addSublayer:border];
        
        [_berthBaseView addSubview:berthButton];
        _berthBaseView.backgroundColor = COLOR_VIEW_BLACK;
        return;
    }
    else
    {
        UIScrollView *berthScrollView = [[UIScrollView alloc] init];
        self.berthScrollView = berthScrollView;
        berthScrollView.tag = 1002;
        berthScrollView.delegate = self;
        berthScrollView.frame = CGRectMake(0, 0, WIDTH_VIEW, HEIGHT_VIEW * 0.18);
        berthScrollView.contentSize = CGSizeMake((self.berthMutableArray.count + 1) * berthScrollView.frame.size.width, berthScrollView.frame.size.height);
        for (int i = 0; i < self.berthMutableArray.count; i++)
        {
            NKBerthView *berthView = [NKBerthView berthView];
            berthView.frame = CGRectMake((i + 1) * berthScrollView.frame.size.width, 0, berthScrollView.frame.size.width, berthScrollView.frame.size.height);
            NKBerth *berth = self.berthMutableArray[i];
            if (berth.parkingNo.length == 4)
            {
                berthView.numberLabel_0.text = [NSString stringWithFormat:@"%@",[berth.parkingNo substringWithRange:NSMakeRange(0, 1)]];
                berthView.numberLabel_1.text = [NSString stringWithFormat:@"%@",[berth.parkingNo substringWithRange:NSMakeRange(1, 1)]];
                berthView.numberLabel_2.text = [NSString stringWithFormat:@"%@",[berth.parkingNo substringWithRange:NSMakeRange(2, 1)]];
                berthView.numberLabel_3.text = [NSString stringWithFormat:@"%@",[berth.parkingNo substringWithRange:NSMakeRange(3, 1)]];
            }
            [berthScrollView addSubview:berthView];
        }
        //增加添加车位baseView
        UIView *addBerthBaseViwe = [[UIView alloc] initWithFrame:CGRectMake(0, 0, berthScrollView.bounds.size.width, berthScrollView.bounds.size.height)];
        
        CGFloat btnW = 108;
        CGFloat btnH = 32;
        CGFloat baseViewH = HEIGHT_VIEW * 0.18;
        UIButton *berthButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH_VIEW - btnW) / 2, (baseViewH - btnH) / 2, btnW, btnH)];
        [berthButton setTitle:@"新增车场" forState:UIControlStateNormal];
        [berthButton setTitleColor:COLOR_TITLE_GRAY forState:UIControlStateNormal];
        berthButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [berthButton addTarget:self action:@selector(clickAddBerthButton) forControlEvents:UIControlEventTouchUpInside];
        berthButton.layer.cornerRadius = CORNERRADIUS;
        berthButton.layer.masksToBounds = YES;
        //画虚线
        CAShapeLayer *border = [CAShapeLayer layer];
        border.strokeColor = COLOR_TITLE_GRAY.CGColor;
        border.fillColor = nil;
        border.path = [UIBezierPath bezierPathWithRect:berthButton.bounds].CGPath;
        border.frame = berthButton.bounds;
        border.lineWidth = 1.5f;
        border.lineCap = @"square";
        border.lineDashPattern = @[@4, @6];
        [berthButton.layer addSublayer:border];
        
        addBerthBaseViwe.backgroundColor = COLOR_VIEW_BLACK;
        [addBerthBaseViwe addSubview:berthButton];
        [berthScrollView addSubview:addBerthBaseViwe];
        [_berthBaseView addSubview:berthScrollView];
        //到达边缘不弹跳
        berthScrollView.bounces = NO;
        //整页滚动
        berthScrollView.pagingEnabled = YES;
        //设置不显示水平滚动提示条
        berthScrollView.showsHorizontalScrollIndicator = NO;
        //滚动一个屏显示第一个车
        berthScrollView.contentOffset = CGPointMake(WIDTH_VIEW, 0);
    }
}
- (void)createBottomBaseView
{
    _bottomBaseView.backgroundColor = COLOR_VIEW_BLACK;
    
    _rechargeLabel.textColor = COLOR_TITLE_GRAY;
    _billLabel.textColor = COLOR_TITLE_GRAY;
    _recordLabel.textColor = COLOR_TITLE_GRAY;
    _couponLabel.textColor = COLOR_TITLE_GRAY;
    _parkingFans.textColor = COLOR_TITLE_GRAY;
    _achievementLabel.textColor = COLOR_TITLE_GRAY;
}
//配置小圆点
-(void)configPageControl
{
    //创建
    _carPageControl = [[NKPageControl alloc] initWithStyle:NKPageControlStyleMain];
    //常规设置
    _carPageControl.frame = CGRectMake(0 , 0, WIDTH_VIEW, 20);//小圆点控件的大小位置
    if (self.carMutableArray.count == 0)
    {
        _carPageControl.numberOfPages = 0;//小圆点个数
    }
    else
    {
        _carPageControl.numberOfPages = 2;//小圆点个数
    }
    _carPageControl.currentPage = 1;
    //配置颜色
    //    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    //    pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    _carPageControl.userInteractionEnabled = NO;//关闭与  用户的交互
    //添加导视图中
    [_carBaseView addSubview:_carPageControl];
    
    _berthPageControl = [[NKPageControl alloc] initWithStyle:NKPageControlStyleMain];
    _berthPageControl.frame = CGRectMake(0 , 0, WIDTH_VIEW, 20);
    if (self.berthMutableArray.count == 0)
    {
        _berthPageControl.numberOfPages = 0;
    }
    else
    {
        _berthPageControl.numberOfPages = self.berthMutableArray.count + 1;
    }
    _berthPageControl.currentPage = 1;
    _berthPageControl.userInteractionEnabled = NO;
    [_berthBaseView addSubview:_berthPageControl];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(nonnull UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    if (scrollView.tag == 1001)
    {
        _carPageControl.currentPage = round(offset.x / scrollView.frame.size.width);//round四舍五入函数
    }
    else
    {
        _berthPageControl.currentPage = round(offset.x / scrollView.frame.size.width);//round四舍五入函数
    }
}
#pragma mark - button相关方法
- (IBAction)clickTopBaseViewTopLeftButton:(UIButton *)sender
{
    PersonalInfoTableViewController *pitvc = [[PersonalInfoTableViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:pitvc];
    [self presentViewController:navi animated:YES completion:nil];
    
}
- (IBAction)clickTopBaseViewTopRightButton:(UIButton *)sender
{
    PassCardViewController *pcvc = [[PassCardViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:pcvc];
    [self presentViewController:navi animated:YES completion:nil];
}
- (void)clickCarTopButton
{
    ManageCarViewController *mcVC = [[ManageCarViewController alloc] init];
    if (self.carPageControl.currentPage == 0)
    {
        //如果是最后一个页面，则将车辆数组下标设置为0
        mcVC.index = 0;
    }
    mcVC.index = self.carPageControl.currentPage - 1;
    mcVC.loginMsg = self.loginMsg;
    mcVC.recordMutableArray = self.recordMutableArray;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:mcVC];
    [self presentViewController:navi animated:YES completion:nil];
}
- (void)clickAddCarButton
{
    AddCarsViewController *acVC = [[AddCarsViewController alloc] init];
    acVC.user = self.loginMsg.user;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:acVC];
    [self presentViewController:navi animated:YES completion:nil];
}
- (void)clickAddBerthButton
{
    NSLog(@"添加车位");
}
#pragma mark - 底部六个按钮
//充值
- (IBAction)clickRechargeButton:(UIButton *)sender
{
    PayViewController *payVC = [[PayViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:payVC];
    [self.tabBarController presentViewController:navi animated:YES completion:nil];
}
//发票
- (IBAction)clickBillButton:(UIButton *)sender
{
    NSLog(@"发票");
    NKAlertView *alertView = [[NKAlertView alloc] initWithAlertViewType:NKAlertViewTypeInfomation Height:172 andWidth:WIDTH_VIEW - 60];
    [alertView show:YES];
}
//卡券
- (IBAction)clickRecordButton:(UIButton *)sender
{
    CouponViewController *cCV = [[CouponViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:cCV];
    [self.tabBarController presentViewController:navi animated:YES completion:nil];
}
//消息
- (IBAction)clickCouponButton:(UIButton *)sender
{
    MassageCenterTableViewController *mcTVC = [[MassageCenterTableViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:mcTVC];
    [self presentViewController:navi animated:YES completion:nil];
}
//记录
- (IBAction)clickParkingFansButton:(UIButton *)sender
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"myToken"];
    ParkingRecordTableViewController *prtVC = [[ParkingRecordTableViewController alloc] initWithToken:token];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:prtVC];
    [self.tabBarController presentViewController:navi animated:YES completion:nil];
}
//本地通
- (IBAction)clickAchievementButton:(UIButton *)sender
{
    LocalPassportViewController *lpTVC = [[LocalPassportViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lpTVC];
    [self.tabBarController presentViewController:navi animated:YES completion:nil];
}
#pragma mark - 网络请求
- (void)postToGetLatestRecords
{
    MBProgressHUD *waitHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    waitHUD.mode = MBProgressHUDModeIndeterminate;
    waitHUD.bezelView.color = COLOR_HUD_BLACK;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"sspId"] forKey:@"sspId"];
    NKDataManager *dataManager = [NKDataManager sharedDataManager];
    [dataManager POSTGetLatestStopRecordWithParameters:parameters Success:^(NSMutableArray *mutableArray) {
        self.recordMutableArray = [NSMutableArray arrayWithArray:mutableArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [waitHUD hideAnimated:YES];
            [waitHUD removeFromSuperViewOnHide];
            [self updateLatestCarRecord];
        });
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [waitHUD hideAnimated:YES];
            [waitHUD removeFromSuperViewOnHide];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.bezelView.color = COLOR_HUD_BLACK;
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"网络异常";
            [hud hideAnimated:YES afterDelay:1.0];
            [hud removeFromSuperViewOnHide];
        });
    }];
}
#pragma mark - 刷新数据
- (void)updateLatestCarRecord
{
    for (int i = 0; i < self.recordMutableArray.count; i++)
    {
        NKStopLatestRecord *record = self.recordMutableArray[i];
        if ([self.defaultCarView.licenseLabel.text isEqualToString:record.license])
        {
            self.defaultCarView.parkingMsgLabel.text = [NSString stringWithFormat:@"上一次：%@ %ld小时 %.2f元", record.fullAddress, record.duration / 3600, (float)record.money / 100];
            break;
        }
    }
}
@end
