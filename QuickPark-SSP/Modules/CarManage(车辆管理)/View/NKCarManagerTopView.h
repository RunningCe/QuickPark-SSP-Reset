//
//  NKCarManagerTopView.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/12/21.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKCarManagerTopView : UIView

+(instancetype) topView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;
@property (weak, nonatomic) IBOutlet UILabel *licenseLabel;
@property (weak, nonatomic) IBOutlet UIButton *topButton;

@end
