//
//  NKComplainTopView.m
//  QuickPark-SSP
//
//  Created by Nick on 2016/11/30.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKComplainTopView.h"

@implementation NKComplainTopView

+(instancetype) complainTopView
{
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"NKComplainTopView" owner:nil options:nil];
    NKComplainTopView *complaintTopView = [objs lastObject];
    complaintTopView.layer.borderWidth = 1;
    complaintTopView.layer.borderColor = COLOR_BORDER_GRAY.CGColor;
    complaintTopView.layer.cornerRadius = 2;
    complaintTopView.layer.masksToBounds = YES;
    complaintTopView.circleView0.layer.cornerRadius = complaintTopView.circleView0.frame.size.width / 2;
    complaintTopView.circleView0.layer.masksToBounds = YES;
    complaintTopView.circleView1.layer.cornerRadius = complaintTopView.circleView1.frame.size.width / 2;
    complaintTopView.circleView1.layer.masksToBounds = YES;
    complaintTopView.startTimeLabel.textColor = COLOR_TITLE_BLACK;
    complaintTopView.startDateLabel.textColor = COLOR_TITLE_GRAY;
    complaintTopView.endTimeLabel.textColor = COLOR_TITLE_BLACK;
    complaintTopView.endDateLabel.textColor = COLOR_TITLE_GRAY;
    complaintTopView.totalTimeLabel.textColor = COLOR_TITLE_BLACK;
    complaintTopView.cutLineView.backgroundColor = COLOR_BORDER_GRAY;
    complaintTopView.licenseLabel.textColor = COLOR_TITLE_WHITE;
    complaintTopView.licenseLabel.backgroundColor = COLOR_BACK_BLUE;
    complaintTopView.licenseLabel.layer.cornerRadius = CORNERRADIUS;
    complaintTopView.licenseLabel.layer.masksToBounds = YES;
    complaintTopView.licenseLabel.font = [UIFont systemFontOfSize:16.0];
    
    return complaintTopView;
}

@end
