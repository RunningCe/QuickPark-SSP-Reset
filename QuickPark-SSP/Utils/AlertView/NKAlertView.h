//
//  NKAlertView.h
//  PopAlertView_test
//
//  Created by Jack on 16/8/28.
//  Copyright © 2016年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NKComplainTopView, NKEvaluateView, ChargeDetailSubView, NKLatestParkingView;

@interface NKAlertView : UIView

typedef enum{
    NKAlertViewTypeCarCertificate,//车辆认证弹出框
    NKAlertViewTypeSetPayPassword,//设置密码弹出框
    NKAlertViewTypeRealNameCertificate,//实名认证弹出框
    NKAlertViewTypePassword,//输入密码弹出框
    NKAlertViewTypeInfomation,//提示信息
    NKAlertViewTypeNewUserCoupon,//新用户优惠券
    NKAlertViewTypeSharedCouponSuccess,
    NKAlertViewTypeSharedToWeChat,//分享到微信 yes
    NKAlertViewTypeFailedToCallCar,//呼叫结束，没有呼叫到车位
    NKAlertViewTypeCancelCallingCar,//取消呼叫
    NKAlertViewTypeCancelOrder,//取消订单
    NKAlertViewTypeFailedToReserveBerth,//预留车位失败
    NKAlertViewTypeSuccessToPark,//停车成功
    NKAlertViewTypeOrderTimeOut,//订单超时
    NKAlertViewTypeHappyParkingBerthAppointment,//伯乐车位预定
    NKAlertViewTypeParkingRule,//计价规则 yes
    NKAlertViewTypeEvaluatDetailRecord,//评价详情 yes
    NKPopViewTypeParkingRuleAndChargeDetail,//计价规则及收费详情 yes
    NKPopViewTypeLatestParking,//最近泊车 yes
    NKAlertViewTypeBindSuccess,//绑定本地通成功 yes
    NKAlertViewTypeRemoveBind,//解除绑定 yes
    NKAlertViewTypeBalanceNotEnough,//余额不足 yes 
} NKAlertViewType;

@property (nonatomic, strong)UIView *bGView;
@property (nonatomic, strong)UILabel *titleLabel;
//输入密码开放参数
@property (nonatomic, strong)NSMutableArray *passwordTextFieldArray;
@property (nonatomic, strong)UIButton *passwordSureButton;
@property (nonatomic, strong)UIButton *forgetPasswordButton;
//设置密码开放参数
@property (nonatomic, strong)NSMutableArray *setPasswordTextFieldArray;
@property (nonatomic, strong)NSMutableArray *resetPasswordTExtFieldArray;
@property (nonatomic, strong)UIButton *setPasswordSureButton;
//车辆认证
@property (nonatomic, strong)UIButton *certificateCarButton;
@property (nonatomic, strong)UIButton *deleteCarButton;

//优惠券参数
@property (nonatomic, strong)UIButton *sharedCouponButton;
@property (nonatomic, strong)UIButton *chargeCouponButton;
@property (nonatomic, strong)UILabel *UserNewRegisterCouponMoneyLabel;

//分享参数
@property (nonatomic, strong)UIButton *sharedToWeChatButton;
@property (nonatomic, strong)UIButton *sharedToFriendCircleButton;
@property (nonatomic, strong)UILabel *sharedCouponMoneyLabel;

//通用参数
@property (nonatomic, strong)UIButton *sureButton;
@property (nonatomic, strong)UIButton *cancelButton;
@property (nonatomic, strong)UILabel *titleLable;

//迅停单参数 停车扣除费用
@property (nonatomic, strong)UILabel *deductLabel;
//应急状态
@property (nonatomic, strong)UIButton *continueCreateOrderButton;
//@property (nonatomic, strong)UIButton *systemSendOrderButton;
@property (nonatomic, strong)UIButton *endCallButton;

//收费详情弹窗
@property (nonatomic, strong)ChargeDetailSubView *chargeDetailSubView;
@property (nonatomic, strong)UIScrollView *chargeAndRuleScrollView;
@property (nonatomic, strong)UIPageControl *pageControl;
//计价规则图片
@property (nonatomic, strong)UIImageView *parkingPriceRuleImageView;

//评价详情弹窗
@property (nonatomic, strong)NKEvaluateView *firstEvaluatView;
@property (nonatomic, strong)NKEvaluateView *secondEvaluatView;

//最近泊车弹窗
@property (nonatomic, strong)NKLatestParkingView *latestParkingView;

//绑定本地账户弹窗
@property (nonatomic, strong)UILabel *bindPassportLabel;
@property (nonatomic, strong)UILabel *bindPassportDetailLabel;
@property (nonatomic, assign)UIButton *removeBindSureButton;

//补交弹窗
@property (nonatomic, strong)UIButton *rechargeButton;

- (instancetype)initWithAlertViewType:(NKAlertViewType)type;
- (instancetype)initWithAlertViewType:(NKAlertViewType)type Height:(CGFloat)height andWidth:(CGFloat)width;
- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;

@end
