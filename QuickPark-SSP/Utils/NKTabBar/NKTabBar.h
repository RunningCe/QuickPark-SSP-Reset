//
//  NKTabBar.h
//  MyTabbarTest
//
//  Created by Nick on 2016/11/14.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NKTabBar;

@protocol NKTabBarDelegate <UITabBarDelegate>

@optional

- (void)tabBarDidClickQuickParkButton:(NKTabBar *)tabBar;

@end

@interface NKTabBar : UITabBar

@property (nonatomic, strong) UIButton *quickParkButton;
@property (nonatomic, weak) id <NKTabBarDelegate> tabBarDelegate;

@end
