//
//  NKCollectionViewCell.h
//  QuickPark-SSP
//
//  Created by Nick on 16/8/9.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
@property (weak, nonatomic) IBOutlet UIView *cellView;

@end
