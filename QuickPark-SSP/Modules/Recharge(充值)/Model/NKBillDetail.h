//
//  NKBillDetail.h
//  QuickPark-SSP
//
//  Created by Nick on 2017/2/24.
//  Copyright © 2017年 Nick. All rights reserved.
//  账单详情类

#import <Foundation/Foundation.h>

@interface NKBillDetail : NSObject
//消息ID
@property (nonatomic, assign) NSInteger id;
//订单创建时间
@property (nonatomic, strong) NSString *createTime;
//订单类型
@property (nonatomic, retain) NSString *recordType;
//订单金额分
@property (nonatomic, retain) NSString *money;


@end
