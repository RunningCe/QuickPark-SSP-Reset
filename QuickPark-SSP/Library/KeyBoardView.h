//
//  KeyBoardView.h
//  MyKeyboardDemo
//
//  Created by laitang on 16/4/28.
//  Copyright © 2016年 laitang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    NKKeyBoardProvinceName,//省份键盘
    NKKeyBoardNumber//数字，字母键盘
} NKKeyBoardType;

@protocol KeyBoardViewDelegate <NSObject>

- (void)passValueWithButton:(UIButton *)button;

@end

@interface KeyBoardView : UIView

-(instancetype)initWithFrame:(CGRect)frame andType:(NKKeyBoardType)type;

@property (nonatomic, assign)id<KeyBoardViewDelegate> delegate;

@end
