//
//  LocalPassportTableViewCell.h
//  QuickPark-SSP
//
//  Created by Nick on 2017/5/3.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LocalPassportCellDelegate <NSObject>

- (void)clickCellButton:(UIButton *)button;

@end

@interface LocalPassportTableViewCell : UITableViewCell

@property (nonatomic, weak) id<LocalPassportCellDelegate> delegate;

- (void)setCellButtonTag:(NSInteger)tag;

- (void)setCellBackColor:(UIColor *)color;

- (void)setCellButtonTitle:(NSString *)title;

- (void)setCellLabelTitle:(NSString *)title;

@end
