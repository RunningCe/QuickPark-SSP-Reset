//
//  NKMainCarView.m
//  QuickPark-SSP
//
//  Created by Nick on 2017/2/21.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "NKMainCarView.h"

@implementation NKMainCarView

+ (instancetype)mainCarViewWithType:(NKMainCarViewType)type
{
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"NKMainCarView" owner:nil options:nil];
    NKMainCarView  *mainCarView = objs.lastObject;
    
    if (type == NKMainCarViewTypeNew)
    {
        //更改图片的大小，和车牌号距离图片的位置
        mainCarView.carBrandImageViewHeight.constant = 0;
        mainCarView.carBrandImageViewAndLicenceLabelSpc.constant = 25;
        
        mainCarView.topLabel.textColor = COLOR_TITLE_GRAY;
        mainCarView.carBrandImageView.backgroundColor = [UIColor clearColor];
        
        mainCarView.carLicenseLabel.backgroundColor = COLOR_BACK_BLUE;
        mainCarView.carLicenseLabel.textColor = COLOR_TITLE_WHITE;
        mainCarView.carLicenseLabel.layer.cornerRadius = CORNERRADIUS;
        mainCarView.carLicenseLabel.layer.masksToBounds = YES;
        CAShapeLayer *border = [CAShapeLayer layer];
        border.strokeColor = COLOR_TITLE_WHITE.CGColor;
        border.fillColor = nil;
        border.path = [UIBezierPath bezierPathWithRect:mainCarView.carLicenseLabel.bounds].CGPath;
        border.frame = mainCarView.carLicenseLabel.bounds;
        border.lineWidth = 1.5f;
        border.lineCap = @"square";
        border.lineDashPattern = @[@4, @6];
        [mainCarView.carLicenseLabel.layer addSublayer:border];
        
        mainCarView.latestParkingNameLabel.textColor = COLOR_TITLE_GRAY;
        mainCarView.latestParkingTimeAndMoneyLabel.textColor = COLOR_TITLE_GRAY;
        mainCarView.backgroundColor = COLOR_VIEW_BLACK;
    }
    else if (type == NKMainCarViewTypeIsCertificating)
    {
        mainCarView.topLabel.textColor = COLOR_TITLE_GRAY;
        mainCarView.carBrandImageView.backgroundColor = [UIColor clearColor];
        
        mainCarView.carLicenseLabel.backgroundColor = COLOR_BACK_BLUE;
        mainCarView.carLicenseLabel.textColor = COLOR_TITLE_WHITE;
        mainCarView.carLicenseLabel.layer.cornerRadius = CORNERRADIUS;
        mainCarView.carLicenseLabel.layer.masksToBounds = YES;
        CAShapeLayer *border = [CAShapeLayer layer];
        border.strokeColor = COLOR_TITLE_WHITE.CGColor;
        border.fillColor = nil;
        border.path = [UIBezierPath bezierPathWithRect:mainCarView.carLicenseLabel.bounds].CGPath;
        border.frame = mainCarView.carLicenseLabel.bounds;
        border.lineWidth = 1.5f;
        border.lineCap = @"square";
        border.lineDashPattern = @[@4, @6];
        [mainCarView.carLicenseLabel.layer addSublayer:border];
        
        mainCarView.latestParkingNameLabel.textColor = COLOR_TITLE_GRAY;
        mainCarView.latestParkingTimeAndMoneyLabel.textColor = COLOR_TITLE_GRAY;
        mainCarView.backgroundColor = COLOR_VIEW_BLACK;
    }
    else if (type == NKMainCarViewTypeCertificateSuccess)
    {
        mainCarView.topLabel.textColor = COLOR_TITLE_GRAY;
        mainCarView.carBrandImageView.backgroundColor = [UIColor clearColor];
        mainCarView.carLicenseLabel.backgroundColor = COLOR_BACK_BLUE;
        mainCarView.carLicenseLabel.textColor = COLOR_TITLE_WHITE;
        mainCarView.carLicenseLabel.layer.cornerRadius = CORNERRADIUS;
        mainCarView.carLicenseLabel.layer.masksToBounds = YES;
        mainCarView.carLicenseLabel.layer.borderColor = COLOR_TITLE_WHITE.CGColor;
        mainCarView.carLicenseLabel.layer.borderWidth = 1;
        mainCarView.latestParkingNameLabel.textColor = COLOR_TITLE_GRAY;
        mainCarView.latestParkingTimeAndMoneyLabel.textColor = COLOR_TITLE_GRAY;
        mainCarView.backgroundColor = COLOR_VIEW_BLACK;
    }
    else
    {
        //更改图片的大小，和车牌号距离图片的位置
        mainCarView.carBrandImageViewHeight.constant = 0;
        mainCarView.carBrandImageViewAndLicenceLabelSpc.constant = 25;
        
        mainCarView.topLabel.textColor = COLOR_TITLE_GRAY;
        mainCarView.carBrandImageView.backgroundColor = [UIColor clearColor];
        
        mainCarView.carLicenseLabel.backgroundColor = COLOR_BACK_BLUE;
        mainCarView.carLicenseLabel.textColor = COLOR_TITLE_WHITE;
        mainCarView.carLicenseLabel.layer.cornerRadius = CORNERRADIUS;
        mainCarView.carLicenseLabel.layer.masksToBounds = YES;
        CAShapeLayer *border = [CAShapeLayer layer];
        border.strokeColor = COLOR_TITLE_WHITE.CGColor;
        border.fillColor = nil;
        border.path = [UIBezierPath bezierPathWithRect:mainCarView.carLicenseLabel.bounds].CGPath;
        border.frame = mainCarView.carLicenseLabel.bounds;
        border.lineWidth = 1.5f;
        border.lineCap = @"square";
        border.lineDashPattern = @[@4, @6];
        [mainCarView.carLicenseLabel.layer addSublayer:border];
        
        mainCarView.latestParkingNameLabel.textColor = COLOR_TITLE_GRAY;
        mainCarView.latestParkingTimeAndMoneyLabel.textColor = COLOR_TITLE_GRAY;
        mainCarView.backgroundColor = COLOR_VIEW_BLACK;
    }
    
    
    
    return mainCarView;
}

@end
