//
//  LocalPassportViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 2017/5/3.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "LocalPassportViewController.h"
#import "LocalPassportTableViewCell.h"
#import "BindLocalPassportViewController.h"
#import "NKDataManager.h"
#import "MBProgressHUD.h"
#import "NKLocalPassportBaseDto.h"
#import "NKAlertView.h"
#import "NKColorManager.h"

@interface LocalPassportViewController ()<UITableViewDelegate, UITableViewDataSource, LocalPassportCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) NKDataManager *dataManager;

@property (nonatomic, strong) MBProgressHUD *HUD;

@property (nonatomic, strong) NSArray *bindArray;

@property (nonatomic, strong) NSArray *unBindArray;

@property (nonatomic, strong) NSArray *currentArray;

@property (nonatomic, strong) NKAlertView *alertView;

@end

@implementation LocalPassportViewController

#pragma mark - setter && getter
- (NSArray *)currentArray
{
    if (_currentArray == nil)
    {
        _currentArray = [NSArray array];
    }
    return _currentArray;
}
- (NSArray *)bindArray
{
    if (_bindArray == nil)
    {
        _bindArray = [NSArray array];
    }
    return _bindArray;
}
- (NSArray *)unBindArray
{
    if (_unBindArray == nil)
    {
        _unBindArray = [NSArray array];
    }
    return _unBindArray;
}

- (NKDataManager *)dataManager
{
    if (!_dataManager)
    {
        _dataManager = [NKDataManager sharedDataManager];
    }
    return _dataManager;
}

#pragma Controller Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBar];
    [self initSubViews];
    
    [self.tableView registerClass:[LocalPassportTableViewCell class] forCellReuseIdentifier:@"LocalPassportTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self postToGetLocalPassportInfo];
}

- (void)dealloc
{
    [_HUD removeFromSuperViewOnHide];
    _HUD = nil;
}

#pragma mark - 界面初始化
- (void)setNavigationBar
{
    self.navigationItem.title = @"本地通";
    UIImage *leftItemImage = [UIImage imageNamed:@"左箭头"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[leftItemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_TITLE_WHITE}];
    self.navigationController.navigationBar.barTintColor = COLOR_NAVI_BLACK;
    [self.navigationController.navigationBar setTintColor:COLOR_NAVI_BLACK];
}
- (void)goBack
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
- (void)initSubViews
{
    self.view.backgroundColor = [UIColor colorWithRed:229.0 / 255.0 green:229.0 / 255.0 blue:229.0 / 255.0 alpha:1.0];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, WIDTH_VIEW, 36)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: topView];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW / 2, 36)];
    _leftButton = leftButton;
    [leftButton setTitle:@"已绑" forState:UIControlStateNormal];
    [leftButton setTitleColor:COLOR_TITLE_BLACK forState:UIControlStateNormal];
    [leftButton setTitleColor:COLOR_TITLE_RED forState:UIControlStateSelected];
    [leftButton addTarget:self action:@selector(clickTopViewButton:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.selected = YES;
    leftButton.tag = 1000;
    [topView addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH_VIEW / 2, 0, WIDTH_VIEW / 2, 36)];
    _rightButton = rightButton;
    [rightButton setTitle:@"未绑" forState:UIControlStateNormal];
    [rightButton setTitleColor:COLOR_TITLE_BLACK forState:UIControlStateNormal];
    [rightButton setTitleColor:COLOR_TITLE_RED forState:UIControlStateSelected];
    [rightButton addTarget:self action:@selector(clickTopViewButton:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.tag = 1001;
    [topView addSubview:rightButton];
    
    UIView *line = [[UIView alloc] initWithFrame: CGRectMake(0, 35, WIDTH_VIEW / 2, 2)];
    _line = line;
    line.backgroundColor = COLOR_MAIN_RED;
    [topView addSubview:line];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 101, WIDTH_VIEW, HEIGHT_VIEW - 101)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = BACKGROUND_COLOR;
    [self.view addSubview:_tableView];
    
    //添加滑动手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.tableView addGestureRecognizer:recognizer];
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.tableView addGestureRecognizer:recognizer];
    
    _HUD = [[MBProgressHUD alloc] init];
    _HUD.center = self.view.center;
    [self.view addSubview:_HUD];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocalPassportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocalPassportTableViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    
    if (cell == nil)
    {
        cell = [[LocalPassportTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LocalPassportTableViewCell"];
    }
    if (_leftButton.selected)
    {
        NKLocalPassportBindDto *passport = self.currentArray[indexPath.row];
        [cell setCellLabelTitle:passport.cityName];
        [cell setCellButtonTitle:@"解除绑定"];
        [cell setCellButtonTag:indexPath.row + 1000];
        [cell setCellBackColor:[NKColorManager colorWithStr:passport.listColor alpha:1.0]];
    }
    else
    {
        NKLocalPassportUnbindDto *passport = self.currentArray[indexPath.row];
        [cell setCellLabelTitle:passport.cityName];
        [cell setCellButtonTitle:@"绑定"];
        [cell setCellButtonTag:indexPath.row + 2000];
        [cell setCellBackColor:[NKColorManager colorWithStr:passport.listColor alpha:1.0]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 114;
}

#pragma mark - 点击button的方法
- (void)clickTopViewButton:(UIButton *)sender
{
    if (sender.selected)
    {
        return;
    }
    [_rightButton setSelected:NO];
    [_leftButton setSelected:NO];
    sender.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _line.frame;
        frame.origin.x = WIDTH_VIEW / 2 * (sender.tag - 1000);
        _line.frame = frame;
    }];
    [self postToGetLocalPassportInfo];
}

#pragma mark - 添加滑动手势
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if (_line.frame.origin.x == WIDTH_VIEW / 2)
        {
            return;
        }
        CGRect frame = _line.frame;
        frame.origin.x = WIDTH_VIEW / 2;
        [UIView animateWithDuration:0.3 animations:^{
            _line.frame = frame;
            _leftButton.selected = NO;
            _rightButton.selected = YES;
        }];
        
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        if (_line.frame.origin.x == 0)
        {
            return;
        }
        CGRect frame = _line.frame;
        frame.origin.x  = 0;
        [UIView animateWithDuration:0.3 animations:^{
            _line.frame = frame;
            _leftButton.selected = YES;
            _rightButton.selected = NO;
        }];
    }
    [self postToGetLocalPassportInfo];
}

