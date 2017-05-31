//
//  ChargeDetailSubView.h
//  QuickPark-SSP
//
//  Created by Nick on 2017/1/5.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChargeDetailSubView : UIView

+ (instancetype) chargeDetailSubView;

@property (weak, nonatomic) IBOutlet UILabel *comingTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *comingDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *licenseLabel;
@property (weak, nonatomic) IBOutlet UILabel *leavingTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *leavingDateLabel;
@property (weak, nonatomic) IBOutlet UIView *circleView_left;
@property (weak, nonatomic) IBOutlet UIView *circleView_right;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeAndMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel_0;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel_1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel_2;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel_3;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel_4;
//@property (weak, nonatomic) IBOutlet UILabel *titleLabel_5;//抹零
@property (weak, nonatomic) IBOutlet UILabel *titleLabel_6;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel_7;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel_8;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel_9;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel_0;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel_1;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel_2;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel_3;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel_4;
//@property (weak, nonatomic) IBOutlet UILabel *moneyLabel_5;//抹零
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel_6;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel_7;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel_8;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel_9;

@property (weak, nonatomic) IBOutlet UIButton *complainButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIView *cutlineView_0;
@property (weak, nonatomic) IBOutlet UIView *cutlineView_1;
@property (weak, nonatomic) IBOutlet UIView *cutlineView_2;
@property (weak, nonatomic) IBOutlet UIView *cutlineView_3;
@property (weak, nonatomic) IBOutlet UIView *cutlineView_4;

@end
