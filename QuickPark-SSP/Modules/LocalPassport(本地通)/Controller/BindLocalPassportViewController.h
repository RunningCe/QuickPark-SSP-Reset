//
//  BindLocalPassportViewController.h
//  QuickPark-SSP
//
//  Created by Nick on 2017/5/4.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NKLocalPassportUnbindDto;

@interface BindLocalPassportViewController : UIViewController

- (instancetype)initWithLocalPassport:(NKLocalPassportUnbindDto *)bindDto;

@end
