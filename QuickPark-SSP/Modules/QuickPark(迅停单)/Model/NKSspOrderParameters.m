//
//  NKSspOrderParameters.m
//  QuickPark-SSP
//
//  Created by Nick on 2016/10/14.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKSspOrderParameters.h"

@implementation NKSspOrderParameters

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.license forKey:@"license"];
    [aCoder encodeObject:self.destination forKey:@"destination"];
    [aCoder encodeObject:self.radius forKey:@"radius"];
    [aCoder encodeInteger:self.bookingFee forKey:@"bookingFee"];
    [aCoder encodeInteger:self.tip forKey:@"tip"];
    [aCoder encodeObject:self.cuslevel forKey:@"cuslevel"];
    [aCoder encodeObject:self.sspId forKey:@"sspId"];
    [aCoder encodeInteger:self.orderType forKey:@"orderType"];
    [aCoder encodeObject:self.lng forKey:@"lng"];
    [aCoder encodeObject:self.lat forKey:@"lat"];
    [aCoder encodeObject:self.clientId forKey:@"clientId"];
    [aCoder encodeInteger:self.cusSex forKey:@"cusSex"];
    [aCoder encodeInteger:self.carChargeType forKey:@"carChargeType"];
    [aCoder encodeObject:self.cusName forKey:@"cusName"];
    [aCoder encodeObject:self.clientType forKey:@"clientType"];
    [aCoder encodeObject:self.cusMob forKey:@"cusMob"];
    [aCoder encodeObject:self.orderNo forKey:@"orderNo"];
    [aCoder encodeObject:self.cancelReason forKey:@"cancelReason"];
    [aCoder encodeInteger:self.isOvertime forKey:@"isOvertime"];
    [aCoder encodeInteger:self.cancelType forKey:@"cancelType"];
    [aCoder encodeObject:self.parkingno forKey:@"parkingno"];
    [aCoder encodeInteger:self.cartype forKey:@"cartype"];
    [aCoder encodeInteger:self.keepcartime forKey:@"keepcartime"];
    [aCoder encodeInteger:self.takecartime forKey:@"takecartime"];
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.license = [aDecoder decodeObjectForKey:@"license"];
        self.destination = [aDecoder decodeObjectForKey:@"destination"];
        self.radius = [aDecoder decodeObjectForKey:@"radius"];
        self.bookingFee = [aDecoder decodeIntegerForKey:@"bookingFee"];
        self.tip = [aDecoder decodeIntegerForKey:@"tip"];
        self.cuslevel = [aDecoder decodeObjectForKey:@"cuslevel"];
        self.sspId = [aDecoder decodeObjectForKey:@"sspId"];
        self.orderType = [aDecoder decodeIntegerForKey:@"orderType"];
        self.lng = [aDecoder decodeObjectForKey:@"lng"];
        self.lat = [aDecoder decodeObjectForKey:@"lat"];
        self.clientId = [aDecoder decodeObjectForKey:@"clientId"];
        self.cusSex = [aDecoder decodeIntegerForKey:@"cusSex"];
        self.carChargeType = [aDecoder decodeIntegerForKey:@"carChargeType"];
        self.cusName = [aDecoder decodeObjectForKey:@"cusName"];
        self.clientType = [aDecoder decodeObjectForKey:@"cusName"];
        self.cusMob = [aDecoder decodeObjectForKey:@"cusName"];
        self.orderNo = [aDecoder decodeObjectForKey:@"orderNo"];
        self.cancelReason = [aDecoder decodeObjectForKey:@"cancelReason"];
        self.isOvertime = [aDecoder decodeIntegerForKey:@"isOvertime"];
        self.cancelType = [aDecoder decodeIntegerForKey:@"cancelType"];
        self.parkingno = [aDecoder decodeObjectForKey:@"parkingno"];
        self.cartype = [aDecoder decodeIntegerForKey:@"cartype"];
        self.keepcartime = [aDecoder decodeIntegerForKey:@"keepcartime"];
        self.takecartime = [aDecoder decodeIntegerForKey:@"takecartime"];
    }
    return self;
}



@end
