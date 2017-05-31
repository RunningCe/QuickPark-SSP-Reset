//
//  ManageCarViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 2016/12/14.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "ManageCarViewController.h"
#import "Masonry.h"
#import "NKSlider.h"
#import "NKLogin.h"
#import "NKDataManager.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "NKCarManagerTopView.h"
#import "NKCarManagerTopFirstView.h"
#import "NKColorManager.h"
#import "CarCertificateViewController.h"
#import "NKMainCarView.h"
#import "NKCarUncertificatedTableViewCell.h"
#import "NKCarCertificatedTableViewCell.h"
#import "NKStopLatestRecord.h"
#import "AddCarsViewController.h"
#import "NKChartManager.h"
#import "NKCarTotalExpendAndTime.h"
#import "NKImageManager.h"
#import "NKPageControl.h"
#import "NKAlertView.h"

#define CellHeight 44
#define cardColor_0 [UIColor colorWithRed:222.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:1.0]
#define cardColor_1 [UIColor colorWithRed:255.0/255.0 green:144.0/255.0 blue:0.0/255.0 alpha:1.0]
#define cardColor_2 [UIColor colorWithRed:184.0/255.0 green:224.0/255.0 blue:0.0/255.0 alpha:1.0]
#define cardColor_3 [UIColor colorWithRed:0.0/255.0 green:181.0/255.0 blue:175.0/255.0 alpha:1.0]
#define cardColor_4 [UIColor colorWithRed:174.0/255.0 green:0.0/255.0 blue:255.0/255.0 alpha:1.0]
#define cardColor_5 [UIColor colorWithRed:0.0/255.0 green:138.0/255.0 blue:225.0/255.0 alpha:1.0]

@interface ManageCarViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong)NKDataManager *dataManager;

//页面基本视图
@property (nonatomic, strong) UIView *topBaseView;
@property (nonatomic, strong) UITableView *carDetailBaseTableView;
@property (nonatomic, strong) UIView *carManagerBaseView;
@property (nonatomic, strong) NKPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic, strong) UIButton *certificateButton;
@property (nonatomic, strong) UIImageView *certificateCarImageView;
@property (nonatomic, strong) UIImageView *deleteCarImageView;
@property (nonatomic, strong) NKCarManagerTopFirstView *topManagerFirstView;

//主家车辆及其他车辆视图
@property (nonatomic, strong) UITableView *otherCarTableView;
@property (nonatomic, strong) NKMainCarView *mainCarView;
@property (nonatomic, strong) UIView *mainCarBaseView;

//车辆数组
@property (nonatomic, strong) NSMutableArray *carsMutableArray;
@property (nonatomic, strong) NKCar *currentCar;//当前操作车辆
@property (nonatomic, strong) NKCar *mainCar;//默认车辆

//界面需要修改数据的控件

@property (nonatomic, assign) BOOL isDefaultCar;
@property (nonatomic, strong) NSString *currentColorStr;
@property (nonatomic, strong) NSMutableArray *colorCardButtonArray;
@property (nonatomic, strong) NKSlider *slider;

@property (nonatomic, strong) NSMutableArray *labelMutableArray;//三个label
@property (nonatomic, strong) NSMutableArray *topViewArray;//顶部的view，不包含第一个topfirstView
@property (nonatomic, strong) NKCarManagerTopView *currentTopView;//当前的Topview
@property (nonatomic, strong) NKCarManagerTopFirstView *firstTopView;

@end

@implementation ManageCarViewController

-(NSMutableArray *)carsMutableArray
{
    if (_carsMutableArray == nil)
    {
        _carsMutableArray = [NSMutableArray array];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSArray *carArray = [NSArray arrayWithArray:[userDefault objectForKey:@"carArray"]];
        for (int i = 0; i < carArray.count; i++)
        {
            NSData *data = carArray[i];
            NKCar *car = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if (car.isDefaultCar) {
                self.mainCar = car;
            }
            [_carsMutableArray addObject:car];
        }
        //将默认车辆放到数组第一位
        if (!self.mainCar) {
            self.mainCar = [_carsMutableArray firstObject];
        }
        NSUInteger temp = 0;
        for (NKCar *car in _carsMutableArray)
        {
            if ([car.license isEqualToString:self.mainCar.license]) {
                temp = [_carsMutableArray indexOfObject:car];
            }
        }
        [_carsMutableArray exchangeObjectAtIndex:0 withObjectAtIndex:temp];
    }
    return _carsMutableArray;
}
- (NSMutableArray *)labelMutableArray
{
    if (_labelMutableArray == nil)
    {
        _labelMutableArray = [NSMutableArray array];
    }
    return _labelMutableArray;
}

