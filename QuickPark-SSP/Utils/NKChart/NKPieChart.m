//
//  NKPieChart.m
//  QuickPark-SSP
//
//  Created by Nick on 2017/2/23.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "NKPieChart.h"
#import "NKPieData.h"
#import "NSDictionary+Compared.h"

#define PieColor_Red [UIColor colorWithRed:204.0 / 255.0 green:0.0 / 255.0 blue:51.0 / 255.0 alpha:1.0f]
#define PieColor_Pink [UIColor colorWithRed:255.0 / 255.0 green:92.0 / 255.0 blue:119.0 / 255.0 alpha:1.0f]
#define PieColor_LightPink [UIColor colorWithRed:239.0 / 255.0 green:143.0 / 255.0 blue:142.0 / 255.0 alpha:1.0f]
#define PieColor_DoubleLightPink [UIColor colorWithRed:255.0 / 255.0 green:192.0 / 255.0 blue:192.0 / 255.0 alpha:1.0f]


@implementation NKPieChart

+ (instancetype)NKChartPieViewWithPieData:(NKPieData *)pieData Frame:(CGRect)frame andType:(NKPieType)type
{
    // 数据
    //判断返回数据是否为空
    if (pieData.cityFee.count == 0)
    {
        return nil;
    }
    //根据停车次数/金额获取最主要的停车地点
    NSString *city_lot_str = [pieData.cityFee nk_ascendingComparedAllKeys].firstObject;
    
    NSString *city_str = [city_lot_str componentsSeparatedByString:@"-"].firstObject;
    NSString *lot_str = [city_lot_str componentsSeparatedByString:@"-"].lastObject;
    //判断是哪个圆饼
    NSMutableDictionary *dic;
    NSArray *colorArray;
    if (type == NKPieTypeLot)
    {
        NSMutableDictionary *lotDic = [NSMutableDictionary dictionary];
        for (NSString *key in pieData.parkinglotFee) {
            if ([key hasPrefix:lot_str]) {
                [lotDic setObject:pieData.parkinglotFee[key] forKey:key];
            }
        }
        dic = lotDic;
        colorArray = @[PieColor_Red, PieColor_Pink, PieColor_LightPink, PieColor_DoubleLightPink];
    }
    else if (type == NKPieTypeCity)
    {
        NSMutableDictionary *cityDic = [NSMutableDictionary dictionary];
        for (NSString *key in pieData.cityFee) {
            if ([key hasPrefix:city_str]) {
                [cityDic setObject:pieData.cityFee[key] forKey:key];
            }
        }
        dic = cityDic;
        colorArray = @[PieColor_Red, PieColor_Pink, PieColor_LightPink, PieColor_DoubleLightPink];
    }
    //创建数据数组
    NSMutableArray *items = [NSMutableArray array];

    int totalValue = 0;//总值
    int tempValue = 0;//保存前三个值之和
    for (NSString *key in dic)
    {
        NSString *value = dic[key];
        totalValue += value.intValue;
    }
    NSArray *allKeys = [dic allKeys];
    for (int i = 0; i < ((allKeys.count > 4) ? 4 : allKeys.count); i++)
    {
        if (i == 3)
        {
            PNPieChartDataItem *item = [PNPieChartDataItem dataItemWithValue:totalValue - tempValue color:colorArray[i] description:@"其他"];
            [items addObject:item];
            break;
        }
        NSString *key = allKeys[i];
        NSString *value = dic[key];
        PNPieChartDataItem *item = [PNPieChartDataItem dataItemWithValue:value.intValue color:colorArray[i] description:[key componentsSeparatedByString:@"-"].lastObject];
        [items addObject:item];
        tempValue += value.intValue;
    }
    
    NKPieChart *pie = [[NKPieChart alloc] initWithFrame:frame items:items];
    pie.descriptionTextColor = [UIColor whiteColor];
    pie.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:0];
    pie.descriptionTextShadowColor = [UIColor clearColor]; // 阴影颜色
    pie.showOnlyValues = YES; // 只显示数值不显示内容描述
    pie.innerCircleRadius = 0;
    
    [pie strokeChart];
    pie.legendStyle = PNLegendItemStyleSerial; // 标注排放样式
    pie.legendFont = [UIFont boldSystemFontOfSize:8.0f];
    pie.legendFontColor = [UIColor whiteColor];
    
    return pie;
}

@end
