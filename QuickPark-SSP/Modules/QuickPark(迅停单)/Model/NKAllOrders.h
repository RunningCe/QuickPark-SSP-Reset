//
//  NKAllOrders.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/10/27.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NKOrderPage.h"

@interface NKAllOrders : NSObject

@property (nonatomic, strong) NSArray *nowlist;
@property (nonatomic, strong) NKOrderPage *page;
//private List<MepOrderDto> nowlist = new ArrayList<MepOrderDto>();//正在进行的订单 redis取的
//private Page page;//正在进行的订单,数据库取的 分页

@end
