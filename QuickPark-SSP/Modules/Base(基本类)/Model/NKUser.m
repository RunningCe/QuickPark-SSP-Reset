//
//  NKUser.m
//  QuickPark-SSP
//
//  Created by Nick on 16/8/18.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKUser.h"
#import "NKCar.h"
#import "NKBerth.h"

@interface NKUser()

@end

@implementation NKUser

#pragma mark setter&&getter
-(NSMutableArray *)cars
{
    if (!_cars)
    {
        _cars = [NSMutableArray array];
    }
    return _cars;
}
-(NSMutableArray *)berths
{
    if (!_berths)
    {
        _berths = [NSMutableArray array];
    }
    return _berths;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.rejectExplain forKey:@"rejectExplain"];
    [aCoder encodeInteger:self.realNameStatus forKey:@"realNameStatus"];
    [aCoder encodeInteger:self.accountStatus forKey:@"accountStatus"];
    [aCoder encodeInteger:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.birthDate forKey:@"birthDate"];
    [aCoder encodeObject:self.realName forKey:@"realName"];
    [aCoder encodeObject:self.realNameNoPassReject forKey:@"realNameNoPassReject"];
    [aCoder encodeObject:self.auditStatus forKey:@"auditStatus"];
    [aCoder encodeObject:self.cityLatiude forKey:@"cityLatiude"];
    [aCoder encodeObject:self.cityLongitude forKey:@"cityLongitude"];
    [aCoder encodeObject:self.cars forKey:@"cars"];
    [aCoder encodeObject:self.userType forKey:@"userType"];
    [aCoder encodeInteger:self.balance forKey:@"balance"];
    [aCoder encodeObject:self.berths forKey:@"berths"];
    [aCoder encodeObject:self.idCard forKey:@"idCard"];
    [aCoder encodeObject:self.id forKey:@"id"];
    [aCoder encodeObject:self.idCardPic forKey:@"idCardPic"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.membership forKey:@"membership"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeInteger:self.points forKey:@"points"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.niName forKey:@"niName"];
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.loginName forKey:@"loginName"];
    [aCoder encodeObject:self.experience forKey:@"experience"];
    [aCoder encodeObject:self.cityName forKey:@"cityName"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.signature forKey:@"signatrue"];
    
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        
        self.rejectExplain = [aDecoder decodeObjectForKey:@"rejectExplain"];
        self.realNameStatus = [aDecoder decodeIntegerForKey:@"realNameStatus"];
        self.accountStatus = [aDecoder decodeIntegerForKey:@"accountStatus"];
        self.sex = [aDecoder decodeIntegerForKey:@"sex"];
        self.birthDate = [aDecoder decodeObjectForKey:@"birthDate"];
        self.realName = [aDecoder decodeObjectForKey:@"realName"];
        self.realNameNoPassReject = [aDecoder decodeObjectForKey:@"realNameNoPassReject"];
        self.auditStatus = [aDecoder decodeObjectForKey:@"auditStatus"];
        self.cityLatiude = [aDecoder decodeObjectForKey:@"cityLatiude"];
        self.cityLongitude = [aDecoder decodeObjectForKey:@"cityLongitude"];
        self.cars = [aDecoder decodeObjectForKey:@"cars"];
        self.userType = [aDecoder decodeObjectForKey:@"userType"];
        self.balance = [aDecoder decodeIntegerForKey:@"balance"];
        self.berths = [aDecoder decodeObjectForKey:@"berths"];
        self.idCard = [aDecoder decodeObjectForKey:@"idCard"];
        self.id = [aDecoder decodeObjectForKey:@"id"];
        self.idCardPic = [aDecoder decodeObjectForKey:@"idCardPic"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.membership = [aDecoder decodeObjectForKey:@"membership"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.points = [aDecoder decodeIntegerForKey:@"points"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.niName = [aDecoder decodeObjectForKey:@"niName"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.loginName = [aDecoder decodeObjectForKey:@"loginName"];
        self.experience = [aDecoder decodeObjectForKey:@"experience"];
        self.cityName = [aDecoder decodeObjectForKey:@"cityName"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.signature = [aDecoder decodeObjectForKey:@"signature"];
    }
    return self;
}

@end
