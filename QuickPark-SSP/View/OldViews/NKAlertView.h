//
//  NKAlertView.h
//  PopAlertView_test
//
//  Created by Jack on 16/8/28.
//  Copyright © 2016年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKAlertView : UIView

typedef enum{
    NKAlertViewTypeCarCertificate,//车辆认证弹出框
    NKAlertViewTypeSetPayPassword,//设置密码弹出框
    NKAlertViewTypeRealNameCertificate,//实名认证弹出框
    NKAlertViewTypePassword,//输入密码弹出框
    NKAlertViewTypeInfomation,//提示信息
    NKAlertViewTypeNewUserCoupon,//新用户优惠券
    NKAlertViewTypeSharedCouponSuccess,
    NKAlertViewTypeSharedToWeChat,//分享到微信
    NKAlertViewType2DCode,//二维码
    NKAlertViewTypeFailedToCallCar,//呼叫结束，没有呼叫到车位
    NKAlertViewTypeCancelCallingCar,//取消呼叫
    NKAlertViewTypeCancelOrder,//取消订单
    NKAlertViewTypeFailedToReserveBerth,//预留车位失败
    NKAlertViewTypeSuccessToPark,//停车成功
    NKAlertViewTypeOrderTimeOut,//订单超时
    NKAlertViewTypeHappyParkingBerthAppointment//伯乐车位预定
} NKAlertViewType;

@property(nonatomic, strong)UIView *bGView;
@property(nonatomic, strong)UIButton *bGButton;
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

//二维码参数
@property (nonatomic, strong)UIButton *twoDCodeButton;
@property (nonatomic, strong)UIImageView *twoDCodeImageView;

//通用参数
@property (nonatomic, strong)UIButton *sureButton;
@property (nonatomic, strong)UIButton *cancelButton;
@property (nonatomic, strong)UILabel *titleLable;

//迅停单参数 停车扣除费用
@property (nonatomic, strong)UILabel *deductLabel;
//应急状态
@property (nonatomic, strong)UIButton *continueCreateOrderButton;
@property (nonatomic, strong)UIButton *systemSendOrderButton;
@property (nonatomic, strong)UIButton *endCallButton;



- (instancetype)initWithAlertViewType:(NKAlertViewType)type;
+ (NKAlertView *)sharedAlertViewByType:(NKAlertViewType)type;
- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;

@end
