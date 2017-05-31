//
//  NKTabBar.m
//  MyTabbarTest
//
//  Created by Nick on 2016/11/14.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKTabBar.h"

#define QuickParkButtonW 60
#define QuickParkButtonH 60

@implementation NKTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIButton *quickParkButton = [[UIButton alloc] init];
        quickParkButton.backgroundColor = [UIColor clearColor];
        [quickParkButton setImage:[UIImage imageNamed:@"quickpark"] forState:UIControlStateNormal];
        quickParkButton.layer.cornerRadius = quickParkButton.frame.size.width / 2;
        quickParkButton.layer.masksToBounds = YES;
        CGRect frame = quickParkButton.frame;
        frame.size = CGSizeMake(QuickParkButtonW, QuickParkButtonH);
        quickParkButton.frame = frame;
        [quickParkButton addTarget:self action:@selector(quickParkButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:quickParkButton];
        [self bringSubviewToFront:quickParkButton];
        self.quickParkButton = quickParkButton;
    }
    return self;
}
- (void)quickParkButtonClicked
{
    //通知代理
    if ([self.tabBarDelegate respondsToSelector:@selector(tabBarDidClickQuickParkButton:)])
    {
        [self.tabBarDelegate tabBarDidClickQuickParkButton:self];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置中间按钮的位置
    CGPoint centerPoint = self.quickParkButton.center;
    centerPoint.x = self.frame.size.width / 2;
    centerPoint.y = self.frame.size.height / 2 - 10;
    self.quickParkButton.center = centerPoint;
    
    //设置其他tabbarButton的位置和尺寸
    CGFloat tabBarButtonW = (self.frame.size.width - QuickParkButtonW) / 2;
    CGFloat tabBarButtonindex = 0;
    
    for (UIView *child in self.subviews)
    {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class])
        {
            if (tabBarButtonindex == 2)
            {
                CGRect frame = child.frame;
                frame.size.width = tabBarButtonW;
                frame.origin.x = (tabBarButtonindex - 1) * tabBarButtonW + QuickParkButtonW;
                child.frame = frame;
                tabBarButtonindex++;
                break;
            }
            CGRect frame = child.frame;
            frame.size.width = tabBarButtonW;
            frame.origin.x = tabBarButtonindex * tabBarButtonW;
            child.frame = frame;
            tabBarButtonindex++;
            if (tabBarButtonindex == 1)
            {
                tabBarButtonindex++;
            }
        }
    }
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isKindOfClass:NSClassFromString(@"UIButton")])
    {
        CGPoint newPoint = [self.quickParkButton convertPoint:point fromView:self];
        if (CGRectContainsPoint(self.quickParkButton.bounds, newPoint))
        {
            view = self.quickParkButton;
        }
    }
    return view;
}
@end
