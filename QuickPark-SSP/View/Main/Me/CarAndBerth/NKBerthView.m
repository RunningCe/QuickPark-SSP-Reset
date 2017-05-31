//
//  NKBerthView.m
//  QuickPark-SSP
//
//  Created by Nick on 2016/11/15.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKBerthView.h"

@implementation NKBerthView

+(instancetype) berthView
{
    NSBundle *bundle=[NSBundle mainBundle];
    NKBerthView *berthView =[bundle loadNibNamed:@"NKBerthView" owner:nil options:nil].lastObject;
    berthView.backgroundColor = COLOR_VIEW_BLACK;
    
    berthView.parkingMsgLabel.textColor = COLOR_TITLE_GRAY;
    berthView.berthNameLabel.textColor = COLOR_TITLE_WHITE;
    berthView.berthAddressLabel.textColor = COLOR_TITLE_WHITE;
    berthView.berthNoBaseView.backgroundColor = COLOR_VIEW_BLACK;
    
    berthView.numberLabel_0.backgroundColor = COLOR_BACK_GRAY;
    berthView.numberLabel_0.textColor = COLOR_TITLE_BLACK;
    berthView.numberLabel_0.layer.cornerRadius = CORNERRADIUS;
    berthView.numberLabel_0.layer.masksToBounds = YES;
    berthView.numberLabel_1.backgroundColor = COLOR_BACK_GRAY;
    berthView.numberLabel_1.textColor = COLOR_TITLE_BLACK;
    berthView.numberLabel_1.layer.cornerRadius = CORNERRADIUS;
    berthView.numberLabel_1.layer.masksToBounds = YES;
    berthView.numberLabel_2.backgroundColor = COLOR_BACK_GRAY;
    berthView.numberLabel_2.textColor = COLOR_TITLE_BLACK;
    berthView.numberLabel_2.layer.cornerRadius = CORNERRADIUS;
    berthView.numberLabel_2.layer.masksToBounds = YES;
    berthView.numberLabel_3.backgroundColor = COLOR_BACK_GRAY;
    berthView.numberLabel_3.textColor = COLOR_TITLE_BLACK;
    berthView.numberLabel_3.layer.cornerRadius = CORNERRADIUS;
    berthView.numberLabel_3.layer.masksToBounds = YES;
    
    return berthView;
}

@end
