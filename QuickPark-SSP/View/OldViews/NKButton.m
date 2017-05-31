//
//  NKButton.m
//  myButton
//
//  Created by Jack on 16/8/15.
//  Copyright © 2016年 Jack. All rights reserved.
//

#import "NKButton.h"

@implementation NKButton

- (instancetype)init {
    if (self = [super init]) {
        [self initBigbutton];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initBigbutton];
    }
    return self;
}

- (void)initBigbutton {
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    [self addSubview:self.label];
    [self addSubview:self.detailLabel];
}

#pragma mark -Set

-(void)setLabelTitle:(NSString *)labelTitle
{
    if (_labelTitle != labelTitle) {
        _labelTitle = labelTitle;
        self.label.text = labelTitle;
        [self setNeedsDisplay];
    }
}
-(void)setDetailTitle:(NSString *)detailTitle
{
    if (_detailTitle != detailTitle) {
        _detailTitle = detailTitle;
        self.detailLabel.text = detailTitle;
        [self setNeedsLayout];
    }
}
#pragma mark -Get

-(UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.textColor = [UIColor blackColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:15];
        _label.numberOfLines = 0;
    }
    return _label;
}
-(UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = [UIColor blackColor];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
//    if (_buttontype != BigButtonTypeNormalWithoutTouch && _buttontype != BigButtonTypeRoundWithoutTouch) {
//        _touchView.hidden = NO;
//    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
//    if (_touchView.hidden == NO) {
//        _touchView.hidden = YES;
//    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
//    if (_touchView.hidden == NO) {
//        _touchView.hidden = YES;
//    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self initUI];
}

- (void)initUI {
    
    //文字坐标
    //_titleLabel.frame = CGRectMake(0, buttonImageHeight + imageYLabel, SELFWIDTH, buttonLabelHeight);
    _label.frame = CGRectMake(0, 12, self.bounds.size.width, 16);
    [_label setFont:[UIFont systemFontOfSize:15.0]];
    _label.textAlignment = NSTextAlignmentCenter;
    _detailLabel.frame = CGRectMake(0, 36, self.bounds.size.width, 10);
    [_detailLabel setFont:[UIFont systemFontOfSize:9.0]];
    _detailLabel.textAlignment = NSTextAlignmentCenter;
}
-(instancetype)initWithFrame:(CGRect)frame buttonTitle:(NSString *)title buttonDetaileTitle:(NSString *)buttonDetailTitle
{
    if (self = [super initWithFrame:frame]) {
        _labelTitle = title;
        _detailTitle = buttonDetailTitle;
        self.label.text = self.labelTitle;
        self.detailLabel.text = self.detailTitle; //文本信息
        [self initBigbutton];
    }
    return self;
}


@end