- (NSMutableArray *)colorCardArray
{
    if (_colorCardButtonArray == nil)
    {
        _colorCardButtonArray = [NSMutableArray array];
    }
    return _colorCardButtonArray;
}
- (NSMutableArray *)topViewArray
{
    if (_topViewArray == nil)
    {
        _topViewArray = [NSMutableArray array];
    }
    return _topViewArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化界面
    [self setNavigationBar];
    [self createTopView];
    [self createCarDetailBottomView];
    [self createCarManagerBottomView];
    
    [self updateTopScrollViewData];
    //网络请求
    [self postToGetPieData];
    [self postGetUserTotalExpendAndTime];
    
    //注册单元格
    [self.otherCarTableView registerNib:[UINib nibWithNibName:@"NKCarUncertificatedTableViewCell" bundle:nil] forCellReuseIdentifier:@"NKCarUncertificatedTableViewCell"];
    [self.otherCarTableView registerNib:[UINib nibWithNibName:@"NKCarCertificatedTableViewCell" bundle:nil] forCellReuseIdentifier:@"NKCarCertificatedTableViewCell"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    //清空车辆数组内容
    [self.carsMutableArray removeAllObjects];
    self.carsMutableArray = nil;
}
#pragma mark - 界面数据更新方法
- (void)updateTopScrollViewData
{
    //设置车辆色卡，车牌，背景图
    for (int i = 0; i < self.topViewArray.count; i++)
    {
        NKCar *car = self.carsMutableArray[i];
        NKCarManagerTopView *topView = self.topViewArray[i];
        topView.licenseLabel.text = car.license;
        topView.tagImageView.image = [topView.tagImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        if (car.colourCard)
        {
            topView.tagImageView.tintColor = [NKColorManager colorWithStr:car.colourCard alpha:1.0];
        }
        if (car.carbgurl)
        {
            topView.bgImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:car.carbgurl]]];
        }
    }
    //设置小圆点
    self.pageControl.currentPage = self.index;
    //设置界面滑动的位置
    _topScrollView.contentOffset = CGPointMake(WIDTH_VIEW * self.index, 0);
}
- (void)updateDefualtCarData
{
    //重新加载数组的数据
    [self.carsMutableArray removeAllObjects];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *carArray = [NSArray arrayWithArray:[userDefault objectForKey:@"carArray"]];
    for (int i = 0; i < carArray.count; i++)
    {
        NSData *data = carArray[i];
        NKCar *car = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (car.isDefaultCar) {
            self.mainCar = car;
        }
        [self.carsMutableArray addObject:car];
    }
    //将默认车辆放到数组第一位
    if (!self.mainCar) {
        self.mainCar = [_carsMutableArray firstObject];
    }
    NSUInteger temp = 0;
    for (NKCar *car in self.carsMutableArray)
    {
        if ([car.license isEqualToString:self.mainCar.license]) {
            temp = [self.carsMutableArray indexOfObject:car];
        }
    }
    [self.carsMutableArray exchangeObjectAtIndex:0 withObjectAtIndex:temp];
    
    //更新界面
    //审核状态 0：新建 1：提交审核 2：审核通过 3：审核不通过
    if (self.mainCar.auditFlag == 0)
    {
        CGRect frame = _mainCarView.frame;
        [_mainCarView removeFromSuperview];
        _mainCarView = [NKMainCarView mainCarViewWithType:NKMainCarViewTypeNew];
        _mainCarView.frame = frame;
        [_mainCarBaseView addSubview:_mainCarView];
        
        _mainCarView.carBrandImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.mainCar.carseriespic]]];
        _mainCarView.carLicenseLabel.text = self.mainCar.license;
        for (NKStopLatestRecord *record in self.recordMutableArray) {
            if ([record.license isEqualToString:self.mainCar.license]) {
                _mainCarView.latestParkingNameLabel.text = record.fullAddress;
                _mainCarView.latestParkingTimeAndMoneyLabel.text = [NSString stringWithFormat:@"%ld小时 %.2lf元", record.duration / 3600, (float)record.money / 100];
            }
        }
    }
    else if (self.mainCar.auditFlag == 1)
    {
        CGRect frame = _mainCarView.frame;
        [_mainCarView removeFromSuperview];
        _mainCarView = [NKMainCarView mainCarViewWithType:NKMainCarViewTypeIsCertificating];
        _mainCarView.frame = frame;
        [_mainCarBaseView addSubview:_mainCarView];
        
        _mainCarView.carBrandImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.mainCar.carseriespic]]];
        _mainCarView.carLicenseLabel.text = self.mainCar.license;
        for (NKStopLatestRecord *record in self.recordMutableArray) {
            if ([record.license isEqualToString:self.mainCar.license]) {
                _mainCarView.latestParkingNameLabel.text = record.fullAddress;
                _mainCarView.latestParkingTimeAndMoneyLabel.text = [NSString stringWithFormat:@"%ld小时 %.2lf元", record.duration / 3600, (float)record.money / 100];
            }
        }
    }
    else if (self.mainCar.auditFlag == 2)
    {
        CGRect frame = _mainCarView.frame;
        [_mainCarView removeFromSuperview];
        _mainCarView = [NKMainCarView mainCarViewWithType:NKMainCarViewTypeCertificateSuccess];
        _mainCarView.frame = frame;
        [_mainCarBaseView addSubview:_mainCarView];
        
        _mainCarView.carBrandImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.mainCar.carseriespic]]];
        _mainCarView.carLicenseLabel.text = self.mainCar.license;
        for (NKStopLatestRecord *record in self.recordMutableArray) {
            if ([record.license isEqualToString:self.mainCar.license]) {
                _mainCarView.latestParkingNameLabel.text = record.fullAddress;
                _mainCarView.latestParkingTimeAndMoneyLabel.text = [NSString stringWithFormat:@"%ld小时 %.2lf元", record.duration / 3600, (float)record.money / 100];
            }
        }
    }
    else
    {
        CGRect frame = _mainCarView.frame;
        [_mainCarView removeFromSuperview];
        _mainCarView = [NKMainCarView mainCarViewWithType:NKMainCarViewTypeCertificateFaile];
        _mainCarView.frame = frame;
        [_mainCarBaseView addSubview:_mainCarView];
        
        _mainCarView.carBrandImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.mainCar.carseriespic]]];
        _mainCarView.carLicenseLabel.text = self.mainCar.license;
        for (NKStopLatestRecord *record in self.recordMutableArray) {
            if ([record.license isEqualToString:self.mainCar.license]) {
                _mainCarView.latestParkingNameLabel.text = record.fullAddress;
                _mainCarView.latestParkingTimeAndMoneyLabel.text = [NSString stringWithFormat:@"%ld小时 %.2lf元", record.duration / 3600, (float)record.money / 100];
            }
        }
    }
    
}
#pragma mark - 界面初始化方法
- (void)setNavigationBar
{
    self.navigationItem.title = @"车辆管理";
    UIImage *leftItemImage = [UIImage imageNamed:@"左箭头"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[leftItemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIImage *rightItemImage = [UIImage imageNamed:@"managecar_addcar"];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[rightItemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickAddCarButton)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_TITLE_WHITE}];
    
    self.navigationController.navigationBar.barTintColor = COLOR_NAVI_BLACK;
    self.navigationController.navigationBar.backgroundColor = COLOR_NAVI_BLACK;
}
- (void)goBack
{
    if (self.navigationController.childViewControllers.count == 1)
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)createTopView
{
    _topBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, WIDTH_VIEW, HEIGHT_VIEW * 0.32)];
    _topBaseView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_topBaseView];
    
    UIView *topBottomView = [[UIView alloc] init];
    [_topBaseView addSubview:topBottomView];
    topBottomView.backgroundColor = COLOR_VIEW_GRAY;
    [topBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topBaseView.mas_left);
        make.right.equalTo(_topBaseView.mas_right);
        make.height.mas_equalTo(CellHeight + 1);
        make.bottom.mas_equalTo(_topBaseView.mas_bottom);
    }];
    
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW, HEIGHT_VIEW * 0.32 - CellHeight)];
    _topScrollView.delegate = self;
    _topScrollView.userInteractionEnabled = YES;
    _topScrollView.contentSize = CGSizeMake(_topScrollView.bounds.size.width * (self.carsMutableArray.count + 1), _topScrollView.bounds.size.height);
    //到达边缘不弹跳
    _topScrollView.bounces = NO;
    //整页滚动
    _topScrollView.pagingEnabled = YES;
    //设置不显示水平滚动提示条
    _topScrollView.showsHorizontalScrollIndicator = NO;
    [_topBaseView addSubview:_topScrollView];
    
    //创建第一个页面-主页面的顶部视图
    NKCarManagerTopFirstView *firstTopView = [NKCarManagerTopFirstView topFirstView];
    _firstTopView = firstTopView;
    self.topManagerFirstView = firstTopView;
    [_topScrollView addSubview:firstTopView];
    NSString *carManagerBg = [[NSUserDefaults standardUserDefaults] objectForKey:@"carManagerBg"];
    UIImage *firstBgImage = [UIImage imageWithData:[NKImageManager getImageDataWithUrl:carManagerBg]];
    if (firstBgImage) {
        firstTopView.bgImageView.image = firstBgImage;
    }
    firstTopView.iconImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.loginMsg.user.avatar]]];
    firstTopView.niNameLabel.text = self.loginMsg.user.niName;
    [firstTopView.topButton addTarget:self action:@selector(changeManageCarBGImage) forControlEvents:UIControlEventTouchUpInside];
    [firstTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topScrollView.mas_top);
        make.left.equalTo(_topScrollView.mas_left);
        make.width.mas_equalTo(WIDTH_VIEW);
        make.height.mas_equalTo(_topScrollView.mas_height);
    }];
    
    //创建后续页面的顶部视图
    for (int i = 0; i < self.carsMutableArray.count; i++)
    {
        NKCarManagerTopView *topView = [NKCarManagerTopView topView];
        [_topScrollView addSubview:topView];
        [topView.topButton addTarget:self action:@selector(clickChangeCarBGImageButton:) forControlEvents:UIControlEventTouchUpInside];
        topView.topButton.tag = 900 + i;
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topScrollView.mas_top);
            make.left.equalTo(_topScrollView.mas_left).offset(WIDTH_VIEW + WIDTH_VIEW * i);
            make.width.mas_equalTo(WIDTH_VIEW);
            make.height.mas_equalTo(_topScrollView.mas_height);
        }];
        [self.topViewArray addObject:topView];
    }
    _pageControl = [[NKPageControl alloc] initWithStyle:NKPageControlManageCar];
    [_topBaseView addSubview:_pageControl];
    _pageControl.numberOfPages = self.carsMutableArray.count + 1;//小圆点个数
    _pageControl.userInteractionEnabled = NO;//关闭与用户的交互
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:158.0 / 255.0 green:158.0 / 255.0 blue:158.0 / 255.0 alpha:1.0];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topBaseView.mas_left);
        make.bottom.equalTo(topBottomView.mas_top).offset(-5);
        make.height.equalTo(@10);
        make.width.mas_equalTo(WIDTH_VIEW);
    }];
    
    NSArray *imageStrArray = @[@"manageCar_车场", @"manageCar_时长", @"manageCar_消费"];
    NSArray *strArray1 = @[@"0次", @"0小时", @"0元"];
    NSArray *strArray2 = @[@"泊遍车场", @"累计停车时长", @"累计停车消费"];
    [self.labelMutableArray removeAllObjects];
    for (int i = 0; i < 3; i++)
    {
        UIView *subView = [[UIView alloc] init];
        [topBottomView addSubview:subView];
        subView.backgroundColor = COLOR_BACKGROUND_BLACK;
        [subView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topBottomView.mas_left).offset(i * WIDTH_VIEW / 3);
            make.top.equalTo(topBottomView.mas_top);
            make.bottom.equalTo(topBottomView.mas_bottom);
            if (i == 2)
            {
                make.width.mas_equalTo(WIDTH_VIEW / 3);
            }
            else
            {
                make.width.mas_equalTo(WIDTH_VIEW / 3 - 1);
            }
        }];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageStrArray[i]]];
        [subView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(subView.mas_left).offset(12);
            make.centerY.equalTo(subView.mas_centerY);
            make.height.equalTo(@24.5);
            make.width.equalTo(@24.5);
        }];
        UILabel *firstLabel = [[UILabel alloc] init];
        [subView addSubview:firstLabel];
        [self.labelMutableArray addObject:firstLabel];
        firstLabel.text = strArray1[i];
        firstLabel.font = [UIFont systemFontOfSize:12.0];
        firstLabel.textColor = COLOR_TITLE_WHITE;
        [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(8);
            make.top.equalTo(subView.mas_top).offset(10);
            make.height.equalTo(@12);
        }];
        UILabel *secondLabel = [[UILabel alloc] init];
        [subView addSubview:secondLabel];
        secondLabel.text = strArray2[i];
        secondLabel.font = [UIFont systemFontOfSize:10.0];
        secondLabel.textColor = COLOR_TITLE_GRAY;
        [secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(8);
            make.top.equalTo(firstLabel.mas_bottom).offset(6);
            make.height.equalTo(@10);
        }];
    }
}
- (void)createCarDetailBottomView
{
    _carDetailBaseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HEIGHT_VIEW * 0.32 + 64, WIDTH_VIEW, HEIGHT_VIEW * 0.68 - 64)];
    _carDetailBaseTableView.delegate = self;
    _carDetailBaseTableView.dataSource = self;
    _carDetailBaseTableView.backgroundColor = COLOR_VIEW_BLACK;
    _carDetailBaseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_carDetailBaseTableView];
    float isBigView = HEIGHT_VIEW * 0.68 - 64 - 44 * 5;
    UIView *tableFooterView;
    if (isBigView > 127)
    {
        tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW, isBigView)];
        tableFooterView.backgroundColor = COLOR_VIEW_BLACK;
        _carDetailBaseTableView.tableFooterView = tableFooterView;
    }
    else
    {
        tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW, 127)];
        tableFooterView.backgroundColor = COLOR_VIEW_BLACK;
        _carDetailBaseTableView.tableFooterView = tableFooterView;
    }
    UIView *footerBottomBaseView = [[UIView alloc] init];
    footerBottomBaseView.backgroundColor = COLOR_BACKGROUND_BLACK;
    [tableFooterView addSubview:footerBottomBaseView];
    [footerBottomBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tableFooterView.mas_left);
        make.bottom.equalTo(tableFooterView.mas_bottom);
        make.right.equalTo(tableFooterView.mas_right);
        make.height.mas_equalTo(CellHeight);
    }];
    UIButton *deleteButton = [[UIButton alloc] init];
    [footerBottomBaseView addSubview:deleteButton];
    [deleteButton setTitle:@"删除车辆" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [deleteButton addTarget:self action:@selector(clickDeleteCarButton) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footerBottomBaseView.mas_centerX).multipliedBy(0.6);
        make.centerY.equalTo(footerBottomBaseView.mas_centerY);
    }];
    _certificateButton = [[UIButton alloc] init];
    [footerBottomBaseView addSubview:_certificateButton];
    [_certificateButton setTitle:@"认证车辆" forState:UIControlStateNormal];
    [_certificateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _certificateButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_certificateButton addTarget:self action:@selector(clickCertificateCarButton) forControlEvents:UIControlEventTouchUpInside];
    [_certificateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footerBottomBaseView.mas_centerX).multipliedBy(1.6);
        make.centerY.equalTo(footerBottomBaseView.mas_centerY);
    }];
    UIView *cutlineView = [[UIView alloc] init];
    [footerBottomBaseView addSubview:cutlineView];
    cutlineView.backgroundColor = COLOR_VIEW_GRAY;
    [cutlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(footerBottomBaseView.mas_centerX);
        make.top.equalTo(footerBottomBaseView.mas_top).offset(5);
        make.bottom.equalTo(footerBottomBaseView.mas_bottom).offset(-5);
        make.width.equalTo(@1);
    }];
    _deleteCarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"manageCar_删除"]];
    [footerBottomBaseView addSubview:_deleteCarImageView];
    [_deleteCarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(deleteButton.mas_left).offset(-8);
        make.centerY.equalTo(deleteButton.mas_centerY);
        make.height.equalTo(@14);
        make.width.equalTo(@14);
    }];
    _certificateCarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"manageCar_认证"]];
    [footerBottomBaseView addSubview:_certificateCarImageView];
    [_certificateCarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_certificateButton.mas_left).offset(-8);
        make.centerY.equalTo(_certificateButton.mas_centerY);
        make.height.equalTo(@14);
        make.width.equalTo(@14);
    }];
    UIButton *qrCodeButton = [[UIButton alloc] init];
    [tableFooterView addSubview:qrCodeButton];
    [qrCodeButton setImage:[UIImage imageNamed:@"manageCar_智慧贴_defualt"] forState:UIControlStateNormal];
    [qrCodeButton addTarget:self action:@selector(clickQRCodeButton) forControlEvents:UIControlEventTouchUpInside];
    [qrCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tableFooterView.mas_centerY).multipliedBy(0.6);
        make.centerX.equalTo(tableFooterView.mas_centerX).multipliedBy(0.5);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    UIButton *parkingCardButton = [[UIButton alloc] init];
    [tableFooterView addSubview:parkingCardButton];
    [parkingCardButton setImage:[UIImage imageNamed:@"manageCar_畅停卡"] forState:UIControlStateNormal];
    [parkingCardButton addTarget:self action:@selector(clickParkingCardButton) forControlEvents:UIControlEventTouchUpInside];
    [parkingCardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tableFooterView.mas_centerY).multipliedBy(0.6);
        make.centerX.equalTo(tableFooterView.mas_centerX).multipliedBy(1.5);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    UILabel *qrCodeLabel = [[UILabel alloc] init];
    [tableFooterView addSubview:qrCodeLabel];
    qrCodeLabel.text = @"智慧贴";
    qrCodeLabel.textColor = COLOR_TITLE_GRAY;
    qrCodeLabel.font = [UIFont systemFontOfSize:12.0];
    [qrCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qrCodeButton.mas_bottom).offset(8);
        make.centerX.equalTo(qrCodeButton.mas_centerX);
        make.height.equalTo(@12);
    }];
    UILabel *parkingCardLabel = [[UILabel alloc] init];
    [tableFooterView addSubview:parkingCardLabel];
    parkingCardLabel.text = @"畅停卡";
    parkingCardLabel.textColor = COLOR_TITLE_GRAY;
    parkingCardLabel.font = [UIFont systemFontOfSize:12.0];
    [parkingCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(parkingCardButton.mas_bottom).offset(8);
        make.centerX.equalTo(parkingCardButton.mas_centerX);
        make.height.equalTo(@12);
    }];
    //隐藏该view
    _carDetailBaseTableView.hidden = YES;
}
- (void)createCarManagerBottomView
{
    //BaseView
    _carManagerBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT_VIEW * 0.32 + 64, WIDTH_VIEW, HEIGHT_VIEW * 0.68 - 64)];
    _carManagerBaseView.backgroundColor = COLOR_BACKGROUND_BLACK;
    [self.view addSubview:_carManagerBaseView];
    //饼图View
