//
//  NKBerth.m
//  QuickPark-SSP
//
//  Created by Nick on 16/8/18.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKBerth.h"


@implementation NKBerth

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.id forKey:@"id"];
    [aCoder encodeObject:self.parkingId forKey:@"parkingId"];
    [aCoder encodeObject:self.msg forKey:@"msg"];
    [aCoder encodeInteger:self.timestamp forKey:@"timestamp"];
    [aCoder encodeInteger:self.berthType forKey:@"berthType"];
    [aCoder encodeObject:self.berthSN forKey:@"berthSN"];
    [aCoder encodeInteger:self.ret forKey:@"ret"];
    [aCoder encodeObject:self.parkingNo forKey:@"parkingNo"];
    [aCoder encodeObject:self.berthStand forKey:@"berthStand"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeInteger:self.isSpecifyEntrance forKey:@"isSpecifyEntrance"];
    [aCoder encodeObject:self.endTime forKey:@"endTime"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.startTime forKey:@"startTime"];
    [aCoder encodeInteger:self.status forKey:@"status"];
    [aCoder encodeObject:self.berthName forKey:@"berthName"];
    
    
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.id = [aDecoder decodeIntegerForKey:@"id"];
        self.parkingId = [aDecoder decodeObjectForKey:@"parkingId"];
        self.msg = [aDecoder decodeObjectForKey:@"msg"];
        self.timestamp = [aDecoder decodeIntegerForKey:@"timestamp"];
        self.berthType = [aDecoder decodeIntegerForKey:@"berthType"];
        self.berthSN = [aDecoder decodeObjectForKey:@"berthSN"];
        self.ret = [aDecoder decodeIntegerForKey:@"ret"];
        self.parkingNo = [aDecoder decodeObjectForKey:@"parkingNo"];
        self.berthStand = [aDecoder decodeObjectForKey:@"berthStand"];
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.isSpecifyEntrance = [aDecoder decodeIntegerForKey:@"isSpecifyEntrance"];
        self.endTime = [aDecoder decodeObjectForKey:@"endTime"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.startTime = [aDecoder decodeObjectForKey:@"startTime"];
        self.status = [aDecoder decodeIntegerForKey:@"status"];
        self.berthName = [aDecoder decodeObjectForKey:@"berthName"];
        
        
    }
    return self;
}


@end
