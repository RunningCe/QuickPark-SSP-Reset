//
//  NKSlider.m
//  QuickPark-SSP
//
//  Created by Nick on 2016/11/18.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKSlider.h"

@implementation NKSlider


+ (NKSlider *)mySliderInitWithFrame:(CGRect)frame
{
    UIImage *thumbImage = [UIImage imageNamed:@"滑块"];
    UISlider *slider = [[UISlider alloc] initWithFrame:frame];
    
    [slider setThumbImage:thumbImage forState:UIControlStateNormal];
    slider.value = 1.0;
    slider.minimumValue = 0;
    slider.maximumValue = 1.0;
    slider.maximumTrackTintColor = COLOR_VIEW_GRAY;
    slider.minimumTrackTintColor = COLOR_TITLE_RED;
    
    return (NKSlider*)slider;
}

//从xib中加载
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        UIImage *thumbImage = [UIImage imageNamed:@"滑块"];
        
        [self setThumbImage:thumbImage forState:UIControlStateNormal];
        self.value = 1.0;
        self.minimumValue = 0;
        self.maximumValue = 1.0;
        self.maximumTrackTintColor = COLOR_VIEW_GRAY;
        self.minimumTrackTintColor = COLOR_BUTTON_RED;
    }
    return self;
}


@end
