//
//  RepaymentRecordTableViewCell.h
//  QuickPark-SSP
//
//  Created by Nick on 2017/5/18.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepaymentRecordTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *cellBaseView;
@property (weak, nonatomic) IBOutlet UIImageView *tagImageViwe;
@property (weak, nonatomic) IBOutlet UILabel *licenseLabel;
@property (weak, nonatomic) IBOutlet UIImageView *berthIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *berthNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *berthNameDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *berthIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *comingTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *leavingTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *ruleButton;
@property (weak, nonatomic) IBOutlet UILabel *ruleLabel;
@property (weak, nonatomic) IBOutlet UILabel *comingDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *comingWeekLabel;
@property (weak, nonatomic) IBOutlet UILabel *leavingDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *leavingWeekLabel;
@property (weak, nonatomic) IBOutlet UIView *cutLineView;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *chargeDetailButton;
@property (weak, nonatomic) IBOutlet UILabel *chargeDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *selecteButton;

@end
