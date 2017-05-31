//
//  NKCar.m
//  QuickPark-SSP
//
//  Created by Nick on 16/8/18.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKCar.h"


@implementation NKCar

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.timestamp forKey:@"timestamp"];
    [aCoder encodeInteger:self.ret forKey:@"ret"];
    [aCoder encodeObject:self.msg forKey:@"msg"];
    
    [aCoder encodeObject:self.id forKey:@"id"];
    [aCoder encodeInteger:self.auditFlag forKey:@"auditFlag"];
    [aCoder encodeInteger:self.tagBalance forKey:@"tagBalance"];
    [aCoder encodeObject:self.owner forKey:@"owner"];
    [aCoder encodeObject:self.displacement forKey:@"displacement"];
    [aCoder encodeObject:self.engine forKey:@"engine"];
    [aCoder encodeObject:self.ownerId forKey:@"ownerId"];
    [aCoder encodeInteger:self.color forKey:@"color"];
    [aCoder encodeObject:self.license forKey:@"license"];
    [aCoder encodeObject:self.icon forKey:@"icon"];
    [aCoder encodeInteger:self.paySwitch forKey:@"paySwitch"];
    [aCoder encodeObject:self.tagSn forKey:@"tagSn"];
    [aCoder encodeObject:self.carType forKey:@"carType"];
    [aCoder encodeObject:self.drivingId forKey:@"drivingId"];
    
    [aCoder encodeObject:self.appealSspId forKey:@"appealSspId"];
    [aCoder encodeObject:self.colourCard forKey:@"colourCard"];
    [aCoder encodeInteger:self.isDefaultCar forKey:@"isDefaultCar"];
    
    [aCoder encodeObject:self.carbgurl forKey:@"carbgurl"];
    [aCoder encodeObject:self.carseries forKey:@"carseries"];
    [aCoder encodeObject:self.carseriespic forKey:@"carseriespic"];
    
    [aCoder encodeInteger:self.freePwdMoneyLimit forKey:@"freePwdMoneyLimit"];
    
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.timestamp = [aDecoder decodeIntegerForKey:@"timestamp"];
        self.ret = [aDecoder decodeIntegerForKey:@"ret"];
        self.msg = [aDecoder decodeObjectForKey:@"msg"];
        
        self.id = [aDecoder decodeObjectForKey:@"id"];
        self.auditFlag = [aDecoder decodeIntegerForKey:@"auditFlag"];
        self.tagBalance = [aDecoder decodeIntegerForKey:@"tagBalance"];
        self.owner = [aDecoder decodeObjectForKey:@"owner"];
        self.displacement = [aDecoder decodeObjectForKey:@"displacement"];
        self.engine = [aDecoder decodeObjectForKey:@"engine"];
        self.ownerId = [aDecoder decodeObjectForKey:@"ownerId"];
        self.color = [aDecoder decodeIntegerForKey:@"color"];
        self.license = [aDecoder decodeObjectForKey:@"license"];
        self.icon = [aDecoder decodeObjectForKey:@"icon"];
        self.paySwitch = [aDecoder decodeIntegerForKey:@"paySwitch"];
        self.tagSn = [aDecoder decodeObjectForKey:@"tagSn"];
        self.carType = [aDecoder decodeObjectForKey:@"carType"];
        self.drivingId = [aDecoder decodeObjectForKey:@"drivingId"];
        
        self.appealSspId = [aDecoder decodeObjectForKey:@"appealSspId"];
        self.colourCard = [aDecoder decodeObjectForKey:@"colourCard"];
        self.isDefaultCar = [aDecoder decodeIntegerForKey:@"isDefaultCar"];
        
        self.carbgurl = [aDecoder decodeObjectForKey:@"carbgurl"];
        self.carseries = [aDecoder decodeObjectForKey:@"carseries"];
        self.carseriespic = [aDecoder decodeObjectForKey:@"carseriespic"];
        
        self.freePwdMoneyLimit = [aDecoder decodeIntegerForKey:@"freePwdMoneyLimit"];
    }
    return self;
}

@end
