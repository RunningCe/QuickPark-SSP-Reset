//
//  NKBerth.h
//  QuickPark-SSP
//
//  Created by Nick on 16/8/18.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKBerth : NSObject<NSCoding>

//泊位id
@property (nonatomic, assign)NSInteger id;
//停车场id
@property (nonatomic, copy)NSString *parkingId;
//??
@property (nonatomic, copy)NSString *msg;
//??
@property (nonatomic, assign)NSInteger timestamp;
//泊位类型
@property (nonatomic, assign)NSInteger berthType;
//泊位SN码
@property (nonatomic, copy)NSString *berthSN;
//??
@property (nonatomic, assign)NSInteger ret;
//停车场编号
@property (nonatomic, copy)NSString *parkingNo;
//泊位规格 长*宽*高
@property (nonatomic, copy)NSString *berthStand;
//用户名
@property (nonatomic, copy)NSString *userName;
//??
@property (nonatomic, assign)NSInteger isSpecifyEntrance;
//泊位归属结束时间
@property (nonatomic, copy)NSString *endTime;
//用户id
@property (nonatomic, copy)NSString *userId;
//泊位归属开始时间
@property (nonatomic, copy)NSString *startTime;
//状态
@property (nonatomic, assign)NSInteger status;
//泊位名称
@property (nonatomic, copy)NSString *berthName;

@end
