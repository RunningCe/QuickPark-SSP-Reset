//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import "WXApiManager.h"
#import "NKDataManager.h"

#pragma mark - 用户获取设备ip地址
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <ifaddrs.h>
#import <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation WXApiManager

#pragma mark - 单例

+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}
+(BOOL)isWXAPPInstall
{
    return [WXApi isWXAppInstalled];
}
-(void)sharedToWeChat
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"迅停送好礼，注册即送30元停车优惠券";
    message.description = @"迅停；让停车更便捷";
    [message setThumbImage:[UIImage imageNamed:@"ssp"]];
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = @"http://ssp.quickpark.com.cn//qpforssp/app/share.jsp";
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}
-(void)sharedToFriendCircle
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"迅停送好礼，注册即送30元停车优惠券";
    message.description = @"迅停；让停车更便捷";
    [message setThumbImage:[UIImage imageNamed:@"ssp"]];
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = @"http://ssp.quickpark.com.cn//qpforssp/app/share.jsp";
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}
//登录接口
-(void)loginWechat
{
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"App";
    [WXApi sendReq:req];
}
#pragma mark 微信支付
//支付接口
-(void)payWechatWithParameters:(NKPay *)wxpay
{
    NKDataManager *dataManager = [NKDataManager sharedDataManager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSString *addressIP = [WXApiManager getIPAddress:YES];
    
    [parameters setObject:wxpay.body forKey:@"body"];
    [parameters setObject:[NSNumber numberWithDouble:wxpay.total_fee] forKey:@"total_fee"];
    [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"myToken"] forKey:@"token"];
    [parameters setObject:addressIP forKey:@"terminalIp"];
    [parameters setObject:[NSNumber numberWithDouble:wxpay.amount] forKey:@"amount"];
    NSLog(@"%@", parameters);
    
    [dataManager POSTWXPayWithParameters:parameters Success:^(NKWXPay *wxpay) {
        if ([wxpay.msg isEqualToString:@"success wx pay!"])
        {
            PayReq *request = [[PayReq alloc] init];
            request.openID = wxpay.appid;
            request.partnerId = wxpay.partnerid;
            request.prepayId = wxpay.prepayid;
            request.package = @"Sign=WXPay";
            request.nonceStr = wxpay.noncestr;
            
            //FUCK!!!!!!!!
            UInt32 timeSta = wxpay.timestamp.intValue;
            request.timeStamp = timeSta;
            
            request.sign = wxpay.sign;
            
            NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",request.openID,request.partnerId,request.prepayId,request.nonceStr,(long)request.timeStamp,request.package,request.sign );
            
            [WXApi sendReq:request];
        }
    } Failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
}
#pragma mark - 获取设备ip地址
//获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ /*IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,*/ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ /*IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4,*/ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [WXApiManager getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}
//获取所有相关IP信息
+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

#pragma mark - 微信登录
- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[SendAuthResp class]]) //判断是否为授权请求，否则与微信支付等功能发生冲突
    {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0)
        {
            NSLog(@"code %@",aresp.code);
            [self wechatDidLoginWithCode:aresp.code];
        }
    }
    else if([resp isKindOfClass:[PayResp class]])
    {
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg;
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                //支付成功发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WeChatPaySuccess" object:nil userInfo:nil];
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
    else
    {
        //分享回调
        if (resp.errCode == WXSuccess)
        {
            //分享成功
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WeChatSharedSuccess" object:nil userInfo:nil];
        }
        else
        {
            //分享失败
            NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
        }
    }
}
- (void)wechatDidLoginWithCode:(NSString *)code
{
    NSLog(@"%@", code);
    [self getWechatAccessTokenWithCode:code];
}
- (void)getWechatAccessTokenWithCode:(NSString *)code
{
    NSString *url =[NSString stringWithFormat:
                    @"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",
                    WX_APPID,WX_APPSecret,code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"%@",dic);
                NSString *accessToken = dic[@"access_token"];
                NSString *openId = dic[@"openid"];
                
                [self getWechatUserInfoWithAccessToken:accessToken openId:openId];
            }
        });
    });
}
- (void)getWechatUserInfoWithAccessToken:(NSString *)accessToken openId:(NSString *)openId
{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data)
            {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",dic);
                
                NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
                [parametersDic setObject:openId forKey:@"TpOpenId"];
                [parametersDic setObject:@0 forKey:@"type"];
                [parametersDic setObject:[dic objectForKey:@"sex"] forKey:@"sex"];
                [parametersDic setObject:[dic objectForKey:@"nickname"] forKey:@"nickName"];
                [parametersDic setObject:[dic objectForKey:@"headimgurl"] forKey:@"headImgUrl"];
                
                NSLog(@"%@", parametersDic);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"wechatDidLoginNotification" object:self userInfo:parametersDic];
                //****************************//
            }
        });
        
    });
}
// 这个方法是用于从微信返回第三方App
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}


@end
