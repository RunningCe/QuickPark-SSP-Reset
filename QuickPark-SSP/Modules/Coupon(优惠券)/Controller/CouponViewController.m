//
//  CouponViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 16/9/20.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "CouponViewController.h"
#import "CouponTableViewCell.h"
#import "NKDataManager.h"
#import "WXApiManager.h"
#import "NKAlertView.h"
#import "MBProgressHUD/MBProgressHUD.h"

#define TopSpec 64
#define TopViewHeight 36

@interface CouponViewController ()<UITableViewDelegate, UITableViewDataSource>

//顶部选择背景view
@property (nonatomic, strong)UIView *topChooseView;
//三个Button
@property (nonatomic, strong)UIButton *canUseButton;
@property (nonatomic, strong)UIButton *didUseButton;
@property (nonatomic, strong)UIButton *outDateButton;
//下划线
@property (nonatomic, strong)UIView *bottomLine;

//可使用界面的输入框和按钮
@property (nonatomic, strong)UITextField *topTextField;
@property (nonatomic, strong)UIButton *exchangeButton;

//三个tableView
@property (nonatomic, strong)UITableView *canUseTableView;
@property (nonatomic, strong)UITableView *didUseTableView;
@property (nonatomic, strong)UITableView *outDateTableView;

@property (nonatomic, strong)UIView *tableHeaderView;

@property (nonatomic, strong)NKDataManager *dataManager;
//三个优惠券的存储数组
@property (nonatomic, strong)NSMutableArray *canUseCouponArray;
@property (nonatomic, strong)NSMutableArray *usedCouponArray;
@property (nonatomic, strong)NSMutableArray *expireCouponArray;

@property (nonatomic, strong)NKAlertView *alertView;

@end

