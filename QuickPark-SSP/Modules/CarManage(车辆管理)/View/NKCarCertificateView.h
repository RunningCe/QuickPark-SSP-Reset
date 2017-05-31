//
//  NKCarCertificateView.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/12/28.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKCarCertificateView : UIView

+ (NKCarCertificateView *)carCertificateView;

//****右侧界面****
//品牌型号
@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseCarTypeButton;
//车身颜色
@property (weak, nonatomic) IBOutlet UIButton *carColorButton_0;
@property (weak, nonatomic) IBOutlet UIButton *carColorButton_1;
@property (weak, nonatomic) IBOutlet UIButton *carColorButton_2;
@property (weak, nonatomic) IBOutlet UIButton *carColorButton_3;
@property (weak, nonatomic) IBOutlet UIButton *carColorButton_4;
@property (weak, nonatomic) IBOutlet UIButton *carColorButton_5;
@property (weak, nonatomic) IBOutlet UIButton *carColorButton_6;
@property (weak, nonatomic) IBOutlet UIButton *carColorButton_7;
@property (weak, nonatomic) IBOutlet UIButton *carColorButton_8;
@property (weak, nonatomic) IBOutlet UIButton *carColorButton_9;
@property (nonatomic, strong) NSArray *carColorButtonArray;
//认证照片
@property (weak, nonatomic) IBOutlet UIButton *cardImageButton;
@property (weak, nonatomic) IBOutlet UIButton *handleCardImageButton;
@property (weak, nonatomic) IBOutlet UIButton *explainButton;
@property (weak, nonatomic) IBOutlet UIButton *certificateButton;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UIView *firstSubView;
@property (weak, nonatomic) IBOutlet UIView *secondSubView;
@property (weak, nonatomic) IBOutlet UIView *thirdSubView;

@end
