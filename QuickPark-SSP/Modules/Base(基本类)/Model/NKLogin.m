//
//  NKLogin.m
//  QuickPark-SSP
//
//  Created by Nick on 16/8/22.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKLogin.h"

@implementation NKLogin

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.ret forKey:@"ret"];
    [aCoder encodeInteger:self.timestamp forKey:@"timestamp"];
    [aCoder encodeObject:self.msg forKey:@"msg"];
    [aCoder encodeObject:self.user forKey:@"user"];
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.ret = [aDecoder decodeIntegerForKey:@"ret"];
        self.timestamp = [aDecoder decodeIntegerForKey:@"timestamp"];
        self.msg = [aDecoder decodeObjectForKey:@"msg"];
        self.user = [aDecoder decodeObjectForKey:@"user"];
    }
    return self;
}
@end
