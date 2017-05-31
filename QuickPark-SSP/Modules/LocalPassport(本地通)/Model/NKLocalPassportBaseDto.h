//
//  NKLocalPassportBaseDto.h
//  QuickPark-SSP
//
//  Created by Nick on 2017/5/5.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NKLocalPassportBindDto.h"
#import "NKLocalPassportUnbindDto.h"

@interface NKLocalPassportBaseDto : NSObject

@property (nonatomic, assign) NSInteger ret;

@property (nonatomic, copy) NSArray<NKLocalPassportUnbindDto *> *unbindCity;

@property (nonatomic, copy) NSArray<NKLocalPassportBindDto *> *alreadyBindCity;

@end
