//
//  OneKeyStopCarNavigationViewController.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/10/9.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import "SpeechSynthesizer.h"
//#import "MoreMenuView.h"
#import "NKSspOrderParameters.h"

@interface OneKeyStopCarNavigationViewController : UIViewController

-(instancetype)initWithParameters:(NKSspOrderParameters *)parameters andStarPoint:(AMapNaviPoint *)startPoint andCountDownTime:(NSInteger) countDownTime;

@end
