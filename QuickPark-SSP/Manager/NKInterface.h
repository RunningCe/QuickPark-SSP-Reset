//
//  NKInterface.h
//  QuickPark-SSP
//
//  Created by Nick on 2017/5/16.
//  Copyright © 2017年 Nick. All rights reserved.
//

#ifndef NKInterface_h
#define NKInterface_h


//线上 HTTP
//#define SERVER_BASE_ADDRESS @"http://ssp.quickpark.com.cn/qpforssp/mobileApi/"
//#define SERVER_BASIC_ADDRESS @"http://ssp.quickpark.com.cn/qpforssp/"
//线上 HTTPS
#define SERVER_BASE_ADDRESS @"https://ssp.quickpark.com.cn/qpforssp/mobileApi/"
#define SERVER_BASIC_ADDRESS @"https://ssp.quickpark.com.cn/qpforssp/"
//雨刷
//#define SERVER_BASE_ADDRESS @"http://192.168.0.164:8084/qpforssp/mobileApi/"
//#define SERVER_BASIC_ADDRESS @"http://192.168.0.164:8084/qpforssp/"
//排气管
//#define SERVER_BASE_ADDRESS @"http://192.168.0.159:8084/qpforssp/mobileApi/"
//#define SERVER_BASIC_ADDRESS @"http://192.168.0.159:8084/qpforssp/"
//测试服
//#define SERVER_BASE_ADDRESS @"http://120.76.154.100:8050/qpforssp/mobileApi/"
//#define SERVER_BASIC_ADDRESS @"http://120.76.154.100:8050/qpforssp/"

/*******************用户中心旧接口************************/
////请求验证码的地址
//#define POST_MASK_URLSTRING @""SERVER_BASE_ADDRESS@"getSmsValidateCode.do"
////请求登录地址
//#define POST_LOGIN_URLSTRING @""SERVER_BASE_ADDRESS@"login.do"
////第三方登录接口
//#define POST_TPLOGIN_URLSTRING @""SERVER_BASE_ADDRESS@"tpLogin.do"
////第三方登录时绑定手机号接口
//#define POST_TPBINDLOGIN_URLSTRING @""SERVER_BASE_ADDRESS@"tpBindLogin.do"
////修改个人信息
//#define POST_UPDATEMYINFO_URLSTRING @""SERVER_BASE_ADDRESS@"updateMyInfo.do"
////刷新数据接口
//#define POST_UPDATEDATA_URLSTRING @""SERVER_BASE_ADDRESS@"flushDataByToken.do"
/*******************用户中心新接口************************/
//请求验证码的地址
#define POST_MASK_URLSTRING @""SERVER_BASIC_ADDRESS@"userinfo/getSmsValidateCode"
//请求登录地址
#define POST_LOGIN_URLSTRING @""SERVER_BASIC_ADDRESS@"userinfo/login"
//第三方登录接口
#define POST_TPLOGIN_URLSTRING @""SERVER_BASIC_ADDRESS@"userinfo/tpLogin"
//第三方登录时绑定手机号接口
#define POST_TPBINDLOGIN_URLSTRING @""SERVER_BASIC_ADDRESS@"userinfo/tpBindLogin"
//修改个人信息
#define POST_UPDATEMYINFO_URLSTRING @""SERVER_BASIC_ADDRESS@"userinfo/updateMyInfo"
//刷新数据接口
#define POST_UPDATEDATA_URLSTRING @""SERVER_BASIC_ADDRESS@"userinfo/flushDataByToken"
/******************************************************/
//用户中心验证码接口
#define POST_USERCENTER_MASK_URLSTRING @""SERVER_BASIC_ADDRESS@"userinfo/getSmsValidateCode"
//上传文件,照片
#define POST_UPLOADFILE_URLSTRING @"https://fileserver.quickpark.com.cn/getimg/img/uploadFile.do"
//实名认证
#define POST_REALNAME_CERTIFACATION_URLSTRING @""SERVER_BASE_ADDRESS@"realnameCertification.do"
//消息中心
#define POST_MESSAGECENTER_URLSTRING @""SERVER_BASE_ADDRESS@"getMessagePushRecord.do"
//请求账单
#define POST_USERPARKINGBILL_URLSTRING @""SERVER_BASE_ADDRESS@"queryUserParkingBill.do"
//查询用户
#define POST_TRANSFERUSER_URLSTRING @""SERVER_BASE_ADDRESS@"queryTransferUser.do"
//转账
#define POST_CONFIRMTRANSFER_URLSTRING @""SERVER_BASE_ADDRESS@"confirmTransfer.do"
//查询支付密码
#define POST_QUERYUSERPAYPASSWORD_URLSTRING @""SERVER_BASE_ADDRESS@"queryUserPayPassword.do"
//重置支付密码
#define POST_UPDATEUSERPAYPASSWORD_URLSTRING @""SERVER_BASE_ADDRESS@"updateUserPayPassword.do"
//充值
#define POST_RECHARGE_URLSTRING @""SERVER_BASE_ADDRESS@"orderNumberReq.do"
//请求最近转账
#define POST_QUERYTRANSFERRECORD_URLSTRING @""SERVER_BASE_ADDRESS@"queryTransferRecord.do"
//支付宝支付
#define POST_ALIYPAY_URLSTRING @""SERVER_BASE_ADDRESS@"sspalisign.do"
//微信支付
#define POST_WXPAY_URLSTRING @""SERVER_BASE_ADDRESS@"sspwxprepareorder.do"

