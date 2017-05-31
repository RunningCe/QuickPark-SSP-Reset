//
//  AddCarsViewController.h
//  QuickPark-SSP
//
//  Created by Nick on 16/8/16.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKUser.h"

@interface AddCarsViewController : UIViewController
//7个textField的数组
@property (nonatomic, strong)NSMutableArray *textFieldMuatableArray;
@property (nonatomic, strong)NKUser *user;

@end
