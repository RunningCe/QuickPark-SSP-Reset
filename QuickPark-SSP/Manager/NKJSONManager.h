//
//  NKJSONManager.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/12/26.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKJSONManager : NSObject

+ (NKJSONManager *) sharedJSONManager;
//JSON字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
//字符串转JSON字符串
+ (NSString *)JSONStringWithString:(NSString *)aString;

@end
