//
//  NKSspOrderBackValue.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/10/14.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKSspOrderBackValue : NSObject

@property (nonatomic, copy)NSString *msg;
@property (nonatomic, assign)NSInteger ret;
@property (nonatomic, strong)NSObject *obj;

//返回参数说明

//下单
/*
 返回值:
 ret      msg	obj
 0	orderNo  订单号(String)
 -20      参数错误
 -30	    订单生成失败
 -40      附近没有停车场
 */

//取消订单
/*
 ret	msg
 0	取消成功!
 -100	取消失败!
 -101	订单不存在!
 -102	参数错误!
 -103	服务器异常!
 */

//导航界面信息获取
/*
 ret      msg	obj
 0	GuidePageDto对象
 -102    参数错误
 -101    订单不存在
 */

//重新打开APP后确认用户是否存在未完成订单
/*
 ret      msg	obj
 0	ordertime下单时间(时间戳,毫秒  Long)
 -102    参数错误
 -101    订单不存在
 -103    订单已完结
 */

@end