@implementation CouponViewController
-(NSMutableArray *)canUseCouponArray
{
    if (_canUseCouponArray == nil)
    {
        _canUseCouponArray = [NSMutableArray array];
    }
    return _canUseCouponArray;
}
-(NSMutableArray *)usedCouponArray
{
    if (_usedCouponArray == nil)
    {
        _usedCouponArray = [NSMutableArray array];
    }
    return _usedCouponArray;
}
-(NSMutableArray *)expireCouponArray
{
    if (_expireCouponArray == nil)
    {
        _expireCouponArray = [NSMutableArray array];
    }
    return _expireCouponArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(couponWXSharedSuccess) name:@"WeChatSharedSuccess" object:nil];
    
    self.canUseTableView.tableFooterView = [[UIView alloc]init];
    self.didUseTableView.tableFooterView = [[UIView alloc] init];
    self.outDateTableView.tableFooterView = [[UIView alloc] init];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //发送网络请求，获取优惠券数组
    [self postToGetCoupon];
    [self postToGetUsedCoupon];
    [self postGetExpireCoupon];
    //初始化界面
    [self initTopView];
    //创建三个tableView
    [self initCanUseTableView];
    [self initDidUsedTableView];
    [self initOutDateTableView];
    //注册三个tableView的单元格
    [_canUseTableView registerNib:[UINib nibWithNibName:@"CouponTableViewCell" bundle:nil] forCellReuseIdentifier:@"CouponTableViewCell_canuse"];
    [_didUseTableView registerNib:[UINib nibWithNibName:@"CouponTableViewCell" bundle:nil] forCellReuseIdentifier:@"CouponTableViewCell_used"];
    [_outDateTableView registerNib:[UINib nibWithNibName:@"CouponTableViewCell" bundle:nil] forCellReuseIdentifier:@"CouponTableViewCell_outdate"];
    //设置tableView隐藏
    _canUseTableView.hidden = NO;
    _didUseTableView.hidden = YES;
    _outDateTableView.hidden = YES;
}
- (void)setNavigationBar
{
    self.navigationItem.title = @"优惠券";
    UIImage *leftItemImage = [UIImage imageNamed:@"左箭头"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[leftItemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    UIImage *rightItemImage = [UIImage imageNamed:@"coupon_share"];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[rightItemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickItemButtonTosharedToWeChat)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_TITLE_WHITE}];
    
    self.navigationController.navigationBar.barTintColor = COLOR_NAVI_BLACK;
    self.navigationController.navigationBar.backgroundColor = COLOR_NAVI_BLACK;
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
#pragma mark - 界面上一些视图的初始化
-(void) initTopView
{
    _topChooseView = [[UIView alloc] initWithFrame:CGRectMake(0, TopSpec, WIDTH_VIEW, TopViewHeight)];
    _topChooseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_topChooseView];
    
    _canUseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW / 3, TopViewHeight)];
    [_canUseButton setTitle:@"可使用" forState:UIControlStateNormal];
    [_canUseButton addTarget:self action:@selector(clickChooseButton:) forControlEvents:UIControlEventTouchUpInside];
    [_canUseButton setTitleColor:COLOR_TITLE_BLACK forState:UIControlStateNormal];
    [_canUseButton setTitleColor:COLOR_BUTTON_RED forState:UIControlStateSelected];
    _canUseButton.tag = 700;
    [_topChooseView addSubview:_canUseButton];
    
    _didUseButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH_VIEW / 3, 0, WIDTH_VIEW / 3, TopViewHeight)];
    [_didUseButton setTitle:@"已使用" forState:UIControlStateNormal];
    [_didUseButton addTarget:self action:@selector(clickChooseButton:) forControlEvents:UIControlEventTouchUpInside];
    [_didUseButton setTitleColor:COLOR_TITLE_BLACK forState:UIControlStateNormal];
    [_didUseButton setTitleColor:COLOR_BUTTON_RED forState:UIControlStateSelected];
    _didUseButton.tag = 701;
    [_topChooseView addSubview:_didUseButton];
    
    _outDateButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH_VIEW / 3 * 2, 0, WIDTH_VIEW / 3, TopViewHeight)];
    [_outDateButton setTitle:@"已过期" forState:UIControlStateNormal];
    [_outDateButton addTarget:self action:@selector(clickChooseButton:) forControlEvents:UIControlEventTouchUpInside];
    [_outDateButton setTitleColor:COLOR_TITLE_BLACK forState:UIControlStateNormal];
    [_outDateButton setTitleColor:COLOR_BUTTON_RED forState:UIControlStateSelected];
    _outDateButton.tag = 702;
    [_topChooseView addSubview:_outDateButton];
    
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, TopViewHeight - 2, WIDTH_VIEW / 3, 2)];
    _bottomLine.backgroundColor = COLOR_BUTTON_RED;
    [_topChooseView addSubview:_bottomLine];
}
#pragma mark - 三个tableView的初始化
- (void) initCanUseTableView
{
    _canUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TopViewHeight + TopSpec, WIDTH_VIEW, HEIGHT_VIEW - TopViewHeight - TopSpec)];
    _canUseTableView.tableFooterView = [[UIView alloc] init];
    _canUseTableView.backgroundColor = BACKGROUND_COLOR;
    _canUseTableView.tag = 600;
    _canUseTableView.delegate = self;
    _canUseTableView.dataSource = self;
    
    //创建tableheaderview
