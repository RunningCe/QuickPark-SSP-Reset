//
//  QQApiManager.h
//  QuickPark-SSP
//
//  Created by Nick on 16/9/14.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface QQApiManager : NSObject<TencentSessionDelegate>

+ (instancetype)sharedManager;
- (void)loginQQ;

@end
