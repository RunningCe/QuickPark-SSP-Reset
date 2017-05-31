//
//  HappyParkingOrderdetailTableViewCell.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/10/26.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HappyParkingOrderdetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *colorCardImageView;
@property (weak, nonatomic) IBOutlet UILabel *licenseLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *parkingPlaceImageView;
@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkingNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *baseView;

@end