//优惠券接口,查询未使用的优惠券
#define POST_GETSSPCOUPON_URLSTRING @""SERVER_BASIC_ADDRESS@"coupon/getSspCouponBySspId"
//查询过期的优惠券
#define POST_GETSSPEXPIRECOUPON_URLSTRING @""SERVER_BASIC_ADDRESS@"coupon/getsspexpirecouponbysspid"
//查询使用过的优惠券
#define POST_GETSSPUSEDCOUPON_URLSTRING @""SERVER_BASIC_ADDRESS@"coupon/getsspusedcouponbysspid"
//根据发送类型查询优惠券
#define POST_QUERYCOUPONBYTYPE_URLSTRING @""SERVER_BASIC_ADDRESS@"coupon/queryCouponBySendType"
//分享获取优惠券
#define POST_SHAREGETCOUPON_URLSTRING @""SERVER_BASIC_ADDRESS@"coupon/shareGetCoupon"

//添加车辆
#define POST_ADDCAR_URLSTRING @""SERVER_BASE_ADDRESS@"myCarModify.do"
//删除车辆
#define POST_DELETECAR_URLSTRING @""SERVER_BASE_ADDRESS@"deleteCar.do"
//获取车辆时长，金额
#define POST_GETCAREXPENDANDTIME_URLSTRING @""SERVER_BASIC_ADDRESS@"carinfo/querycarexpendandtime"
//获取所有车辆时长，金额
#define POST_GETCARTOTALEXPENDANDTIME_URLSTRING @""SERVER_BASIC_ADDRESS@"carinfo/getCarCountInfo"
//设置默认车辆
#define POST_SETDEFALTCAR_URLSTRING @""SERVER_BASIC_ADDRESS@"carinfo/setupdefaultcar"
//取消设置用户默认车辆
#define POST_CANCELDEFALTCAR_URLSTRING @""SERVER_BASIC_ADDRESS@"carinfo/canceldefaultcar"
//更新车辆色卡
#define POST_UPDATECARCOLORCARD_URLSTRING @""SERVER_BASIC_ADDRESS@"carinfo/updatecarcolorcard"
//请求充值规则
#define POST_GETRECHARGERULE_URLSTRING @""SERVER_BASIC_ADDRESS@"rechargedonate"
//设置车辆背景图
#define POST_UPDATECARBGIMAGEVIEW_URLSTRING @""SERVER_BASIC_ADDRESS@"carinfo/updatecarbgpicture"
//查询车辆是否已存在
#define POST_CHECKCAREXIST_URLSTRING @""SERVER_BASIC_ADDRESS@"carinfo/queryAuditCarByLic"
//认证车辆
#define POST_CERTIFICATECAR_URLSTRING @""SERVER_BASIC_ADDRESS@"carinfo/identifycar"
//自动扣款
#define POST_CARPAYSWITCH_URLSTRING @""SERVER_BASE_ADDRESS@"myCarPaySwitch.do"
//调节自动扣款金额
#define POST_CHANGECARFREEMONEY_URLSTRING @""SERVER_BASIC_ADDRESS@"carinfo/saveOrUpdateCarFreePwdMoney"

