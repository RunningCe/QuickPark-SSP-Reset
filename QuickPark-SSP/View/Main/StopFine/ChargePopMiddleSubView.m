//
//  chargePopMiddleSubView.m
//  QuickPark-SSP
//
//  Created by Nick on 2016/12/20.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "ChargePopMiddleSubView.h"

@implementation ChargePopMiddleSubView

+ (instancetype)chargePopMiddleSubView
{
    NSBundle *bundle=[NSBundle mainBundle];
    ChargePopMiddleSubView *chargePopMiddleSubView =[bundle loadNibNamed:@"ChargePopMiddleSubView" owner:nil options:nil].lastObject;
    chargePopMiddleSubView.backgroundColor = COLOR_VIEW_BLACK;
    
    return chargePopMiddleSubView;
}

@end
