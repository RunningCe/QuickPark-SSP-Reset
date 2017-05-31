//
//  NKCarBrandData.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/12/30.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKCarBrandData : NSObject

@property (nonatomic, assign) NSInteger brand_id;
@property (nonatomic, strong) NSString *cartypename;
@property (nonatomic, strong) NSString *brandlogourl;
@property (nonatomic, strong) NSString *logoname;
@property (nonatomic, strong) NSString *initials;
@property (nonatomic, strong) NSArray *btiList;

@end
