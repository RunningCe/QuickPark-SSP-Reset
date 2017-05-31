//
//  NKEvaluateSubView.m
//  QuickPark-SSP
//
//  Created by Nick on 2017/3/9.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "NKEvaluateSubView.h"
#import "Masonry.h"

@implementation NKEvaluateSubView

+(NKEvaluateSubView *)nk_evaluateSubView
{
    NKEvaluateSubView *evaluateView = [[NKEvaluateSubView alloc] init];
    
    //头像
    UIImageView *iconImageView = [[UIImageView alloc] init];
    evaluateView.iconImageView = iconImageView;
    [evaluateView addSubview:iconImageView];
    iconImageView.image = [UIImage imageNamed:@"头像"];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(evaluateView.mas_left).offset(12);
        make.top.equalTo(evaluateView.mas_top).offset(12);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    //名称
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 14)];
    evaluateView.nameLabel = nameLabel;
    [evaluateView addSubview:nameLabel];
    nameLabel.text = @"";
    nameLabel.textColor = COLOR_TITLE_BLACK;
    nameLabel.font = [UIFont systemFontOfSize:14.0];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).offset(12);
        make.top.equalTo(iconImageView.mas_top);
    }];
    //星级
    UIButton *pointButton = [[UIButton alloc] init];
    [evaluateView addSubview:pointButton];
    [pointButton setImage:[UIImage imageNamed:@"总分star"] forState:UIControlStateNormal];
    [pointButton setTitle:@"5.0" forState:UIControlStateNormal];
    [pointButton setTitleColor:COLOR_TITLE_WHITE forState:UIControlStateNormal];
    pointButton.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [pointButton setBackgroundColor:COLOR_MAIN_RED];
    pointButton.layer.cornerRadius = 2;
    pointButton.layer.masksToBounds = YES;
    [pointButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_left);
        make.top.equalTo(nameLabel.mas_bottom).offset(8);
        make.size.mas_equalTo(CGSizeMake(42, 14));
    }];
    //右箭头
    evaluateView.rightArrowButton = [[UIButton alloc] init];
    [evaluateView addSubview:evaluateView.rightArrowButton];
    [evaluateView.rightArrowButton setImage:[UIImage imageNamed:@"evaluate_arrow_right"] forState:UIControlStateNormal];
    [evaluateView.rightArrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(evaluateView.mas_right).offset(-12);
        make.top.equalTo(evaluateView.mas_top).offset(20);
        make.size.mas_equalTo(CGSizeMake(20, 40));
    }];
    
    //星星
    CGFloat btnW = 22;
    CGFloat spc = 16;
    evaluateView.starButtonArray  = [NSMutableArray array];
    for (int i = 0; i < 5; i++)
    {
        UIButton *starButton = [[UIButton alloc] init];
        [starButton setImage:[UIImage imageNamed:@"evaluate_star_normal"] forState:UIControlStateNormal];
        [starButton setImage:[UIImage imageNamed:@"evaluate_star_select"] forState:UIControlStateSelected];
        [evaluateView addSubview:starButton];
        [starButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(evaluateView.mas_left).offset(60 + (btnW + spc) * i);
            make.top.equalTo(pointButton.mas_bottom).offset(16);
            make.size.mas_equalTo(CGSizeMake(btnW, btnW));
        }];
        [evaluateView.starButtonArray addObject:starButton];
    }
    //分数
    evaluateView.pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 12)];
    [evaluateView addSubview:evaluateView.pointLabel];
    evaluateView.pointLabel.text = @"0分";
    evaluateView.pointLabel.textColor = COLOR_TITLE_GRAY;
    evaluateView.pointLabel.font = [UIFont systemFontOfSize:12.0];
    [evaluateView.pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(evaluateView.mas_left).offset(60 + 38 * 5);
        make.top.equalTo(pointButton.mas_bottom).offset(20);
        make.height.equalTo(@12);
    }];
    
    //评价button
    CGFloat tagBtnW = (WIDTH_VIEW - 60) / 3;
    CGFloat tagSpc = 6;
    evaluateView.tagButtonArray = [NSMutableArray array];
    for (int i = 0; i < 2; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            UIButton *tagButton = [[UIButton alloc] init];
            [tagButton setTitle:@"充满活力" forState:UIControlStateNormal];
            [tagButton setTitleColor:COLOR_TITLE_GRAY forState:UIControlStateNormal];
            [tagButton setTitleColor:COLOR_TITLE_RED forState:UIControlStateSelected];
            tagButton.layer.cornerRadius = 11;
            tagButton.layer.masksToBounds = YES;
            tagButton.layer.borderWidth = 1;
            tagButton.layer.borderColor = COLOR_TITLE_GRAY.CGColor;
            tagButton.titleLabel.font = [UIFont systemFontOfSize:10.0];
            tagButton.hidden = YES;
            [evaluateView addSubview:tagButton];
            [tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(evaluateView.mas_left).offset(30 + (tagBtnW + tagSpc) * j);
                make.top.equalTo(pointButton.mas_bottom).offset(60 + 30 * i);
                make.size.mas_equalTo(CGSizeMake(tagBtnW, 22));
            }];
            [evaluateView.tagButtonArray addObject:tagButton];
        }
    }
    
    return evaluateView;
}

@end
