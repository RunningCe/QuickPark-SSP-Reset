//
//  NSDictionary+Compared.h
//  QuickPark-SSP
//
//  Created by Nick on 2017/2/28.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Compared)

/*****************获取升序键值*********************/
- (NSArray *)nk_ascendingComparedAllKeys;

/*****************获取降序键值*********************/
- (NSArray *)nk_descendingComparedAllKeys;

@end
