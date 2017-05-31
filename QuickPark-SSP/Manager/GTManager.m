 //
//  GTManager.m
//  QuickPark-SSP
//
//  Created by Nick on 16/9/29.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "GTManager.h"

@interface GTManager() 

@end

@implementation GTManager

+(instancetype)sharedManager
{
    static dispatch_once_t token;
    static GTManager *instance;
    dispatch_once(&token, ^{
        instance = [[GTManager alloc] init];
    });
    return instance;
}

#pragma mark - GeTuiSdkDelegate

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    NSLog(@"\n>>[GTSdk RegisterClient]:%@\n\n", clientId);
    //保存clientID
    [[NSUserDefaults standardUserDefaults] setObject:clientId forKey:@"clientId"];
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>[GTSdk error]:%@\n\n", [error localizedDescription]);
}

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    // [ GTSdk ]：汇报个推自定义事件(反馈透传消息)
    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
    
    // 数据转换
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
        
    }
    if ([payloadMsg hasSuffix:@"1002"]){
        //车辆停好了
        [[NSNotificationCenter defaultCenter]postNotificationName:@"parkingSuccess" object:nil userInfo:@{@"payloadMsg":payloadMsg}];
    }
    //if ([payloadMsg hasSuffix:@"1001"])
    if (![payloadMsg hasSuffix:@"1002"] && ![payloadMsg hasSuffix:@"1003"]){
        //收到mep抢单消息
        [[NSNotificationCenter defaultCenter]postNotificationName:@"orderCreateSuccess" object:nil userInfo:@{@"payloadMsg":payloadMsg}];
    }
    if ([payloadMsg hasSuffix:@"1003"]){
        //车位预留失败，进入应急
        [[NSNotificationCenter defaultCenter]postNotificationName:@"berthReservedFaild" object:nil userInfo:@{@"payloadMsg":payloadMsg}];
    }

}

/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // 发送上行消息结果反馈
    NSString *msg = [NSString stringWithFormat:@"sendmessage=%@,result=%d", messageId, result];
    NSLog(@"\n>>[GTSdk DidSendMessage]:%@\n\n", msg);
}

/** SDK运行状态通知 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // 通知SDK运行状态
    NSLog(@"\n>>[GTSdk SdkState]:%u\n\n", aStatus);
}

/** SDK设置推送模式回调 */
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    if (error) {
        NSLog(@"\n>>[GTSdk SetModeOff Error]:%@\n\n", [error localizedDescription]);
        return;
    }
    
    NSLog(@"\n>>[GTSdk SetModeOff]:%@\n\n", isModeOff ? @"开启" : @"关闭");
}

@end
