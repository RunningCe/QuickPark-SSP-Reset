//
//  NKUser.h
//  QuickPark-SSP
//
//  Created by Nick on 16/8/18.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKUser : NSObject<NSCoding>

//审核不通过原因
@property (nonatomic, copy)NSString *rejectExplain;
//实名认证状态 0 未认证 1 认证中 2 认证通过 3认证失败
@property (nonatomic, assign)NSInteger realNameStatus;
// 在线账户状态：0未开通，1正常，2挂失，3注销
@property (nonatomic, assign)NSInteger accountStatus;
//性别:0男，1女
@property (nonatomic, assign)NSInteger sex;
//车主用户生日
@property (nonatomic, copy)NSString *birthDate;
//名字
@property (nonatomic, copy)NSString *realName;
//实名认证不通过原因
@property (nonatomic, copy)NSString *realNameNoPassReject;
//审核状态
@property (nonatomic, copy)NSString *auditStatus;
//城市维度
@property (nonatomic, copy)NSString *cityLatiude;
//城市经度
@property (nonatomic, copy)NSString *cityLongitude;
//车辆信息
@property (nonatomic, strong)NSMutableArray *cars;
//用户类型
@property (nonatomic, copy)NSString *userType;
//在线账户余额
@property (nonatomic, assign)NSInteger balance;
//泊位信息
@property (nonatomic, strong)NSMutableArray *berths;
//身份证
@property (nonatomic, copy)NSString *idCard;
//??
@property (nonatomic, copy)NSString *id;
//身份证照片
@property (nonatomic, copy)NSString *idCardPic;
//??
@property (nonatomic, copy)NSString *token;
//会籍
@property (nonatomic, copy)NSString *membership;
//手机
@property (nonatomic, copy)NSString *mobile;
//积分
@property (nonatomic, assign)NSInteger points;
//电子邮箱
@property (nonatomic, copy)NSString *email;
//昵称
@property (nonatomic, copy)NSString *niName;
//头像路径
@property (nonatomic, copy)NSString *avatar;
//登录名
@property (nonatomic, copy)NSString *loginName;
//经验
@property (nonatomic, copy)NSString *experience;
//城市名称
@property (nonatomic, copy)NSString *cityName;
//？？
@property (nonatomic, copy)NSString *address;
//签名
@property (nonatomic, copy) NSString *signature;
//车辆管理主背景
@property (nonatomic, copy) NSString *carManagerBg;

@end
