//
//  HappyParkingOrderdetailTableViewCell.m
//  QuickPark-SSP
//
//  Created by Nick on 2016/10/26.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "HappyParkingOrderdetailTableViewCell.h"

@implementation HappyParkingOrderdetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _baseView.backgroundColor = [UIColor whiteColor];
    _baseView.layer.cornerRadius = 2;
    _baseView.layer.masksToBounds = YES;
    
    _licenseLabel.textColor = TITLE_COLOR_LIGHT;
    _timeLabel.textColor = TITLE_COLOR_DEEP;
    _parkingNameLabel.textColor = TITLE_COLOR_DEEP;
    _locationLabel.textColor = TITLE_COLOR_LIGHT;
    
    [_cancelButton setTitleColor:BUTTON_COLOR_RED forState:UIControlStateNormal];
    _cancelButton.layer.cornerRadius = CORNERRADIUS;
    _cancelButton.layer.masksToBounds = YES;
    _cancelButton.layer.borderColor = BUTTON_COLOR_RED.CGColor;
    _cancelButton.layer.borderWidth = 1;
    
    self.backgroundColor = BACKGROUND_COLOR;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
