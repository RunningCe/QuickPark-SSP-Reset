//
//  NKLocalPassportBindDto.h
//  QuickPark-SSP
//
//  Created by Nick on 2017/5/5.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKLocalPassportBindDto : NSObject

//主键ID
@property (nonatomic, assign) NSInteger keyId;
//迅停用户id
@property (nonatomic, copy) NSString *qpUserId;
//县区编码
@property (nonatomic, assign) NSInteger prefectureCode;
//绑定状态
@property (nonatomic, assign) NSInteger bindStatus;
//最后一个的操作时间
@property (nonatomic, copy) NSDate *lastOpTime;
//本地用户ID
@property (nonatomic, copy) NSString *localUserId;
//颜色
@property (nonatomic, copy) NSString *listColor;

@property (nonatomic, copy) NSString *cityName;

@end
