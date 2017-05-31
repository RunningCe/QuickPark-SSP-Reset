//
//  NKCarCertificateView.m
//  QuickPark-SSP
//
//  Created by Nick on 2016/12/28.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKCarCertificateView.h"

@implementation NKCarCertificateView

- (NSArray *)carColorButtonArray
{
    if (_carColorButtonArray == nil)
    {
        _carColorButtonArray = @[_carColorButton_0, _carColorButton_1, _carColorButton_2, _carColorButton_3, _carColorButton_4, _carColorButton_5, _carColorButton_6, _carColorButton_7, _carColorButton_8, _carColorButton_9];
    }
    return _carColorButtonArray;
}

+ (NKCarCertificateView *)carCertificateView
{
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"NKCarCertificateView" owner:nil options:nil];
    NKCarCertificateView *certificateView = objs.lastObject;
    //右侧页面
    //品牌型号
    //车身颜色
    for (int i = 0; i < certificateView.carColorButtonArray.count; i++)
    {
        UIButton *button = certificateView.carColorButtonArray[i];
        button.layer.cornerRadius = button.frame.size.width / 2;
        button.layer.masksToBounds = YES;
        [button setImage:[UIImage imageNamed:@"addCar_车身颜色选中"] forState:UIControlStateSelected];
        button.tag = 900 + i;
        if (i == 0)
        {
            button.layer.borderColor = [UIColor grayColor].CGColor;
            button.layer.borderWidth = 1;
        }
    }
    //照片
    certificateView.cardImageButton.layer.cornerRadius = CORNERRADIUS;
    certificateView.cardImageButton.layer.masksToBounds = YES;
    certificateView.cardImageButton.layer.borderWidth = 1;
    certificateView.cardImageButton.layer.borderColor = [UIColor grayColor].CGColor;
    certificateView.cardImageButton.tag = 1000;
    
    certificateView.handleCardImageButton.layer.cornerRadius = CORNERRADIUS;
    certificateView.handleCardImageButton.layer.masksToBounds = YES;
    certificateView.handleCardImageButton.layer.borderWidth = 1;
    certificateView.handleCardImageButton.layer.borderColor = [UIColor grayColor].CGColor;
    certificateView.handleCardImageButton.tag = 1001;
    
    certificateView.msgLabel.hidden = YES;
    certificateView.firstSubView.hidden = NO;
    certificateView.secondSubView.hidden = NO;
    certificateView.thirdSubView.hidden = NO;
    
    return certificateView;
}

@end
