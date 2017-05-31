//
//  ChargeDetailSubView.m
//  QuickPark-SSP
//
//  Created by Nick on 2017/1/5.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "ChargeDetailSubView.h"

@implementation ChargeDetailSubView

+ (instancetype) chargeDetailSubView
{
    NSBundle *bundle=[NSBundle mainBundle];
    ChargeDetailSubView *chargeDetailSubView =[bundle loadNibNamed:@"ChargeDetailSubView" owner:nil options:nil].lastObject;
    chargeDetailSubView.backgroundColor = COLOR_VIEW_BLACK;
    
    chargeDetailSubView.comingTimeLabel.textColor = COLOR_TITLE_BLACK;
    chargeDetailSubView.comingDateLabel.textColor = COLOR_TITLE_GRAY;
    chargeDetailSubView.leavingTimeLabel.textColor = COLOR_TITLE_BLACK;
    chargeDetailSubView.leavingDateLabel.textColor = COLOR_TITLE_GRAY;
    chargeDetailSubView.totalTimeAndMoneyLabel.textColor = COLOR_TITLE_BLACK;
    
    chargeDetailSubView.licenseLabel.textColor = COLOR_TITLE_WHITE;
    chargeDetailSubView.licenseLabel.backgroundColor = COLOR_BACK_BLUE;
    chargeDetailSubView.licenseLabel.layer.cornerRadius = CORNERRADIUS;
    chargeDetailSubView.licenseLabel.layer.masksToBounds = YES;
    
    chargeDetailSubView.circleView_left.backgroundColor = [UIColor clearColor];
    chargeDetailSubView.circleView_left.layer.cornerRadius = chargeDetailSubView.circleView_left.frame.size.width / 2;
    chargeDetailSubView.circleView_left.layer.masksToBounds = YES;
    chargeDetailSubView.circleView_left.layer.borderWidth = 1;
    chargeDetailSubView.circleView_left.layer.borderColor = CUTLINE_COLOR.CGColor;
    chargeDetailSubView.circleView_right.backgroundColor = CUTLINE_COLOR;
    chargeDetailSubView.circleView_right.layer.cornerRadius = chargeDetailSubView.circleView_right.frame.size.width / 2;
    chargeDetailSubView.circleView_right.layer.masksToBounds = YES;
    
    chargeDetailSubView.titleLabel_0.textColor = COLOR_TITLE_BLACK;
    chargeDetailSubView.titleLabel_1.textColor = COLOR_TITLE_BLACK;
    chargeDetailSubView.titleLabel_2.textColor = COLOR_TITLE_BLACK;
    chargeDetailSubView.titleLabel_3.textColor = COLOR_TITLE_BLACK;
    chargeDetailSubView.titleLabel_4.textColor = COLOR_TITLE_BLACK;
//    chargeDetailSubView.titleLabel_5.textColor = COLOR_TITLE_BLACK;//抹零
    chargeDetailSubView.titleLabel_6.textColor = COLOR_TITLE_BLACK;
    chargeDetailSubView.titleLabel_7.textColor = COLOR_TITLE_BLACK;
    chargeDetailSubView.titleLabel_8.textColor = COLOR_TITLE_BLACK;
    chargeDetailSubView.titleLabel_9.textColor = COLOR_TITLE_RED;
    
    chargeDetailSubView.moneyLabel_0.textColor = COLOR_TITLE_BLACK;
    chargeDetailSubView.moneyLabel_1.textColor = COLOR_TITLE_BLACK;
    chargeDetailSubView.moneyLabel_2.textColor = COLOR_TITLE_BLACK;
    chargeDetailSubView.moneyLabel_3.textColor = COLOR_TITLE_BLACK;
    chargeDetailSubView.moneyLabel_4.textColor = COLOR_TITLE_BLACK;
//    chargeDetailSubView.moneyLabel_5.textColor = COLOR_TITLE_BLACK;//抹零
    chargeDetailSubView.moneyLabel_6.textColor = COLOR_TITLE_BLACK;
    chargeDetailSubView.moneyLabel_7.textColor = COLOR_TITLE_BLACK;
    chargeDetailSubView.moneyLabel_8.textColor = COLOR_TITLE_BLACK;
    chargeDetailSubView.moneyLabel_9.textColor = COLOR_TITLE_RED;
    
    chargeDetailSubView.cutlineView_0.backgroundColor = CUTLINE_COLOR;
    chargeDetailSubView.cutlineView_1.backgroundColor = CUTLINE_COLOR;
    chargeDetailSubView.cutlineView_2.backgroundColor = CUTLINE_COLOR;
    chargeDetailSubView.cutlineView_3.backgroundColor = COLOR_MAIN_RED;
    chargeDetailSubView.cutlineView_4.backgroundColor = COLOR_MAIN_RED;
    
    [chargeDetailSubView.complainButton setTitleColor:COLOR_TITLE_BLACK forState:UIControlStateNormal];
    [chargeDetailSubView.backButton setTitleColor:COLOR_TITLE_BLACK forState:UIControlStateNormal];
    
    return chargeDetailSubView;
}

@end