//迅停单下单
#define POST_CREATE_ONEKEYORDER_URLSTRING @""SERVER_BASIC_ADDRESS@"parkingorder/createorder"
//取消订单
#define POST_CANCEL_ONEKEYORDER_URLSTRING @""SERVER_BASIC_ADDRESS@"parkingorder/cancelorder"
//获取导航界面信息
#define POST_GETNAVIVIEWDATA_ONEKEYORDER_URLSTRING @""SERVER_BASIC_ADDRESS@"parkingorder/ordercallback"
//检查是否有未完成订单
#define POST_CHECK_ONEKEYORDER_URLSTRING @""SERVER_BASIC_ADDRESS@"parkingorder/determineuseroder"
//获取迅停单基本配置信息
#define POST_GETBASEDATA_ONEKEYORDER_URLSTRING @""SERVER_BASIC_ADDRESS@"parkingorder/querybasicprice"
//应急处理-继续呼叫
#define POST_CONTINUECREATE_ONEKEYORDER_URLSTRING @""SERVER_BASIC_ADDRESS@"parkingorder/continuecallparking"
//应急处理-系统指派车位
#define POST_SYSTEMSENDBERTH_ONEKEYORDER_URLSTRING @""SERVER_BASIC_ADDRESS@"parkingorder/autosendparking"
//应急处理-结束呼叫
#define POST_ENDCALL_ONEKEYORDER_URLSTRING @""SERVER_BASIC_ADDRESS@"parkingorder/endcallparking"

//精致
//预约存车
#define POST_ELEGANT_SAVECAR_URLSTRING @""SERVER_BASIC_ADDRESS@"elegantorder/elegantsave"
//预约取车
#define POST_ELEGANT_TAKECAR_URLSTRING @""SERVER_BASIC_ADDRESS@"elegantorder/elegantpickup"
//取消存车
#define POST_ELEGANT_CANCELSAVECAR_URLSTRING @""SERVER_BASIC_ADDRESS@"elegantorder/cancelelegantsave"
//取消取车
#define POST_ELEGANT_CANCELTAKECAR_URLSTRING @""SERVER_BASIC_ADDRESS@"elegantorder/cancelelegantpickup"
//查询订单
#define POST_ELEGANT_GETALLORDER_URLSTRING @""SERVER_BASIC_ADDRESS@"elegantorder/allorder"
//查询车场数据
#define POST_ELEGANT_GETPARKINGDATA_URLSTRING @""SERVER_BASIC_ADDRESS@"elegantorder/queryelegantparking"
//查询车位实时状态
#define POST_ELEGANT_GETBERTHSTATUS_URLSTRING @""SERVER_NEWBASE_ADDRESS@"mobileforssp_parkingrealstatus.action"
//查询车位实时状态
#define POST_ELEGANT_GETCURRENTBERTH_URLSTRING @""SERVER_NEWBASE_ADDRESS@"mobileforssp_parkingrealstatus.action"

