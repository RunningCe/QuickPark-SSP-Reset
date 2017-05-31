//
//  NKBillDetailTableViewCell.m
//  QuickPark-SSP
//
//  Created by Nick on 2017/2/24.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "NKBillDetailTableViewCell.h"

@implementation NKBillDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.billTypeLabel.textColor = COLOR_TITLE_BLACK;
    self.billCreateTimeLabel.textColor = COLOR_TITLE_GRAY;
    self.moneyLabel.textColor = COLOR_TITLE_BLACK;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
