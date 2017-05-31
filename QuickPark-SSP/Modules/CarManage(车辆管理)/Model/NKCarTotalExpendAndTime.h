//
//  NKCarTotalExpendAndTime.h
//  QuickPark-SSP
//
//  Created by Nick on 2017/2/24.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKCarTotalExpendAndTime : NSObject
//formatTime String	格式化后的停车时间
@property (nonatomic, copy) NSString *formatTime;
//totalTime	long	累计停车时长
@property (nonatomic, assign) long totalTime;
//totalExpend int	累计消费
@property (nonatomic, assign) int totalExpend;
//stopParkNum int	停过的车场个数
@property (nonatomic, assign) int stopParkNum;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger ret;

@end
