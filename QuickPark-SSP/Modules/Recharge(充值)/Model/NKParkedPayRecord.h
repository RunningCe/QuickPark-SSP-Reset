//
//  NKParkedPayRecord.h
//  QuickPark-SSP
//
//  Created by Nick on 16/8/30.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKParkedPayRecord : NSObject

@property (nonatomic, copy)NSString *parkedRecordId;  //停车记录ID

@property (nonatomic, assign)NSInteger registerType;  //登记类型（1道闸自动感应2标签自动感应3人工登记）

@property (nonatomic, copy)NSString *regId; //登记ID（MEP ID、设备SN）

@property (nonatomic, copy)NSString *license; //车牌号

@property (nonatomic, assign)NSInteger payType;  //结算类型

@property (nonatomic, assign)NSInteger carRegTime;  //来车时间

@property (nonatomic, assign)NSInteger carBalanceTime; //走车结算时间

@property (nonatomic, assign)NSInteger settleId;  //结算ID

@property (nonatomic, assign)NSInteger cusType; //客户类型（0会员，1非会员）

@property (nonatomic, copy)NSString * cusLevel; //客户会籍

@property (nonatomic, copy)NSString * cusId;  //客户ID

@property (nonatomic, assign)NSInteger carType; //车辆类型（1-小型车（默认值），2-中型车，3-大型车，默认值：1）

@property (nonatomic, assign)NSInteger payFeeType;  //付费方式（0后付费，1预付费，默认值：0）

@property (nonatomic, assign)NSInteger totalCharge; //计费总额

@property (nonatomic, assign)NSInteger freeCharge; //产品优惠金额

@property (nonatomic, copy)NSString * allowanceId; //产品编码

//private int receivableMoney;  //消费应收

@property (nonatomic, assign)NSInteger discount; //折扣

@property (nonatomic, assign)NSInteger couponMoney; //优惠券金额

@property (nonatomic, copy)NSString * couponNo; //优惠券编码

@property (nonatomic, assign)NSInteger chargeFee; //应缴（客户)

@property (nonatomic, assign)NSInteger fee;  //实收（收费员）

@property (nonatomic, assign)NSInteger advanceCharge; //预收

@property (nonatomic, assign)NSInteger chargeType; //收费方式（0会员消费、1人工收费、2免费车辆）

@property (nonatomic, copy)NSString * imgUrl; //图片

@property (nonatomic, assign)NSInteger escapeFee; //欠费金额

@property (nonatomic, assign)NSInteger completeStatus; //完结状态（0已完结，1未完结）

@property (nonatomic, assign)NSInteger ifValid; //是否有效（0有效，1无效，2订单无效(结算的时候只能负一次，如果已经负一次的情况下，那么设置记录表有效，登记消费记录表设置为2订单无效。不写入停车收费详情表)）

@property (nonatomic, copy)NSString * dutySettleMep;

//新增12-5
@property (nonatomic, strong)NSDate *createtime;//创建时间
@property (nonatomic, copy)NSString *checkStatus;//审核状态


@end
