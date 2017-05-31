//
//  HappyParkingTableViewCell.m
//  QuickPark-SSP
//
//  Created by Nick on 2016/10/24.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "HappyParkingTableViewCell.h"

@implementation HappyParkingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _BaseView.layer.cornerRadius = CORNERRADIUS;
    _BaseView.layer.masksToBounds = YES;
    _BaseView.backgroundColor = [UIColor whiteColor];
    
    _parkImageView.layer.cornerRadius = CORNERRADIUS;
    _parkImageView.layer.masksToBounds = YES;
    
    _storeCarButton.layer.cornerRadius = CORNERRADIUS;
    _storeCarButton.layer.masksToBounds = YES;
    _storeCarButton.layer.borderColor = BUTTON_COLOR_RED.CGColor;
    _storeCarButton.layer.borderWidth = 1;
    [_storeCarButton setTitleColor:BUTTON_COLOR_RED forState:UIControlStateNormal];
    _takeoutCarButton.layer.cornerRadius = CORNERRADIUS;
    _takeoutCarButton.layer.masksToBounds = YES;
    _takeoutCarButton.layer.borderColor = BUTTON_COLOR_RED.CGColor;
    _takeoutCarButton.layer.borderWidth = 1;
    [_takeoutCarButton setTitleColor:BUTTON_COLOR_RED forState:UIControlStateNormal];
    
    _locationLabel.textColor = TITLE_COLOR_LIGHT;
    _parkNameLabel.textColor = TITLE_COLOR_DEEP;
    _parkDistanceLabel.textColor = TITLE_COLOR_LIGHT;
    _parkBerthLabel.textColor = TITLE_COLOR_LIGHT;

    self.backgroundColor = BACKGROUND_COLOR;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
