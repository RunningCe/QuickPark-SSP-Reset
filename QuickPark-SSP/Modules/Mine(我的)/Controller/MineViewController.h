//
//  MineViewController.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/11/15.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKLogin.h"

@interface MineViewController : UIViewController<UIScrollViewDelegate>
@property (nonatomic, strong)NKLogin *loginMsg;
@end
