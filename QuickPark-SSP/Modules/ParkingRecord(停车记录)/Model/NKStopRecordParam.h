//
//  NKStopRecordParam.h
//  QuickPark-SSP
//
//  Created by Nick on 16/8/23.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKStopRecordParam : NSObject

@property (nonatomic, copy)NSString *license;//车牌号
@property (nonatomic, copy)NSString *commentStatus;//评价状态0未评价， 1已评价
@property (nonatomic, copy)NSString *pageSize;//每条页数
@property (nonatomic, copy)NSString *pageNo;//请求当前页数
@property (nonatomic, copy)NSString *token;
@property (nonatomic, assign)NSInteger timestamp;
@property (nonatomic, copy)NSString *imei;
@property (nonatomic, copy)NSString *imsi;
@property (nonatomic, copy)NSString *number;//发起请示的手机
@property (nonatomic, copy)NSString *phoneType;//手机类型
@property (nonatomic, copy)NSString *version;
@property (nonatomic, assign)NSInteger versionCode;
@property (nonatomic, copy)NSString *deviceToken;//设备令牌（iOS设备唯一标识），用于APNS服务推送中标识设备的身份
@property (nonatomic, copy)NSString *clientId;//推送服务令牌（设备唯一标识），用于标识推送信息接收者身份

@end
