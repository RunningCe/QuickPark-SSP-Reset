//
//  NKImageManager.h
//  QuickPark-SSP
//
//  Created by Nick on 2017/1/20.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NKImageManager : NSObject

+ (NSData *)getImageDataWithUrl:(NSString *)imageURL;
+ (void)storImage:(UIImage *)image WithKey:(NSString *)key;

@end
