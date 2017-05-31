//
//  NKCarView.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/11/15.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NKCarViewTypeNew,
    NKCarViewTypeIsCertificating,
    NKCarViewTypeCertificateSuccess,
    NKCarViewTypeCertificateFaile
}NKCarViewType;
@interface NKCarView : UIView

@property (weak, nonatomic) IBOutlet UILabel *parkingMsgLabel;
@property (weak, nonatomic) IBOutlet UILabel *licenseLabel;
@property (weak, nonatomic) IBOutlet UIImageView *carLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *carBrandLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;
@property (weak, nonatomic) IBOutlet UIButton *topButton;

+(instancetype) carViewWithTypeWithType:(NKCarViewType)type;

@end
