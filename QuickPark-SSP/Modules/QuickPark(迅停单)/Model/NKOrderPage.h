//
//  NKOrderPage.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/10/27.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKOrderPage : NSObject
@property (nonatomic, assign) Boolean needTotal;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger totalRecord;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, strong) NSArray *results;

//private boolean needTotal=true;//是否需要总记录数  以防以后数据量大了 不再获取总数
//private int pageNo = 1;//页码，默认是第一页
//private int pageSize = 30;//每页显示的记录数，默认是30
//private int totalRecord;//总记录数
//private int totalPage;//总页数
//private List<?> results;//对应的当前页记录

@end
