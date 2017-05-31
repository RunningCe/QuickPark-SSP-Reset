//
//  NKParkingPayBill.h
//  QuickPark-SSP
//
//  Created by Nick on 16/8/30.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKParkingPayBill : NSObject

@property (nonatomic, strong)NSArray *parkedPayRecord;
@property (nonatomic, assign)NSInteger timestamp;
@property (nonatomic, copy)NSString *msg;
@property (nonatomic, assign)NSInteger ret;

@end
