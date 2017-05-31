//
//  NKSspOrderParameters.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/10/14.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKSspOrderParameters : NSObject<NSCoding>

@property (nonatomic, copy)NSString *license;//车牌号
@property (nonatomic, copy)NSString *destination;//目的地
@property (nonatomic, copy)NSString *radius;//半径:m
@property (nonatomic, assign)NSInteger bookingFee;//预约费(服务费)
@property (nonatomic, assign)NSInteger tip;//小费
@property (nonatomic, copy)NSString *cuslevel;//会籍
@property (nonatomic, copy)NSString *sspId;//sspid
@property (nonatomic, assign)NSInteger orderType;//订单类型,0一口价,1竞拍价
@property (nonatomic, copy)NSString *lng;//经度
@property (nonatomic, copy)NSString *lat;//纬度
@property (nonatomic, copy)NSString *clientId;//推送服务令牌（设备唯一标识），用于标识推送信息接收者身份
@property (nonatomic, assign)NSInteger cusSex;//用户性别
@property (nonatomic, assign)NSInteger carChargeType;//10 不确定 11 小型车（默认）  12 中型车 13 大型车
@property (nonatomic, copy)NSString *cusName;//用户姓名
@property (nonatomic, copy)NSString *clientType;//客户端类型 1 Android 2 iOS
@property (nonatomic, copy)NSString *cusMob;//手机号

@property (nonatomic, copy)NSString *orderNo;//订单号
@property (nonatomic, copy)NSString *cancelReason;//取消原因
@property (nonatomic, assign)NSInteger isOvertime;//订单是否超时,0-未超时,1-超时
@property (nonatomic, assign)NSInteger cancelType;//取消类型,  0-取消呼叫(mep未接单,免费取消订单),1-终止呼叫(是否超时前端判断后插入isOvertimr属性),2-超时取消(15min超时)
//********精致车库**********
@property (nonatomic, copy)NSString *parkingno;//车场编号
@property (nonatomic, assign)NSInteger cartype;//车辆类型
@property (nonatomic, assign)NSInteger keepcartime;//停车时间
@property (nonatomic, assign)NSInteger takecartime;//取车时间
@end
