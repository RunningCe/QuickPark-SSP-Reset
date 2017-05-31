//
//  NKColorManager.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/12/26.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>      
#import "UIKit/UIColor.h"

@interface NKColorManager : NSObject

//颜色转换方法
+ (NKColorManager *) sharedColorManager;
+ (UIColor*) colorWithStr:(NSString *)hexStr alpha:(CGFloat)alphaValue;
+ (NSString*) stringWithUIColor:(UIColor*)color;

@end
