//
//  WXApiManager.h
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "NKPay.h"

@interface WXApiManager : NSObject<WXApiDelegate>

+ (instancetype)sharedManager;
+(BOOL)isWXAPPInstall;
-(void)loginWechat;
-(void)sharedToWeChat;
-(void)sharedToFriendCircle;
-(void)payWechatWithParameters:(NKPay *)wxpay;

@end
