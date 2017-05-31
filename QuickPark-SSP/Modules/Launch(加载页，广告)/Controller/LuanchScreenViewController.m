//
//  LuanchScreenViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 2016/11/7.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "LuanchScreenViewController.h"
#import "LoginViewController.h"
#import "NKLogin.h"
#import "MainTabbarViewController.h"
#import "NKDataManager.h"
#import "NKImageManager.h"


@interface LuanchScreenViewController ()

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) UIImageView *launchImageView;

@property (nonatomic, strong) UIButton *countDownButton;

@property (nonatomic, strong) NSTimer *countTimer;

@property (nonatomic, assign) int count;

@end
// 显示的时间
static int const showtime = 3;

@implementation LuanchScreenViewController

- (NSTimer *)countTimer
{
    if (!_countTimer) {
        _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    return _countTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    [self postToGetImageUrl];
}
- (void)viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarHidden = NO;
}
- (void)viewDidAppear:(BOOL)animated
{
    [self startTimer];
    // 倒计时方法1：GCD
    // [self startCoundown];
}

- (void) initSubViews
{
    // 1.广告图片
    _launchImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _launchImageView.backgroundColor = [UIColor whiteColor];
    _launchImageView.userInteractionEnabled = YES;
    _launchImageView.contentMode = UIViewContentModeScaleAspectFit;
    _launchImageView.clipsToBounds = YES;
    _launchImageView.image = [UIImage imageNamed:@""];
    //点击调到广告页面
    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToAd)];
    //[_launchImageView addGestureRecognizer:tap];
    
    // 2.跳过按钮
    CGFloat btnW = 60;
    CGFloat btnH = 30;
    _countDownButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH_VIEW - btnW - 24, btnH, btnW, btnH)];
    [_countDownButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_countDownButton setTitle:[NSString stringWithFormat:@"跳过%ds", showtime] forState:UIControlStateNormal];
    _countDownButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_countDownButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _countDownButton.backgroundColor = [UIColor colorWithRed:38 /255.0 green:38 /255.0 blue:38 /255.0 alpha:0.6];
    _countDownButton.layer.cornerRadius = 4;
    
    [self.view addSubview:_launchImageView];
    [self.view addSubview:_countDownButton];
}
- (void)countDown
{
    _count--;
    [_countDownButton setTitle:[NSString stringWithFormat:@"跳过%ds",_count] forState:UIControlStateNormal];
    if (_count == 0)
    {
        [self dismiss];
        //获得storyBored中的
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //检验登录状态
        NSInteger LoginFlag = [[NSUserDefaults standardUserDefaults] integerForKey:@"loginFlag"];
        if (LoginFlag == 0)
        {
            //未登录
            //初始化一个登陆界面控制器
            LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            //设置登陆界面为主视图控制器
            self.window.rootViewController = loginVC;
        }
        if (LoginFlag == 1)
        {
            //已登录直接推出界面
            NSString *str = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
            NSString *path = [NSString stringWithFormat:@"%@/LoginMsg.txt", str];
            NSData *data = [NSData dataWithContentsOfFile:path];
            NKLogin *LoginMsg = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            //    NSLog(@"%@", LoginMsg);
            //初始化一个tabBar控制器
            
            MainTabbarViewController *mainTabbarController = [[MainTabbarViewController alloc] initWithLoginMsg:LoginMsg];
            //设置控制器为Window的根控制器,并且在MainTabbarController中设置自控制器
            self.window.rootViewController=mainTabbarController;
        }
    }
}

// 定时器倒计时
- (void)startTimer
{
    _count = showtime;
    [[NSRunLoop mainRunLoop] addTimer:self.countTimer forMode:NSRunLoopCommonModes];
}

// GCD倒计时
- (void)startCoundown
{
    __block int timeout = showtime + 1; //倒计时时间 + 1
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self dismiss];
                
            });
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_countDownButton setTitle:[NSString stringWithFormat:@"跳过%ds",timeout] forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
// 移除广告页面
- (void)dismiss
{
    [self.countTimer invalidate];
    self.countTimer = nil;
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.view.alpha = 0.f;
        
    } completion:^(BOOL finished) {
        
        [self pushMainVC];
    }];
    
}
- (void)pushMainVC
{
    //获得storyBored中的
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //检验登录状态
    NSInteger LoginFlag = [[NSUserDefaults standardUserDefaults] integerForKey:@"loginFlag"];
    if (LoginFlag == 0)
    {
        //未登录
        //初始化一个登陆界面控制器
        LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        //设置登陆界面为主视图控制器
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    if (LoginFlag == 1)
    {
        //已登录直接推出界面
        NSString *str = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
        NSString *path = [NSString stringWithFormat:@"%@/LoginMsg.txt", str];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NKLogin *LoginMsg = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        //    NSLog(@"%@", LoginMsg);
        //初始化一个tabBar控制器
        MainTabbarViewController *mainTabbarController = [[MainTabbarViewController alloc] initWithLoginMsg:LoginMsg];
        //设置控制器为Window的根控制器,并且在MainTabbarController中设置自控制器
        [self presentViewController:mainTabbarController animated:YES completion:nil];
    }
}

#pragma mark - 网络请求
- (void)postToGetImageUrl
{
    NKDataManager *dataManager = [NKDataManager sharedDataManager];
    [dataManager POSTGEtAdvertisementImageWithParameters:nil Success:^(NSArray<NSString *> *imageURLArray) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        NSLog(@"%@",path);
        if (imageURLArray.count == 0)
        {
            //无图片加载本地图片
        }
        else
        {
            //有图片加载图片
            NSMutableArray *ImageURLMutableArray = [NSMutableArray array];
            for (NSString *url in imageURLArray)
            {
                NSString *str = [url stringByReplacingOccurrencesOfString:@"http://ssp.quickpark.com.cn:80" withString:@"https://ssp.quickpark.com.cn"];
                [ImageURLMutableArray addObject:str];
            }
            NSString *imageUrl = ImageURLMutableArray[arc4random() % ImageURLMutableArray.count];
            NSData *imageData = [NKImageManager getImageDataWithUrl:imageUrl];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.launchImageView.image = [UIImage imageWithData:imageData];
            });
        }
    } Failure:^(NSError *error) {
        NSLog(@"网络异常");
    }];
}
@end
