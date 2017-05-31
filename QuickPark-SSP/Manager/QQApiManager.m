//
//  QQApiManager.m
//  QuickPark-SSP
//
//  Created by Nick on 16/9/14.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "QQApiManager.h"

@interface QQApiManager()

@property (nonatomic, strong)TencentOAuth *tencentOAuth;
@property (nonatomic, strong)NSString *qqOpenId;

@end

@implementation QQApiManager

+(instancetype)sharedManager
{
    static dispatch_once_t token;
    static QQApiManager *instance;
    dispatch_once(&token, ^{
        instance = [[QQApiManager alloc] init];
    });
    return instance;
}
-(void)loginQQ
{
    _tencentOAuth=[[TencentOAuth alloc]initWithAppId:QQAppid andDelegate:self];
    NSArray *permissions = [NSArray arrayWithObjects:@"get_user_info",@"get_simple_userinfo",@"add_t", nil];
    [_tencentOAuth authorize:permissions inSafari:NO];
}
#pragma mark TencentSessionDelegate
//登陆完成调用
- (void)tencentDidLogin
{
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        //  获取到记录登录用户的OpenID、Token以及过期时间
        self.qqOpenId = _tencentOAuth.openId;
        [_tencentOAuth getUserInfo];
    }
    else
    {
        NSLog(@"登录不成功 没有获取accesstoken");
    }
}
//非网络错误导致登录失败：
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    NSLog(@"tencentDidNotLogin");
    if (cancelled)
    {
        NSLog(@"用户取消登录");
    }else{
        NSLog(@"登录失败");
    }
}
// 网络错误导致登录失败：
-(void)tencentDidNotNetWork
{
    NSLog(@"无网络连接，请设置网络");
}
-(void)getUserInfoResponse:(APIResponse *)response
{
    NSLog(@"获取到QQ信息");
    //可以发送网络请求给本地服务器了！！！！！！
    
    NSDictionary *dic = response.jsonResponse;
    
    NSLog(@"%@", dic);
    NSString *sex = [dic objectForKey:@"gender"];
    if ([sex isEqualToString:@"男"])
    {
        sex = @"0";
    }
    else
    {
        sex = @"1";
    }
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    [parametersDic setObject:self.qqOpenId forKey:@"TpOpenId"];
    [parametersDic setObject:@1 forKey:@"type"];
    [parametersDic setObject:sex forKey:@"sex"];
    [parametersDic setObject:[dic objectForKey:@"nickname"] forKey:@"nickName"];
    [parametersDic setObject:[dic objectForKey:@"figureurl"] forKey:@"headImgUrl"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"wechatDidLoginNotification" object:self userInfo:parametersDic];
    
}


@end