//    _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW, 48)];
//    //_tableHeaderView.backgroundColor = [UIColor grayColor];
//    _topTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, 12, WIDTH_VIEW * 0.75, 24)];
//    _topTextField.placeholder = @" 输入优惠码";
//    _topTextField.borderStyle = UITextBorderStyleNone;
//    _topTextField.layer.borderColor = COLOR_TITLE_GRAY.CGColor;
//    _topTextField.layer.borderWidth = 1;
//    _topTextField.layer.cornerRadius = CORNERRADIUS;
//    _topTextField.layer.masksToBounds = YES;
//    _exchangeButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH_VIEW * 0.75 + 20, 12, WIDTH_VIEW * 0.15, 24)];
//    _exchangeButton.backgroundColor = COLOR_BUTTON_RED;
//    _exchangeButton.layer.cornerRadius = CORNERRADIUS;
//    _exchangeButton.layer.masksToBounds = YES;
//    [_exchangeButton setTitle:@"兑换" forState:UIControlStateNormal];
//    [_exchangeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    
//    [_tableHeaderView addSubview:_topTextField];
//    [_tableHeaderView addSubview:_exchangeButton];
//    _canUseTableView.tableHeaderView = _tableHeaderView;
    
    [self.view addSubview:_canUseTableView];
}
- (void) initDidUsedTableView
{
    _didUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TopViewHeight + TopSpec, WIDTH_VIEW, HEIGHT_VIEW - TopViewHeight - TopSpec)];
    _didUseTableView.tableFooterView = [[UIView alloc] init];
    _didUseTableView.backgroundColor = BACKGROUND_COLOR;
    _didUseTableView.tag = 601;
    _didUseTableView.delegate = self;
    _didUseTableView.dataSource = self;
    [self.view addSubview:_didUseTableView];
}
- (void) initOutDateTableView
{
    _outDateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TopViewHeight + TopSpec, WIDTH_VIEW, HEIGHT_VIEW - TopViewHeight - TopSpec)];
    _outDateTableView.tableFooterView = [[UIView alloc] init];
    _outDateTableView.backgroundColor = BACKGROUND_COLOR;
    _outDateTableView.tag = 602;
    _outDateTableView.dataSource = self;
    _outDateTableView.delegate = self;
    [self.view addSubview:_outDateTableView];
}
#pragma mark - UItableViewDelegate， UItableViewdatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 600)
    {
        return self.canUseCouponArray.count;
    }
    else if (tableView.tag == 601)
    {
        return self.usedCouponArray.count;
    }
    else
    {
        return self.expireCouponArray.count;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponTableViewCell *cell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (tableView.tag == 600)
    {
        //可使用
        cell = [tableView dequeueReusableCellWithIdentifier:@"CouponTableViewCell_canuse" forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[CouponTableViewCell alloc] init];
        }
        NKUserCoupon *coupon = self.canUseCouponArray[indexPath.row];
        
        cell.moneyLabel.text = [NSString stringWithFormat:@"%d", coupon.denomination / 100];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:coupon.periodtimestart/1000];
        NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:coupon.periodtimeend/1000];
        [formatter setDateFormat:@"HH:mm"];
        NSString *startTimeStr = [formatter stringFromDate:startTime];
        NSString *endTimeStr = [formatter stringFromDate:endTime];
        [formatter setDateFormat:@"YYYY年MM月dd日"];
        //NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:coupon.validitytimeend/1000];
        NSString *endDateStr = [formatter stringFromDate:coupon.expiretime];
        
        if ([coupon.ratio isEqualToString:@"0"])
        {
            cell.limitMoneyLabel.text = @"停车立减";
            cell.couponTypeLabel.text = @"立减";
        }
        else
        {
            cell.limitMoneyLabel.text = [NSString stringWithFormat:@"满%@元可用", coupon.ratio];
            cell.couponTypeLabel.text = @"满减";
        }
        if (startTime && endTime)
        {
            cell.limitTimeLabel.text = [NSString stringWithFormat:@"限定%@-%@使用", startTimeStr, endTimeStr];
        }
        else
        {
            cell.limitTimeLabel.text = @"无限定时间";
        }
        if (endDateStr)
        {
            cell.limitDateLabel.text = [NSString stringWithFormat:@"有效期%@", endDateStr];
        }
        else
        {
            cell.limitDateLabel.text = @"永久有效";
        }
        if (coupon.roadsection)
        {
            cell.limitPlaceLabel.text = [NSString stringWithFormat:@"仅限%@路段使用", coupon.roadsection];
        }
        else
        {
            cell.limitPlaceLabel.text = @"全路段可用";
        }
