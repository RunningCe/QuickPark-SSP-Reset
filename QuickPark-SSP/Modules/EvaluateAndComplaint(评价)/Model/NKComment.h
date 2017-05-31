//
//  NKComment.h
//  QuickPark-SSP
//
//  Created by Nick on 16/8/24.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NKComment.h"

@interface NKComment : NSObject

@property (nonatomic, assign)NSInteger ret;
@property (nonatomic, strong)NSArray *parkedTag;
@property (nonatomic, assign)NSInteger timestamp;
@property (nonatomic, strong)NSArray *carGoTag;
@property (nonatomic, copy)NSString *msg;
@property (nonatomic, strong)NSArray *carToTag;

@end
