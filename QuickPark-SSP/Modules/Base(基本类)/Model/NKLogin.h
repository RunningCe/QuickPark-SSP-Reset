//
//  NKLogin.h
//  QuickPark-SSP
//
//  Created by Nick on 16/8/22.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NKUser.h"
#import "NKBerth.h"
#import "NKCar.h"

@interface NKLogin : NSObject<NSCoding>

@property (nonatomic, assign)NSInteger ret;
@property (nonatomic, assign)NSInteger timestamp;
@property (nonatomic, copy)NSString *msg;
@property (nonatomic, strong)NKUser *user;

@end
