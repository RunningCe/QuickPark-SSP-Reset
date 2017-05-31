//
//  NKEvaluateSubView.h
//  QuickPark-SSP
//
//  Created by Nick on 2017/3/9.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKEvaluateSubView : UIView

+(NKEvaluateSubView *)nk_evaluateSubView;
@property (nonatomic, strong) NSMutableArray *starButtonArray;
@property (nonatomic, strong) NSMutableArray *tagButtonArray;
@property (nonatomic, strong) UILabel *pointLabel;
@property (nonatomic, strong) UIButton *rightArrowButton;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end
