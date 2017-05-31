//
//  NKBase.h
//  QuickPark-SSP
//
//  Created by Nick on 16/8/29.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKBase : NSObject

@property (nonatomic, assign)NSInteger timestamp;
@property (nonatomic, assign)NSInteger ret;
@property (nonatomic, copy)NSString *msg;
@property (nonatomic, strong) NSString *obj;

@end
