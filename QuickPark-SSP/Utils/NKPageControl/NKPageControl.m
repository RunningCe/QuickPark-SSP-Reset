//
//  NKPageControl.m
//  QuickPark-SSP
//
//  Created by Nick on 2017/5/8.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "NKPageControl.h"

@interface NKPageControl ()

@property (nonatomic, assign) NKPageControlStyle style;

@end

@implementation NKPageControl

-(instancetype) initWithStyle:(NKPageControlStyle)pageControlStyle
{
    self = [super init];
    
    _style = pageControlStyle;
    
    return self;
}

-(void) updateDots
{
    if (_style == NKPageControlManageCar)
    {
        for (int i = 0; i < self.subviews.count; i++)
        {
            if (i == 0)
            {
                UIView *dot = [self.subviews objectAtIndex:i];
                dot.backgroundColor = [UIColor clearColor];
                UIImageView *imageView;
                if (dot.subviews.count == 0)
                {
                    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, dot.frame.size.width, dot.frame.size.height)];
                    [dot addSubview:imageView];
                }
                else
                {
                    imageView = dot.subviews.firstObject;
                }
                if (i == self.currentPage)
                {
                    imageView.image = [UIImage imageNamed:@"page_main_selected"];
                }
                else
                {
                    imageView.image = [UIImage imageNamed:@"page_main"];
                }
            }
        }
    }
    else if (_style == NKPageControlStyleMain)
    {
        for (int i = 0; i < self.subviews.count; i++)
        {
            if (i == 0)
            {
                UIView* dot = [self.subviews objectAtIndex:i];
                dot.backgroundColor = [UIColor clearColor];
                UIImageView *imageView;
                if (dot.subviews.count == 0)
                {
                    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, dot.frame.size.width, dot.frame.size.height)];
                    [dot addSubview:imageView];
                }
                else
                {
                    imageView = dot.subviews.firstObject;
                }
                if (i == self.currentPage)
                {
                    imageView.image = [UIImage imageNamed:@"page_plus_selected"];
                }
                else
                {
                    imageView.image = [UIImage imageNamed:@"page_plus"];
                }
            }
            if (i == 1)
            {
                UIView* dot = [self.subviews objectAtIndex:i];
                dot.backgroundColor = [UIColor clearColor];
                UIImageView *imageView;
                if (dot.subviews.count == 0)
                {
                    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, dot.frame.size.width, dot.frame.size.height)];
                    [dot addSubview:imageView];
                }
                else
                {
                    imageView = dot.subviews.firstObject;
                }
                if (i == self.currentPage)
                {
                    imageView.image = [UIImage imageNamed:@"page_main_selected"];
                }
                else
                {
                    imageView.image = [UIImage imageNamed:@"page_main"];
                }
            }
        }
    }
}

-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}

@end