//        if (coupon.coupontype)
//        {
//            cell.quanImageView.image = [UIImage imageNamed:@"泊券"];
//        }
        
    }
    else if (tableView.tag == 601)
    {
        //已经使用
        cell = [tableView dequeueReusableCellWithIdentifier:@"CouponTableViewCell_used" forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[CouponTableViewCell alloc] init];
        }
        NKUserCoupon *coupon = self.usedCouponArray[indexPath.row];
        cell.leadingImageView.image = [UIImage imageNamed:@"coupon_left_outtime"];
        cell.trailImageView.image = [UIImage imageNamed:@"coupon_right_outtime"];
        cell.moneyLabel.text = [NSString stringWithFormat:@"%d", coupon.denomination / 100];
        cell.moneyLabel.textColor = COLOR_TITLE_GRAY;
        cell.moneyDetailLabel.textColor = COLOR_TITLE_GRAY;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:coupon.periodtimestart/1000];
        NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:coupon.periodtimeend/1000];
        [formatter setDateFormat:@"HH:mm"];
        NSString *startTimeStr = [formatter stringFromDate:startTime];
        NSString *endTimeStr = [formatter stringFromDate:endTime];
        [formatter setDateFormat:@"YYYY年MM月dd日"];
        //NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:coupon.validitytimeend/1000];
        NSString *endDateStr = [formatter stringFromDate:coupon.expiretime];
        
        if ([coupon.ratio isEqualToString:@"0"])
        {
            cell.limitMoneyLabel.text = @"停车立减";
            cell.couponTypeLabel.text = @"立减";
            cell.couponTypeLabel.textColor = COLOR_TITLE_GRAY;
            cell.couponTypeLabel.backgroundColor = [UIColor whiteColor];
            cell.couponTypeLabel.layer.borderWidth = 1;
            cell.couponTypeLabel.layer.borderColor = COLOR_TITLE_GRAY.CGColor;
        }
        else
        {
            cell.limitMoneyLabel.text = [NSString stringWithFormat:@"满%@元可使用", coupon.ratio];
            cell.couponTypeLabel.text = @"满减";
            cell.couponTypeLabel.textColor = COLOR_TITLE_GRAY;
            cell.couponTypeLabel.backgroundColor = [UIColor whiteColor];
            cell.couponTypeLabel.layer.borderWidth = 1;
            cell.couponTypeLabel.layer.borderColor = COLOR_TITLE_GRAY.CGColor;
        }
        cell.limitMoneyLabel.textColor = COLOR_TITLE_GRAY;
        cell.limitTimeLabel.text = [NSString stringWithFormat:@"限定%@-%@使用", startTimeStr, endTimeStr];
        cell.limitTimeLabel.textColor = COLOR_TITLE_GRAY;
        cell.limitDateLabel.text = [NSString stringWithFormat:@"有效期%@", endDateStr];
        cell.limitDateLabel.textColor = COLOR_TITLE_GRAY;
        cell.limitPlaceLabel.text = [NSString stringWithFormat:@"仅限%@使用", coupon.roadsection];
        cell.limitPlaceLabel.textColor = COLOR_TITLE_GRAY;
