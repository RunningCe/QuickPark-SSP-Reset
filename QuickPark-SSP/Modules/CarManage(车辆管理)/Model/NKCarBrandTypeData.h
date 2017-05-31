//
//  NKCarBrandTypeData.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/12/30.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKCarBrandTypeData : NSObject

@property (nonatomic, assign) NSInteger brandType_id;//车辆类型标识ID
@property (nonatomic, strong) NSString *cartypename;//车辆品牌
@property (nonatomic, strong) NSString *brandtype;//车型
@property (nonatomic, assign) NSInteger parentid;//车辆品牌ID

@end
