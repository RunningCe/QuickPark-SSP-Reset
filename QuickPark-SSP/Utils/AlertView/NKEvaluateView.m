//
//  NKEvaluateView.m
//  QuickPark-SSP
//
//  Created by Nick on 2017/1/3.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "NKEvaluateView.h"

@implementation NKEvaluateView

+(instancetype) evaluateView
{
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"NKEvaluateView" owner:nil options:nil];
    NKEvaluateView *evaluateView = [objs lastObject];
    
    evaluateView.nameLabel.textColor = COLOR_TITLE_BLACK;
    [evaluateView.totalPointButton setTitleColor:COLOR_TITLE_WHITE forState:UIControlStateNormal];
    [evaluateView.totalPointButton setBackgroundColor:COLOR_MAIN_RED];
    evaluateView.totalPointButton.layer.cornerRadius = 2;
    evaluateView.totalPointButton.layer.masksToBounds = YES;
    evaluateView.parkingTypeLabel.textColor = COLOR_TITLE_GRAY;
    evaluateView.parkingTypeLabel.layer.cornerRadius = 2;
    evaluateView.parkingTypeLabel.layer.masksToBounds = YES;
    evaluateView.parkingTypeLabel.layer.borderColor = COLOR_TITLE_GRAY.CGColor;
    evaluateView.parkingTypeLabel.layer.borderWidth = 1;
    
    evaluateView.starImageArray = [NSArray arrayWithObjects:evaluateView.starImageView_00, evaluateView.starImageView_01, evaluateView.starImageView_02, evaluateView.starImageView_03, evaluateView.starImageView_04,nil];
    
    evaluateView.tagLabelArray = [NSArray arrayWithObjects:evaluateView.tagLabel_00, evaluateView.tagLabel_01, evaluateView.tagLabel_02, evaluateView.tagLabel_10,evaluateView.tagLabel_11, evaluateView.tagLabel_12,nil];
    
    for (UILabel *label in evaluateView.tagLabelArray)
    {
        label.textColor = COLOR_TITLE_GRAY;
        label.layer.cornerRadius = 6;
        label.layer.masksToBounds = YES;
        label.layer.borderColor = COLOR_TITLE_GRAY.CGColor;
        label.layer.borderWidth = 1;
    }
    
    return evaluateView;
}

@end