//        if (coupon.coupontype)
//        {
//            cell.quanImageView.image = [UIImage imageNamed:@"泊券"];
//        }
    }
    else
    {
        //已经过期602
        cell = [tableView dequeueReusableCellWithIdentifier:@"CouponTableViewCell_outdate" forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[CouponTableViewCell alloc] init];
        }
        NKUserCoupon *coupon = self.expireCouponArray[indexPath.row];
        cell.leadingImageView.image = [UIImage imageNamed:@"coupon_left_outtime"];
        cell.trailImageView.image = [UIImage imageNamed:@"coupon_right_outtime"];
        cell.moneyLabel.text = [NSString stringWithFormat:@"%d", coupon.denomination / 100];
        cell.moneyLabel.textColor = COLOR_TITLE_GRAY;
        cell.moneyDetailLabel.textColor = COLOR_TITLE_GRAY;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:coupon.periodtimestart/1000];
        NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:coupon.periodtimeend/1000];
        [formatter setDateFormat:@"HH:mm"];
        NSString *startTimeStr = [formatter stringFromDate:startTime];
        NSString *endTimeStr = [formatter stringFromDate:endTime];
        [formatter setDateFormat:@"YYYY年MM月dd日"];
        //NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:coupon.validitytimeend/1000];
        NSString *endDateStr = [formatter stringFromDate:coupon.expiretime];
        
        cell.moneyLabel.text = [NSString stringWithFormat:@"%d", coupon.denomination / 100];
        cell.moneyLabel.textColor = COLOR_TITLE_GRAY;
        cell.moneyDetailLabel.textColor = COLOR_TITLE_GRAY;
        
        if ([coupon.ratio isEqualToString:@"0"])
        {
            cell.limitMoneyLabel.text = @"停车立减";
            cell.couponTypeLabel.text = @"立减";
            cell.couponTypeLabel.textColor = COLOR_TITLE_GRAY;
            cell.couponTypeLabel.backgroundColor = [UIColor whiteColor];
            cell.couponTypeLabel.layer.borderWidth = 1;
            cell.couponTypeLabel.layer.borderColor = COLOR_TITLE_GRAY.CGColor;
        }
        else
        {
            cell.limitMoneyLabel.text = [NSString stringWithFormat:@"满%@元可使用", coupon.ratio];
            cell.couponTypeLabel.text = @"满减";
            cell.couponTypeLabel.textColor = COLOR_TITLE_GRAY;
            cell.couponTypeLabel.backgroundColor = [UIColor whiteColor];
            cell.couponTypeLabel.layer.borderWidth = 1;
            cell.couponTypeLabel.layer.borderColor = COLOR_TITLE_GRAY.CGColor;
        }
        cell.limitMoneyLabel.textColor = COLOR_TITLE_GRAY;
        cell.limitTimeLabel.text = [NSString stringWithFormat:@"限定%@-%@使用", startTimeStr, endTimeStr];
        cell.limitTimeLabel.textColor = COLOR_TITLE_GRAY;
        cell.limitDateLabel.text = [NSString stringWithFormat:@"有效期%@", endDateStr];
        cell.limitDateLabel.textColor = COLOR_TITLE_GRAY;
        cell.limitPlaceLabel.text = [NSString stringWithFormat:@"仅限%@使用", coupon.roadsection];
        cell.limitPlaceLabel.textColor = COLOR_TITLE_GRAY;
//        if (coupon.coupontype)
//        {
//            cell.quanImageView.image = [UIImage imageNamed:@"泊券"];
//        }
    }
    cell.couponTypeLabel.layer.cornerRadius = 10;
    cell.couponTypeLabel.layer.masksToBounds = YES;
    cell.backgroundColor = BACKGROUND_COLOR;
    cell.contentView.backgroundColor = BACKGROUND_COLOR;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 96;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW, 10)];
    view.backgroundColor = BACKGROUND_COLOR;
    return view;
}
#pragma mark 切换tableView按钮
- (void)clickChooseButton:(UIButton *)sender
{
    _canUseButton.selected = NO;
    _didUseButton.selected = NO;
    _outDateButton.selected = NO;
    sender.selected = YES;
    if (sender.tag == 700)
    {
        //第一个tableView
        _canUseTableView.hidden = NO;
        _didUseTableView.hidden = YES;
        _outDateTableView.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = _bottomLine.frame;
            frame.origin.x = 0;
            _bottomLine.frame = frame;
        }];
    }
    else if (sender.tag == 701)
    {
        //第二个tableview
        _canUseTableView.hidden = YES;
        _didUseTableView.hidden = NO;
        _outDateTableView.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = _bottomLine.frame;
            frame.origin.x = WIDTH_VIEW / 3;
            _bottomLine.frame = frame;
        }];
    }
    else if (sender.tag == 702)
    {
        //第三个tableView
        _canUseTableView.hidden = YES;
        _didUseTableView.hidden = YES;
        _outDateTableView.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = _bottomLine.frame;
            frame.origin.x = WIDTH_VIEW / 3 * 2;
            _bottomLine.frame = frame;
        }];
    }
    else
    {
        
    }
}
#pragma mark - 网络请求相关方法
-(void) postToGetCoupon
{
    _dataManager = [NKDataManager sharedDataManager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *sspid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sspId"];
    [parameters setObject:sspid forKey:@"sspid"];
    
    [_dataManager POSTGetUserCouponWithParameters:parameters Success:^(NSArray *couponArray) {
        if (couponArray.count > 0)
        {
            self.canUseCouponArray = [NSMutableArray arrayWithArray:couponArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_canUseTableView reloadData];
            });
        }
        else
        {
            NSLog(@"优惠券为空1！");
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty_bg"]];
                imageView.center = CGPointMake(self.view.center.x, self.view.center.y - 42);
                [_canUseTableView addSubview:imageView];
            });
        }
    } Failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}
