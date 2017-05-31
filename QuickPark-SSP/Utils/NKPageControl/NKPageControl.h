//
//  NKPageControl.h
//  QuickPark-SSP
//
//  Created by Nick on 2017/5/8.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger{
    //主页的pageControl
    NKPageControlStyleMain,
    //车辆管理界面的pageControl
    NKPageControlManageCar,
}NKPageControlStyle;

@interface NKPageControl : UIPageControl

- (instancetype)initWithStyle:(NKPageControlStyle)pageControlStyle;


@end
