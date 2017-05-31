//
//  KeyBoardView.m
//  MyKeyboardDemo
//
//  Created by laitang on 16/4/28.
//  Copyright © 2016年 laitang. All rights reserved.
//

#import "KeyBoardView.h"

#define kWidth self.frame.size.width
#define kHeight self.frame.size.height
#define ButtonWidth ((kWidth - 16)/9 - 1)
#define ButtonHeight ((kWidth - 16)/9/7*8)
#define ButtonWidth_s ((kWidth - 16)/10 - 1)
#define ButtonHeight_s ((kWidth - 16)/10/7*8)

@interface KeyBoardView ()
@property (nonatomic, strong)NSMutableArray *numberArray;
@property (nonatomic, strong)NSMutableArray *provinceArray;


@end

@implementation KeyBoardView
-(instancetype)initWithFrame:(CGRect)frame andType:(NKKeyBoardType)type;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.provinceArray = [@[@"京", @"津", @"沪", @"渝", @"冀", @"豫", @"云", @"辽", @"黑",
                              @"湘", @"皖", @"鲁",@"新", @"苏", @"浙", @"赣", @"鄂", @"桂", @"甘", @"晋",
                              @"蒙", @"陕",@"吉", @"闽", @"贵", @"粤", @"青", @"藏", @"川", @"宁", @"琼",@"港", @"澳", @"台"] mutableCopy];
        self.numberArray = [@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9",
                              @"0", @"Q", @"W",@"E", @"R", @"T", @"Y", @"U", @"I", @"O", @"P",
                              @"A", @"S",@"D", @"F", @"G", @"H", @"J", @"K", @"L", @"Z", @"X",@"C", @"V", @"B",@"N", @"M", @"←"] mutableCopy];
        [self setUpMyKeyBoardWithType:type];

    }
    return self;
}

- (void)setUpMyKeyBoardWithType:(NKKeyBoardType)type
{
    if (type == NKKeyBoardProvinceName)
    {
        NSInteger index = 0;
        for (NSInteger i = 0; i < 4; i++) {
            for (NSInteger j = 0; j < 9; j++) {
                if (i == 3 && j == 0)
                {
                    j++;
                }
                if (i == 3 && j == 8)
                {
                    break;
                }
                UIButton *keyButton = [UIButton buttonWithType:UIButtonTypeCustom];
                keyButton.backgroundColor = [UIColor whiteColor];
                [keyButton setTitleColor:[UIColor colorWithRed:69.0/255.0 green:69.0/255.0 blue:69.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                keyButton.frame = CGRectMake(((ButtonWidth+3)*j), 3+((ButtonHeight+3) *i), ButtonWidth, ButtonHeight);
                [keyButton setTitle:_provinceArray[index] forState:UIControlStateNormal];
                keyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
                keyButton.tag = 4000+index;
                [keyButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
                [keyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                keyButton.layer.cornerRadius = CORNERRADIUS;
                keyButton.layer.masksToBounds = YES;
                [keyButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:keyButton];
                
                index++;
            }
            
        }

    }
    else if (type == NKKeyBoardNumber)
    {
        NSInteger index = 0;
        for (NSInteger i = 0; i < 4; i++) {
            for (NSInteger j = 0; j < 10; j++) {
                if (i == 0 || i == 1)//第一行，第二行
                {
                    UIButton *keyButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    keyButton.backgroundColor = [UIColor whiteColor];
                    [keyButton setTitleColor:[UIColor colorWithRed:69.0/255.0 green:69.0/255.0 blue:69.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                    keyButton.frame = CGRectMake(((ButtonWidth_s+3)*j), 3+((ButtonHeight_s+3) *i), ButtonWidth_s, ButtonHeight_s);
                    [keyButton setTitle:_numberArray[index] forState:UIControlStateNormal];
                    keyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
                    keyButton.tag = 5000+index;
                    [keyButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
                    [keyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    keyButton.layer.cornerRadius = CORNERRADIUS;
                    keyButton.layer.masksToBounds = YES;
                    [keyButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:keyButton];
                }
                else if (i == 2)//第三行
                {
                    if (j == 9)
                    {
                        break;
                    }
                    NSInteger leftSpec = ButtonWidth_s / 2;
                    UIButton *keyButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    keyButton.backgroundColor = [UIColor whiteColor];
                    [keyButton setTitleColor:[UIColor colorWithRed:69.0/255.0 green:69.0/255.0 blue:69.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                    keyButton.frame = CGRectMake(((ButtonWidth_s+3)*j) + leftSpec, 3+((ButtonHeight_s+3) *i), ButtonWidth_s, ButtonHeight_s);
                    [keyButton setTitle:_numberArray[index] forState:UIControlStateNormal];
                    keyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
                    keyButton.tag = 5000+index;
                    [keyButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
                    [keyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    keyButton.layer.cornerRadius = CORNERRADIUS;
                    keyButton.layer.masksToBounds = YES;
                    [keyButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:keyButton];
                }
                else//第四行
                {
                    if (i == 3 && j == 0)
                    {
                        j++;
                    }
                    if (i == 3 && j == 9)
                    {
                        break;
                    }
                    UIButton *keyButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    keyButton.backgroundColor = [UIColor whiteColor];
                    [keyButton setTitleColor:[UIColor colorWithRed:69.0/255.0 green:69.0/255.0 blue:69.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                    keyButton.frame = CGRectMake(((ButtonWidth_s+3)*j), 3+((ButtonHeight_s+3) *i), ButtonWidth_s, ButtonHeight_s);
                    [keyButton setTitle:_numberArray[index] forState:UIControlStateNormal];
                    keyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
                    keyButton.tag = 5000+index;
                    [keyButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
                    [keyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    keyButton.layer.cornerRadius = CORNERRADIUS;
                    keyButton.layer.masksToBounds = YES;
                    [keyButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:keyButton];
                }
                index++;
            }
            
        }

    }
    else
    {
        return;
    }
}


- (void)clickAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(passValueWithButton:)]) {
        [self.delegate passValueWithButton:sender];
    }
}



@end
