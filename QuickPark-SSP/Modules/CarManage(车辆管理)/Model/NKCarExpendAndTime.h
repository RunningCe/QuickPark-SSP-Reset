//
//  NKCarExpendAndTime.h
//  QuickPark-SSP
//
//  Created by Nick on 16/9/22.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKCarExpendAndTime : NSObject

//********************单辆车的停车参数*************************//
@property (nonatomic, copy)NSString *totalExpend;
@property (nonatomic, copy)NSString *totalTime;
@property (nonatomic, copy)NSString *stopNum;//停车次数
@property (nonatomic, copy)NSString *msg;
@property (nonatomic, assign)NSInteger ret;

//private String totalExpend;//单位:分
//private String totalTime;//单位:秒


@end
