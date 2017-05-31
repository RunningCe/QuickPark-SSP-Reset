//
//  NKPieData.h
//  QuickPark-SSP
//
//  Created by Nick on 2017/2/23.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKPieData : NSObject

//停遍车场次数
@property (nonatomic, assign) NSInteger parkedlotTimes;
//城市消费记录
@property (nonatomic, strong) NSDictionary *cityFee;
//车场消费记录
@property (nonatomic, strong) NSDictionary *parkinglotFee;

@end
