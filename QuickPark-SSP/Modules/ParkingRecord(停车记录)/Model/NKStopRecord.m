//
//  NKStopRecord.m
//  QuickPark-SSP
//
//  Created by Nick on 16/8/24.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKStopRecord.h"

@implementation NKStopRecord

- (NSDictionary *)objectClassInArray
{
    
    return @{@"records" : [NKStopDetailRecord class]};
    
}

@end
