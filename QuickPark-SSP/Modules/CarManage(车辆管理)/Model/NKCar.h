//
//  NKCar.h
//  QuickPark-SSP
//
//  Created by Nick on 16/8/18.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKCar : NSObject<NSCoding>

@property (nonatomic, assign)NSInteger timestamp;
@property (nonatomic, assign)NSInteger ret;
@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *id;//车辆ID
//审核状态 0：新建 1：提交审核 2：审核通过 3：审核不通过
@property (nonatomic, assign)NSInteger auditFlag;
//??
@property (nonatomic, assign)NSInteger tagBalance;
//车主
@property (nonatomic, copy)NSString *owner;
//排量如 1.6 3.0
@property (nonatomic, copy)NSString *displacement;
//发动机号
@property (nonatomic, copy)NSString *engine;
//车主身份证号
@property (nonatomic, copy)NSString *ownerId;
//车身颜色0白色，1黑色，2灰色，3蓝色
@property (nonatomic, assign)NSInteger color;
//车牌
@property (nonatomic, copy)NSString *license;
//车辆的照片url
@property (nonatomic, copy)NSString *icon;
//自动支付开关 1 关闭 0开启
@property (nonatomic, assign)NSInteger paySwitch;
//自动支付金额
@property (nonatomic, assign)NSInteger freePwdMoneyLimit;
//标签Sn
@property (nonatomic, copy)NSString *tagSn;
//车型:01大型车,02中型车,03小型车,04微型车
@property (nonatomic, copy)NSString *carType;
//行驶证编号
@property (nonatomic, copy)NSString *drivingId;

@property (nonatomic, copy)NSString *sspId;
//申诉车主的sspid成功后用该ID替代原有的sspid
@property (nonatomic, copy)NSString *appealSspId;
//色卡
@property (nonatomic, copy)NSString *colourCard;
//是否为默认车辆
@property (nonatomic, assign)NSInteger isDefaultCar;
//@property (nonatomic, assign)NSInteger id;
//@property (nonatomic, copy)NSString *licence;
// private String carbgurl;//车辆背景url
@property (nonatomic, copy)NSString *carbgurl;
@property (nonatomic, copy)NSString *carseries;
@property (nonatomic, copy)NSString *carseriespic;

@end