-(void) postToGetUsedCoupon
{
    _dataManager = [NKDataManager sharedDataManager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *sspid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sspId"];
    [parameters setObject:sspid forKey:@"sspid"];
    
    [_dataManager POSTGetUserUsedCouponWithParameters:parameters Success:^(NSArray *couponArray) {
        if (couponArray.count > 0)
        {
            self.usedCouponArray = [NSMutableArray arrayWithArray:couponArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_didUseTableView reloadData];
            });
        }
        else
        {
            NSLog(@"优惠券为空2！");
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty_bg"]];
                imageView.center = CGPointMake(self.view.center.x, self.view.center.y - 42);
                [_didUseTableView addSubview:imageView];
            });
        }
    } Failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}
-(void) postGetExpireCoupon
{
    _dataManager = [NKDataManager sharedDataManager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *sspid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sspId"];
    [parameters setObject:sspid forKey:@"sspid"];
    
    [_dataManager POSTGetUserExpireCouponWithParameters:parameters Success:^(NSArray *couponArray) {
        if (couponArray.count > 0)
        {
            self.expireCouponArray = [NSMutableArray arrayWithArray:couponArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_outDateTableView reloadData];
            });
        }
        else
        {
            NSLog(@"优惠券为空3！");
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty_bg"]];
                imageView.center = CGPointMake(self.view.center.x, self.view.center.y - 42);
                [_outDateTableView addSubview:imageView];
            });
        }
    } Failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}
#pragma mark - 分享方法
-(void)couponWXSharedSuccess
{
    _dataManager = [NKDataManager sharedDataManager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"myToken"];
    [parameters setObject:token forKey:@"token"];
    
    [_dataManager POSTGetSharedCouponWithParameters:parameters Success:^(NSArray *couponArray) {
        if (couponArray.count > 0)
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"分享成功！";
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                [hud removeFromSuperViewOnHide];
            });
            NSInteger couponTotalMoney = 0;
            for (NKUserCoupon *coupon in couponArray)
            {
                couponTotalMoney = couponTotalMoney + coupon.denomination/100;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //弹窗送优惠券
                _alertView = [[NKAlertView alloc] initWithAlertViewType:NKAlertViewTypeSharedCouponSuccess];
                _alertView.sharedCouponMoneyLabel.text = [NSString stringWithFormat:@"%lu",(long)couponTotalMoney];
                //button点击事件
                [_alertView.chargeCouponButton addTarget:self action:@selector(clickAlertChargeCouponButton) forControlEvents:UIControlEventTouchUpInside];
                
                [_alertView show:YES];
            });
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"获取失败";
            hud.detailsLabel.text = @"提示：每日只能获取一次优惠券！";
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.5];
                [hud removeFromSuperViewOnHide];
            });
        }
    } Failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}
-(void)clickAlertChargeCouponButton
{
    [_alertView hide:YES];
    [self postToGetCoupon];
    [_canUseTableView reloadData];
}
-(void)clickItemButtonTosharedToWeChat
{
    [_alertView hide:YES];
    //弹出分享的界面
    _alertView = [[NKAlertView alloc] initWithAlertViewType:NKAlertViewTypeSharedToWeChat Height:90 andWidth:WIDTH_VIEW * 0.8];
    //两个button点击事件
    [_alertView.sharedToWeChatButton addTarget:self action:@selector(clickAlertButtonSharedToWechat) forControlEvents:UIControlEventTouchUpInside];
    [_alertView.sharedToFriendCircleButton addTarget:self action:@selector(clickAlertButtonSharedToFriendCircle) forControlEvents:UIControlEventTouchUpInside];
    
    [_alertView show:YES];
}
- (void)clickAlertButtonSharedToWechat
{
    WXApiManager *manager = [WXApiManager sharedManager];
    [_alertView hide:YES];
    [manager sharedToWeChat];
}
- (void)clickAlertButtonSharedToFriendCircle
{
    WXApiManager *manager = [WXApiManager sharedManager];
    [_alertView hide:YES];
    [manager sharedToFriendCircle];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
