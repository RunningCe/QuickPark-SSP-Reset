//
//  NKButton.h
//  myButton
//
//  Created by Jack on 16/8/15.
//  Copyright © 2016年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKButton : UIControl

//定义按钮上的两个label和文字
@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)UILabel *detailLabel;
@property (nonatomic, copy)NSString *labelTitle;
@property (nonatomic, copy)NSString *detailTitle;

- (instancetype)initWithFrame:(CGRect)frame buttonTitle:(NSString *)title buttonDetaileTitle:(NSString *)buttonDetailTitle;

@end
