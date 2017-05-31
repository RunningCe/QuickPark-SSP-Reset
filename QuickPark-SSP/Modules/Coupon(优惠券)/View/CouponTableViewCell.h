//
//  CouponTableViewCell.h
//  QuickPark-SSP
//
//  Created by Nick on 16/9/20.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *leadingImageView;
@property (weak, nonatomic) IBOutlet UIImageView *trailImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyDetailLabel;

@end