//    UIView *pieBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW, _carManagerBaseView.frame.size.height / 2 - 1)];
//    pieBaseView.backgroundColor = COLOR_VIEW_BLACK;
//    [_carManagerBaseView addSubview:pieBaseView];
//    UIView *cityPie = [NKChartManager NKChartPieViewWithPieData:nil andFrame:CGRectMake(0, 0, pieBaseView.frame.size.width / 2, pieBaseView.frame.size.height) andPieSize:CGSizeMake(110, 110)];
//    [pieBaseView addSubview:cityPie];
//    UIView *lotPieView = [NKChartManager NKChartPieViewWithPieData:nil andFrame:CGRectMake(pieBaseView.frame.size.width / 2, 0, pieBaseView.frame.size.width / 2, pieBaseView.frame.size.height) andPieSize:CGSizeMake(90, 90)];
//    [pieBaseView addSubview:lotPieView];
    //主驾车辆
    _mainCarBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, _carManagerBaseView.frame.size.height / 2, WIDTH_VIEW / 5 * 2, _carManagerBaseView.frame.size.height / 2)];
    _mainCarBaseView.backgroundColor = COLOR_VIEW_BLACK;
    [_carManagerBaseView addSubview:_mainCarBaseView];
    
    switch (self.mainCar.auditFlag) {
        case 0:
            _mainCarView = [NKMainCarView mainCarViewWithType:NKMainCarViewTypeNew];
            break;
        case 1:
            _mainCarView = [NKMainCarView mainCarViewWithType:NKMainCarViewTypeIsCertificating];
            break;
        case 2:
            _mainCarView = [NKMainCarView mainCarViewWithType:NKMainCarViewTypeCertificateSuccess];
            break;
        case 3:
            _mainCarView = [NKMainCarView mainCarViewWithType:NKMainCarViewTypeCertificateFaile];
            break;
        default:
            break;
    }
    _mainCarView.frame = CGRectMake(0, 0, _mainCarBaseView.frame.size.width, _mainCarBaseView.frame.size.height);
    [self updateDefualtCarData];
    [_mainCarBaseView addSubview:_mainCarView];
    //副驾车辆
    _otherCarTableView = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH_VIEW / 5 * 2, _carManagerBaseView.frame.size.height / 2, WIDTH_VIEW / 5 * 3, _carManagerBaseView.frame.size.height / 2)];
    _otherCarTableView.backgroundColor = COLOR_VIEW_BLACK;
    _otherCarTableView.separatorColor = COLOR_BACKGROUND_BLACK;
    _otherCarTableView.delegate = self;
    _otherCarTableView.dataSource = self;
    [_carManagerBaseView addSubview:_otherCarTableView];
}
#pragma mark - UITableViewDelegate&&UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.otherCarTableView])
    {
        return 1;
    }
    else
    {
        return 5;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.otherCarTableView])
    {
        return self.carsMutableArray.count - 1;
    }
    else
    {
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.otherCarTableView])
    {
        NKCar *car = self.carsMutableArray[indexPath.row + 1];
        if (car.auditFlag == 2)
        {
            NKCarCertificatedTableViewCell *cell = [self.otherCarTableView dequeueReusableCellWithIdentifier:@"NKCarCertificatedTableViewCell" forIndexPath:indexPath];
            cell.carBrandImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:car.carseriespic]]];
            cell.carLicenseLabel.text = car.license;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            for (NKStopLatestRecord *record in self.recordMutableArray) {
                if ([record.license isEqualToString:car.license]) {
                    cell.latestParkingNameLabel.text = record.fullAddress;
                    cell.latestParkingTimeAndMoneyLabel.text = [NSString stringWithFormat:@"%ld小时 %.2lf元", record.duration / 3600, (float)record.money / 100];
                }
            }
            UILongPressGestureRecognizer *longPressed = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(didLongPressTableViewCell:)];
            longPressed.minimumPressDuration = 1;
            [cell.contentView addGestureRecognizer:longPressed];
            return cell;
        }
        else
        {
            NKCarUncertificatedTableViewCell *cell = [self.otherCarTableView dequeueReusableCellWithIdentifier:@"NKCarUncertificatedTableViewCell" forIndexPath:indexPath];
            cell.carLicenseLabel.text = car.license;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            for (NKStopLatestRecord *record in self.recordMutableArray) {
                if ([record.license isEqualToString:car.license]) {
                    cell.latestParkingNameLabel.text = record.fullAddress;
                    cell.latestParkingTimeAndMoneyLabel.text = [NSString stringWithFormat:@"%ld小时 %.2lf元", record.duration / 3600, (float)record.money / 100];
                }
            }
            UILongPressGestureRecognizer *longPressed = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(didLongPressTableViewCell:)];
            longPressed.minimumPressDuration = 1;
            [cell.contentView addGestureRecognizer:longPressed];
            return cell;
        }
    }
    else
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"customCell"];
        switch (indexPath.section)
        {
            case 0:
                [self createSecondCell:cell];
                break;
            case 1:
                [self createThirdCell:cell];
                break;
            case 2:
                [self createFourthCell:cell];
                break;
            case 3:
                [self createFifthCell:cell];
                break;
            case 4:
                [self createSixthCell:cell];
                break;
            default:
                break;
        }
        cell.contentView.backgroundColor = COLOR_VIEW_BLACK;
        cell.backgroundColor = COLOR_VIEW_BLACK;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.otherCarTableView])
    {
        return 54;
    }
    else
    {
        return CellHeight;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([tableView isEqual:self.otherCarTableView])
    {
        return 0;
    }
    else
    {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.otherCarTableView])
    {
        return 20;
    }
    else
    {
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.otherCarTableView])
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW / 5 * 3, 20)];
        view.backgroundColor = COLOR_VIEW_BLACK;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, WIDTH_VIEW / 5 * 3, 10)];
        label.text = @"副";
        label.textColor = COLOR_TITLE_GRAY;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10.0];
        [view addSubview:label];
        return view;
    }
    else
    {
        return nil;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ([tableView isEqual:self.otherCarTableView])
    {
        return nil;
    }
    else
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW, 1)];
        view.backgroundColor = COLOR_BACKGROUND_BLACK;
        return view;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _pageControl.currentPage = indexPath.row + 2;//round四舍五入函数
    _carDetailBaseTableView.hidden = NO;
    _carManagerBaseView.hidden = YES;
    //3.如果是车辆详情的顶部视图，加载相关数据
    self.currentCar = self.carsMutableArray[indexPath.row + 1];
    self.currentTopView = self.topViewArray[indexPath.row + 1];
    [self.topScrollView setContentOffset:CGPointMake(WIDTH_VIEW * (indexPath.row + 2) , 0) animated:YES];
    
    if (self.currentCar.auditFlag == 0)
    {
        [self.certificateButton setTitle:@"认证车辆" forState:UIControlStateNormal];
        self.certificateButton.userInteractionEnabled = YES;
    }
    else if (self.currentCar.auditFlag == 1)
    {
        [self.certificateButton setTitle:@"审核中" forState:UIControlStateNormal];
        _certificateCarImageView.image = [UIImage imageNamed:@"manageCar_认证中"];
        self.certificateButton.userInteractionEnabled = NO;
    }
    else if (self.currentCar.auditFlag == 2)
    {
        [self.certificateButton setTitle:@"已认证" forState:UIControlStateNormal];
        self.certificateButton.userInteractionEnabled = NO;
    }
    else
    {
        [self.certificateButton setTitle:@"重新认证" forState:UIControlStateNormal];
        self.certificateButton.userInteractionEnabled = YES;
    }
    //页面停止滑动时发送网络请求
    [self postGetCarTotalExpendAndTimeWithCarLicense:_currentCar.license];
}
- (void)didLongPressTableViewCell:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        CGPoint pointTouch = [gestureRecognizer locationInView:self.otherCarTableView];
        NSIndexPath *indexPath = [self.otherCarTableView indexPathForRowAtPoint:pointTouch];
        NSLog(@"%ld", (long)indexPath.row);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"设置默认车辆" message:@"是否将该车辆设置为主驾车辆" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action_sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //1.设置车辆为默认车辆,设置成功后在返回的block中取消原来的默认车辆
            NKCar *car = self.carsMutableArray[indexPath.row + 1];
            self.currentCar = car;
            [self setDefualtCarWithLicense:car.license];
        }];
        UIAlertAction *action_cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:action_sure];
        [alertController addAction:action_cancel];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
