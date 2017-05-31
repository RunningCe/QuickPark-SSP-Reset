//
//  NKMessage.h
//  QuickPark-SSP
//
//  Created by Nick on 16/8/30.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKMessage : NSObject

@property (nonatomic, strong)NSArray *records;
@property (nonatomic, assign)NSInteger timestamp;
@property (nonatomic, assign)NSInteger currentCount;
@property (nonatomic, copy)NSString *msg;
@property (nonatomic, assign)NSInteger total;
@property (nonatomic, assign)NSInteger ret;

@end
