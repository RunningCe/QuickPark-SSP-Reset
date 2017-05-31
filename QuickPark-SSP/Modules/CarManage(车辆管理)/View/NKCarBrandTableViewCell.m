//
//  NKCarBrandTableViewCell.m
//  QuickPark-SSP
//
//  Created by Nick on 2016/12/29.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKCarBrandTableViewCell.h"

@implementation NKCarBrandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.carBrandLabel.textColor = COLOR_TITLE_BLACK;
    self.bottomLineView.backgroundColor = BACKGROUND_COLOR;
}

@end
