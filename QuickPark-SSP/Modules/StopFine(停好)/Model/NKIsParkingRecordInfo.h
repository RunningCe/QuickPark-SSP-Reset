//
//  IsParkingRecordInfo.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/12/19.
//  Copyright © 2016年 Nick. All rights reserved.
//
//  类描述：正在停车的停车记录

#import <Foundation/Foundation.h>

@interface NKIsParkingRecordInfo : NSObject

@property (nonatomic, assign)long startTime;//开始停车时间
@property (nonatomic, copy)NSString *parkingName;//停车名称
@property (nonatomic, copy)NSString *parkingNo;//停车场编号
@property (nonatomic, copy)NSString *mepName;//收费员名称
@property (nonatomic, copy)NSString *mepId;//收费员ID
@property (nonatomic, copy)NSString *mepScore;//mep评分
@property (nonatomic, copy)NSString *mepTel;//mep电话
@property (nonatomic, copy)NSString *license;//车牌号
@property (nonatomic, copy)NSString *colourCard;//色卡
@property (nonatomic, copy)NSString *parkImg;//停车场图标
@property (nonatomic, assign)NSInteger *color;//车身颜色:0白色，1黑色，2灰色，3蓝色
@property (nonatomic, copy)NSString *berthNo;//车场编号

@property (nonatomic, copy)NSString *fullAddress;//停车所在地全称
@property (nonatomic, copy)NSString *parkingLogoUrl;//车场logo图片

@end
