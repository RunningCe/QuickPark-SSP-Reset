//
//  NKColorManager.m
//  QuickPark-SSP
//
//  Created by Nick on 2016/12/26.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKColorManager.h"

@implementation NKColorManager

static NKColorManager *sharedColorManager = nil;
+ (NKColorManager *)sharedColorManager
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if (sharedColorManager == nil) {
            sharedColorManager = [[self alloc] init];
        }
    });
    return sharedColorManager;
}
+ (NSString*)stringWithUIColor:(UIColor*)color
{
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    int rgb = (int) (r * 255.0f)<<16 | (int) (g * 255.0f)<<8 | (int) (b * 255.0f)<<0;
    return [NSString stringWithFormat:@"#ff%06x", rgb];
}
+ (UIColor*) colorWithStr:(NSString *)hexStr alpha:(CGFloat)alphaValue
{
    /*将16进制字符串用C方法转换成10进制字符串@"ffbb11"与@"ffffbb11"结果一样。
     NSString *str = @"ffbb11";
     NSString *temp10 = [NSString stringWithFormat:@"%lu",strtoul([str UTF8String],0,16)];
     NSLog(@"心跳数字 10进制 %@",temp10);
     UIColor *color = [self colorWithHex:temp10.integerValue alpha:1.0];
     self.view.backgroundColor = color;
     */
    if ([hexStr hasPrefix:@"#"])
    {
        NSString *str = [hexStr substringWithRange:NSMakeRange(hexStr.length - 6, 6)];
        NSString *temp10 = [NSString stringWithFormat:@"%lu",strtoul([str UTF8String],0,16)];
        NSInteger hexValue = temp10.integerValue;
        return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                               green:((float)((hexValue & 0xFF00) >> 8))/255.0
                                blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
    }
    else
    {
        return [UIColor redColor];
    }
}


@end
