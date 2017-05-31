//
//  NKCarBrandBaseData.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/12/30.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKCarBrandBaseData : NSObject

@property (nonatomic, assign) int ret;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, assign) NSInteger timestamp;
@property (nonatomic, strong) NSDictionary *result;

/*
 ret返回值说明：
    SUCCESS(0,"success"),//成功
	DATA_NOT_EXIST(-4,"data not exist"),//数据不存在
	SERVER_ERROR(-99,"server error"),//服务器异常
	FAIL(-100,"fail"),//处理失败
 */

@end
