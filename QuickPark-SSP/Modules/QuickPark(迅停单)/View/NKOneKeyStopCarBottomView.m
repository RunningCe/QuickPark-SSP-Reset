//
//  NKOneKeyStopCarBottomView.m
//  QuickPark-SSP
//
//  Created by Nick on 2016/11/21.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKOneKeyStopCarBottomView.h"

@interface NKOneKeyStopCarBottomView()


@end

@implementation NKOneKeyStopCarBottomView

+(instancetype) bottomView
{
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"NKOneKeyStopCarBottomView" owner:nil options:nil];
    
    NKOneKeyStopCarBottomView *view = [objs lastObject];
    view.poiAddressLabel.textColor = COLOR_TITLE_GRAY;
    view.callMoneyLabel.textColor = COLOR_TITLE_GRAY;
    view.minMoneyLabel.textColor = COLOR_TITLE_GRAY;
    view.maxMoneyLabel.textColor = COLOR_TITLE_GRAY;
    view.textBasicMoneyLabel.textColor = COLOR_TITLE_GRAY;
    view.textTipLabel.textColor = COLOR_TITLE_GRAY;
    view.textRadiusLabel.textColor = COLOR_TITLE_GRAY;
    
    view.bottomLeftTopLabel.textColor = COLOR_TITLE_GRAY;
    view.bottomLeftBottomLabel.textColor = COLOR_TITLE_GRAY;
    view.bottomRightTopLabel.textColor = COLOR_TITLE_GRAY;
    view.bottomRightBottomLabel.textColor = COLOR_TITLE_GRAY;
    
    return view;
}
@end
