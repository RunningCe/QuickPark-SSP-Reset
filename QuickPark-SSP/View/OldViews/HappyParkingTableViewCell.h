//
//  HappyParkingTableViewCell.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/10/24.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HappyParkingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *BaseView;
@property (weak, nonatomic) IBOutlet UIImageView *parkImageView;
@property (weak, nonatomic) IBOutlet UILabel *parkNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *parkTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkBerthLabel;
@property (weak, nonatomic) IBOutlet UIButton *storeCarButton;
@property (weak, nonatomic) IBOutlet UIButton *takeoutCarButton;


@end
