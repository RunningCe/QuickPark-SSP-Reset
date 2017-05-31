//
//  GTManager.h
//  QuickPark-SSP
//
//  Created by Nick on 16/9/29.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeTuiSdk.h"

@interface GTManager : NSObject <GeTuiSdkDelegate>

+(instancetype)sharedManager;

@end
