//
//  NKDataManager.m
//  QuickPark-SSP
//
//  Created by Nick on 16/8/22.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKDataManager.h"
#import "NKComment.h"
#import "NKCommentTag.h"
#import "NKMessageRecord.h"
#import "NKIsParkingRecordInfo.h"
#import "NKCarBrandBaseData.h"
#import "NKCarBrandData.h"
#import "NKCarBrandTypeData.h"
#import "NKAdvertisementImageData.h"
#import "NKPieData.h"
#import "NKCarTotalExpendAndTime.h"
#import "NKBillDetail.h"
#import "NKMepInfo.h"
#import "NKLocalPassportBaseDto.h"
#import "NKInterface.h"

@interface NKDataManager()

@property (nonatomic, strong)AFHTTPSessionManager *dataManager;

@end

@implementation NKDataManager

static NKDataManager *sharedDataManager = nil;

+ (NKDataManager *)sharedDataManager{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if (sharedDataManager == nil)
        {
            sharedDataManager = [[self alloc] init];
        }
    });
    return sharedDataManager;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if (sharedDataManager == nil)
        {
            sharedDataManager = [super allocWithZone:zone];
        }
    });
    return sharedDataManager;
}
- (AFHTTPSessionManager *)dataManager
{
    if (_dataManager == nil)
    {
        _dataManager = [AFHTTPSessionManager manager];
        _dataManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _dataManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _dataManager.requestSerializer.timeoutInterval = 20.0;
    }
    return _dataManager;
}
#pragma mark -网络请求方法
#pragma mark -请求验证码
-(void)POSTMaskDataWithParameters:(id)parameters Success:(void (^)(NKMask *))success Failure:(void (^)(NSError *))failure{
    [self.dataManager POST:POST_MASK_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功！！！");
        NKMask *mask = [NKMask mj_objectWithKeyValues:responseObject];
        success(mask);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败！！！！");
        failure(error);
    }];
}
- (void)POSTUserCenterMaskDataWithParameters:(id)parameters Success:(void (^)(NKMask *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_USERCENTER_MASK_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功！！！");
        NKMask *mask = [NKMask mj_objectWithKeyValues:responseObject];
        success(mask);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败！！！！");
        failure(error);
    }];
}
#pragma mark -请求登录信息
-(void)POSTLoginDataWithParameters:(id)parameters Success:(void (^)(NKLogin *))success Failure:(void (^)(NSError *))failure{
    
    [self.dataManager POST:POST_LOGIN_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKLogin *loginMsg = [NKLogin mj_objectWithKeyValues:responseObject];
        success(loginMsg);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败！！！！");
        failure(error);
    }];
}
#pragma mark -第三方登录（不需要绑定手机号码）
-(void)POSTTPLoginDataWithParameters:(id)parameters Success:(void (^)(NKLogin *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_TPLOGIN_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功！！！");
        NKLogin *loginMsg = [NKLogin mj_objectWithKeyValues:responseObject];
        //NKUser *user = [NKUser mj_objectWithKeyValues:loginMsg.user];
        success(loginMsg);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败！！！！");
        failure(error);
    }];
}
#pragma mark -第三方登录（需要绑定手机号码）
-(void)POSTTPBindLoginDataWithParameters:(id)parameters Success:(void (^)(NKLogin *))success Failure:(void (^)(NSError *))failure
{
    
    [self.dataManager POST:POST_TPBINDLOGIN_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功！！！");
        NKLogin *loginMsg = [NKLogin mj_objectWithKeyValues:responseObject];
        //NKUser *user = [NKUser mj_objectWithKeyValues:loginMsg.user];
        success(loginMsg);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败！！！！");
        failure(error);
    }];
}
#pragma mark -请求停车记录
-(void)POSTGetStopRecordWithParameters:(id)parameters Success:(void (^)(NSMutableArray *))success Failure:(void (^)(NSError *))failure{
    
    //以post的形式提交，POST的参数就是上面的域名，parameters的参数是一个字典类型，将上面的字典作为它的参数
    [self.dataManager POST:POST_STOPRECORD_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKStopRecord *stopRecord = [NKStopRecord mj_objectWithKeyValues:responseObject];
        NSMutableArray *detailArray = [NSMutableArray array];
        for (int i = 0; i < stopRecord.records.count; i++)
        {
            NKStopDetailRecord *detailRecord = [NKStopDetailRecord mj_objectWithKeyValues:stopRecord.records[i]];
            [detailArray addObject:detailRecord];
        }
        success(detailArray);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//请求停车记录，按月份
//-(void)POSTGetStopRecordByMonthWithParameters:(id)parameters Success:(void (^)(NSMutableArray *))success Failure:(void (^)(NSError *))failure
//{
//    _dataManager = [AFHTTPSessionManager manager];
//    _dataManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    //以post的形式提交，POST的参数就是上面的域名，parameters的参数是一个字典类型，将上面的字典作为它的参数
//    
//    [_dataManager POST:POST_STOPRECORD_MONTH_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"请求成功！！！");
//        NKStopRecord *stopRecord = [NKStopRecord mj_objectWithKeyValues:responseObject];
//        NSMutableArray *detailArray = [NSMutableArray array];
//        for (int i = 0; i < stopRecord.total; i++)
//        {
//            NKStopDetailRecord *detailRecord = [NKStopDetailRecord mj_objectWithKeyValues:stopRecord.records[i]];
//            [detailArray addObject:detailRecord];
//        }
//        success(detailArray);
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"请求失败！！！！");
//        failure(error);
//    }];
//}
#pragma mark -请求最近一次的停车记录
-(void)POSTGetLatestStopRecordWithParameters:(id)parameters Success:(void (^)(NSMutableArray *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_STOPRECORD_LATEST_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKStopRecord *stopRecord = [NKStopRecord mj_objectWithKeyValues:responseObject];
        NSMutableArray *detailArray = [NSMutableArray array];
        if (stopRecord.ret == 0)
        {
            for (int i = 0; i < stopRecord.records.count; i++)
            {
                NKStopLatestRecord *detailRecord = [NKStopLatestRecord mj_objectWithKeyValues:stopRecord.records[i]];
                [detailArray addObject:detailRecord];
            }
        }
        success(detailArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败！！！！");
        failure(error);
    }];
}
#pragma mark -请求评价标签
-(void)POSTGetCommentWithParameters:(id)parameters Success:(void (^)(NSMutableArray *, NSMutableArray *, NSMutableArray *))success Failure:(void (^)(NSError *))failure{
    
    //以post的形式提交，POST的参数就是上面的域名，parameters的参数是一个字典类型，将上面的字典作为它的参数
    
    [self.dataManager POST:POST_COMMENT_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKComment *comment = [NKComment mj_objectWithKeyValues:responseObject];
        NSMutableArray *parkedTagArray = [NSMutableArray array];
        for (int i = 0; i < comment.parkedTag.count; i++)
        {
            NKCommentTag *tag = [NKCommentTag mj_objectWithKeyValues:comment.parkedTag[i]];
            [parkedTagArray addObject:tag];
        }
         NSMutableArray *carGoTagArray = [NSMutableArray array];
        for (int i = 0; i < comment.carGoTag.count; i++)
        {
            NKCommentTag *tag = [NKCommentTag mj_objectWithKeyValues:comment.carGoTag[i]];
            [carGoTagArray addObject:tag];
        }
         NSMutableArray *carToTagArray = [NSMutableArray array];
        for (int i = 0; i < comment.carToTag.count; i++)
        {
            NKCommentTag *tag = [NKCommentTag mj_objectWithKeyValues:comment.carToTag[i]];
            [carToTagArray addObject:tag];
        }
        success(parkedTagArray, carGoTagArray, carToTagArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -提交评价
-(void)POSTUploadCommentWithParameters:(id)parameters Success:(void (^)(NSString *))success Failure:(void (^)(NSError *))failure{
    
    //以post的形式提交，POST的参数就是上面的域名，parameters的参数是一个字典类型，将上面的字典作为它的参数
    [self.dataManager POST:POST_COMMENTUPLOAD_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"评价请求成功！！！");
        NSString *str = @"ok";
        success(str);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败！！！！%@", error);
        failure(error);
    }];
}
#pragma mark -实名认证
-(void)POSTRealNameCertificateWithParameters:(id)parameters Success:(void (^)(NKBase *))success Failure:(void (^)(NSError *))failure{
    
    [self.dataManager POST:POST_REALNAME_CERTIFACATION_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"实名认证成功！！");
        NKBase *base = [NKBase mj_objectWithKeyValues:responseObject];
        success(base);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"实名认证失败！！");
        failure(error);
    }];
    
}
#pragma mark -修改个人信息
-(void)POSTUpdateMyInfoWithParameters:(id)parameters Success:(void (^)(NKBase *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_UPDATEMYINFO_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKBase *base = [NKBase mj_objectWithKeyValues:responseObject];
        success(base);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -获取消息中心信息
-(void)POSTGetMessageWithParameters:(id)parameters Success:(void (^)(NSMutableArray *))success Failure:(void (^)(NSError *))failure
{
    
    [self.dataManager POST:POST_MESSAGECENTER_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKMessage *message = [NKMessage mj_objectWithKeyValues:responseObject];
        NSMutableArray *messageArray = [NSMutableArray array];
        for (int i = 0; i < message.records.count; i++)
        {
            NKMessageRecord *record = [NKMessageRecord mj_objectWithKeyValues:message.records[i]];
            [messageArray addObject:record];
        }
        success(messageArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -请求账单信息
-(void)POSTGetUserParkingBillWithParameters:(id)parameters Success:(void (^)(NSMutableArray *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_USERPARKINGBILL_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *parkingRecordArray = [NSMutableArray array];
        NKParkingPayBill *bill = [NKParkingPayBill mj_objectWithKeyValues:responseObject];
        for (int i = 0; i < bill.parkedPayRecord.count; i++)
        {
            NKParkedPayRecord *record = [NKParkedPayRecord mj_objectWithKeyValues:bill.parkedPayRecord[i]];
            [parkingRecordArray addObject:record];
        }
        success(parkingRecordArray);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -查询用户
-(void)POSTSearchUserWithParameters:(id)parameters Success:(void (^)(NKUser *))success Failure:(void (^)(NSError *))failure
{
    
    [self.dataManager POST:POST_TRANSFERUSER_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NKUser *user = [NKUser mj_objectWithKeyValues:responseObject];
        success(user);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -查询用户密码
-(void)POSTQueryUserPayPasswordWithParameters:(id)parameters Success:(void (^)(NSString *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_QUERYUSERPAYPASSWORD_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString* backStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        success(backStr);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -更改用户密码
-(void)POSTUpdateUserPasswordWithParameters:(id)parameters Success:(void (^)(NSString *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_UPDATEUSERPAYPASSWORD_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString* backStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        success(backStr);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -转账
-(void)POSTConfirmTransferWithParameters:(id)parameters Success:(void (^)(NSString *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_CONFIRMTRANSFER_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString* backStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        success(backStr);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -最近转账记录
-(void)POSTQueryTransferRecordWithParameters:(id)parameters Success:(void (^)(NKTransferRecord *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_QUERYTRANSFERRECORD_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKTransferRecord *records = [NKTransferRecord mj_objectWithKeyValues:responseObject];
        success(records);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -校验验证码
-(void)POSTToCheckSmsCodeWithParameters:(id)parameters Success:(void (^)(NKBase *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_CHECKSMSCODE_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKBase *base = [NKBase mj_objectWithKeyValues:responseObject];
        success(base);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -支付宝支付
-(void)POSTAliypayWithParameters:(id)parameters Success:(void (^)(NKAliypay *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_ALIYPAY_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKAliypay *pay = [NKAliypay mj_objectWithKeyValues:responseObject];
        success(pay);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -微信支付
-(void)POSTWXPayWithParameters:(id)parameters Success:(void (^)(NKWXPay *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_WXPAY_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@", dic);
        NKWXPay *pay = [NKWXPay mj_objectWithKeyValues:responseObject];
        success(pay);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -刷新数据
-(void)POSTUpdateDataWithParameters:(id)parametes Success:(void (^)(NKLogin *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_UPDATEDATA_URLSTRING parameters:parametes progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKLogin *loginMsg = [NKLogin mj_objectWithKeyValues:responseObject];
        success(loginMsg);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -可用优惠券
-(void)POSTGetUserCouponWithParameters:(id)parameters Success:(void (^)(NSArray *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_GETSSPCOUPON_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKBase *base = [NKBase mj_objectWithKeyValues:responseObject];
        NSMutableArray *mutableArray = [NSMutableArray array];
        if (base.ret == -13 || base.ret == -16 || base.ret == -10)
        {
            success(mutableArray);
        }
        else
        {
            NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            for (int i = 0; i < array.count; i++)
            {
                NKUserCoupon *coupon = [NKUserCoupon mj_objectWithKeyValues:array[i]];
                [mutableArray addObject:coupon];
            }
            success(mutableArray);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -使用过的优惠券
-(void)POSTGetUserUsedCouponWithParameters:(id)parameters Success:(void (^)(NSArray *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_GETSSPUSEDCOUPON_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKBase *base = [NKBase mj_objectWithKeyValues:responseObject];
        NSMutableArray *mutableArray = [NSMutableArray array];
        if (base.ret == -13 || base.ret == -16 || base.ret == -10)
        {
            success(mutableArray);
        }
        else
        {
            NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            for (int i = 0; i < array.count; i++)
            {
                NKUserCoupon *coupon = [NKUserCoupon mj_objectWithKeyValues:array[i]];
                [mutableArray addObject:coupon];
            }
            success(mutableArray);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -过期优惠券
-(void)POSTGetUserExpireCouponWithParameters:(id)parameters Success:(void (^)(NSArray *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_GETSSPEXPIRECOUPON_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKBase *base = [NKBase mj_objectWithKeyValues:responseObject];
        NSMutableArray *mutableArray = [NSMutableArray array];
        if (base.ret == -13 || base.ret == -16 || base.ret == -10)
        {
            success(mutableArray);
        }
        else
        {
            NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            for (int i = 0; i < array.count; i++)
            {
                NKUserCoupon *coupon = [NKUserCoupon mj_objectWithKeyValues:array[i]];
                [mutableArray addObject:coupon];
            }
            success(mutableArray);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -分享获取优惠券
-(void)POSTGetSharedCouponWithParameters:(id)parameters Success:(void (^)(NSArray *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_SHAREGETCOUPON_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKBase *base = [NKBase mj_objectWithKeyValues:responseObject];
        NSMutableArray *mutableArray = [NSMutableArray array];
        if (base.ret == -13 || base.ret == -16 || base.ret == -10)
        {
            success(mutableArray);
        }
        else
        {
            NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            for (int i = 0; i < array.count; i++)
            {
                NKUserCoupon *coupon = [NKUserCoupon mj_objectWithKeyValues:array[i]];
                [mutableArray addObject:coupon];
            }
            success(mutableArray);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -根据类型查询优惠券
-(void)POSTQueryCouponWithParameters:(id)parameters Success:(void (^)(NSArray *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_QUERYCOUPONBYTYPE_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKBase *base = [NKBase mj_objectWithKeyValues:responseObject];
        NSMutableArray *mutableArray = [NSMutableArray array];
        if (base.ret == -13 || base.ret == -16 || base.ret == -10)
        {
            success(mutableArray);
        }
        else
        {
            NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            for (int i = 0; i < array.count; i++)
            {
                NKUserCoupon *coupon = [NKUserCoupon mj_objectWithKeyValues:array[i]];
                [mutableArray addObject:coupon];
            }
            success(mutableArray);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -添加车辆
-(void)POSTAddCarWithParameters:(id)parameters Success:(void (^)(NKCar *))success Failure:(void (^)(NSError *))failure{
    
    [self.dataManager POST:POST_ADDCAR_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NKCar *car = [NKCar mj_objectWithKeyValues:responseObject];
        success(car);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -删除车辆
-(void)POSTDeleteCarWithParameters:(id)parameters Success:(void (^)(NKBase *))success Failure:(void (^)(NSError *))failure{
    
    [self.dataManager POST:POST_DELETECAR_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKBase *base = [NKBase mj_objectWithKeyValues:responseObject];
        success(base);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -上传车辆照片,实名认证照片
- (void)POSTUploadImagesWithParameters:(id)parameters Success:(void (^)(NKFile *))success Failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"image/jpeg",@"image/png", @"application/octet-stream",@"text/json",nil];
    
    NSArray *imageArray = [NSArray arrayWithArray:parameters[@"imageArray"]];
    for (int i = 0; i < imageArray.count; i++)
    {
        UIImage *image = imageArray[i];
        [manager POST:POST_UPLOADFILE_URLSTRING parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSData *imageData = UIImageJPEGRepresentation(image, 1);
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@%d.jpg", str, i];
            
            //上传的参数(上传图片，以文件流的格式)
            [formData appendPartWithFileData:imageData
                                        name:@"file"
                                    fileName:fileName
                                    mimeType:@"image/jpeg"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"文件正在上传！");
            NSLog(@"%@", uploadProgress);
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"上传成功！！");
            NKFile *file = [NKFile mj_objectWithKeyValues:responseObject];
            NSLog(@"%@", file);
//            file.url = [NSString stringWithFormat:@"https://file.quickpark.com.cn/getimg/img/viewimg/mnt/resource%@", file.url];
            success(file);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"上传失败！！");
            NSLog(@"%@", error);
            failure(error);
        }];
        
    }
}
#pragma mark -认证车辆
-(void)POSTToCertificateCarWithParameters:(id)parameters Success:(void (^)(NKBase *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_CERTIFICATECAR_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKBase *base = [NKBase mj_objectWithKeyValues:responseObject];
        success(base);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -查询车辆是否已存在
-(void)POSTTOCheckCarExistWithParameters:(id)parameters Success:(void (^)(NKBase *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_CHECKCAREXIST_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKBase *base = [NKBase mj_objectWithKeyValues:responseObject];
        success(base);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -获取车辆的总里程和总消费时间
-(void)POSTGetCarExpendAndTimeWithParameters:(id)parameters Success:(void (^)(NKCarExpendAndTime *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_GETCAREXPENDANDTIME_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKCarExpendAndTime *eat = [NKCarExpendAndTime mj_objectWithKeyValues:responseObject];
        success(eat);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -获取所有车辆的总里程和总消费时间
-(void)POSTGetCarTotalExpendAndTimeWithParameters:(id)parameters Success:(void (^)(NKCarTotalExpendAndTime *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_GETCARTOTALEXPENDANDTIME_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKCarTotalExpendAndTime *eat = [NKCarTotalExpendAndTime mj_objectWithKeyValues:responseObject];
        success(eat);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -获取车辆饼图数据
-(void)POSTGetManageCarPieDataWithParameters:(id)parameters Success:(void (^)(NKPieData *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_GETMANAGECARPIEDATA_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKPieData *pieData = [NKPieData mj_objectWithKeyValues:responseObject];
        success(pieData);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -设置默认车辆
-(void)POSTSetDefaultCarWithParameters:(id)parameters Success:(void (^)(NKBase *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_SETDEFALTCAR_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKBase *base = [NKBase mj_objectWithKeyValues:responseObject];
        success(base);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -取消设置默认车辆
-(void)POSTCancelDefaultCarWithParameters:(id)parameters Success:(void (^)(NKBase *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_CANCELDEFALTCAR_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKBase *base = [NKBase mj_objectWithKeyValues:responseObject];
        success(base);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -更新车辆色卡
-(void)POSTUpdateCarColorCardWithParameters:(id)parameters Success:(void (^)(NKBase *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_UPDATECARCOLORCARD_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKBase *base = [NKBase mj_objectWithKeyValues:responseObject];
        success(base);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -更改车辆背景图
-(void)POSTUpdateCarBGImageWithParameters:(id)parameters Success:(void (^)(NKBase *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_UPDATECARBGIMAGEVIEW_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKBase *base = [NKBase mj_objectWithKeyValues:responseObject];
        success(base);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -自动扣费开关
-(void)POSTCarPaySwitchParameters:(id)parameters Success:(void (^)(NKCar *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_CARPAYSWITCH_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKCar *car = [NKCar mj_objectWithKeyValues:responseObject];
        success(car);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -调节免密额度
-(void)POSTChangeCarFreeMoneyWithParameters:(id)parameters Success:(void (^)(NKBase *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_CHANGECARFREEMONEY_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKBase *base = [NKBase mj_objectWithKeyValues:responseObject];
        success(base);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -充值规则
-(void)POSTGetRechargeRuleWithParameters:(id)parameters Success:(void (^)(NSArray *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager GET:POST_GETRECHARGERULE_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (int i = 0; i < array.count; i++)
        {
            NKRechargeRule *rule = [NKRechargeRule mj_objectWithKeyValues:array[i]];
            [mutableArray addObject:rule];
        }
        success(mutableArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -迅停单
//获取订单的一些基本配置信息
-(void)POSTGetOneKeyOrderBaseDataWithParameters:(id)parameters Success:(void (^)(NKSspOrderBackValue *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_GETBASEDATA_ONEKEYORDER_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKSspOrderBackValue *backValue = [NKSspOrderBackValue mj_objectWithKeyValues:responseObject];
        success(backValue);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//迅停单下单
-(void)POSTCreateOneKeyOrderWithParameters:(id)parameters Success:(void (^)(NKSspOrderBackValue *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_CREATE_ONEKEYORDER_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NKSspOrderBackValue *backValue = [NKSspOrderBackValue mj_objectWithKeyValues:responseObject];
        success(backValue);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}
//迅停单取消下单
-(void)POSTCancelOneKeyOrderWithParameters:(id)parameters Success:(void (^)(NKSspOrderBackValue *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_CANCEL_ONEKEYORDER_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKSspOrderBackValue *backValue = [NKSspOrderBackValue mj_objectWithKeyValues:responseObject];
        success(backValue);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//导航界面获取信息
-(void)POSTGetOneKeyOrderNaviViewDataWithParameters:(id)parameters Success:(void (^)(NKSspOrderBackValue *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_GETNAVIVIEWDATA_ONEKEYORDER_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKSspOrderBackValue *backValue = [NKSspOrderBackValue mj_objectWithKeyValues:responseObject];
        success(backValue);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//查询是否有未完成订单
-(void)POSTCheckOneKeyOrderWithParameters:(id)parameters Success:(void (^)(NKSspOrderBackValue *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_CHECK_ONEKEYORDER_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKSspOrderBackValue *backValue = [NKSspOrderBackValue mj_objectWithKeyValues:responseObject];
        success(backValue);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//应急处理-继续呼叫
- (void)POSTContinueCreateOrderWithParameters:(id)parameters Success:(void (^)(NKSspOrderBackValue *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_CONTINUECREATE_ONEKEYORDER_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKSspOrderBackValue *backValue = [NKSspOrderBackValue mj_objectWithKeyValues:responseObject];
        success(backValue);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//应急处理-系统分配车位
-(void)POSTSystemSendBerthWithParameters:(id)parameters Success:(void (^)(NKSspOrderBackValue *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_SYSTEMSENDBERTH_ONEKEYORDER_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKSspOrderBackValue *backValue = [NKSspOrderBackValue mj_objectWithKeyValues:responseObject];
        success(backValue);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//应急处理-停止呼叫
-(void)POSTEndCallWithParameters:(id)parameters Success:(void (^)(NKSspOrderBackValue *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_ENDCALL_ONEKEYORDER_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKSspOrderBackValue *backValue = [NKSspOrderBackValue mj_objectWithKeyValues:responseObject];
        success(backValue);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -精致
//存车
-(void)POSTElegantSaveCarWithParameters:(id)parameters Success:(void (^)(NKSspOrderBackValue *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_ELEGANT_SAVECAR_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKSspOrderBackValue *backValue = [NKSspOrderBackValue mj_objectWithKeyValues:responseObject];
        success(backValue);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//取车
-(void)POSTElegantTakeCarWithParameters:(id)parameters Success:(void (^)(NKSspOrderBackValue *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_ELEGANT_TAKECAR_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKSspOrderBackValue *backValue = [NKSspOrderBackValue mj_objectWithKeyValues:responseObject];
        success(backValue);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//取消存车
-(void)POSTElegantCancelSaveCarWithParameters:(id)parameters Success:(void (^)(NKSspOrderBackValue *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_ELEGANT_CANCELSAVECAR_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKSspOrderBackValue *backValue = [NKSspOrderBackValue mj_objectWithKeyValues:responseObject];
        success(backValue);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//取消取车
-(void)POSTElegantCancelTakeCarWithParameters:(id)parameters Success:(void (^)(NKSspOrderBackValue *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_ELEGANT_CANCELTAKECAR_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKSspOrderBackValue *backValue = [NKSspOrderBackValue mj_objectWithKeyValues:responseObject];
        success(backValue);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//获取车场数据
-(void)POSTElegantGetParkingDataWithParameters:(id)parameters Success:(void (^)(NKSspOrderBackValue *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_ELEGANT_GETPARKINGDATA_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKSspOrderBackValue *backValue = [NKSspOrderBackValue mj_objectWithKeyValues:responseObject];
        success(backValue);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//查询所有订单
-(void)POSTElegantGetAllOrderWithParameters:(id)parameters Success:(void (^)(NKSspOrderBackValue *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_ELEGANT_GETALLORDER_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKSspOrderBackValue *backValue = [NKSspOrderBackValue mj_objectWithKeyValues:responseObject];
        success(backValue);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//查询车位实时状态
-(void)POSTElegantGetBerthsWithParameters:(id)parameters Success:(void (^)(NKSspOrderBackValue *))success Failure:(void (^)(NSError *))failure
{}
#pragma mark -投诉及评价
//获取投诉tag
-(void)POSTGetComplaintTagWithParameters:(id)parameters Success:(void (^)(NSArray *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_GETCOMPLAINTTAG_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *tagArray = [NSMutableArray array];
        for (int i = 0; i < array.count; i++)
        {
            NKSspComplaintTag *tag = [NKSspComplaintTag mj_objectWithKeyValues:array[i]];
            [tagArray addObject:tag];
        }
        success(tagArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//投诉
-(void)POSTComplaintWithParameters:(id)parameters Susccess:(void (^)(int))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_COMPLAINT_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = [NSData dataWithData:responseObject];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        int ret = [str intValue];
        success(ret);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//获取评价标签
-(void)POSTGetCommentTagWithParameters:(id)parameters Success:(void (^)(NSMutableArray *, NSMutableArray *, NSMutableArray *, NSMutableArray *, NSMutableArray *, NSMutableArray *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_COMMENT_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableArray *allArray = [NSMutableArray array];
        for (int i = 0; i < array.count; i++)
        {
            NKSspEvaluateTag *tag = [NKSspEvaluateTag mj_objectWithKeyValues:array[i]];
            [allArray addObject:tag];
        }
        NSMutableArray *array11_5 = [NSMutableArray array];
        NSMutableArray *array11_1 = [NSMutableArray array];
        NSMutableArray *array11_2 = [NSMutableArray array];
        NSMutableArray *array11_3 = [NSMutableArray array];
        NSMutableArray *array11_4 = [NSMutableArray array];
        
        NSMutableArray *array12_5 = [NSMutableArray array];
        NSMutableArray *array12_1 = [NSMutableArray array];
        NSMutableArray *array12_2 = [NSMutableArray array];
        NSMutableArray *array12_3 = [NSMutableArray array];
        NSMutableArray *array12_4 = [NSMutableArray array];
        
        NSMutableArray *array13_5 = [NSMutableArray array];
        NSMutableArray *array13_1 = [NSMutableArray array];
        NSMutableArray *array13_2 = [NSMutableArray array];
        NSMutableArray *array13_3 = [NSMutableArray array];
        NSMutableArray *array13_4 = [NSMutableArray array];
        
        NSMutableArray *array21_5 = [NSMutableArray array];
        NSMutableArray *array21_1 = [NSMutableArray array];
        NSMutableArray *array21_2 = [NSMutableArray array];
        NSMutableArray *array21_3 = [NSMutableArray array];
        NSMutableArray *array21_4 = [NSMutableArray array];
        
        NSMutableArray *array22_5 = [NSMutableArray array];
        NSMutableArray *array22_1 = [NSMutableArray array];
        NSMutableArray *array22_2 = [NSMutableArray array];
        NSMutableArray *array22_3 = [NSMutableArray array];
        NSMutableArray *array22_4 = [NSMutableArray array];
        
        NSMutableArray *array23_5 = [NSMutableArray array];
        NSMutableArray *array23_1 = [NSMutableArray array];
        NSMutableArray *array23_2 = [NSMutableArray array];
        NSMutableArray *array23_3 = [NSMutableArray array];
        NSMutableArray *array23_4 = [NSMutableArray array];
        
        for (NKSspEvaluateTag *tag in allArray)
        {
            if (tag.tagtype == 11)
            {
                switch (tag.starlevel)
                {
                    case 1:
                        [array11_1 addObject:tag];
                        break;
                    case 2:
                        [array11_2 addObject:tag];
                        break;
                    case 3:
                        [array11_3 addObject:tag];
                        break;
                    case 4:
                        [array11_4 addObject:tag];
                        break;
                    case 5:
                        [array11_5 addObject:tag];
                        break;
                    default:
                        break;
                }
            }
            if (tag.tagtype == 12)
            {
                switch (tag.starlevel)
                {
                    case 1:
                        [array12_1 addObject:tag];
                        break;
                    case 2:
                        [array12_2 addObject:tag];
                        break;
                    case 3:
                        [array12_3 addObject:tag];
                        break;
                    case 4:
                        [array12_4 addObject:tag];
                        break;
                    case 5:
                        [array12_5 addObject:tag];
                        break;
                    default:
                        break;
                }
            }
            if (tag.tagtype == 13)
            {
                switch (tag.starlevel)
                {
                    case 1:
                        [array13_1 addObject:tag];
                        break;
                    case 2:
                        [array13_2 addObject:tag];
                        break;
                    case 3:
                        [array13_3 addObject:tag];
                        break;
                    case 4:
                        [array13_4 addObject:tag];
                        break;
                    case 5:
                        [array13_5 addObject:tag];
                        break;
                    default:
                        break;
                }
            }
            if (tag.tagtype == 21)
            {
                switch (tag.starlevel)
                {
                    case 1:
                        [array21_1 addObject:tag];
                        break;
                    case 2:
                        [array21_2 addObject:tag];
                        break;
                    case 3:
                        [array21_3 addObject:tag];
                        break;
                    case 4:
                        [array21_4 addObject:tag];
                        break;
                    case 5:
                        [array21_5 addObject:tag];
                        break;
                    default:
                        break;
                }
            }
            if (tag.tagtype == 22)
            {
                switch (tag.starlevel)
                {
                    case 1:
                        [array22_1 addObject:tag];
                        break;
                    case 2:
                        [array22_2 addObject:tag];
                        break;
                    case 3:
                        [array22_3 addObject:tag];
                        break;
                    case 4:
                        [array22_4 addObject:tag];
                        break;
                    case 5:
                        [array22_5 addObject:tag];
                        break;
                    default:
                        break;
                }
            }
            if (tag.tagtype == 23)
            {
                switch (tag.starlevel)
                {
                    case 1:
                        [array23_1 addObject:tag];
                        break;
                    case 2:
                        [array23_2 addObject:tag];
                        break;
                    case 3:
                        [array23_3 addObject:tag];
                        break;
                    case 4:
                        [array23_4 addObject:tag];
                        break;
                    case 5:
                        [array23_5 addObject:tag];
                        break;
                    default:
                        break;
                }
            }
        }
        NSMutableArray *array11 = [NSMutableArray arrayWithObjects:array11_1, array11_2, array11_3, array11_4, array11_5, nil];
        NSMutableArray *array12 = [NSMutableArray arrayWithObjects:array12_1, array12_2, array12_3, array12_4, array12_5, nil];
        NSMutableArray *array13 = [NSMutableArray arrayWithObjects:array13_1, array13_2, array13_3, array13_4, array13_5, nil];
        NSMutableArray *array21 = [NSMutableArray arrayWithObjects:array21_1, array21_2, array21_3, array21_4, array21_5, nil];;
        NSMutableArray *array22 = [NSMutableArray arrayWithObjects:array22_1, array22_2, array22_3, array22_4, array22_5, nil];;
        NSMutableArray *array23 = [NSMutableArray arrayWithObjects:array23_1, array23_2, array23_3, array23_4, array23_5, nil];;
        success(array11, array12, array13, array21, array22, array23);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//评价
- (void)POSTToCommentWithParameters:(id)parameters Success:(void (^)(int))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_COMMENTUPLOAD_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = [NSData dataWithData:responseObject];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        int ret = [str intValue];
        success(ret);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//获取评价详情
- (void)POSTToGetEvaluateRecordWithParameters:(id)parameters Success:(void (^)(NKEvaluateRecord *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_GETONEDETAILEVALUATE_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKEvaluateRecord *record = [NKEvaluateRecord mj_objectWithKeyValues:responseObject];
        success(record);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
//获取评价Mep信息
- (void)POSTToGetMEPInfomationWithParameters:(id)parameters Success:(void (^)(NKMepInfo *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_GETMEPINFO_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKMepInfo *mep = [NKMepInfo mj_objectWithKeyValues:responseObject];
        success(mep);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark - 停好-获取正在停车的停车记录
- (void)POSTToGetIsParkingRecordWithParameters:(id)parameters Success:(void (^)(NSArray *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_ISPARKINGRECORD_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *array = [NSArray mj_objectArrayWithKeyValuesArray:responseObject];
        NSMutableArray *records = [NSMutableArray array];
        for (int i = 0; i < array.count; i++)
        {
            NKIsParkingRecordInfo *record = [NKIsParkingRecordInfo mj_objectWithKeyValues:array[i]];
            [records addObject:record];
        }
        success(records);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
- (void)POSTToGetParkingPriceRuleWithParameters:(id)parameters Success:(void (^)(NSString *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_GETPARKINGRULE_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString* backStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        success(backStr);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -请求车辆品牌列表
-(void)POSTToGetAllCarBrandWithParameters:(id)parameters Success:(void (^)(NKCarBrandBaseData *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_GETALLCARBRANDLIST_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKCarBrandBaseData *baseData = [NKCarBrandBaseData mj_objectWithKeyValues:responseObject];
        //获取数组，并排序
        NSArray *keyArray = [baseData.result allKeys];
        //将JSON转对象
        NSDictionary *resultDic = [NSDictionary dictionaryWithDictionary:baseData.result];
        NSMutableDictionary *resultMutableDic = [NSMutableDictionary dictionary];
        for (int i = 0; i < keyArray.count; i++)
        {
            NSArray *carBrandArray = [resultDic objectForKey:keyArray[i]];
            NSMutableArray *carBrandMutableArray = [NSMutableArray array];
            for (int j = 0; j < carBrandArray.count; j++) {
                NKCarBrandData *brandData = [NKCarBrandData mj_objectWithKeyValues:carBrandArray[j]];
                [carBrandMutableArray addObject:brandData];
            }
            [resultMutableDic setObject:carBrandMutableArray forKey:keyArray[i]];
        }
        baseData.result = [NSDictionary dictionaryWithDictionary:resultMutableDic];
        success(baseData);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -获取广告图片
-(void)POSTGEtAdvertisementImageWithParameters:(id)parameters Success:(void (^)(NSArray<NSString *> *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_GETADVERTISEMENTIMG_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKAdvertisementImageData *imageData = [NKAdvertisementImageData mj_objectWithKeyValues:responseObject];
        NSMutableArray<NSString *> *urlsMutableArray = [NSMutableArray array];
        if (imageData.names.count > 0)
        {
            for (NSString *nameStr in imageData.names)
            {
                NSString *urlStr = [NSString stringWithFormat:@"%@%@", imageData.baseUrl, nameStr];
                [urlsMutableArray addObject:urlStr];
            }
        }
        success(urlsMutableArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -获取消费账单详情列表
-(void)POSTGetBillDetailWithParameters:(id)parameters Success:(void (^)(NSArray *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_GETBILLDETAIL_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *array = [NSArray mj_objectArrayWithKeyValuesArray:responseObject];
        NSMutableArray *billListArray = [NSMutableArray array];
        for (int i = 0; i < array.count; i++) {
            NKBillDetail *bill = [NKBillDetail mj_objectWithKeyValues:array[i]];
            [billListArray addObject:bill];
        }
        success(billListArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark -绑定本地账户
-(void)POSTToGetLocalPassportInfoWithParameters:(id)parameters Success:(void (^)(NKLocalPassportBaseDto *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_GETLOCALPASSPORTINFO_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKLocalPassportBaseDto *baseDto = [NKLocalPassportBaseDto mj_objectWithKeyValues:responseObject];
        success(baseDto);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
-(void)POSTToBindLocalPassportWithParameters:(id)parameters Success:(void (^)(NKBase *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_BINDLOCALPASSPORT_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKBase *base = [NKBase mj_objectWithKeyValues:responseObject];
        success(base);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
-(void)POSTToRemoveBindLocalPassportWithParameters:(id)parameters Success:(void (^)(NKBase *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_CANCELBINDLOCALPASSPORT_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKBase *base = [NKBase mj_objectWithKeyValues:responseObject];
        success(base);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark - 补交费用
-(void)POSTToGetRepaymentRecordWithParameters:(id)parameters Success:(void (^)(NSMutableArray *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_GETREPAYMENTRECORD_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKStopRecord *stopRecord = [NKStopRecord mj_objectWithKeyValues:responseObject];
        NSMutableArray *detailArray = [NSMutableArray array];
        for (int i = 0; i < stopRecord.records.count; i++)
        {
            NKStopDetailRecord *detailRecord = [NKStopDetailRecord mj_objectWithKeyValues:stopRecord.records[i]];
            [detailArray addObject:detailRecord];
        }
        success(detailArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
-(void)POSTToGetRepaymentRecordNumberWithParameters:(id)parameters Success:(void (^)(NKBase *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_GETREPAYMENTRECORDNUMBER_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKBase *base = [NKBase mj_objectWithKeyValues:responseObject];
        success(base);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
-(void)POSTToCheckBalanceWithParameters:(id)parameters Success:(void (^)(NKBase *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_CHECKBALANCE_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKBase *base = [NKBase mj_objectWithKeyValues:responseObject];
        success(base);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
-(void)POSTToRepayWithParameters:(id)parameters Success:(void (^)(NKBase *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_REPAY_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKBase *base = [NKBase mj_objectWithKeyValues:responseObject];
        success(base);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
#pragma mark - 校验密码
-(void)POSTToCheckPassWordWithParameters:(id)parameters Success:(void (^)(NKBase *))success Failure:(void (^)(NSError *))failure
{
    [self.dataManager POST:POST_CHECKPASSWORD_URLSTRING parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NKBase *base = [NKBase mj_objectWithKeyValues:responseObject];
        success(base);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
/******************************************************************************/
#pragma mark - 将数据写到文件及NSUserdefault中的类方法
+(void)writeDataToTextWith:(NKLogin *)loginMsg
{
    //将token以及登录标记flag，还有一些基本信息 写到userdefault中
    /************************token******flag**************************************/
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:@1 forKey:@"loginFlag"];
    NKUser *user = [NKUser mj_objectWithKeyValues:loginMsg.user];
    NSString *token = user.token;
    [userDefault setObject:token forKey:@"myToken"];
    /************************token******flag**************************************/
    
    /**********************车辆车位信息*************************/
    NSString *sspId = user.loginName;
    NSMutableArray *carArray = [NSMutableArray array];
    for (int i = 0; i < user.cars.count; i++)
    {
        NKCar *car = [NKCar mj_objectWithKeyValues:user.cars[i]];
        NSData *carData = [NSKeyedArchiver archivedDataWithRootObject:car];
        [carArray addObject:carData];
    }
    
    NSMutableArray *berthArray = [NSMutableArray array];
    for (int i = 0; i < user.berths.count; i++)
    {
        NKBerth *berth = [NKBerth mj_objectWithKeyValues:user.berths[i]];
        NSData *berthData = [NSKeyedArchiver archivedDataWithRootObject:berth];
        [berthArray addObject:berthData];
    }
    [userDefault setObject:carArray forKey:@"carArray"];
    [userDefault setObject:berthArray forKey:@"berthArray"];
    [userDefault setObject:sspId forKey:@"sspId"];
    /**********************车辆车位信息*************************/
    
    /**********************头像， 名称，积分，余额，实名认证状态*************************/
    NSInteger balance = user.balance;
    NSInteger points = user.points;
    NSString *iconImageUrl;
    NSInteger realNameStatus = user.realNameStatus;
    if (user.avatar == nil)
    {
        iconImageUrl = [NSString stringWithFormat:@""];
        [userDefault setObject:nil forKey:@"iconImageData"];
    }
    else
    {
        iconImageUrl = [NSString stringWithFormat:@"%@", user.avatar];
        NSData *iconImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString: user.avatar]];
        [userDefault setObject:iconImageData forKey:@"iconImageData"];
        [[NSUserDefaults standardUserDefaults] objectForKey:@"iconImageData"];
    }
    NSString *niName;
    if (user.niName == nil)
    {
        niName = [NSString stringWithFormat:@"昵称"];
    }
    else
    {
        niName = user.niName;
    }
    [userDefault setInteger:balance forKey:@"balance"];
    [userDefault setObject:iconImageUrl forKey:@"avatar"];
    [userDefault setObject:[NSNumber numberWithInteger:points] forKey:@"points"];
    [userDefault setObject:niName forKey:@"niName"];
    [userDefault setInteger:realNameStatus forKey:@"realNameStatus"];
    /**********************头像， 名称，积分，余额*************************/
    
    /**********************个人信息**************************************/
    NSString *realName;
    if (user.realName == nil)
    {
        realName = [NSString stringWithFormat:@""];
    }
    else
    {
        realName = [NSString stringWithFormat:@"%@", user.realName];
    }
    NSString *birthDate;
    if (user.birthDate == nil)
    {
        birthDate = [NSString stringWithFormat:@""];
    }
    else
    {
        birthDate = [NSString stringWithFormat:@"%@", user.birthDate];
    }
    NSInteger sex = user.sex;
    NSString *mobile;
    if (user.mobile == nil)
    {
        mobile = [NSString stringWithFormat:@""];
    }
    else
    {
        mobile = [NSString stringWithFormat:@"%@", user.mobile];
    }
    NSString *email;
    if (user.email == nil)
    {
        email = [NSString stringWithFormat:@""];
    }
    else
    {
        email = [NSString stringWithFormat:@"%@", user.email];
    }
    NSString *userType;
    if (user.userType == nil)
    {
        userType = [NSString stringWithFormat:@"普通用户"];
    }
    else
    {
        userType = [NSString stringWithFormat:@"%@", user.userType];
    }
    NSString *membership;
    if (user.membership == nil)
    {
        membership = [NSString stringWithFormat:@"普通用户"];
    }
    else
    {
        membership = user.membership;
    }
    NSString *signature = user.signature;
    if (!signature)
    {
        signature = @"个性签名";
    }
    [userDefault setObject:realName forKey:@"realName"];
    [userDefault setObject:birthDate forKey:@"birthDate"];
    [userDefault setObject:mobile forKey:@"mobile"];
    [userDefault setObject:email forKey:@"email"];
    [userDefault setObject:[NSNumber numberWithInteger:sex] forKey:@"sex"];
    [userDefault setObject:userType forKey:@"userType"];
    [userDefault setObject:membership forKey:@"membership"];
    [userDefault setObject:signature forKey:@"signature"];
    
    //车辆管理背景图
    NSString *bgurl = user.carManagerBg;
    if (bgurl)
    {
        [userDefault setObject:bgurl forKey:@"carManagerBg"];
    }else{
        [userDefault setObject:@"bgurl" forKey:@"carManagerBg"];
    }
    /**********************个人信息**************************************/
    
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
    [userDefault setObject:userData forKey:@"userData"];
    
    //将整个loginMsg归档存到本地
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:loginMsg];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *pathStr = [NSString stringWithFormat:@"%@/LoginMsg.txt", path];
    [data writeToFile:pathStr atomically:YES];
    
    //[self readModel];
    
}
//-(void)readModel
//{
//    NSString *str = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
//    NSString *path = [NSString stringWithFormat:@"%@/LoginMsg.txt", str];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    //将data装换为model   如果在归档的时候是数组,那么反归档的倒得的也是数组
//    NKLogin *LoginMsg = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//    NSLog(@"%@", LoginMsg);
//}
@end
