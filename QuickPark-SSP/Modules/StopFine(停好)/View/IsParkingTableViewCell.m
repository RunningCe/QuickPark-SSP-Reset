//
//  IsParkingTableViewCell.m
//  QuickPark-SSP
//
//  Created by Nick on 2016/12/13.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "IsParkingTableViewCell.h"

@interface IsParkingTableViewCell ()

@end

@implementation IsParkingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cellBaseView.layer.cornerRadius = CORNERRADIUS;
    self.cellBaseView.layer.masksToBounds = YES;
    self.cellBaseView.backgroundColor = BACKGROUND_COLOR;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.ruleLabel.textColor = COLOR_TITLE_GRAY;
    self.licenseLabel.textColor = COLOR_TITLE_BLACK;
    self.berthIdLabel.textColor = COLOR_TITLE_BLACK;
    self.berthNameLabel.textColor = COLOR_TITLE_BLACK;
    self.berthNameDetailLabel.textColor = COLOR_TITLE_BLACK;
    self.comingDateLabel.textColor = COLOR_TITLE_GRAY;
    self.comingTimeLabel.textColor = COLOR_TITLE_BLACK;
    self.comingWeekLabel.textColor = COLOR_TITLE_GRAY;
    self.timeLabel_0.backgroundColor = COLOR_VIEW_BLACK;
    self.timeLabel_0.layer.cornerRadius = CORNERRADIUS;
    self.timeLabel_0.layer.masksToBounds = YES;
    self.timeLabel_0.textColor = [UIColor whiteColor];
    self.timeLabel_1.backgroundColor = COLOR_VIEW_BLACK;
    self.timeLabel_1.layer.cornerRadius = CORNERRADIUS;
    self.timeLabel_1.layer.masksToBounds = YES;
    self.timeLabel_1.textColor = [UIColor whiteColor];
    self.timeLabel_2.backgroundColor = COLOR_VIEW_BLACK;
    self.timeLabel_2.layer.cornerRadius = CORNERRADIUS;
    self.timeLabel_2.layer.masksToBounds = YES;
    self.timeLabel_2.textColor = [UIColor whiteColor];
    self.timeLabel_3.backgroundColor = COLOR_VIEW_BLACK;
    self.timeLabel_3.layer.cornerRadius = CORNERRADIUS;
    self.timeLabel_3.layer.masksToBounds = YES;
    self.timeLabel_3.textColor = [UIColor whiteColor];
    [self.mepStarButton setBackgroundColor:COLOR_BUTTON_RED];
    [self.mepStarButton setTitleColor:COLOR_TITLE_WHITE forState:UIControlStateNormal];
    self.mepStarButton.layer.cornerRadius = 2;
    self.mepStarButton.layer.masksToBounds = YES;
    [self.mepStarButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -4.0, 0.0, 0.0)];
    self.tagImageViwe.image = [self.tagImageViwe.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
