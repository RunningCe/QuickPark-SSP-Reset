//
//  ManageCarViewController.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/12/14.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NKLogin;

@interface ManageCarViewController : UIViewController

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NKLogin *loginMsg;
@property (nonatomic, strong) NSMutableArray *recordMutableArray;

@end
