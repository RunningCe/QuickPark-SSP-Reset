//
//  NKCarManagerTopView.m
//  QuickPark-SSP
//
//  Created by Nick on 2016/12/21.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKCarManagerTopView.h"

@implementation NKCarManagerTopView

+(instancetype) topView
{
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"NKCarManagerTopView" owner:nil options:nil];
    NKCarManagerTopView *topView = objs.lastObject;
    topView.licenseLabel.layer.cornerRadius = CORNERRADIUS;
    topView.licenseLabel.layer.masksToBounds = YES;
    topView.licenseLabel.layer.borderColor = COLOR_VIEW_WHITE.CGColor;
    topView.licenseLabel.layer.borderWidth = 1;
    topView.licenseLabel.backgroundColor = COLOR_BACK_BLUE;
    
    return topView;
}

@end
