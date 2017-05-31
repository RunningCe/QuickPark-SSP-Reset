//
//  NKPieChart.h
//  QuickPark-SSP
//
//  Created by Nick on 2017/2/23.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <PNChart/PNChart.h>
@class NKPieData;

typedef enum {
    NKPieTypeCity,
    NKPieTypeLot
}NKPieType;

@interface NKPieChart : PNPieChart

+ (instancetype)NKChartPieViewWithPieData:(NKPieData *)pieData Frame:(CGRect)frame andType:(NKPieType)type;

@end
