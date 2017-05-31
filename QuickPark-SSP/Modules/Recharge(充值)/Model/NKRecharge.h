//
//  NKRecharge.h
//  QuickPark-SSP
//
//  Created by Nick on 16/8/31.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKRecharge : NSObject
@property (nonatomic, assign)NSInteger timestamp;
@property (nonatomic, assign)NSInteger ret;
@property (nonatomic, copy)NSString *msg;

//private String userId;// 用户Id
//private String userLoginName;//用户登录名
//private String mobile;//手机号码
//private String uuid;//订单号
//private double amount;//交易面值
//private double discount = 1.0;//交易折扣
//private double total_fee;//实际应付金额

@end
