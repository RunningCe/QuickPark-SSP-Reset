//
//  NKDataManager.h
//  QuickPark-SSP
//
//  Created by Nick on 16/8/22.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "MJExtension.h"
#import "NKMask.h"
#import "NKCar.h"
#import "NKBerth.h"
#import "NKUser.h"
#import "NKLogin.h"
#import "NKStopRecord.h"
#import "NKStopLatestRecord.h"
#import "NKStopDetailRecord.h"
#import "NKAddCar.h"
#import "NKFile.h"
#import "NKBase.h"
#import "NKMessage.h"
#import "NKParkingPayBill.h"
#import "NKParkedPayRecord.h"
#import "NKTransferRecord.h"
#import "NKPay.h"
#import "NKAliypay.h"
#import "NKWXPay.h"
#import "NKUserCoupon.h"
#import "NKCarExpendAndTime.h"
#import "NKRechargeRule.h"
#import "NKSspOrderParameters.h"
#import "NKSspOrderBackValue.h"
#import "NKSspOrderBasicData.h"
#import "NKSspComplaintTag.h"
#import "NKSspEvaluateTag.h"
#import "NKEvaluateRecord.h"
@class NKParkingCharge, NKParkingPriceRule, NKCarBrandBaseData, NKPieData, NKCarTotalExpendAndTime, NKBillDetail, NKMepInfo, NKLocalPassportBaseDto;


@interface NKDataManager : NSObject

+(NKDataManager *)sharedDataManager;

+(void)writeDataToTextWith:(NKLogin *)loginMsg;

