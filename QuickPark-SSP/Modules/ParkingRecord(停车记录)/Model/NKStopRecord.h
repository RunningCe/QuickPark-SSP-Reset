//
//  NKStopRecord.h
//  QuickPark-SSP
//
//  Created by Nick on 16/8/24.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NKStopDetailRecord.h"
#import "MJExtension.h"

@interface NKStopRecord : NSObject

@property (nonatomic, strong)NSMutableArray *records;
@property (nonatomic, assign)NSInteger timestamp;
@property (nonatomic, assign)NSInteger currentCount;
@property (nonatomic, assign)NSInteger total;
@property (nonatomic, assign)NSInteger ret;
@property (nonatomic, copy)NSString *msg;


@end
