//
//  NKCarManagerTopFirstView.m
//  QuickPark-SSP
//
//  Created by Nick on 2017/2/20.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "NKCarManagerTopFirstView.h"

@implementation NKCarManagerTopFirstView

+(instancetype) topFirstView
{
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"NKCarManagerTopFirstView" owner:nil options:nil];
    NKCarManagerTopFirstView *topView = objs.lastObject;
    
    topView.iconImageView.layer.cornerRadius = topView.iconImageView.frame.size.width / 2;
    topView.iconImageView.layer.masksToBounds = YES;
    
    return topView;
}


@end