#pragma mark - 创建单元格的5个方法
- (void)createSecondCell:(UITableViewCell *)cell
{
    cell.textLabel.text = @"爱车管家";
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.textColor = COLOR_TITLE_GRAY;
    [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).offset(12);
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.height.equalTo(@14);
    }];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    [cell.contentView addSubview:nameLabel];
    nameLabel.text = @"暂无";
    nameLabel.font = [UIFont systemFontOfSize:12.0];
    nameLabel.textColor = COLOR_TITLE_WHITE;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.textLabel.mas_right).offset(12);
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.height.equalTo(@12);
    }];
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    [cell.contentView addSubview:phoneLabel];
    phoneLabel.text = @"";
    phoneLabel.font = [UIFont systemFontOfSize:12.0];
    phoneLabel.textColor = COLOR_TITLE_WHITE;
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right).offset(12);
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.height.equalTo(@12);
    }];
}
- (void)createThirdCell:(UITableViewCell *)cell
{
    cell.textLabel.text = @"常用车场";
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.textColor = COLOR_TITLE_GRAY;
    [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).offset(12);
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.height.equalTo(@14);
    }];
    
    UIImageView *homeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"manageCar_家庭"]];
    [cell.contentView addSubview:homeImageView];
    [homeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.textLabel.mas_right).offset(12);
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.height.equalTo(@12);
        make.width.equalTo(@12);
    }];
    UILabel *homeLabel = [[UILabel alloc] init];
    [cell.contentView addSubview:homeLabel];
    homeLabel.text = @"暂无";
    homeLabel.textColor = COLOR_TITLE_WHITE;
    homeLabel.font = [UIFont systemFontOfSize:12.0];
    [homeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(homeImageView.mas_right).offset(8);
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.height.equalTo(@12);
    }];
    UIImageView *companyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"manageCar_公司"]];
    [cell.contentView addSubview:companyImageView];
    [companyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(homeLabel.mas_right).offset(16);
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.height.equalTo(@12);
        make.width.equalTo(@12);
    }];
    UILabel *companyLabel = [[UILabel alloc] init];
    [cell.contentView addSubview:companyLabel];
    companyLabel.text = @"暂无";
    companyLabel.textColor = COLOR_TITLE_WHITE;
    companyLabel.font = [UIFont systemFontOfSize:12.0];
    [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(companyImageView.mas_right).offset(8);
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.height.equalTo(@12);
    }];
}
- (void)createFourthCell:(UITableViewCell *)cell
{
    NSArray *strArray = @[@"应用通知", @"微信通知", @"短信通知"];
    cell.textLabel.text = @"消费通知";
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.textColor = COLOR_TITLE_GRAY;
    [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).offset(12);
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.height.equalTo(@14);
    }];
    float spec = WIDTH_VIEW * 0.22;
    for (int i = 0; i < 3; i++)
    {
        UIButton *button = [[UIButton alloc] init];
        [cell.contentView addSubview:button];
        [button setTitle:strArray[i] forState:UIControlStateNormal];
        [button setTitleColor:COLOR_TITLE_WHITE forState:UIControlStateSelected];
        [button setTitleColor:COLOR_TITLE_GRAY forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.left.equalTo(cell.textLabel.mas_right).offset(24 + spec * i);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.height.equalTo(@12);
        }];
        UIImageView *imageView;//暂时先写死
        if (i == 0)
        {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"manageCar_选择"]];
        }
        else
        {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"勾选框-未勾选"]];
        }
        [cell.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(button.mas_left).offset(-4);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.height.equalTo(@8);
            make.width.equalTo(@8);
        }];
    }
}
- (void)createFifthCell:(UITableViewCell *)cell
{
    cell.textLabel.text = @"免密额度";
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.textColor = COLOR_TITLE_GRAY;
    [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).offset(12);
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.height.equalTo(@14);
    }];
    
    NKSlider *slider = [NKSlider mySliderInitWithFrame:CGRectMake(0, 0, WIDTH_VIEW, 44)];
    _slider = slider;
    [cell.contentView addSubview:slider];
    //免密金额
    if (self.currentCar.freePwdMoneyLimit == 0)
    {
        self.slider.value = 0;
    }
    else if (self.currentCar.freePwdMoneyLimit == 20)
    {
        self.slider.value = 0.33;
    }
    else if (self.currentCar.freePwdMoneyLimit == 50)
    {
        self.slider.value = 0.67;
    }
    else if (self.currentCar.freePwdMoneyLimit == 100)
    {
        self.slider.value = 1;
    }
    slider.continuous = NO;
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.textLabel.mas_right).offset(12);
        make.right.equalTo(cell.contentView.mas_right).offset(-12);
        make.centerY.equalTo(cell.mas_centerY).multipliedBy(0.8);
    }];
    NSArray *strArray = @[@"0", @"20", @"50", @"100"];
    for (int i = 0; i < 4; i++)
    {
        UILabel *label = [[UILabel alloc] init];
        [cell.contentView addSubview:label];
        label.text = strArray[i];
        label.font = [UIFont systemFontOfSize:8.0];
        label.textColor = COLOR_TITLE_WHITE;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(slider.mas_bottom).offset(2);
            if (i == 0)
            {
                make.left.equalTo(slider.mas_left);
            }
            else if (i == 1)
            {
                make.centerX.equalTo(slider.mas_centerX).multipliedBy(0.8);
            }
            else if (i == 2)
            {
                make.centerX.equalTo(slider.mas_centerX).multipliedBy(1.2);
            }
            else
            {
                make.right.equalTo(slider.mas_right);
            }
            make.height.equalTo(@8);
        }];
    }
}
- (void)createSixthCell:(UITableViewCell *)cell
{
    cell.textLabel.text = @"识别标签";
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.textColor = COLOR_TITLE_GRAY;
    [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).offset(12);
        make.centerY.equalTo(cell.contentView.mas_centerY);
        make.height.equalTo(@14);
    }];
    NSArray *carColorArray = @[cardColor_0, cardColor_1, cardColor_2, cardColor_3, cardColor_4, cardColor_5];
    float spc = WIDTH_VIEW * 0.06;
    [self.colorCardArray removeAllObjects];
    for (int i = 0; i < 6; i++)
    {
        UIButton *button = [[UIButton alloc] init];
        [cell.contentView addSubview:button];
        button.layer.cornerRadius = 11;
        button.layer.masksToBounds = YES;
        [button setBackgroundColor:carColorArray[i]];
        [button addTarget:self action:@selector(clickColorCardButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"manageCar_选中标签"] forState:UIControlStateSelected];
        [self.colorCardArray addObject:button];
        button.tag = 1000 + i;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.textLabel.mas_right).offset(12 + (spc+22) * i);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.height.equalTo(@22);
            make.width.equalTo(@22);
        }];
    }
    
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //1.判断小圆点的位置
    CGPoint offset = scrollView.contentOffset;
    _pageControl.currentPage = round(offset.x / scrollView.frame.size.width);//round四舍五入函数
    
    if ([scrollView isEqual:self.topScrollView]){
        //2.判断要显示的视图
        if (_pageControl.currentPage == 0)
        {
            _carManagerBaseView.hidden = NO;
            _carDetailBaseTableView.hidden = YES;
            [self postGetUserTotalExpendAndTime];
        }
        else
        {
            _carDetailBaseTableView.hidden = NO;
            _carManagerBaseView.hidden = YES;
            //3.如果是车辆详情的顶部视图，加载相关数据
            self.currentCar = self.carsMutableArray[_pageControl.currentPage - 1];
            self.currentTopView = self.topViewArray[_pageControl.currentPage - 1];
            //免密金额
            if (self.currentCar.freePwdMoneyLimit == 0)
            {
                self.slider.value = 0;
            }
            else if (self.currentCar.freePwdMoneyLimit == 20)
            {
                self.slider.value = 0.33;
            }
            else if (self.currentCar.freePwdMoneyLimit == 50)
            {
                self.slider.value = 0.67;
            }
            else if (self.currentCar.freePwdMoneyLimit == 100)
            {
                self.slider.value = 1;
            }
            //车辆认证状态
            if (self.currentCar.auditFlag == 0)
            {
                [self.certificateButton setTitle:@"认证车辆" forState:UIControlStateNormal];
                self.certificateButton.userInteractionEnabled = YES;
            }
            else if (self.currentCar.auditFlag == 1)
            {
                [self.certificateButton setTitle:@"审核中" forState:UIControlStateNormal];
                _certificateCarImageView.image = [UIImage imageNamed:@"manageCar_认证中"];
                self.certificateButton.userInteractionEnabled = NO;
            }
            else if (self.currentCar.auditFlag == 2)
            {
                [self.certificateButton setTitle:@"已认证" forState:UIControlStateNormal];
                self.certificateButton.userInteractionEnabled = NO;
            }
            else
            {
                [self.certificateButton setTitle:@"重新认证" forState:UIControlStateNormal];
                self.certificateButton.userInteractionEnabled = YES;
            }
            //页面停止滑动时发送网络请求
            [self postGetCarTotalExpendAndTimeWithCarLicense:_currentCar.license];
        }
    }
    
}
#pragma mark - Slider&&Button相关方法
- (void)clickChangeCarBGImageButton:(UIButton *)sender
{
    self.currentTopView = self.topViewArray[sender.tag - 900];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更改车辆背景" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action_photoFromCamera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhotoFromCamera];
        
    }];
    UIAlertAction *action_photoFromAlbum = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhotoFromAlbum];
    }];
    UIAlertAction *action_cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:action_photoFromCamera];
    [alertController addAction:action_photoFromAlbum];
    [alertController addAction:action_cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)changeManageCarBGImage
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更改车辆管理管理背景" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action_photoFromCamera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhotoFromCamera];
    }];
    UIAlertAction *action_photoFromAlbum = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhotoFromAlbum];
    }];
    UIAlertAction *action_cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:action_photoFromCamera];
    [alertController addAction:action_photoFromAlbum];
    [alertController addAction:action_cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)sliderValueChanged:(NKSlider *)sender
{
    if (sender.value == 0 || (sender.value > 0 && sender.value < 0.17))
    {
        sender.value = 0;
        [self postChangeCarFreeMoneyWithMoney:0];
    }
    else if (sender.value == 0.17 || (sender.value > 0.17 && sender.value < 0.5))
    {
        sender.value = 0.33;
        [self postChangeCarFreeMoneyWithMoney:20];
    }
    else if (sender.value == 0.5 || (sender.value > 0.5 && sender.value < 0.83))
    {
        sender.value = 0.67;
        [self postChangeCarFreeMoneyWithMoney:50];
    }
    else
    {
        sender.value = 1;
        [self postChangeCarFreeMoneyWithMoney:100];
    }
//    [self postChangeNotNeedPasswordMoneyWithMoney:sender.value];
}
- (void)clickColorCardButton:(UIButton *)sender
{
    for (UIButton *button in self.colorCardArray)
    {
        button.selected = NO;
    }
    sender.selected = YES;
    //将获取的色值装换成字符串
    UIColor *color = sender.backgroundColor;
    self.currentColorStr = [NKColorManager stringWithUIColor:color];
    [self postUpdateCarColorCard];
}
- (void)clickDeleteCarButton
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除车辆" message:@"删除车辆后不能恢复，只能重新添加" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除车辆" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       [self deleteCar];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:deleteAction];
    [alert addAction:cancelAction];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}
