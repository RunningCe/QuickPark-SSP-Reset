//
//  AliyPayApiManager.h
//  QuickPark-SSP
//
//  Created by Jack on 16/9/13.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NKPay.h"

@interface AliyPayApiManager : NSObject

+(instancetype)sharedManager;
+(void)doAlipayPayWithParameters:(NKPay *)aliypay;
+(void)doAlipayAuth;
@end
