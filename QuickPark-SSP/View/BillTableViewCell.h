//
//  BillTableViewCell.h
//  QuickPark-SSP
//
//  Created by Nick on 16/8/19.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end