- (void)clickCertificateCarButton
{
    NSLog(@"认证车辆！");
    CarCertificateViewController *ccVC = [[CarCertificateViewController alloc] init];
    ccVC.currentCar = self.currentCar;
    ccVC.carsArray = self.carsMutableArray;
    [self.navigationController pushViewController:ccVC animated:YES];
}
- (void)clickQRCodeButton
{
    NSLog(@"智慧贴");
    NKAlertView *alertView = [[NKAlertView alloc] initWithAlertViewType:NKAlertViewTypeInfomation Height:172 andWidth:WIDTH_VIEW - 60];
    [alertView show:YES];
}
- (void)clickParkingCardButton
{
    NSLog(@"畅停卡");
    NKAlertView *alertView = [[NKAlertView alloc] initWithAlertViewType:NKAlertViewTypeInfomation Height:172 andWidth:WIDTH_VIEW - 60];
    [alertView show:YES];
}
- (void)clickAddCarButton
{
    AddCarsViewController *acVC = [[AddCarsViewController alloc] init];
    acVC.user = self.loginMsg.user;
    [self.navigationController pushViewController:acVC animated:YES];
}
#pragma mark - 网络请求
//获取车辆饼图数据
- (void)postToGetPieData
{
    NSString *sspId = [[NSUserDefaults standardUserDefaults] objectForKey:@"sspId"];
    
    _dataManager = [NKDataManager sharedDataManager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:sspId forKey:@"sspId"];
//    [parameters setValue:@"SSP20161209000000" forKey:@"sspId"];
    [_dataManager POSTGetManageCarPieDataWithParameters:parameters Success:^(NKPieData *pieData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //画饼图
            UIView *pieBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW, _carManagerBaseView.frame.size.height / 2 - 1)];
            pieBaseView.backgroundColor = COLOR_VIEW_BLACK;
            [_carManagerBaseView addSubview:pieBaseView];
            UIView *cityPie = [NKChartManager NKChartPieViewWithPieData:pieData andFrame:CGRectMake(0, 0, pieBaseView.frame.size.width / 2, pieBaseView.frame.size.height) PieSize:CGSizeMake(110, 110) andType:NKPieTypeLot];
            [pieBaseView addSubview:cityPie];
            UIView *lotPieView = [NKChartManager NKChartPieViewWithPieData:pieData andFrame:CGRectMake(pieBaseView.frame.size.width / 2, 0, pieBaseView.frame.size.width / 2, pieBaseView.frame.size.height) PieSize:CGSizeMake(90, 90) andType:NKPieTypeCity];
            [pieBaseView addSubview:lotPieView];
        });
    } Failure:^(NSError *error) {
        [self showHUDToSuperViewWith:@"网络异常"];
    }];
}
//获取所有车辆消费总金额和消费时长
- (void)postGetUserTotalExpendAndTime
{
    NSString *sspid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sspId"];
    _dataManager = [NKDataManager sharedDataManager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:sspid forKey:@"sspid"];
    [_dataManager POSTGetCarTotalExpendAndTimeWithParameters:parameters Success:^(NKCarTotalExpendAndTime *carExpendAndTime) {
        if (carExpendAndTime.ret == 0) {
            //更新界面
            dispatch_async(dispatch_get_main_queue(), ^{
                UILabel *numberLabel = self.labelMutableArray[0];
                numberLabel.text = [NSString stringWithFormat:@"%d个", carExpendAndTime.stopParkNum];
                UILabel *timeLabel = self.labelMutableArray[1];
                timeLabel.text = [NSString stringWithFormat:@"%ld小时", carExpendAndTime.totalTime / 3600];
                UILabel *moneyLabel = self.labelMutableArray[2];
                moneyLabel.text = [NSString stringWithFormat:@"%d元", carExpendAndTime.totalExpend / 100];
                [self.carDetailBaseTableView reloadData];
            });
        }
    } Failure:^(NSError *error) {
        [self showHUDToSuperViewWith:@"网络异常"];
    }];
}
//获取车辆消费总金额和消费时长
- (void)postGetCarTotalExpendAndTimeWithCarLicense:(NSString *)license
{
    _dataManager = [NKDataManager sharedDataManager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:license forKey:@"license"];
    /*
     -10  此车牌号尚未查询到记录！
     -20 参数错误！
     0 success
     */
    [_dataManager POSTGetCarExpendAndTimeWithParameters:parameters Success:^(NKCarExpendAndTime *carExpendAndTime) {
        if (carExpendAndTime.ret == 0)
        {
            //success
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UILabel *numberLabel = self.labelMutableArray[0];
                numberLabel.text = [NSString stringWithFormat:@"%@个", carExpendAndTime.stopNum];
                UILabel *timeLabel = self.labelMutableArray[1];
                timeLabel.text = [NSString stringWithFormat:@"%d小时", carExpendAndTime.totalTime.integerValue / 3600];
                UILabel *moneyLabel = self.labelMutableArray[2];
                moneyLabel.text = [NSString stringWithFormat:@"%d元", carExpendAndTime.totalExpend.integerValue / 100];
                [self.carDetailBaseTableView reloadData];
            });
        }
        else if(carExpendAndTime.ret == -10)
        {
            [self showHUDToSuperViewWith:@"未查询到车辆记录"];
        }
        else
        {
            [self showHUDToSuperViewWith:carExpendAndTime.msg];
        }
    } Failure:^(NSError *error) {
        [self showHUDToSuperViewWith:@"网络异常"];
    }];
}
//设置默认车辆
- (void)setDefualtCarWithLicense:(NSString *)license
{
    //发送网络请求改变车辆默认状态
    _dataManager = [NKDataManager sharedDataManager];
    NSString *sspId = [[NSUserDefaults standardUserDefaults] objectForKey:@"sspId"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:license forKey:@"license"];
    [parameters setObject:sspId forKey:@"sspid"];
    
    [_dataManager POSTSetDefaultCarWithParameters:parameters Success:^(NKBase *base) {
        if (base.ret == 0)
        {
            [self showHUDToSuperViewWith:@"开启默认车辆成功"];
            //重新保存数据
            self.currentCar.isDefaultCar = 1;//修改缓存中车辆默认状态
            NSMutableArray *carDatasArray = [NSMutableArray array];
            for (NKCar *car in self.carsMutableArray)
            {
                if ([car.license isEqualToString:self.mainCar.license])
                {
                    car.isDefaultCar = 1;
                }
                NSData *carData = [NSKeyedArchiver archivedDataWithRootObject:car];
                [carDatasArray addObject:carData];
            }
            [[NSUserDefaults standardUserDefaults] setObject:carDatasArray forKey:@"carArray"];
            
            [self cancelDefualtCarWithLicense:self.mainCar.license];
        }
        if (base.ret == -10)
        {
            [self showHUDToSuperViewWith:@"开启默认车辆失败"];
        }
    } Failure:^(NSError *error) {
        [self showHUDToSuperViewWith:@"网络异常"];
    }];
}
//取消默认车辆
- (void)cancelDefualtCarWithLicense:(NSString *)license
{
    _dataManager = [NKDataManager sharedDataManager];
    NSString *sspId = [[NSUserDefaults standardUserDefaults] objectForKey:@"sspId"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:license forKey:@"license"];
    [parameters setObject:sspId forKey:@"sspid"];
    
    [_dataManager POSTCancelDefaultCarWithParameters:parameters Success:^(NKBase *base) {
        if (base.ret == 0)
        {
            //重新保存数据
            self.mainCar.isDefaultCar = 0;//修改缓存中车辆默认状态
            NSMutableArray *carDatasArray = [NSMutableArray array];
            for (NKCar *car in self.carsMutableArray)
            {
                if ([car.license isEqualToString:self.mainCar.license])
                {
                    car.isDefaultCar = 0;
                }
                NSData *carData = [NSKeyedArchiver archivedDataWithRootObject:car];
                [carDatasArray addObject:carData];
            }
            [[NSUserDefaults standardUserDefaults] setObject:carDatasArray forKey:@"carArray"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateDefualtCarData];
                [self.otherCarTableView reloadData];
            });
        }
    } Failure:^(NSError *error) {
        [self showHUDToSuperViewWith:@"网络异常"];
    }];
}
//更改车辆色卡
- (void)postUpdateCarColorCard
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"更改色卡颜色" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action_sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _dataManager = [NKDataManager sharedDataManager];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:_currentCar.license forKey:@"license"];
        [parameters setObject:self.currentColorStr forKey:@"colorCard"];
        
        //更改车辆色卡
        [_dataManager POSTUpdateCarColorCardWithParameters:parameters Success:^(NKBase *base) {
            if (base.ret == 0)
            {
                [self showHUDToSuperViewWith:@"更改色卡成功"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.currentTopView.tagImageView.image = [self.currentTopView.tagImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    self.currentTopView.tagImageView.tintColor = [NKColorManager colorWithStr:self.currentColorStr alpha:1.0];
                });
                //找出更改色卡更新本地色卡
                NSMutableArray *carDataArray = [NSMutableArray array];
                for (int i = 0; i < self.carsMutableArray.count; i++)
                {
                    NKCar *car = self.carsMutableArray[i];
                    if ([car.license isEqualToString:self.currentCar.license])
                    {
                        car.colourCard = self.currentColorStr;
                    }
                    NSData *carData = [NSKeyedArchiver archivedDataWithRootObject:car];
                    [carDataArray addObject:carData];
                }
                [[NSUserDefaults standardUserDefaults] setObject:carDataArray forKey:@"carArray"];
            }
            if (base.ret == -10)
            {
                [self showHUDToSuperViewWith:@"更改色卡失败"];
            }
        } Failure:^(NSError *error) {
            [self showHUDToSuperViewWith:@"网络异常"];
        }];
    }];
    UIAlertAction *action_cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    [alertView addAction:action_sure];
    [alertView addAction:action_cancel];
    [self presentViewController:alertView animated:YES completion:nil];
    
}
//调节自动支付金额
- (void)postChangeCarFreeMoneyWithMoney:(NSInteger)money
{
    int paySwitch = 0;
    if (money == 0)
    {
        paySwitch = 1;
    }

    _dataManager = [NKDataManager sharedDataManager];
    NSMutableDictionary *paramenterDic = [NSMutableDictionary dictionary];
    NKCar *car = _currentCar;
    //NKUser *user = self.loginMsg.user;
    [paramenterDic setObject:car.license forKey:@"license"];
    [paramenterDic setObject:[NSNumber numberWithFloat:money] forKey:@"moneyLimit"];
    
    [self.dataManager POSTChangeCarFreeMoneyWithParameters:paramenterDic Success:^(NKBase *base) {
        if (base.ret == 0)
        {
            [self showHUDToSuperViewWith:@"自动支付更改成功"];
            //删除成功后更改本地数据
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSMutableArray *carArray = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"carArray"]];
            for (NSData *carData in carArray)
            {
                NKCar *newCar = [NSKeyedUnarchiver unarchiveObjectWithData:carData];
                if ([newCar.license isEqualToString:self.currentCar.license])
                {
                    newCar.paySwitch = paySwitch;
                    newCar.freePwdMoneyLimit = money;
                    NSData *newData = [NSKeyedArchiver archivedDataWithRootObject:newCar];
                    [carArray replaceObjectAtIndex:[carArray indexOfObject:carData] withObject:newData];
                    break;
                }
            }
            [userDefaults setObject:carArray forKey:@"carArray"];
        }
        else
        {
            [self showHUDToSuperViewWith:base.msg];
        }
    } Failure:^(NSError *error) {
        [self showHUDToSuperViewWith:@"网络异常"];
    }];
}

