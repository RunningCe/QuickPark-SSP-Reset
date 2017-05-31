//
//  LocalPassportTableViewCell.m
//  QuickPark-SSP
//
//  Created by Nick on 2017/5/3.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "LocalPassportTableViewCell.h"
#import "Masonry.h"

@interface LocalPassportTableViewCell ()

@property (nonatomic, strong) UIButton *cellButton;

@property (nonatomic, strong) UIView *baseView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation LocalPassportTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIView *baseView = [[UIView alloc] init];
        _baseView = baseView;
        [self addSubview:baseView];
        baseView.layer.cornerRadius = CORNERRADIUS;
        baseView.layer.masksToBounds = YES;
        [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(14);
            make.left.equalTo(self.mas_left).offset(36);
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self.mas_right).offset(-36);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 18)];
        _titleLabel = titleLabel;
        [baseView addSubview:titleLabel];
        titleLabel.text = @"其他账户";
        titleLabel.font = [UIFont systemFontOfSize:18.0];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(baseView.mas_left);
            make.top.equalTo(baseView.mas_top).offset(23);
            make.right.equalTo(baseView.mas_right);
            make.height.equalTo(@18);
        }];
        
        UIView *cutline = [[UIView alloc] init];
        [self addSubview:cutline];
        cutline.backgroundColor = [UIColor whiteColor];
        [cutline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(23);
            make.left.equalTo(baseView.mas_left);
            make.right.equalTo(baseView.mas_right);
            make.height.mas_equalTo(0.5);
        }];
        
        UIButton *cellButton = [[UIButton alloc] init];
        _cellButton = cellButton;
        [self addSubview:cellButton];
        [cellButton setTitle:@"绑定" forState:UIControlStateNormal];
        cellButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [cellButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cellButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(baseView.mas_left);
            make.top.equalTo(cutline.mas_bottom);
            make.right.equalTo(baseView.mas_right);
            make.height.equalTo(@36);
        }];
        [cellButton addTarget:self action:@selector(clickMyCellButton:) forControlEvents:UIControlEventTouchUpInside];
        
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void)clickMyCellButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(clickCellButton:)])
    {
        [self.delegate clickCellButton:button];
    }
}

- (void)setCellButtonTag:(NSInteger)tag
{
    self.cellButton.tag = tag;
}

- (void)setCellBackColor:(UIColor *)color
{
    self.baseView.backgroundColor = color;
}

- (void)setCellButtonTitle:(NSString *)title
{
    [self.cellButton setTitle:title forState:UIControlStateNormal];
}

- (void)setCellLabelTitle:(NSString *)title
{
    _titleLabel.text = title;
}

@end
