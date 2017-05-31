//
//  NKMepInfo.h
//  QuickPark-SSP
//
//  Created by Nick on 2017/3/10.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKMepInfo : NSObject

//头像URL
@property (nonatomic, copy) NSString *avatar;
//联系电话
@property (nonatomic, copy) NSString *mobile;
//真实姓名
@property (nonatomic, copy) NSString *realName;
//服务次数
@property (nonatomic, copy) NSString *serviceCount;
//标签评价内容及次数
@property (nonatomic, strong) NSDictionary *evaluateTagStat;

@end
