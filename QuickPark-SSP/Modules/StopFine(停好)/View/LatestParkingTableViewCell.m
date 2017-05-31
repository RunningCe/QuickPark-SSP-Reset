//
//  IsParkingTableViewCell.m
//  QuickPark-SSP
//
//  Created by Nick on 2016/12/13.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "LatestParkingTableViewCell.h"

@interface LatestParkingTableViewCell ()

@end

@implementation LatestParkingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cellBaseView.layer.cornerRadius = CORNERRADIUS;
    self.cellBaseView.layer.masksToBounds = YES;
    self.cellBaseView.backgroundColor = BACKGROUND_COLOR;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.licenseLabel.textColor = COLOR_TITLE_BLACK;
    self.berthIdLabel.textColor = COLOR_TITLE_BLACK;
    self.berthNameLabel.textColor = COLOR_TITLE_BLACK;
    self.berthNameDetailLabel.textColor = COLOR_TITLE_BLACK;
    self.comingDateLabel.textColor = COLOR_TITLE_GRAY;
    self.comingTimeLabel.textColor = COLOR_TITLE_BLACK;
    self.comingWeekLabel.textColor = COLOR_TITLE_GRAY;
    self.leavingDateLabel.textColor = COLOR_TITLE_GRAY;
    self.leavingTimeLabel.textColor = COLOR_TITLE_BLACK;
    self.leavingWeekLabel.textColor = COLOR_TITLE_GRAY;
    self.totalMoneyLabel.textColor = COLOR_TITLE_BLACK;
    [self.chargeDetailButton setTitleColor:COLOR_TITLE_GRAY forState:UIControlStateNormal];
    [self.commentButton setBackgroundColor:COLOR_BUTTON_RED];
    [self.commentButton setTitleColor:COLOR_TITLE_WHITE forState:UIControlStateNormal];
    self.commentButton.layer.cornerRadius = CORNERRADIUS;
    self.commentButton.layer.masksToBounds = YES;
    self.tagImageViwe.image = [self.tagImageViwe.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.starBaseView.backgroundColor = BACKGROUND_COLOR;
    
    self.ruleLabel.textColor = COLOR_TITLE_GRAY;
    self.chargeDetailLabel.textColor = COLOR_TITLE_GRAY;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
