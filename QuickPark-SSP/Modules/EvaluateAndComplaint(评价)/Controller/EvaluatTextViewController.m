//
//  EvaluatTextViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 2016/11/29.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "EvaluatTextViewController.h"

@interface EvaluatTextViewController ()<UITextViewDelegate>

@property(nonatomic, strong)UITextView *textView;

@end

@implementation EvaluatTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setNavigationBar];
    [self initSubViews];
}

#pragma mark -初始化界面
- (void)setNavigationBar
{
    self.navigationItem.title = @"补两句";
    UIImage *leftItemImage = [UIImage imageNamed:@"backarrow_black"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[leftItemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_TITLE_BLACK}];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}
- (void)goBack
{
    if (self.navigationController.viewControllers.count == 1)
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)initSubViews
{
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW, HEIGHT_VIEW * 0.45)];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.text = @"不容易啊，别只整两句，直接来200字";
    _textView.textColor = COLOR_TITLE_GRAY;
    [self.view addSubview:_textView];
    _textView.delegate = self;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(12, HEIGHT_VIEW * 0.45 +  12, WIDTH_VIEW - 24, 44)];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickSaveButton) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:COLOR_MAIN_RED];
    button.layer.cornerRadius = CORNERRADIUS;
    button.layer.masksToBounds = YES;
    [self.view addSubview:button];
    
}
- (void)clickSaveButton
{
    if (![_textView.text isEqualToString:@""]) {
        //判断代理中的方法是否被实现，避免未被实现代理的程序崩溃
        if ([self.delegate respondsToSelector:@selector(getSaySomethingString:)])
        {
            [self.delegate getSaySomethingString:_textView.text];
        }
    }
    else
    {
        //判断代理中的方法是否被实现，避免未被实现代理的程序崩溃
        if ([self.delegate respondsToSelector:@selector(getSaySomethingString:)])
        {
            [self.delegate getSaySomethingString:@"未填写"];
        }
    }
    
    if (self.navigationController.viewControllers.count == 1)
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.textColor = COLOR_TITLE_BLACK;
    if ([textView.text isEqualToString:@"不容易啊，别只整两句，直接来200字"])
    {
        textView.text = @"";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    textView.textColor = COLOR_TITLE_GRAY;
    if (textView.text.length < 1)
    {
        textView.text = @"不容易啊，别只整两句，直接来200字";
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



@end
