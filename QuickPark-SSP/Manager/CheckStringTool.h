//
//  CheckStringTool.h
//  phoneNumber_test
//
//  Created by Jack on 16/8/29.
//  Copyright © 2016年 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckStringTool : NSObject

+(BOOL)valiMobile:(NSString *)mobile;
+(BOOL)valiIDCard:(NSString *)cardId;
+(BOOL)valiEmail:(NSString *)email;


@end
