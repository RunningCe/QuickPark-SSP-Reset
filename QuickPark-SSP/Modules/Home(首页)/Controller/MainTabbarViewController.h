//
//  NKTabbarViewController.h
//  MyTabbarTest
//
//  Created by Nick on 2016/11/14.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKLogin.h"

@interface MainTabbarViewController : UITabBarController

@property (nonatomic, strong)NKLogin *loginMsg;

-(instancetype)initWithLoginMsg:(NKLogin *)loginMsg;

@end
