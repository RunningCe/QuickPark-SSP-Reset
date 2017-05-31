//
//  NKCarUncertificatedTableViewCell.m
//  QuickPark-SSP
//
//  Created by Nick on 2017/2/21.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "NKCarUncertificatedTableViewCell.h"

@implementation NKCarUncertificatedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.carLicenseLabel.backgroundColor = [UIColor clearColor];
    self.carLicenseLabel.textColor = COLOR_TITLE_GRAY;
    self.carLicenseLabel.layer.cornerRadius = CORNERRADIUS;
    self.carLicenseLabel.layer.masksToBounds = YES;
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = COLOR_TITLE_GRAY.CGColor;
    border.fillColor = nil;
    border.path = [UIBezierPath bezierPathWithRect:self.carLicenseLabel.bounds].CGPath;
    border.frame = self.carLicenseLabel.bounds;
    border.lineWidth = 1.5f;
    border.lineCap = @"square";
    border.lineDashPattern = @[@4, @6];
    [self.carLicenseLabel.layer addSublayer:border];
    
    self.latestParkingTimeAndMoneyLabel.textColor = COLOR_TITLE_GRAY;
    self.latestParkingNameLabel.textColor = COLOR_TITLE_GRAY;
    
    self.contentView.backgroundColor = COLOR_VIEW_BLACK;
    self.backgroundColor = COLOR_BACKGROUND_BLACK;
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
