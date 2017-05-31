//
//  NKOneKeyStopCarBottomView.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/11/21.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKSlider.h"

@interface NKOneKeyStopCarBottomView : UIView

@property (weak, nonatomic) IBOutlet UILabel *poiNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *poiAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel_0;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel_1;
@property (weak, nonatomic) IBOutlet UILabel *callMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *minMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxMoneyLabel;
@property (weak, nonatomic) IBOutlet NKSlider *moneySlider;
@property (weak, nonatomic) IBOutlet NKSlider *distanceSlider;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel_0;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel_1;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel_2;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel_3;
@property (weak, nonatomic) IBOutlet UIButton *quickParkButton;
@property (weak, nonatomic) IBOutlet UILabel *retainTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *topButton;

//文字
@property (weak, nonatomic) IBOutlet UILabel *textBasicMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *textTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *textRadiusLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLeftTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLeftBottomLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomRightTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomRightBottomLabel;

//两个约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFirst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintSecond;

+(instancetype) bottomView;

@end