//停车记录及评价
//请求停车记录
#define POST_STOPRECORD_URLSTRING @""SERVER_BASIC_ADDRESS@"mepconnect/getstoprecord"
//请求停车记录，按月份
#define POST_STOPRECORD_MONTH_URLSTRING @""SERVER_BASIC_ADDRESS@"mepconnect/getstoprecordbymonth"
//获取最近一次的停车记录
#define POST_STOPRECORD_LATEST_URLSTRING @""SERVER_BASIC_ADDRESS@"mobileApi/queryLastParkRecord.do"
//请求评价标签
#define POST_COMMENT_URLSTRING @""SERVER_BASIC_ADDRESS@"ipspconnect/querystarevalinfolist"
//提交评价
#define POST_COMMENTUPLOAD_URLSTRING @""SERVER_BASIC_ADDRESS@"ipspconnect/evaluateaddorupdate"
//获取投诉标签
#define POST_GETCOMPLAINTTAG_URLSTRING @""SERVER_BASIC_ADDRESS@"ipspconnect/querystarcompinfolist"
//投诉
#define POST_COMPLAINT_URLSTRING @""SERVER_BASIC_ADDRESS@"ipspconnect/complaintaddorupdate"
//获取单条评价详情
#define POST_GETONEDETAILEVALUATE_URLSTRING @""SERVER_BASIC_ADDRESS@"ipspconnect/getEvaluateDetailInfo"
//获取收费员信息
#define POST_GETMEPINFO_URLSTRING @""SERVER_BASIC_ADDRESS@"evaluatesystem/querytollmaninfo"

//停好
//正在停车的停车记录
#define POST_ISPARKINGRECORD_URLSTRING @""SERVER_BASE_ADDRESS@"queryIngBerthByLicense.do"
//获取收费规则
#define POST_GETPARKINGRULE_URLSTRING @""SERVER_BASE_ADDRESS@"getPriceRuleByParkingNo.do"
//请求广告图片列表
#define POST_GETADVERTISEMENTIMG_URLSTRING @""SERVER_BASE_ADDRESS@"getAdverImgUrl"
//请求车辆品牌列表
#define POST_GETALLCARBRANDLIST_URLSTRING @""SERVER_BASIC_ADDRESS@"carinfo/queryCarBrandType"
//车辆管理获取饼图数据
#define POST_GETMANAGECARPIEDATA_URLSTRING @""SERVER_BASIC_ADDRESS@"vehicleanalyze/parkedanalyzedata"
//获取消费账单列表
#define POST_GETBILLDETAIL_URLSTRING @""SERVER_BASIC_ADDRESS@"mobileApi/getBillDetail"

//本地账户
//查询本地用户信息
#define POST_GETLOCALPASSPORTINFO_URLSTRING @""SERVER_BASIC_ADDRESS@"userLocal/queryUserLocalInfo"
//绑定本地账户
#define POST_BINDLOCALPASSPORT_URLSTRING @""SERVER_BASIC_ADDRESS@"userLocal/bindUserLocalInfo"
//取消绑定本地账户
#define POST_CANCELBINDLOCALPASSPORT_URLSTRING @""SERVER_BASIC_ADDRESS@"userLocal/cancelBindLocalAccount"

//补交费用
//获取欠费记录数量
#define POST_GETREPAYMENTRECORDNUMBER_URLSTRING @""SERVER_BASIC_ADDRESS@"/userinfo/getEscapeRecordCountBysspId"
//查询欠费记录
#define POST_GETREPAYMENTRECORD_URLSTRING @""SERVER_BASIC_ADDRESS@"mepconnect/queryOweStopRecord"
//查询账户余额
#define POST_CHECKBALANCE_URLSTRING @""SERVER_BASIC_ADDRESS@"userinfo/querySspBalance"
//验证码校验
#define POST_CHECKSMSCODE_URLSTRING @""SERVER_BASIC_ADDRESS@"userinfo/validateSmsCode"
//缴费
#define POST_REPAY_URLSTRING @""SERVER_BASIC_ADDRESS@"userinfo/sspAfterPay"
//校验密码
#define POST_CHECKPASSWORD_URLSTRING @""SERVER_BASIC_ADDRESS@"userinfo/validatePayPwd"


#endif /* NKInterface_h */
