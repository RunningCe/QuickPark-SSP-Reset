//
//  NKUserCoupon.h
//  QuickPark-SSP
//
//  Created by Nick on 16/9/20.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKUserCoupon : NSObject

@property (nonatomic, copy)NSString *sspid;
@property (nonatomic, assign)NSInteger status;
@property (nonatomic, copy)NSString *couponid;
@property (nonatomic, assign)NSInteger coupontype;
@property (nonatomic, assign)NSInteger periodtimestart;
@property (nonatomic, assign)NSInteger periodtimeend;
@property (nonatomic, assign)NSInteger validitytimestart;
@property (nonatomic, assign)NSInteger validitytimeend;
@property (nonatomic, assign)NSInteger denomination;
@property (nonatomic, copy)NSString *roadsection;
@property (nonatomic, copy)NSString *ratio;
@property (nonatomic, assign)NSInteger createtime;
@property (nonatomic, copy)NSString *creator;
@property (nonatomic, assign)NSInteger couponstatus;
@property (nonatomic, assign)NSInteger sendstatus;
@property (nonatomic, assign)NSInteger sort;
@property (nonatomic, copy)NSString *remark;
//新增优惠券有效期时间
@property (nonatomic, copy)NSDate *expiretime;//用户优惠券过期时间
@property (nonatomic, copy)NSDate *donatetime;//赠送时间
@property (nonatomic, copy)NSDate *usetime;//使用时间
@property (nonatomic, copy)NSDate *startsendtime;//优惠券开始派送日期

//private String sspid;
//private Integer status;//使用状态  0可用  1已使用  2过期
//private String couponid;//优惠券编号
//private Integer coupontype;//优惠券类型
//private Date periodtimestart;//时段开始时间
//private Date periodtimeend;//时段结束时间
//private Date validitytimestart;//有效期开始时间
//private Date validitytimeend;//有效期结束时间
//private Integer denomination;//优惠券面值
//private String roadsection;//可以使用的路段
//private String ratio;//配比
//private Date createtime;//创建时间
//private String creator;//创建人
//private Integer couponstatus;//优惠券状态 （预留可能做逻辑删除等） 0可使用1已删除
//private Integer sendstatus;
//private Integer sort;//排序
//private String remark;//备注

@end
