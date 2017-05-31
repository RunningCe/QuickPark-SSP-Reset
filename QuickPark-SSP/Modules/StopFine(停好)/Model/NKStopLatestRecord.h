//
//  NKStopLatestRecord.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/12/8.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKStopLatestRecord : NSObject

@property (nonatomic, copy)NSString *license;
@property (nonatomic, copy)NSString *parkingName;
@property (nonatomic, copy)NSString *startTime;
@property (nonatomic, copy)NSString *endTime;
@property (nonatomic, assign)int money;
@property (nonatomic, assign)long duration;

@property (nonatomic, copy)NSString *fullAddress;//停车所在地全称

@end
