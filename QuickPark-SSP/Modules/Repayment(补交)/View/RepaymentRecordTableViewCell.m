//
//  RepaymentRecordTableViewCell.m
//  QuickPark-SSP
//
//  Created by Nick on 2017/5/18.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "RepaymentRecordTableViewCell.h"

@implementation RepaymentRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.cellBaseView.layer.cornerRadius = CORNERRADIUS;
//    self.cellBaseView.layer.masksToBounds = YES;
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
    [self.selecteButton setImage:[UIImage imageNamed:@"repayment_circle_selected"] forState:UIControlStateSelected];
    
    self.tagImageViwe.image = [self.tagImageViwe.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    self.ruleLabel.textColor = COLOR_TITLE_GRAY;
    self.chargeDetailLabel.textColor = COLOR_TITLE_GRAY;
}

@end
