//
//  NKGuidePageData.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/10/14.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKGuidePageData : NSObject

@property (nonatomic, copy)NSString *orderid;//  订单id
@property (nonatomic, copy)NSString *meppersonnelnum;//  接单mep
@property (nonatomic, copy)NSString *mepPersonnelName;//  mep收费员姓名
@property (nonatomic, assign)float mepPersonnelScore;//  mep收费员评分
@property (nonatomic, copy)NSString *mepPersonnelPhone;//  mep收费员电话
@property (nonatomic, copy)NSString *parkingName;//  停车场名字
@property (nonatomic, copy)NSString *parkingFee;//  停车场收费价格,分
@property (nonatomic, copy)NSString *parkingAddress;
@property (nonatomic, assign)double lng;//  经度
@property (nonatomic, assign)double lat;//  纬度

@end