#pragma mark - LocalPassportCellDelegate
- (void)clickCellButton:(UIButton *)button
{
    if (button.tag < 2000)
    {
        //已绑定
        NKLocalPassportBindDto *passport = self.currentArray[button.tag - 1000];
        NKAlertView *alertView = [[NKAlertView alloc] initWithAlertViewType:NKAlertViewTypeRemoveBind Height:192 andWidth:WIDTH_VIEW - 72];
        _alertView = alertView;
        alertView.bindPassportLabel.text = [NSString stringWithFormat:@"解除绑定%@账户后", passport.cityName];
        alertView.bindPassportDetailLabel.text = [NSString stringWithFormat:@"将不再关联%@账户信息", passport.cityName];
        alertView.removeBindSureButton.tag = 3000 + button.tag - 1000;
        [alertView.removeBindSureButton addTarget:self action:@selector(clickRemoveBindButton:) forControlEvents:UIControlEventTouchUpInside];
        [alertView show:YES];
    }
    else
    {
        NKLocalPassportUnbindDto *passport = self.currentArray[button.tag - 2000];
        BindLocalPassportViewController *blpVC = [[BindLocalPassportViewController alloc] initWithLocalPassport:passport];
        [self.navigationController pushViewController:blpVC animated:YES];
    }
}
- (void)clickRemoveBindButton:(UIButton *)button
{
    NKLocalPassportBindDto *passport = self.currentArray[button.tag - 3000];
    NSString *areaCode = [NSString stringWithFormat:@"%li", (long)passport.prefectureCode];
    [_alertView hide:YES];
    [self postToRemoveBindWithAreaCode:areaCode];
}

#pragma mark - 网络请求
- (void)postToGetLocalPassportInfo
{
    _HUD.mode = MBProgressHUDModeIndeterminate;
    [_HUD showAnimated:YES];
    
    NSString *sspId = [[NSUserDefaults standardUserDefaults] objectForKey:@"sspId"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:sspId forKey:@"userId"];
    [self.dataManager POSTToGetLocalPassportInfoWithParameters:parameters Success:^(NKLocalPassportBaseDto *baseDto) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_HUD hideAnimated:YES];
        });
        if (baseDto.ret == 0)
        {
            self.bindArray = baseDto.alreadyBindCity;
            self.unBindArray = baseDto.unbindCity;
            if (_leftButton.isSelected)
            {
                self.currentArray = self.bindArray;
            }
            else
            {
                self.currentArray = self.unBindArray;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        else
        {
            [self showHUDWith:@"数据异常"];
        }
    } Failure:^(NSError *error) {
        [self showHUDWith:@"网络异常"];
    }];
    
}

- (void)postToRemoveBindWithAreaCode:(NSString *)areaCode
{
    _HUD.mode = MBProgressHUDModeIndeterminate;
    [_HUD showAnimated:YES];
    
    NSString *sspId = [[NSUserDefaults standardUserDefaults] objectForKey:@"sspId"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:sspId forKey:@"userId"];
    [parameters setValue:areaCode forKey:@"areaCode"];
    
    [self.dataManager POSTToRemoveBindLocalPassportWithParameters:parameters Success:^(NKBase *base) {
        if (base.ret == 0)
        {
            [self showHUDWith:@"解绑账户成功"];
            [self postToGetLocalPassportInfo];
        }
        else
        {
            [self showHUDWith:@"解绑账户失败"];
        }
    } Failure:^(NSError *error) {
        [self showHUDWith:@"网络异常"];
    }];
}

- (void)showHUDWith:(NSString *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _HUD.mode = MBProgressHUDModeText;
        _HUD.label.text = msg;
        [_HUD showAnimated:YES];
        [_HUD hideAnimated:YES afterDelay:2.0];
    });
}

@end
