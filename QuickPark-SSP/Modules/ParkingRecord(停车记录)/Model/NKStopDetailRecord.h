//
//  NKStopDetailRecord.h
//  QuickPark-SSP
//
//  Created by Nick on 16/8/23.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKStopDetailRecord : NSObject

@property (nonatomic, copy)NSString *stopRecordId;//停车记录id
@property (nonatomic, copy)NSString *parking;//停车场名称
@property (nonatomic, copy)NSString *parkingId;//停车场ID
@property (nonatomic, copy)NSString *berth;//车位号，没有为null
@property (nonatomic, copy)NSString *license;//车牌号
@property (nonatomic, copy)NSString *arrive;//来车时间yyyy:MM:dd HH:mm:SS
@property (nonatomic, copy)NSString *leave;//走车时间yyyy:MM:dd HH:mm:SS
@property (nonatomic, assign)NSInteger fee;//停车费用，单位分
@property (nonatomic, assign)NSInteger stopType;//停车类型，如：内部月卡、临时卡、标签车、一卡通车、免费车、未申请
@property (nonatomic, assign)NSInteger payType;//支付类型，如：包年、包月、现金支付、标签支付、一卡通支付、在线支付、未支付
@property (nonatomic, copy)NSString *commentId;//评论id
@property (nonatomic, copy)NSString *commentScore;//评价打的分数
@property (nonatomic, copy)NSString *commentStatus;//评价状态0待评价 1 已评价 2评价已过期
@property (nonatomic, copy)NSString *starLevel;//评价等级
@property (nonatomic, assign)NSInteger mepId;//收费员ID 登记
@property (nonatomic, copy)NSString *mepNumber;//收费员编号 - 登记
@property (nonatomic, copy)NSString *mepName;//收费员姓名 - 登记
@property (nonatomic, copy)NSString *settleNo;//结算mepNo
@property (nonatomic, assign)NSInteger receivedMoney;//预收，单位分
@property (nonatomic, assign)NSInteger receivablesMoney;//应收，单位分
@property (nonatomic, assign)NSInteger discount;//折扣
@property (nonatomic, assign)NSInteger couponMoney;//优惠券
@property (nonatomic, assign)NSInteger freeChange;//产品优惠
@property (nonatomic, assign)NSInteger totalCharge;//消费金额
@property (nonatomic, assign)NSInteger chargeFee;//消费实收
@property (nonatomic, assign)NSInteger bookingfee;//服务费
@property (nonatomic, assign)NSInteger tip;//小费
@property (nonatomic, copy)NSString *goCarEvaluateStar;//来车评价星级
@property (nonatomic, copy)NSString *toCarEvaluateStar;//走车评价星级
@property (nonatomic, copy)NSString *parkingEvaluateStar;//来场评价星级
@property (nonatomic, copy)NSString *goCarScore;//来车评价分数
@property (nonatomic, copy)NSString *toCarScore;//走车评价分数
@property (nonatomic, copy)NSString *parkingScore;//来场评价分数

@property (nonatomic, assign)NSInteger completeStatus;//结算状态 0已完结 1 未完结
@property (nonatomic, strong) NSString *complaintstatus;//投诉状态 0未投诉 1已投诉 2过期48小时

//评价新增
@property (nonatomic, strong) NSString *tocarappearancestar;//走车形象星级
@property (nonatomic, strong) NSString *tocarappearancetag;//走车形象标签
@property (nonatomic, strong) NSString *tocarspeechstar;//走车言谈星级
@property (nonatomic, strong) NSString *tocarspeechtag;//走车言谈标签
@property (nonatomic, strong) NSString *tocaractionstar;//走车行为星级
@property (nonatomic, strong) NSString *tocaractiontag;//走车行为星级
@property (nonatomic, strong) NSString *parkingindicatestar;//车场指示星级
@property (nonatomic, strong) NSString *parkingindicatetag;//车场指示标签
@property (nonatomic, strong) NSString *parkinghealthstar;//车场卫生星级
@property (nonatomic, strong) NSString *parkinghealthtag;//车场卫生标签
@property (nonatomic, strong) NSString *parkingsensestar;//车场感观星级
@property (nonatomic, strong) NSString *parkingsensetag;//车场感观标签
@property (nonatomic, strong) NSString *supplementary;//补两句