#pragma mark - 登录
-(void)POSTMaskDataWithParameters:(id)parameters Success:(void(^)(NKMask* mask))success Failure:(void(^)(NSError *error))failure;
- (void)POSTUserCenterMaskDataWithParameters:(id)parameters Success:(void (^)(NKMask *mask))success Failure:(void (^)(NSError *error))failure;
-(void)POSTLoginDataWithParameters:(id)parameters Success:(void (^)(NKLogin* loginMsg))success Failure:(void(^)(NSError *error))failure;
#pragma mark - 停车记录
-(void)POSTGetStopRecordWithParameters:(id)parameters Success:(void (^)(NSMutableArray *mutableArray))success Failure:(void (^)(NSError *error))failure;
//-(void)POSTGetStopRecordByMonthWithParameters:(id)parameters Success:(void (^)(NSMutableArray *mutableArray))success Failure:(void (^)(NSError *error))failure;
-(void)POSTGetLatestStopRecordWithParameters:(id)parameters Success:(void (^)(NSMutableArray *mutableArray))success Failure:(void (^)(NSError *error))failure;
#pragma mark - 评价
-(void)POSTGetCommentWithParameters:(id)parameters Success:(void (^)(NSMutableArray *parkedArray, NSMutableArray *carGoArray, NSMutableArray *carToArray))success Failure:(void (^)(NSError *error))failure;
-(void)POSTUploadCommentWithParameters:(id)parameters Success:(void (^)(NSString *backStr))success Failure:(void(^)(NSError *error))failure;
#pragma mark - 实名认证 && 个人信息
-(void)POSTRealNameCertificateWithParameters:(id)parameters Success:(void (^)(NKBase *base))success Failure:(void (^)(NSError *error))failure;
-(void)POSTUpdateMyInfoWithParameters:(id)parameters Success:(void (^)(NKBase *base))success Failure:(void (^)(NSError *error))failure;
#pragma mark - 消息中心
-(void)POSTGetMessageWithParameters:(id)parameters Success:(void (^)(NSMutableArray* messageArray))success Failure:(void (^)(NSError *error))failure;
-(void)POSTGetUserParkingBillWithParameters:(id)parameters Success:(void (^)(NSMutableArray *billArray))success Failure:(void (^)(NSError *error))failure;
-(void)POSTSearchUserWithParameters:(id)parameters Success:(void (^)(NKUser *user))success Failure:(void (^)(NSError *error))failure;
-(void)POSTQueryUserPayPasswordWithParameters:(id)parameters Success:(void (^)(NSString *backStr))success Failure:(void (^)(NSError *error))failure;
-(void)POSTUpdateUserPasswordWithParameters:(id)parameters Success:(void (^) (NSString *backStr))success Failure:(void (^)(NSError *error))failure;
-(void)POSTConfirmTransferWithParameters:(id)parameters Success:(void (^)(NSString *backStr))success Failure:(void (^)(NSError *error))failure;
-(void)POSTCarPaySwitchParameters:(id)parameters Success:(void (^) (NKCar *car))success Failure:(void (^) (NSError *error))failure;
-(void)POSTQueryTransferRecordWithParameters:(id)parameters Success:(void (^)(NKTransferRecord *transferRecord))success Failure:(void (^)(NSError *error))failure;
-(void)POSTTPLoginDataWithParameters:(id)parameters Success:(void (^)(NKLogin* loginMsg))success Failure:(void(^)(NSError *error))failure;
-(void)POSTTPBindLoginDataWithParameters:(id)parameters Success:(void (^)(NKLogin* loginMsg))success Failure:(void(^)(NSError *error))failure;
-(void)POSTAliypayWithParameters:(id)parameters Success:(void (^) (NKAliypay *aliypay))success Failure:(void (^)(NSError *error))failure;
-(void)POSTWXPayWithParameters:(id)parameters Success:(void (^)(NKWXPay *wxpay))success Failure:(void (^)(NSError *error))failure;
-(void)POSTGetUserCouponWithParameters:(id)parameters Success:(void (^)(NSArray *couponArray))success Failure:(void(^)(NSError *error))failure;
-(void)POSTGetUserUsedCouponWithParameters:(id)parameters Success:(void (^)(NSArray *couponArray))success Failure:(void(^)(NSError *error))failure;
-(void)POSTGetUserExpireCouponWithParameters:(id)parameters Success:(void (^)(NSArray *couponArray))success Failure:(void(^)(NSError *error))failure;
-(void)POSTGetSharedCouponWithParameters:(id)parameters Success:(void (^)(NSArray *couponArray))success Failure:(void(^)(NSError *error))failure;
-(void)POSTQueryCouponWithParameters:(id)parameters Success:(void (^)(NSArray *couponArray))success Failure:(void(^)(NSError *error))failure;
#pragma mark - 上传照片
-(void)POSTUploadImagesWithParameters:(id)parameters Success:(void (^)(NKFile *file))success Failure:(void (^)(NSError *error))failure;
#pragma mark - 车辆
-(void)POSTAddCarWithParameters:(id)parameters Success:(void (^) (NKCar *car))success Failure:(void (^) (NSError *error))failure;
-(void)POSTDeleteCarWithParameters:(id)parameters Success:(void (^)(NKBase *backBase))success Failure:(void(^)(NSError *error))failure;
-(void)POSTTOCheckCarExistWithParameters:(id)parameters Success:(void (^)(NKBase *base))success Failure:(void (^)(NSError *error))failure;
-(void)POSTToCertificateCarWithParameters:(id)parameters Success:(void (^) (NKBase *base))success Failure:(void (^)(NSError *error))failure;
#pragma mark - 车辆管理
-(void)POSTGetCarExpendAndTimeWithParameters:(id)parameters Success:(void (^)(NKCarExpendAndTime *carExpendAndTime))success Failure:(void(^)(NSError *error))failure;
-(void)POSTGetCarTotalExpendAndTimeWithParameters:(id)parameters Success:(void (^)(NKCarTotalExpendAndTime *carExpendAndTime))success Failure:(void(^)(NSError *error))failure;
-(void)POSTSetDefaultCarWithParameters:(id)parameters Success:(void(^)(NKBase *base))success Failure:(void(^)(NSError *error))failure;
-(void)POSTCancelDefaultCarWithParameters:(id)parameters Success:(void(^)(NKBase *base))success Failure:(void(^)(NSError *error))failure;
-(void)POSTUpdateCarColorCardWithParameters:(id)parameters Success:(void(^)(NKBase *base))success Failure:(void(^)(NSError *error))failure;
-(void)POSTUpdateDataWithParameters:(id)parametes Success:(void (^)(NKLogin *loginMsg))success Failure:(void(^)(NSError *error))failure;
-(void)POSTGetRechargeRuleWithParameters:(id)parameters Success:(void (^)(NSArray *rechargeArray))success Failure:(void(^)(NSError *error))failure;
-(void)POSTUpdateCarBGImageWithParameters:(id)parameters Success:(void (^)(NKBase *base))success Failure:(void(^) (NSError *error))failure;
-(void)POSTGetManageCarPieDataWithParameters:(id)parameters Success:(void (^) (NKPieData *pieData))success Failure:(void(^) (NSError *error))failure;
-(void)POSTChangeCarFreeMoneyWithParameters:(id)parameters Success:(void(^)(NKBase *base))success Failure:(void(^)(NSError *error))failure;
#pragma mark - 迅停单
-(void)POSTGetOneKeyOrderBaseDataWithParameters:(id)parameters Success:(void (^)(NKSspOrderBackValue *backValue))success Failure:(void (^)(NSError *error))failure;
-(void)POSTCreateOneKeyOrderWithParameters:(id)parameters Success:(void (^)(NKSspOrderBackValue *backValue))success Failure:(void(^)(NSError *error))failure;
-(void)POSTCancelOneKeyOrderWithParameters:(id)parameters Success:(void (^)(NKSspOrderBackValue *backValue))success Failure:(void(^)(NSError *error))failure;
-(void)POSTGetOneKeyOrderNaviViewDataWithParameters:(id)parameters Success:(void (^)(NKSspOrderBackValue *backValue))success Failure:(void(^)(NSError *error))failure;
-(void)POSTCheckOneKeyOrderWithParameters:(id)parameters Success:(void (^)(NKSspOrderBackValue *backValue))success Failure:(void (^)(NSError *error))failure;
-(void)POSTContinueCreateOrderWithParameters:(id)parameters Success:(void (^)(NKSspOrderBackValue *backValue))success Failure:(void (^)(NSError *error))failure;
-(void)POSTSystemSendBerthWithParameters:(id)parameters Success:(void (^)(NKSspOrderBackValue *backValue))success Failure:(void (^)(NSError *error))failure;
-(void)POSTEndCallWithParameters:(id)parameters Success:(void (^)(NKSspOrderBackValue *backValue))success Failure:(void (^)(NSError *error))failure;
#pragma mark - 精致网络请求方法
-(void)POSTElegantSaveCarWithParameters:(id)parameters Success:(void (^)(NKSspOrderBackValue *backValue))success Failure:(void(^)(NSError *error))failure;
-(void)POSTElegantTakeCarWithParameters:(id)parameters Success:(void (^)(NKSspOrderBackValue *backValue))success Failure:(void(^)(NSError *error))failure;
-(void)POSTElegantCancelSaveCarWithParameters:(id)parameters Success:(void (^)(NKSspOrderBackValue *backValue))success Failure:(void(^)(NSError *error))failure;
-(void)POSTElegantCancelTakeCarWithParameters:(id)parameters Success:(void (^)(NKSspOrderBackValue *backValue))success Failure:(void(^)(NSError *error))failure;
-(void)POSTElegantGetBerthsWithParameters:(id)parameters Success:(void (^)(NKSspOrderBackValue *backValue))success Failure:(void(^)(NSError *error))failure;
-(void)POSTElegantGetParkingDataWithParameters:(id)parameters Success:(void (^)(NKSspOrderBackValue *backValue))success Failure:(void(^)(NSError *error))failure;
-(void)POSTElegantGetAllOrderWithParameters:(id)parameters Success:(void (^)(NKSspOrderBackValue *backValue))success Failure:(void(^)(NSError *error))failure;
#pragma mark - 新评价及投诉
-(void)POSTGetComplaintTagWithParameters:(id)parameters Success:(void (^)(NSArray *backArray))success Failure:(void(^)(NSError *error))failure;
-(void)POSTComplaintWithParameters:(id)parameters Susccess:(void (^)(int ret))success Failure:(void (^)(NSError *error))failure;
-(void)POSTGetCommentTagWithParameters:(id)parameters Success:(void (^)(NSMutableArray *surfaceEvaluateArray, NSMutableArray *talkEvaluateArray, NSMutableArray *actionEvaluateArray, NSMutableArray *roadsignEvaluateArray, NSMutableArray *hygieneEvaluateArray, NSMutableArray *senseEvaluateArray))success Failure:(void (^)(NSError *error))failure;
-(void)POSTToCommentWithParameters:(id)parameters Success:(void (^)(int ret))success Failure:(void (^)(NSError *error))failure;
-(void)POSTToGetEvaluateRecordWithParameters:(id)parameters Success:(void (^)(NKEvaluateRecord * record))success Failure:(void (^)(NSError *error))failure;
-(void)POSTToGetMEPInfomationWithParameters:(id)parameters Success:(void (^)(NKMepInfo *info))success Failure:(void (^)(NSError *error))failure;
#pragma mark - 停好
-(void)POSTToGetIsParkingRecordWithParameters:(id)parameters Success:(void (^) (NSArray *records))success Failure:(void (^)(NSError *error))failure;
//计费规则
-(void)POSTToGetParkingPriceRuleWithParameters:(id)parameters Success:(void(^) (NSString *pictureURL))success Failure:(void (^)(NSError *error))failure;
//车辆品牌
-(void)POSTToGetAllCarBrandWithParameters:(id)parameters Success:(void(^) (NKCarBrandBaseData *carBrandBaseData))success Failure:(void (^) (NSError * error))failure;
//请求广告
-(void)POSTGEtAdvertisementImageWithParameters:(id)parameters Success:(void(^)(NSArray<NSString *> *imageURLArray))success Failure:(void (^) (NSError *error))failure;
//消费账单
-(void)POSTGetBillDetailWithParameters:(id)parameters Success:(void (^) (NSArray* billDetailArray))success Failure:(void(^)(NSError *error))failure;
#pragma mark - 绑定本地账户
-(void)POSTToGetLocalPassportInfoWithParameters:(id)parameters Success:(void (^) (NKLocalPassportBaseDto * baseDto))success Failure:(void (^) (NSError *error))failure;
-(void)POSTToBindLocalPassportWithParameters:(id)parameters Success:(void (^) (NKBase *base))success Failure:(void (^) (NSError *error))failure;
-(void)POSTToRemoveBindLocalPassportWithParameters:(id)parameters Success:(void (^) (NKBase *base))success Failure:(void (^) (NSError *error))failure;
#pragma mark - 补交费用
-(void)POSTToGetRepaymentRecordWithParameters:(id)parameters Success:(void (^)(NSMutableArray *mutableArray))success Failure:(void (^)(NSError *error))failure;
-(void)POSTToGetRepaymentRecordNumberWithParameters:(id)parameters Success:(void (^) (NKBase *base))success Failure:(void (^) (NSError *error))failure;
-(void)POSTToCheckBalanceWithParameters:(id)parameters Success:(void (^) (NKBase *base))success Failure:(void (^) (NSError *error))failure;
-(void)POSTToCheckSmsCodeWithParameters:(id)parameters Success:(void (^) (NKBase *base))success Failure:(void (^) (NSError *error))failure;
-(void)POSTToRepayWithParameters:(id)parameters Success:(void (^) (NKBase *base))success Failure:(void (^) (NSError *error))failure;
#pragma mark - 校验密码
-(void)POSTToCheckPassWordWithParameters:(id)parameters Success:(void (^) (NKBase *base))success Failure:(void (^) (NSError *error))failure;

@end
