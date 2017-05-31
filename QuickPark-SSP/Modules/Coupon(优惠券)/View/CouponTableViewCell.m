//
//  CouponTableViewCell.m
//  QuickPark-SSP
//
//  Created by Nick on 16/9/20.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "CouponTableViewCell.h"

@implementation CouponTableViewCell

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.contentView.frame = bounds;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
