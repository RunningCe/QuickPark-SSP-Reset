//
//  NKCarBrandTableViewCell.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/12/29.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKCarBrandTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *carBrandImageView;
@property (weak, nonatomic) IBOutlet UILabel *carBrandLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end
