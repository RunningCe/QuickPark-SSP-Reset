//
//  NKWXPay.h
//  QuickPark-SSP
//
//  Created by Nick on 16/9/18.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKWXPay : NSObject

@property (nonatomic, copy)NSString *appid;
@property (nonatomic, copy)NSString *prepayid;
@property (nonatomic, copy)NSString *noncestr;
@property (nonatomic, copy)NSString *sign;
@property (nonatomic, copy)NSString *timestamp;
@property (nonatomic, copy)NSString *packageValue;
@property (nonatomic, copy)NSString *partnerid;
@property (nonatomic, copy)NSString *msg;
@property (nonatomic, copy)NSString *ret;



//private String appid;
///**
// * 预支付订单id
// */
//private String prepayid;
//
//private String noncestr;
//
//private String sign;
//
//private String timestamp;
//
//private String packageValue = "Sign=WXPay";
///**
// * 商户id
// */
//private String partnerid;
//
//private String msg;
//
//private String ret;

@end
