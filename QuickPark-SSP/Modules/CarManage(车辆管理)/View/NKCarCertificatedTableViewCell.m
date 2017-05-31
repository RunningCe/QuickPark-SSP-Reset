//
//  NKCarCertificatedTableViewCell.m
//  QuickPark-SSP
//
//  Created by Nick on 2017/2/21.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "NKCarCertificatedTableViewCell.h"

@implementation NKCarCertificatedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.carLicenseLabel.textColor = COLOR_TITLE_GRAY;
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
