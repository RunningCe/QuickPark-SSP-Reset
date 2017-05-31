//
//  IsParkingTableViewCell.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/12/13.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IsParkingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *cellBaseView;
@property (weak, nonatomic) IBOutlet UIImageView *tagImageViwe;
@property (weak, nonatomic) IBOutlet UILabel *licenseLabel;
@property (weak, nonatomic) IBOutlet UIImageView *berthIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *berthNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *berthNameDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *berthIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *comingTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mepNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *ruleButton;
@property (weak, nonatomic) IBOutlet UILabel *ruleLabel;
@property (weak, nonatomic) IBOutlet UILabel *comingDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *comingWeekLabel;
@property (weak, nonatomic) IBOutlet UIView *cutLineView;
@property (weak, nonatomic) IBOutlet UIButton *mepStarButton;
@property (weak, nonatomic) IBOutlet UIButton *callPhoneButton;
@property (weak, nonatomic) IBOutlet UIButton *sunshadeButton;
@property (weak, nonatomic) IBOutlet UIButton *washCarButton;
@property (weak, nonatomic) IBOutlet UIButton *batteryChargingButton;
@property (weak, nonatomic) IBOutlet UIButton *checkCarButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel_0;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel_1;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel_2;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel_3;

@end
