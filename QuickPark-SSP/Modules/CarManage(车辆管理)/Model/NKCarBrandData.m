//
//  NKCarBrandData.m
//  QuickPark-SSP
//
//  Created by Nick on 2016/12/30.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKCarBrandData.h"
#import "MJExtension.h"
#import "NKCarBrandTypeData.h"

@implementation NKCarBrandData

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"btiList" : [NKCarBrandTypeData class]};
}

+ (NSDictionary *)replacedKeyFromPropertyName{
    
    return @{@"brand_id" : @"id"};
    
}
@end