//新增
@property (nonatomic, strong) NSString *carRegTime;//来车登记时间
@property (nonatomic, strong) NSString *carBalanceTime;//走车结算时间

@property (nonatomic, copy)NSString *fullAddress;//停车所在地全称
@property (nonatomic, copy)NSString *parkingLogoUrl;//停车场logo

//更改增加走车形象编码2017-01-21
@property (nonatomic, copy)NSString *tocarappearancetagcode;//走车形象标签编码
@property (nonatomic, copy)NSString *tocarspeechtagcode;//走车形象标签编码
@property (nonatomic, copy)NSString *tocaractiontagcode;//走车形象标签编码
@property (nonatomic, copy)NSString *parkingindicatetagcode;//走车形象标签编码
@property (nonatomic, copy)NSString *parkinghealthtagcode;//走车形象标签编码
@property (nonatomic, copy)NSString *parkingsensetagcode;//走车形象标签编码

//新增是否选中
@property (nonatomic, assign) BOOL isSelected;

//欠费金额
@property (nonatomic, assign) NSString *escapeFee;
/*
 
 √private String stopRecordId;// 停车记录ID
 private String parking;// 停车场名,
 private String parkingId;// 停车场Id,
 private String berth;// 车位号,没有时为null
 private String license;//车牌号
 private String colour ;//车辆标签
 private String arrive;// 来车时间:yyyy:MM:dd HH:mm:SS,
 private String leave;// 走车时间:yyyy:MM:dd HH:mm:SS,
 private int fee;// 停车费用，单位分,
 private int stopType;// 停车类型，如：内部月卡、临时卡、标签车、一卡通车、免费车、未申请
 private int payType;// 支付类型，如：包年、包月、现金支付、标签支付、一卡通支付、在线支付、未支付
 private String commentId;// 评论id
 private String commentScore;// 评论打的分数
 private String commentStatus;// 评价状态：0待评价，1，已评价
 private String starLevel;//评价等级
 private int completeStatus;  //是否已结算
 private int mepId; //收费员ID - 登记
 private String mepNumber; //收费员编号 - 登记mepNo
 private String mepName; //收费员姓名  -登记
 private int receivedMoney; //预收,单位分',
 private int receivablesMoney;//消费应收,单位分
 private int discount;//折扣
 private int couponMoney;//优惠券
 private int freeCharge;//产品优惠
 private int totalCharge; //消费金额
 private int chargeFee; //消费实收
 private int bookingfee; //服务费
 private int tip;//小费
 private String settleNo;//结算mepNo
 private String complaintstatus;  //投诉状态0:未投诉1:已投诉 2.不可投诉
 
 private String tocarappearancestar;  //走车形象星级
 private String tocarappearancetag;  //走车形象标签
 private String tocarspeechstar;  //走车言谈星级
 private String tocarspeechtag;  //走车言谈标签
 private String tocaractionstar;  //走车行为星级
 private String tocaractiontag;  //走车行为星级
 
 private String parkingindicatestar;  //车场指示星级
 private String parkingindicatetag;  //车场指示标签
 private String parkinghealthstar;  //车场卫生星级
 private String parkinghealthtag;  //车场卫生标签
 private String parkingsensestar;  //车场感观星级
 private String parkingsensetag;  //车场感观标签
 private String parkingLogoUrl ;//停车场图标
 private String fullAddress ;//停车场全名
 private String city ;
 
 private String toCarScore ;
 private String parkingScore ;
 private String toCarEvaluateStar;//走车评价星级
 private String parkingEvaluateStar;//车场场评价星级
 
 private String carRegTime ; //来车登记时间
 private String carBalanceTime ; //走车结算时间
 
 private String supplementary;//补两句
 
 private boolean isEvaluate ; //是否已经评价
 private boolean isEvaluateExpired ; //是否评价时效已过期
 private boolean isComplaintExpired ; //是否已过投诉时效
 private boolean isJustNow ; //是否是刚刚驶离
 */

@end
