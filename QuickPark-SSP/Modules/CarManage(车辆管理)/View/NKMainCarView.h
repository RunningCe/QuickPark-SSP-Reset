//
//  NKMainCarView.h
//  QuickPark-SSP
//
//  Created by Nick on 2017/2/21.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKMainCarView : UIView

typedef enum{
    NKMainCarViewTypeNew = 0,
    NKMainCarViewTypeIsCertificating = 1,
    NKMainCarViewTypeCertificateSuccess = 2,
    NKMainCarViewTypeCertificateFaile = 3
} NKMainCarViewType;

+ (instancetype)mainCarViewWithType:(NKMainCarViewType)type;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *carLicenseLabel;
@property (weak, nonatomic) IBOutlet UILabel *latestParkingNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *latestParkingTimeAndMoneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *carBrandImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carBrandImageViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carBrandImageViewAndLicenceLabelSpc;

@end
