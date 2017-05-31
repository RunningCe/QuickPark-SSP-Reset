//
//  NKMepOrderParameters.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/10/27.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKMepOrderParameters : NSObject
@property (nonatomic, strong) NSString *license;
@property (nonatomic, strong) NSString *parkingaddress;
@property (nonatomic, strong) NSString *parkingname;
@property (nonatomic, strong) NSString *parkingno;
@property (nonatomic, assign) NSInteger cartype;
@property (nonatomic, assign) NSInteger keepcartime;
@property (nonatomic, assign) NSInteger takecartime;
@property (nonatomic, assign) NSInteger ordertime;
@property (nonatomic, strong) NSString *orderid;
@property (nonatomic, assign) NSInteger ordertype;

//private String orderid;// 订单id
//private Integer ordertype;// 订单类型:(迅停单)0一口价,1竞拍价;(精致车库)2预约存车单 3预约取车单;
//private String license;// 车牌
//private String parkingaddress;//停车场地址
//private String parkingname; // 停车场名字
//private String parkingno;//车场编号
//private Integer cartype;//车辆类型
//private Long keepcartime;//存车时间
//private Long takecartime;//取车时间
//private Long ordertime;//订单生成时间
/*
 MepOrderDto{
	private String orderid;// 订单id
	private Integer ordertype;// 订单类型:(迅停单)0一口价,1竞拍价;(精致车库)2预约存车单 3预约取车单;
	private Integer status;// 订单状态
	private String meppersonnelnum;// 接单mep
	private String suitparkings;// 符合条件停车场
	private String license;// 车牌
	private String destination;// 目的地
	private String rang;// 范围
	private Integer bookingfee;// 预约费
	private Integer tip;// 小费
	private Integer chargebackamount;// 扣费金额
	private String cuslevel;// 会籍
	private String cusid;// ssp
	private String berthno;// 预约泊位号
	private Long ordertime;// 订单生成时间
	private Long createtime;// 记录生成时间
	private Long snatchtime;// 抢单时间
	private Integer ifcancel;// 是否取消 （0-取消，1-正常，用户取消和超时？）
	private Long canceltime;// 取消时间
	private String cancelreason;// 取消原因
	private Integer cussex;// 客户性别
	private Integer carchargetype;// 车辆支付类型 10 不确定 11 小型车（默认） 12 中型车 13 大型车
	private String cusname;// 客户姓名
	private String clientid;// 推送服务令牌（设备唯一标识），用于标识推送信息接收者身份
 
	private String clienttype;// 客户端类型 0 android 1 ios
	private String cusmob;//客户手机号
	
	private String meppersonnelname; // mep收费员姓名
	private Float meppersonnelscore; // mep收费员评分
	private String meppersonnelphone; // mep收费员电话
	private String parkingname; // 停车场名字
	private String parkingfee; // 停车场收费价格,分
	private String parkingaddress;//停车场地址
	private Double lng; // 经度
	private Double lat; // 纬度
	
==================精致车库===========================
private String parkingno;//车场编号
private Integer cartype;//车辆类型
private Long keepcartime;//存车时间
private Long takecartime;//取车时间
}
*/

@end
