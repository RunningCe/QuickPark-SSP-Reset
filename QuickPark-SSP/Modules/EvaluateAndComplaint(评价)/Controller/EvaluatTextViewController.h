//
//  EvaluatTextViewController.h
//  QuickPark-SSP
//
//  Created by Nick on 2016/11/29.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EvaluatTextViewControllerDelegate <NSObject>

- (void)getSaySomethingString:(NSString *)string;

@end

@interface EvaluatTextViewController : UIViewController

@property (nonatomic, weak) id <EvaluatTextViewControllerDelegate>delegate;

@end