//开启自动支付
//- (void)postChangeNotNeedPasswordMoneyWithMoney:(float)money
//{
//    int paySwitch = 0;
//    if (money < 0.00001f)
//    {
//        paySwitch = 1;
//    }
//    _dataManager = [NKDataManager sharedDataManager];
//    NSMutableDictionary *paramenterDic = [NSMutableDictionary dictionary];
//    NKCar *car = _currentCar;
//    NKUser *user = self.loginMsg.user;
//    [paramenterDic setObject:car.license forKey:@"license"];
//    [paramenterDic setObject:user.token forKey:@"token"];
//    [paramenterDic setObject:user.id forKey:@"ownerId"];
//    [paramenterDic setObject:car.id forKey:@"id"];
//    [paramenterDic setObject:[NSNumber numberWithInt:paySwitch] forKey:@"paySwitch"];//全部设置为开启状态0 开启 1关闭
//    
//    [self.dataManager POSTCarPaySwitchParameters:paramenterDic Success:^(NKCar *car) {
//        
//        if ([car.msg isEqualToString:@"ok"])
//        {
//            [self showHUDToSuperViewWith:@"自动支付更改成功"];
//            //删除成功后更改本地数据
//            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//            NSMutableArray *carArray = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"carArray"]];
//            for (NSData *carData in carArray)
//            {
//                NKCar *newCar = [NSKeyedUnarchiver unarchiveObjectWithData:carData];
//                if ([newCar.license isEqualToString:self.currentCar.license])
//                {
//                    newCar.paySwitch = 0;
//                    NSData *newData = [NSKeyedArchiver archivedDataWithRootObject:newCar];
//                    [carArray replaceObjectAtIndex:[carArray indexOfObject:carData] withObject:newData];
//                    break;
//                }
//            }
//            [userDefaults setObject:carArray forKey:@"carArray"];
//        }
//        else
//        {
//            [self showHUDToSuperViewWith:car.msg];
//        }
//    } Failure:^(NSError *error) {
//        [self showHUDToSuperViewWith:@"网络异常"];
//    }];
//    
//}
//删除车辆
- (void)deleteCar
{
    self.dataManager = [NKDataManager sharedDataManager];
    
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    [parametersDic setObject:self.loginMsg.user.token forKey:@"token"];
    [parametersDic setObject:self.currentCar.license forKey:@"license"];
    
    [self.dataManager POSTDeleteCarWithParameters:parametersDic Success:^(NKBase *backBase) {
        if ([backBase.msg isEqualToString:@"ok"])
        {
            //删除成功后更改本地数据
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSMutableArray *carArray = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"carArray"]];
            for (NSData *carData in carArray)
            {
                NKCar *newCar = [NSKeyedUnarchiver unarchiveObjectWithData:carData];
                if ([newCar.license isEqualToString:self.currentCar.license])
                {
                    [carArray removeObject:carData];
                    break;
                }
            }
            [userDefaults setObject:carArray forKey:@"carArray"];
            [self.carsMutableArray removeObject:self.currentCar];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showHUDToSuperViewWith:@"删除车辆成功"];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            });
        }
        else
        {
            [self showHUDToSuperViewWith:backBase.msg];
        }
    } Failure:^(NSError *error) {
        [self showHUDToSuperViewWith:@"网络异常"];
    }];
}
//上传图片
- (void)sentPOSTWithImage:(UIImage *)image
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"Loding";
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"myToken"];
    //提交照片
    NKDataManager *dataManager = [NKDataManager sharedDataManager];
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    
    //上传文件参数
    NSArray *imageArray = @[image];
    [parametersDic setObject:imageArray forKey:@"imageArray"];
    [parametersDic setObject:@14 forKey:@"appType"];
    [parametersDic setObject:@0 forKey:@"ext2"];
    [parametersDic setObject:token forKey:@"token"];
    
    [dataManager POSTUploadImagesWithParameters:parametersDic Success:^(NKFile *file) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
        if ([file.msg isEqualToString:@"ok"] && file.url)
        {
            if (_topScrollView.contentOffset.x == 0)
            {
                //更新个人用户信息中的bgurl
                [self postToUpdateManageCarBgWithURL:file.url];
            }
            else
            {
                //发送网络请求更改car中的背景图URL
                [self postToChangeCarBGImageWith:file.url];
            }
        }
        else
        {
            NSLog(@"%@", file.msg);
        }
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    }];
    
}
//更改车辆图片
- (void)postToChangeCarBGImageWith:(NSString *)url
{
    self.dataManager = [NKDataManager sharedDataManager];
    NSMutableDictionary *paramenterDic = [NSMutableDictionary dictionary];
    NKCar *car = _currentCar;
    [paramenterDic setObject:car.license forKey:@"license"];
    [paramenterDic setObject:url forKey:@"picUrl"];
    
    [self.dataManager POSTUpdateCarBGImageWithParameters:paramenterDic Success:^(NKBase *base) {
        if (base.ret == 0)
        {
            _currentCar.carbgurl = [NSString stringWithFormat:@"https://fileserver.quickpark.com.cn/getimg/img/viewimg/mnt/resource/%@", url];
            NSMutableArray *carDataMutableArray = [NSMutableArray array];
            for (NKCar *car in self.carsMutableArray)
            {
                if ([car.license isEqualToString:_currentCar.license])
                {
                    car.carbgurl = [NSString stringWithFormat:@"https://fileserver.quickpark.com.cn/getimg/img/viewimg/mnt/resource/%@", url];;
                }
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:car];
                [carDataMutableArray addObject:data];
            }
            [[NSUserDefaults standardUserDefaults] setObject:carDataMutableArray forKey:@"carArray"];
            [self showHUDToSuperViewWith:@"图片更改成功"];
        }
        else
        {
            [self showHUDToSuperViewWith:base.msg];
        }
    } Failure:^(NSError *error) {
        [self showHUDToSuperViewWith:@"网络异常"];
    }];
}
//更新个人数据中的管理背景图
- (void)postToUpdateManageCarBgWithURL:(NSString *)imageUrl
{
    //发送网络请求
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"Loding";
    
    NKDataManager *dataManager = [NKDataManager sharedDataManager];
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"myToken"];
    [parametersDic setObject:imageUrl forKey:@"carManagerBg"];
    [parametersDic setObject:token forKey:@"token"];
    
    [dataManager POSTUpdateMyInfoWithParameters:parametersDic Success:^(NKBase *base) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
        if (base.ret == 0)
        {
            NSUserDefaults *userDefualt = [NSUserDefaults standardUserDefaults];
            [userDefualt setObject:[NSString stringWithFormat:@"https://fileserver.quickpark.com.cn/getimg/img/viewimg/mnt/resource/%@", imageUrl] forKey:@"carManagerBg"];
        }
        else
        {
            [self showHUDToSuperViewWith:base.msg];
        }
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    }];
}
#pragma mark -拍照相关方法
-(void)takePhotoFromCamera
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];//进入照相界面
}
-(void)takePhotoFromAlbum
{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = NO;
    [self presentViewController:pickerImage animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *iconImage = info[UIImagePickerControllerOriginalImage];
    //判断是不是第一个视图
    if (_topScrollView.contentOffset.x == 0)
    {
        self.topManagerFirstView.bgImageView.image = iconImage;
        [self dismissViewControllerAnimated:YES completion:nil];
        [self sentPOSTWithImage:iconImage];
    }
    else
    {
        self.currentTopView.bgImageView.image = iconImage;
        [self dismissViewControllerAnimated:YES completion:nil];
        //发送网络请求
        [self sentPOSTWithImage:iconImage];
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"取消选取照片");
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - HUD工具方法
- (void)showHUDToSuperViewWith:(NSString *)string
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = string;
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES afterDelay:1.0];
        [hud removeFromSuperViewOnHide];
    });
}
@end
