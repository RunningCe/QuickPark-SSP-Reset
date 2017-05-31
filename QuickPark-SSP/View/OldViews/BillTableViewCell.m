//
//  BillTableViewCell.m
//  QuickPark-SSP
//
//  Created by Nick on 16/8/19.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "BillTableViewCell.h"

@interface BillTableViewCell()




@end

@implementation BillTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //初始化时从xib文件中加载
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"BillTableViewCell" owner:self options:nil];
        //如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        //如果cell的类型不对
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[BillTableViewCell class]])
        {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
    }
    //cell 的基本设置
    _label.backgroundColor = TITLE_COLOR_DEEP;
    
    return self;
}
- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.contentView.frame = bounds;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
