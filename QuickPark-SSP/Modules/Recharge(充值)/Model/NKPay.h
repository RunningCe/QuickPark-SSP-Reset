//
//  NKPay.h
//  QuickPark-SSP
//
//  Created by Nick on 16/9/18.
//  Copyright © 2016年 Nick. All rights reserved.
//
//下单支付类的请求参数
#import <Foundation/Foundation.h>

@interface NKPay : NSObject

@property (nonatomic, copy)NSString *token;
@property (nonatomic, copy)NSString *timestamp;
@property (nonatomic, copy)NSString *imei;
@property (nonatomic, copy)NSString *imsi;
@property (nonatomic, copy)NSString *number;//发起请示的手机号码
@property (nonatomic, copy)NSString *phoneType;//Anroid，IOS
@property (nonatomic, copy)NSString *version;
@property (nonatomic, assign)NSInteger versionCode;
@property (nonatomic, copy)NSString *deviceToken;//设备令牌（iOS设备唯一标识），用于APNS服务推送中标识设备的身份
@property (nonatomic, copy)NSString *clientId;//推送服务令牌（设备唯一标识），用于标识推送信息接收者身份

@property (nonatomic, copy)NSString *subject;
@property (nonatomic, copy)NSString *body;
@property (nonatomic, assign)double amount;//交易面值
@property (nonatomic, assign)double discount;//交易折扣
@property (nonatomic, assign)double total_fee;//实际应付金额
@property (nonatomic, copy)NSString *terminalIp;//微信支付特有


@end
