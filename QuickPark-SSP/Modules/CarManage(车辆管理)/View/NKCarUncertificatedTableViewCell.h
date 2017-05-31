//
//  NKCarUncertificatedTableViewCell.h
//  QuickPark-SSP
//
//  Created by Nick on 2017/2/21.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKCarUncertificatedTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *carLicenseLabel;
@property (weak, nonatomic) IBOutlet UILabel *latestParkingNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *latestParkingTimeAndMoneyLabel;

@end
