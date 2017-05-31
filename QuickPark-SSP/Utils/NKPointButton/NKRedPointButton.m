//
//  NKRedPointButton.m
//  NKRedPointButtonDemo
//
//  Created by Nick on 2017/5/16.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "NKRedPointButton.h"

@implementation NKRedPointButton

- (instancetype)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

- (void)showBadgeOnButtonWithNumber:(int)index
{
    [self removeBadgeOnItemIndex:index];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
    label.text = [NSString stringWithFormat:@"%li", (long)index];
    label.font = [UIFont systemFontOfSize:10.0];
    label.textColor = COLOR_TITLE_RED;
    label.textAlignment = NSTextAlignmentCenter;
    label.tag = 1000 + index;
    label.layer.cornerRadius = 7;
    label.clipsToBounds = YES;
    label.backgroundColor = [UIColor whiteColor];

    CGFloat x = self.frame.size.width;
    CGFloat y = 0;
    label.center = CGPointMake(x, y);
    
    [self addSubview:label];
    //把小红点移到最顶层
    [self bringSubviewToFront:label];
}

-(void)hideBadgeOnItemIndex:(int)index
{
    [self removeBadgeOnItemIndex:index];
}

- (void)removeBadgeOnItemIndex:(int)index
{
    for (UIView *subView in self.subviews)
    {
        if (subView.tag == 1000 + index)
        {
            [subView removeFromSuperview];
        }
    }
}
@end
