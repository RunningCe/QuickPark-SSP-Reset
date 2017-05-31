//
//  MassageCenterTableViewCell.m
//  QuickPark-SSP
//
//  Created by Nick on 16/8/22.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "MassageCenterTableViewCell.h"

@interface MassageCenterTableViewCell()

@end

@implementation MassageCenterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.label_0.textColor = COLOR_TITLE_BLACK;
    self.label_1.textColor = COLOR_TITLE_BLACK;
    self.label_2.textColor = COLOR_TITLE_BLACK;
    self.label_3.textColor = COLOR_TITLE_BLACK;
    self.detailLabel_0.textColor = COLOR_TITLE_GRAY;
    self.detailLabel_1.textColor = COLOR_TITLE_GRAY;
    self.detailLabel_2.textColor = COLOR_TITLE_GRAY;
    self.detailLabel_3.textColor = COLOR_TITLE_GRAY;
    [self.detailButton setTitleColor:COLOR_TITLE_BLACK forState:UIControlStateNormal];
    
    self.baseView.layer.cornerRadius = CORNERRADIUS;
    self.baseView.layer.masksToBounds = YES;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //初始化时从xib文件中加载
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"MassageCenterTableViewCell" owner:self options:nil];
        //如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        //如果cell的类型不对
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[MassageCenterTableViewCell class]])
        {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
    }
    
    
    return self;
}
- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.contentView.frame = bounds;
}


@end
