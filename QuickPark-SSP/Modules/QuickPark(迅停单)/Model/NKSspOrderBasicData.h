//
//  NKSspOrderBasicData.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/10/14.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKSspOrderBasicData : NSObject

@property (nonatomic, assign) NSInteger oneMouthPrice1;//一口价,分
@property (nonatomic, assign) NSInteger oneMouthPrice2;
@property (nonatomic, assign) NSInteger oneMouthPrice3;
@property (nonatomic, assign) NSInteger oneMouthPrice4;
@property (nonatomic, assign) NSInteger auctionPrice1;//竞拍价，分
@property (nonatomic, assign) NSInteger auctionPrice2;
@property (nonatomic, assign) NSInteger auctionPrice3;
@property (nonatomic, assign) NSInteger auctionPrice4;
@property (nonatomic, strong) NSString *parkingRadiu1;//半径，米
@property (nonatomic, strong) NSString *parkingRadiu2;
@property (nonatomic, strong) NSString *parkingRadiu3;
@property (nonatomic, strong) NSString *parkingRadiu4;
@property (nonatomic, assign) NSInteger parkingBasicPrice;//基础预约价,分



@end
