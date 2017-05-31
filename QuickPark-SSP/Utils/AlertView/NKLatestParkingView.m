//
//  NKLatestParkingView.m
//  QuickPark-SSP
//
//  Created by Nick on 2017/3/13.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "NKLatestParkingView.h"

@implementation NKLatestParkingView

+(instancetype) parkingView
{
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"NKLatestParkingView" owner:nil options:nil];
    
    NKLatestParkingView *parkingView = objs.firstObject;
    parkingView.licenseLabelBaseView.layer.cornerRadius = CORNERRADIUS;
    parkingView.licenseLabelBaseView.layer.masksToBounds = YES;
    parkingView.licenseLabel.layer.cornerRadius = CORNERRADIUS;
    parkingView.licenseLabel.layer.masksToBounds = YES;
    parkingView.licenseLabel.layer.borderWidth = 1;
    parkingView.licenseLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    parkingView.evaluateButton.layer.cornerRadius = CORNERRADIUS;
    parkingView.evaluateButton.layer.masksToBounds = YES;
    
    return parkingView;
}


@end
