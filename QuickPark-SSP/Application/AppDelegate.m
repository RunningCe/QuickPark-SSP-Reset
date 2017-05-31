//
//  AppDelegate.m
//  QuickPark-SSP
//
//  Created by Nick on 16/8/8.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "WXApiManager.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <AlipaySDK/AlipaySDK.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "GeTuiSdk.h"
#import "GTManager.h"
#import "Udesk.h"
#import "LuanchScreenViewController.h"
#import <Bugly/Bugly.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //启动图片延时: 0.5秒
    [NSThread sleepForTimeInterval:0.5];
   
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //注册Udesk客服功能
    [UdeskManager initWithAppKey:UdeskAppKey appId:UdeskAppID domain:UdeskDomianName];
    /*******注册个推*********/
    // [ GTSdk ]：是否运行电子围栏Lbs功能和是否SDK主动请求用户定位
    [GeTuiSdk lbsLocationEnable:YES andUserVerify:YES];
    // [ GTSdk ]：自定义渠道
    [GeTuiSdk setChannelId:@"GT-Channel"];
    // [ GTSdk ]：使用APPID/APPKEY/APPSECRENT创建个推实例
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:[GTManager sharedManager]];
    // 注册APNs - custom method - 开发者自定义的方法
    [self registerUserNotification];
    /***********************/
    //注册微信
    [WXApi registerApp:WX_APPID withDescription:@"Wechat"];
    //注册高德地图
    [AMapServices sharedServices].apiKey = GDMapKey;
    //注册腾讯bugly
    [Bugly startWithAppId:BugLyAppid];
    
    //改变状态栏颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //1.创建Window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    LuanchScreenViewController *lsVC = [[LuanchScreenViewController alloc] init];
    self.window.rootViewController = lsVC;
    //2.设置Window为主窗口并显示出来
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - 微信，QQ，支付宝
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    
//    [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
//    return YES;
//}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.scheme compare:QQ_OPEN_SCHEMA] == NSOrderedSame) {
        return [TencentOAuth HandleOpenURL:url];
    }
    else if([url.scheme compare:WX_OPEN_ID] == NSOrderedSame){
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    else if([url.scheme compare:AliyPay_OPEN_SCHEMA] == NSOrderedSame)
    {
        if ([url.host isEqualToString:@"safepay"])
        {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                int code = [[resultDic objectForKey:@"resultStatus"] intValue];
                if(code == 9000){
                    NSLog(@"支付成功！");
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"AliyPaySuccess" object:nil userInfo:nil];
                }else if (code == 8000){
                    NSLog(@"订单正在处理中");
                }else if (code == 4000){
                    NSLog(@"订单支付失败");
                }else if (code == 6001){
                    NSLog(@"用户取消支付");
                }else if (code == 6002){
                    NSLog(@"网络连接出错");
                }
            }];
            // 授权跳转支付宝钱包进行支付，处理授权结果
            [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                // 解析 auth code
                NSString *result = resultDic[@"result"];
                NSString *authCode = nil;
                if (result.length>0) {
                    NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                    for (NSString *subResult in resultArr) {
                        if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                            authCode = [subResult substringFromIndex:10];
                            break;
                        }
                    }
                }
                NSLog(@"授权结果 authCode = %@", authCode?:@"");
            }];
        }
        return YES;
    }
    else
    {
        return YES;
    }
    
}


#pragma mark - 用户通知(推送) _自定义方法
/** 注册用户通知 */
- (void)registerUserNotification {
    
    /*
     注册通知(推送)
     申请App需要接受来自服务商提供推送消息
     */
    // 判读系统版本是否是“iOS 8.0”以上
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ||
//        [UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
//        
//        // 定义用户通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
//        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
//        
//        // 定义用户通知设置
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
//        
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//        
//        // 注册用户通知 - 根据用户通知设置
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    } else { // iOS8.0 以前远程推送设置方式
//        // 定义远程通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
//        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
//        
//        // 注册远程通知 -根据远程通知类型
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
//    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                       UIRemoteNotificationTypeSound |
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
    
}
#pragma mark - 远程通知(推送)回调
/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@"" withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"deviceToken"];
    // [ GTSdk ]：向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"\n>>>[DeviceToken Error]:%@\n\n", error.description);
}

#pragma mark - APP运行中接收到通知(推送)处理 - iOS 10以下版本收到推送
/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    
    // 控制台打印接收APNs信息
    NSLog(@"\n>>>[Receive RemoteNotification]:%@\n\n", userInfo);
    NSString *msg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    
    if ([msg containsString:@"成功下单"])
    {
        NSLog(@"成功下单");
    }
    if ([msg containsString:@"订单取消成功"])
    {
        NSLog(@"订单取消成功");
    }
    if ([msg containsString:@"订单取消失败"])
    {
        NSLog(@"订单取消失败");
    }
    completionHandler(UIBackgroundFetchResultNewData);
}
#pragma mark - iOS 10中收到推送消息

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSLog(@"willPresentNotification：%@", notification.request.content.userInfo);
   
    NSString *msg = notification.request.content.body;
    if ([msg containsString:@"成功下单"])
    {
        NSLog(@"成功下单");
    }
    if ([msg containsString:@"订单取消成功"])
    {
        NSLog(@"订单取消成功");
    }
    if ([msg containsString:@"订单取消失败"])
    {
        NSLog(@"订单取消失败");
    }
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//  iOS 10: 点击通知进入App时触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
    
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    
    NSString *msg = response.notification.request.content.body;
    
    if ([msg containsString:@"成功下单"])
    {
        NSLog(@"成功下单");
    }
    if ([msg containsString:@"订单取消成功"])
    {
        NSLog(@"订单取消成功");
    }
    if ([msg containsString:@"订单取消失败"])
    {
        NSLog(@"订单取消失败");
    }
    completionHandler();
}
#endif

@end
