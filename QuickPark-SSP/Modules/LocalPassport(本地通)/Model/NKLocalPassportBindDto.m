//
//  NKLocalPassportBindDto.m
//  QuickPark-SSP
//
//  Created by Nick on 2017/5/5.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "NKLocalPassportBindDto.h"

@implementation NKLocalPassportBindDto

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    // 实现这个方法的目的：告诉MJExtension框架模型中的属性名对应着字典的哪个key
    return @{
             @"keyId" : @"id",
             @"qpUserId" : @"pqUserId"
             };
}

@end
