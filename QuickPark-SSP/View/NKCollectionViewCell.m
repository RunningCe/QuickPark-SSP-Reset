//
//  NKCollectionViewCell.m
//  QuickPark-SSP
//
//  Created by Nick on 16/8/9.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKCollectionViewCell.h"

@implementation NKCollectionViewCell

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
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"NKCollectionViewCell" owner:self options:nil];
        //如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        //如果cell的类型不对
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[NKCollectionViewCell class]])
        {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
    }
    //cell 的基本设置
    //view背景
    self.cellView.backgroundColor = [UIColor whiteColor];
    //label文字颜色#454545
    self.cellLabel.textColor = TITLE_COLOR_DEEP;
    
    return self;
}
- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.contentView.frame = bounds;
}


@end
