//
//  NKBerthView.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/11/15.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKBerthView : UIView
@property (weak, nonatomic) IBOutlet UILabel *parkingMsgLabel;
@property (weak, nonatomic) IBOutlet UIImageView *berthLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *berthNameLabel;
@property (weak, nonatomic) IBOutlet UIView *berthNoBaseView;
@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;
@property (weak, nonatomic) IBOutlet UILabel *berthAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel_0;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel_1;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel_2;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel_3;
@property (weak, nonatomic) IBOutlet UIButton *topButton;

+(instancetype) berthView;

@end
