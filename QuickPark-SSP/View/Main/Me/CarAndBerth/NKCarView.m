//
//  NKCarView.m
//  QuickPark-SSP
//
//  Created by Nick on 2016/11/15.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKCarView.h"

@implementation NKCarView

+(instancetype) carView
{
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"NKCarView" owner:nil options:nil];
    NKCarView *carView = objs.lastObject;
    
    carView.backgroundColor = COLOR_VIEW_BLACK;
    carView.parkingMsgLabel.textColor = COLOR_TITLE_GRAY;
    
    carView.licenseLabel.textColor = COLOR_TITLE_GRAY;
    carView.licenseLabel.backgroundColor = COLOR_VIEW_BLACK;
    carView.licenseLabel.layer.cornerRadius = CORNERRADIUS;
    carView.licenseLabel.layer.masksToBounds = YES;
    carView.carBrandLabel.textColor = COLOR_TITLE_GRAY;
    
    //画虚线
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = COLOR_TITLE_GRAY.CGColor;
    border.fillColor = nil;
    border.path = [UIBezierPath bezierPathWithRect:carView.licenseLabel.bounds].CGPath;
    border.frame = carView.licenseLabel.bounds;
    border.lineWidth = 1.5f;
    border.lineCap = @"square";
    border.lineDashPattern = @[@4, @6];
    [carView.licenseLabel.layer addSublayer:border];
    
    return carView;
}

@end
