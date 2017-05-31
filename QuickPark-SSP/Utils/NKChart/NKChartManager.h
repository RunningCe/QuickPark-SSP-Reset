//
//  NKChartManager.h
//  QuickPark-SSP
//
//  Created by Nick on 2017/2/23.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NKPieChart.h"
@class NKPieData;

@interface NKChartManager : NSObject

+ (UIView *)NKChartPieViewWithPieData:(NKPieData *)pieData andFrame:(CGRect)frame PieSize:(CGSize)size andType:(NKPieType)type;

@end
