//
//  NKMessageRecord.h
//  QuickPark-SSP
//
//  Created by Nick on 16/8/30.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKMessageRecord : NSObject

@property (nonatomic, assign)NSInteger pushTime;
@property (nonatomic, copy)NSString *pushTitle;
@property (nonatomic, copy)NSString *sspId;
@property (nonatomic, copy)NSString *pushContent;

@end
