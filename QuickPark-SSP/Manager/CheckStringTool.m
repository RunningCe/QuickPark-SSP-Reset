//
//  CheckStringTool.m
//  phoneNumber_test
//
//  Created by Jack on 16/8/29.
//  Copyright © 2016年 Jack. All rights reserved.
//

#import "CheckStringTool.h"

@implementation CheckStringTool

+(BOOL)valiMobile:(NSString *)mobile{
    
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (mobile.length != 11)
    
    {
        
        return NO;
        
    }else{
        
        /**
         
         * 移动号段正则表达式
         
         */
        
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        
        /**
         
         * 联通号段正则表达式
         
         */
        
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        
        /**
         
         * 电信号段正则表达式
         
         */
        
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        
        
        if (isMatch1 || isMatch2 || isMatch3) {
            
            return YES;
            
        }else{
            
            return NO;
            
        }
        
    }
    
}
+(BOOL)valiIDCard:(NSString *)cardId{
    if (cardId.length == 15 || cardId.length == 18)
    {
        cardId = [cardId stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSString *cardId_15 = @"^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$";
        
        NSString *cardId_18 = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$";
        
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cardId_15];
        BOOL isMatch1 = [pred1 evaluateWithObject:cardId];
        
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cardId_18];
        BOOL isMatch2 = [pred2 evaluateWithObject:cardId];
        if (isMatch1 || isMatch2) {
            
            return YES;
            
        }else{
            
            return NO;
            
        }
    }
    return NO;
}
+(BOOL)valiEmail:(NSString *)email
{
    email = [email stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *Email = @"[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Email];
    BOOL isMatch = [pred evaluateWithObject:email];
    
    if (isMatch)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}


@end
