//
//  NKRechargeRule.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/9/30.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKRechargeRule : NSObject

@property (nonatomic, assign)NSInteger id;
@property (nonatomic, assign)double rechargeAmount;//单位： 分
@property (nonatomic, assign)double rechargeDonate;

@end
