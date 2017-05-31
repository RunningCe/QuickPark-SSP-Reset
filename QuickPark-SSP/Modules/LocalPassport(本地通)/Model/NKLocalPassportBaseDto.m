//
//  NKLocalPassportBaseDto.m
//  QuickPark-SSP
//
//  Created by Nick on 2017/5/5.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "NKLocalPassportBaseDto.h"

@implementation NKLocalPassportBaseDto

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"unbindCity" : @"NKLocalPassportUnbindDto",
             @"alreadyBindCity" : @"NKLocalPassportBindDto"
             };
}

@end
