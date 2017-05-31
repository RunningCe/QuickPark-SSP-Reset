//
//  NKTransferRecord.h
//  QuickPark-SSP
//
//  Created by Nick on 16/9/2.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKTransferRecord : NSObject

@property (nonatomic, assign)NSInteger timestamp;
@property (nonatomic, assign)NSInteger ret;
@property (nonatomic, copy)NSString *msg;
@property (nonatomic, strong)NSMutableArray *tansferRecords;

@end
