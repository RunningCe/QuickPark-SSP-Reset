//
//  NKEvaluateView.h
//  QuickPark-SSP
//
//  Created by Nick on 2017/1/3.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKEvaluateView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *totalPointButton;
@property (weak, nonatomic) IBOutlet UILabel *parkingTypeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *starImageView_00;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView_01;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView_02;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView_03;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView_04;

@property (weak, nonatomic) IBOutlet UILabel *tagLabel_00;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel_01;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel_02;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel_10;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel_11;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel_12;


@property (nonatomic, strong)NSArray *starImageArray;
@property (nonatomic, strong) NSArray *tagLabelArray;

+ (instancetype) evaluateView;

@end
