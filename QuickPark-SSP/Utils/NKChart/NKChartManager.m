//
//  NKChartManager.m
//  QuickPark-SSP
//
//  Created by Nick on 2017/2/23.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "NKChartManager.h"
#import "NKPieData.h"
#import "NSDictionary+Compared.h"

@implementation NKChartManager

+ (UIView *)NKChartPieViewWithPieData:(NKPieData *)pieData andFrame:(CGRect)frame PieSize:(CGSize)size andType:(NKPieType)type
{
    //判断返回数据是否为空
    if (pieData.cityFee.count == 0)
    {
        return nil;
    }
    UIView *baseView = [[UIView alloc] initWithFrame:frame];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, 10)];
    ////根据停车次数/金额获取最主要的停车地点，进而获取到城市，区域字段
    NSString *city_lot_str = [pieData.cityFee nk_ascendingComparedAllKeys].firstObject;
    
    NSString *city_str = [city_lot_str componentsSeparatedByString:@"-"].firstObject;
    NSString *lot_str = [city_lot_str componentsSeparatedByString:@"-"].lastObject;
    if (type == NKPieTypeCity)
    {
        titleLabel.text = city_str;
    }
    else if (type == NKPieTypeLot)
    {
        titleLabel.text = lot_str;
    }
    
    titleLabel.textColor = COLOR_TITLE_WHITE;
    titleLabel.font = [UIFont systemFontOfSize:10.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [baseView addSubview:titleLabel];
    
    NKPieChart *pie = [NKPieChart NKChartPieViewWithPieData:pieData Frame:CGRectMake((frame.size.width - size.width) / 2, (frame.size.height - size.height) / 2, size.width, size.height) andType:type];
    
    UIView *legend = [pie getLegendWithMaxWidth:200];
    [legend setFrame:CGRectMake((WIDTH_VIEW / 2 - legend.frame.size.width) / 2, baseView.frame.size.height - legend.frame.size.height - 8, legend.frame.size.width, legend.frame.size.height)];
    [baseView addSubview:legend];
    
    [baseView addSubview:pie];
    
    return baseView;
}

@end
