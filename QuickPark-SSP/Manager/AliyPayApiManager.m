//
//  AliyPayApiManager.m
//  QuickPark-SSP
//
//  Created by Jack on 16/9/13.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "AliyPayApiManager.h"

#import "Order.h"
#import "APAuthV2Info.h"
#import "RSADataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import <UIKit/UIKit.h>
#import "NKDataManager.h"

@implementation AliyPayApiManager

+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static AliyPayApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[AliyPayApiManager alloc] init];
    });
    return instance;
}
+ (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
//支付方法
+(void)doAlipayPayWithParameters:(NKPay *)aliypay
{
    NKDataManager *dataManager = [NKDataManager sharedDataManager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:aliypay.body forKey:@"body"];
    [parameters setObject:aliypay.subject forKey:@"subject"];
    [parameters setObject:[NSNumber numberWithDouble:aliypay.total_fee] forKey:@"total_fee"];
    [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"myToken"] forKey:@"token"];
    [parameters setObject:[NSNumber numberWithDouble:aliypay.amount] forKey:@"amount"];
    
    [dataManager POSTAliypayWithParameters:parameters Success:^(NKAliypay *aliypay) {
        if ([aliypay.ret isEqualToString:@"0"])
        {
            //NSLog(@"%@", aliypay);
            NSString *orderString = [NSString stringWithFormat:@"app_id=%@&biz_content=%@&charset=%@&method=%@&notify_url=%@&sign_type=%@&timestamp=%@&version=%@&sign=%@", aliypay.app_id, aliypay.biz_content, aliypay.charset, aliypay.method, aliypay.notify_url, aliypay.sign_type, aliypay.timestamp, aliypay.version, aliypay.sign];
            //NSLog(@"%@", orderString);
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:AliyPay_OPEN_SCHEMA callback:^(NSDictionary *resultDic) {
                NSLog(@"跳去支付宝支付");
            }];
        }

    } Failure:^(NSError *error) {
        
    }];
    
}

//授权方法
+ (void)doAlipayAuth
{
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *pid = AliyPay_PID;
    NSString *appID = AliyPay_APPID;
    NSString *rsa2PrivateKey = AliyPay_PRIVATEKEY;
    NSString *rsaPrivateKey = AliyPay_PRIVATEKEY;
//    NSString *privateKey = AliyPay_PRIVATEKEY;
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //pid和appID获取失败,提示
    if ([pid length] == 0 ||
        [appID length] == 0 ||
        [rsaPrivateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少pid或者appID或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //生成 auth info 对象
    APAuthV2Info *authInfo = [[APAuthV2Info alloc] init];
    authInfo.pid = pid;
    authInfo.appID = appID;
    
    //auth type
    NSString *authType = [[NSUserDefaults standardUserDefaults] objectForKey:@"authType"];
    if (authType) {
        authInfo.authType = authType;
    }
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = AliyPay_OPEN_SCHEMA;
    
    // 将授权信息拼接成字符串
    NSString *authInfoStr = [authInfo description];
    NSLog(@"authInfoStr = %@",authInfoStr);
    
    // 获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//    id<RSADataSigner *> signer = CreateRSADataSigner(privateKey);
//    NSString *signedString = [signer signString:authInfoStr];
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:authInfoStr withRSA2:YES];
    } else {
        signedString = [signer signString:authInfoStr withRSA2:NO];
    }
    
    // 将签名成功字符串格式化为订单字符串,请严格按照该格式
    if (signedString.length > 0)
    {
        authInfoStr = [NSString stringWithFormat:@"%@&sign=%@&sign_type=%@", authInfoStr, signedString, @"RSA"];
        [[AlipaySDK defaultService] auth_V2WithInfo:authInfoStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
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
}


@end
