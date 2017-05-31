//
//  NKAddCar.h
//  QuickPark-SSP
//
//  Created by Nick on 16/8/26.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKAddCar : NSObject

//@property (nonatomic, copy)NSString *id;//车辆ID
//@property (nonatomic, copy)NSString *license;//车牌
//@property (nonatomic, copy)NSString *drivingId;//行驶证ID
//@property (nonatomic, copy)NSString *owner;//车主
//@property (nonatomic, copy)NSString *ownerId;//车主ID，用户userID
//@property (nonatomic, copy)NSString *engine;//发送机号
//@property (nonatomic, copy)NSString *tagSn;//标签SN
//@property (nonatomic, copy)NSString *carSn;//车架号
//@property (nonatomic, copy)NSString *color;//车身颜色 0白色 1黑色 2灰色 3蓝色
//@property (nonatomic, copy)NSString *displacement;//排量 如：1.6 3.0
//@property (nonatomic, copy)NSString *carType;//车辆类型
//@property (nonatomic, assign)NSInteger paySwitch;//支付开关
@property (nonatomic, copy)NSString *sspId;
@property (nonatomic, assign)NSInteger id;
@property (nonatomic, copy)NSString *licence;

@end
