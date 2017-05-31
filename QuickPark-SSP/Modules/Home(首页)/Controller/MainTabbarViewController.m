//
//  NKTabbarViewController.m
//  MyTabbarTest
//
//  Created by Nick on 2016/11/14.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "MainTabbarViewController.h"
#import "NKTabBar.h"
#import "NKDataManager.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "OneKeyStopCarViewController.h"
#import "MineViewController.h"
#import "OneKeyStopCarNavigationViewController.h"
#import "StopFineViewController.h"

@interface MainTabbarViewController()<NKTabBarDelegate>

@property (nonatomic, strong)NKDataManager *dataManager;

@end

@implementation MainTabbarViewController

-(instancetype)initWithLoginMsg:(NKLogin *)loginMsg
{
    if (self = [super init])
    {
        self.loginMsg  = loginMsg;//赋值一定要在前面！！！
        [self createSubControllers];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NKTabBar *tabBar = [[NKTabBar alloc] initWithFrame:self.tabBar.frame];
    tabBar.tabBarDelegate = self;
    [self setValue:tabBar forKeyPath:@"tabBar"];
    
    [[UITabBar appearance] setBarTintColor:COLOR_TAB_BLACK];
    [UITabBar appearance].translucent = NO;
    
    [self setNavigationBar];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self postToCheckOnekeyOrder];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
#pragma mark - 配置导航栏
- (void)setNavigationBar
{
    self.navigationItem.title = self.loginMsg.user.niName;
    UIImage *rightItemImage = [UIImage imageNamed:@"左箭头"];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[rightItemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_TITLE_WHITE}];
    
    self.navigationController.navigationBar.barTintColor = COLOR_NAVI_BLACK;
    self.navigationController.navigationBar.backgroundColor = COLOR_NAVI_BLACK;
}

#pragma mark - 页面初始化的一些方法
- (void)createSubControllers
{
    //创建子控制器
    //StopFineTableViewController *stopfineVC = [[StopFineTableViewController alloc] init];
    StopFineViewController *stopfineVC = [[StopFineViewController alloc] init];
    
    MineViewController *mineVC = [[MineViewController alloc] initWithNibName:@"MineViewController" bundle:nil];
    mineVC.loginMsg = self.loginMsg;
    mineVC.view.backgroundColor = COLOR_BACKGROUND_BLACK;
    
    self.viewControllers=@[stopfineVC, mineVC];
    //设置tabbar按钮
    [self setTabBarItems];
}

- (void)setTabBarItems
{
    UITabBarItem *item_stopCar = self.tabBar.items[0];
    item_stopCar.title = @"停好";
    item_stopCar.image = [UIImage imageNamed:@"停好"];
    UIImage *selectImage = [UIImage imageNamed:@"停好-选中状态"];
    item_stopCar.selectedImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *item_wallet = self.tabBar.items[1];
    item_wallet.title = @"我的";
    item_wallet.image = [UIImage imageNamed:@"我的"];
    selectImage = [UIImage imageNamed:@"我的-选中状态"];
    item_wallet.selectedImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 默认
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = COLOR_TITLE_GRAY;
    
    // 选中
    NSMutableDictionary *attrSelected = [NSMutableDictionary dictionary];
    attrSelected[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrSelected[NSForegroundColorAttributeName] = COLOR_TITLE_WHITE;
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:attrSelected forState:UIControlStateSelected];
}


#pragma NKTabBarDelegate
- (void)tabBarDidClickQuickParkButton:(NKTabBar *)tabBar
{
    NSLog(@"点击了Quickpark button！！");
    OneKeyStopCarViewController *oscVC = [[OneKeyStopCarViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:oscVC];
    [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark - 网络请求方法
- (void)postToCheckOnekeyOrder
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *orderNo = [[NSUserDefaults standardUserDefaults] objectForKey:@"orderNo"];
    if (orderNo.length == 0)
    {
        return;
    }
    [parameters setObject:orderNo forKey:@"orderNo"];
    _dataManager = [NKDataManager sharedDataManager];
    [_dataManager POSTCheckOneKeyOrderWithParameters:parameters Success:^(NKSspOrderBackValue *backValue) {
        
        if (backValue.ret == 0)
        {
            //有订单存在
            NSString *timeStr = (NSString *)backValue.obj;
            NSTimeInterval time = timeStr.doubleValue / 1000;
            NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
            NSInteger countDownTime = currentTime - time;
            NSInteger leftTime = 900 - countDownTime;
            [[NSUserDefaults standardUserDefaults] setInteger:leftTime forKey:@"leftTime"];
            if (countDownTime > 900)
            {
                //取消订单,超时取消
                [self cancelOrder];
                return;
            }
            else
            {
                AMapNaviPoint *startPoint = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"NaviStartPoint"]];
                NKSspOrderParameters *orderParameters = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"SspOrderParameters"]];
                OneKeyStopCarNavigationViewController *vc = [[OneKeyStopCarNavigationViewController alloc] initWithParameters:orderParameters andStarPoint:startPoint andCountDownTime:leftTime];
                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tabBarController presentViewController:navi animated:YES completion:nil];
                });
            }
            
        }
        else
        {
            //没有订单存在
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"orderNo"];
            NSLog(@"%@", backValue.msg);
        }
    } Failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}
//超时取消下单
-(void)cancelOrder
{
    NSMutableDictionary *parameters = [[NSUserDefaults standardUserDefaults] objectForKey:@"cancelOrderParameters"];
    //取消订单
    _dataManager = [NKDataManager sharedDataManager];
    [_dataManager POSTCancelOneKeyOrderWithParameters:parameters Success:^(NKSspOrderBackValue *backValue) {
        if (backValue.ret == 0)
        {
            NSLog(@"取消订单成功！");
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"orderNo"];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"超时订单取消成功！";
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


@end
