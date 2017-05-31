//
//  NKLatestParkingView.h
//  QuickPark-SSP
//
//  Created by Nick on 2017/3/13.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKLatestParkingView : UIView

@property (weak, nonatomic) IBOutlet UIView *licenseLabelBaseView;
@property (weak, nonatomic) IBOutlet UILabel *licenseLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkingNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkingTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivingTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *leavingTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivingDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *leavingDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *evaluateButton;

+(instancetype) parkingView;

@end
