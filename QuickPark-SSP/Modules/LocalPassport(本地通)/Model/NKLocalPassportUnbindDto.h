//
//  NKLocalPassportUnbindDto.h
//  QuickPark-SSP
//
//  Created by Nick on 2017/5/5.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKLocalPassportUnbindDto : NSObject

//区域编码
@property (nonatomic, assign) NSInteger areaCode;
//城市名称
@property (nonatomic, copy) NSString *cityName;
//列表颜色
@property (nonatomic, copy) NSString *listColor;

@end
