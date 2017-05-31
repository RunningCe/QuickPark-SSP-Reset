//
//  NKRedPointButton.h
//  NKRedPointButtonDemo
//
//  Created by Nick on 2017/5/16.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NKRedPointButton : UIButton

- (void)showBadgeOnButtonWithNumber:(int)index;

-(void)hideBadgeOnItemIndex:(int)index;

@end
