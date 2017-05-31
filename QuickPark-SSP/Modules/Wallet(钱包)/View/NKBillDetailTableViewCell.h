//
//  NKBillDetailTableViewCell.h
//  QuickPark-SSP
//
//  Created by Nick on 2017/2/24.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKBillDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *billTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *billCreateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end
