//
//  NKCarManagerTopFirstView.h
//  QuickPark-SSP
//
//  Created by Nick on 2017/2/20.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKCarManagerTopFirstView : UIView

+(instancetype) topFirstView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *niNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *topButton;

@end
