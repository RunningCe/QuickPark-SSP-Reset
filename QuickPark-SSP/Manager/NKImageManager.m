//
//  NKImageManager.m
//  QuickPark-SSP
//
//  Created by Nick on 2017/1/20.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "NKImageManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation NKImageManager

static NKImageManager *sharedManager = nil;
+(NKImageManager *)sharedImageManager
{
    dispatch_once_t token;
    dispatch_once(&token, ^{
        if (sharedManager == nil)
        {
            sharedManager = [[self alloc] init];
        }
    });
    return sharedManager;
}
+ (NSData *)getImageDataWithUrl:(NSString *)imageURL
{
    NSData *imageData = nil;
    BOOL isExit = [[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:imageURL]];
    if (isExit) {
        NSString *cacheImageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:imageURL]];
        if (cacheImageKey.length) {
            NSString *cacheImagePath = [[SDImageCache sharedImageCache] defaultCachePathForKey:cacheImageKey];
            if (cacheImagePath.length) {
                imageData = [NSData dataWithContentsOfFile:cacheImagePath];
            }
        }
    }
    if (!imageData) {
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
        [[SDWebImageManager sharedManager] saveImageToCache:[UIImage imageWithData:imageData] forURL:[NSURL URLWithString:imageURL]];
    }
//    [[SDImageCache sharedImageCache] clearDisk];//清空内存
    return imageData;
}
+ (void)storImage:(UIImage *)image WithKey:(NSString *)key
{
    [[SDWebImageManager sharedManager] saveImageToCache:image forURL:[NSURL URLWithString:key]];
}
+ (UIImage *)buttonImageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, WIDTH_VIEW, 64);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end
