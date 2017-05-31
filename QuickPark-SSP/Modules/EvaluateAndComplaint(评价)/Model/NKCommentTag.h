//
//  NKCommentTag.h
//  QuickPark-SSP
//
//  Created by Nick on 16/8/24.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKCommentTag : NSObject

@property (nonatomic, assign)NSInteger tagType;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *modifyTime;
@property (nonatomic, assign)NSInteger id;
@property (nonatomic, copy)NSString *createTime;
@property (nonatomic, assign)NSInteger scopeType;
@property (nonatomic, assign)NSInteger operType;
@property (nonatomic, assign)NSInteger tagScope;
@property (nonatomic, assign)NSInteger starLevel;

@end
