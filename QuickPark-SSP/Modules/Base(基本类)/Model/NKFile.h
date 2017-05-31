//
//  NKFile.h
//  QuickPark-SSP
//
//  Created by Nick on 16/8/26.
//  Copyright © 2016年 Nick. All rights reserved.
//  车辆认证时调用上传文件接口，返回的数据

#import <Foundation/Foundation.h>

@interface NKFile : NSObject

@property (nonatomic, assign)NSInteger appType;//应用类型 0：交通事件，1：车辆新增修改照片，2：投诉建议 3:头像修改 4:行驶证照片  5：泊位合同 6.身份证
@property (nonatomic, copy)NSString *url; //资源存储的url
@property (nonatomic, copy)NSString *ext1;//附加信息 appType=0时为事件Id  appType=1或者4时为车辆Id    appType=2 时为投诉建议Id  appType=5时为车主泊位Id
@property (nonatomic, copy)NSString *ext2;//文件类型 0：图片 1：多媒体文件
@property (nonatomic, assign)NSInteger timestamp;
@property (nonatomic, assign)NSInteger ret;
@property (nonatomic, copy)NSString *msg;

@end
