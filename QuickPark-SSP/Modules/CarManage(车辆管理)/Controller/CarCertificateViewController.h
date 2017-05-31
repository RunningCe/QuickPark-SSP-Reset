//
//  CarCertificateViewController.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/12/29.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NKCar;

@interface CarCertificateViewController : UIViewController

@property (nonatomic, strong)NKCar *currentCar;
@property (nonatomic, strong)NSMutableArray *carsArray;

@end
