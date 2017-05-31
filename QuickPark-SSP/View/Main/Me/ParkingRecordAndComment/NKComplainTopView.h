//
//  NKComplainTopView.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/11/30.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKComplainTopView : UIView

+(instancetype) complainTopView;

@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UIView *cutLineView;
@property (weak, nonatomic) IBOutlet UIView *circleView0;
@property (weak, nonatomic) IBOutlet UIView *circleView1;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *licenseLabel;

@end
