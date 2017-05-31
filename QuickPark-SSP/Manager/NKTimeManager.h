//
//  NKTimeManager.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/12/19.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKTimeManager : NSObject

+ (NKTimeManager *)sharedTimeManager;
+ (NSString *)dateToString:(NSDate *)date withDateFormat:(NSString *)format;
+ (NSDate *)stringToDate:(NSString *)dateString withDateFormat:(NSString *)format;
+ (NSDate *)worldTimeToChinaTime:(NSDate *)date;
+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;

@end
