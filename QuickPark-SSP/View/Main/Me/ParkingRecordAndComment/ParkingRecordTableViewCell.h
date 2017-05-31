//
//  ParkingRecordTableViewCell.h
//  QuickPark-SSP
//
//  Created by Nick on 16/8/12.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParkingRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *baseView;
//place
@property (weak, nonatomic) IBOutlet UIImageView *placeImageView;
@property (weak, nonatomic) IBOutlet UILabel *placeParkingLotLabel;
//time
@property (weak, nonatomic) IBOutlet UIImageView *timeImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//start
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
//stop
@property (weak, nonatomic) IBOutlet UILabel *stopTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stopLabel;
@property (weak, nonatomic) IBOutlet UILabel *stopDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyImageLabel;

@property (weak, nonatomic) IBOutlet UILabel *didPayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *didNotPayImageView;


@property (weak, nonatomic) IBOutlet UIView *starBackView;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView_0;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView_1;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView_2;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView_3;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView_4;


@end
