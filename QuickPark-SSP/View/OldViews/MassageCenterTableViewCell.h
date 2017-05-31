//
//  MassageCenterTableViewCell.h
//  QuickPark-SSP
//
//  Created by Nick on 16/8/22.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MassageCenterTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *label_0;
@property (weak, nonatomic) IBOutlet UILabel *label_1;
@property (weak, nonatomic) IBOutlet UILabel *label_2;
@property (weak, nonatomic) IBOutlet UILabel *label_3;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel_0;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel_1;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel_2;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel_3;

@property (weak, nonatomic) IBOutlet UIButton *detailButton;


@end
