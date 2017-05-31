//
//  NKSspEvaluateTag.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/12/1.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKSspEvaluateTag : NSObject

@property (nonatomic, assign) int id;
@property (nonatomic, assign) int starlevel;
@property (nonatomic, assign) BOOL scopetype;
@property (nonatomic, assign) float tagscope;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) int tagtype;
@property (nonatomic, copy) NSString *startext;
@property (nonatomic, copy) NSString *no;
@property (nonatomic, assign) int status;

//private Integer id;
//private Integer starlevel;// 星级
//private Boolean scopetype;// 分值类型 1正值，负值
//private BigDecimal tagscope;// 标签分值（一位小数）
//private String content;// 标签内容
//private Integer tagtype;//标签类型
//private String startext;//星级描述
//private int status;//标签的状态0开1关
//private String no;//标签的编码

@end
