//
//  EvaluateViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 2016/11/28.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "EvaluateViewController.h"
#import "Masonry.h"
#import "EvaluatComplaintViewController.h"
#import "NKDataManager.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "NKEvaluateSubView.h"
#import "NKArrowView.h"
#import "TollCollecterDetailViewController.h"
#import "EvaluateSuccessViewController.h"

@interface EvaluateViewController ()<UITextViewDelegate>
//两个评价子界面 && textView
@property (nonatomic, strong) NKEvaluateSubView *chargerEvaluateSubView;
@property (nonatomic, strong) NKEvaluateSubView *parkingEvaluateSubView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NKArrowView *chargerArrowView;
@property (nonatomic, strong) NKArrowView *parkingArrowView;
//6个评价内容数组，用来保存从服务器获取的6个纬度的评价标签
@property (nonatomic, strong)NSMutableArray *surfaceEvaluatArray;
@property (nonatomic, strong)NSMutableArray *talkEvaluatArray;
@property (nonatomic, strong)NSMutableArray *actionEvaluatArray;
@property (nonatomic, strong)NSMutableArray *roadsignEvaluatArray;
@property (nonatomic, strong)NSMutableArray *hygieneEvaluatArray;
@property (nonatomic, strong)NSMutableArray *senseEvaluatArray;
//2个星星等级
@property (nonatomic, strong) NSString *chargerStarLevel;
@property (nonatomic, strong) NSString *parkingStarLevel;
//2个当前操作的tag数组
@property (nonatomic, strong) NSMutableArray *chargerCurrentTagArray;
@property (nonatomic, strong) NSMutableArray *parkingCurrentTagArray;
//2个用来保存选中标签的数组
@property (nonatomic, strong) NSMutableArray *chargerParametersTagArray;
@property (nonatomic, strong) NSMutableArray *parkingParametersTagArray;
//提交评论的2个标签编码参数
@property (nonatomic, strong) NSString *chargerTagParameterString;
@property (nonatomic, strong) NSString *parkingTagParameterString;
//说两句
@property (nonatomic, strong)NSString *saySomethingString;
@property (nonatomic, strong)NKDataManager *dataManager;

@end

@implementation EvaluateViewController
- (NSMutableArray *)chargerCurrentTagArray
{
    if (_chargerCurrentTagArray == nil)
    {
        _chargerCurrentTagArray = [NSMutableArray array];
    }
    return _chargerCurrentTagArray;
}
- (NSMutableArray *)parkingCurrentTagArray
{
    if (_parkingCurrentTagArray == nil)
    {
        _parkingCurrentTagArray = [NSMutableArray array];
    }
    return _parkingCurrentTagArray;
}
- (NSMutableArray *)chargerParametersTagArray
{
    if (_chargerParametersTagArray == nil)
    {
        _chargerParametersTagArray = [NSMutableArray array];
    }
    return _chargerParametersTagArray;
}
- (NSMutableArray *)parkingParametersTagArray
{
    if (_parkingParametersTagArray == nil)
    {
        _parkingParametersTagArray = [NSMutableArray array];
    }
    return _chargerParametersTagArray;
}

//6个评价内容数组
- (NSMutableArray *)surfaceEvaluatArray
{
    if (!_surfaceEvaluatArray)
    {
        _surfaceEvaluatArray = [NSMutableArray array];
    }
    return _surfaceEvaluatArray;
}
- (NSMutableArray *)talkEvaluatArray
{
    if (!_talkEvaluatArray)
    {
        _talkEvaluatArray = [NSMutableArray array];
    }
    return _talkEvaluatArray;
}
- (NSMutableArray *)actionEvaluatArray
{
    if (!_actionEvaluatArray)
    {
        _actionEvaluatArray = [NSMutableArray array];
    }
    return _actionEvaluatArray;
}
- (NSMutableArray *)roadsignEvaluatArray
{
    if (!_roadsignEvaluatArray)
    {
        _roadsignEvaluatArray = [NSMutableArray array];
    }
    return _roadsignEvaluatArray;
}
- (NSMutableArray *)hygieneEvaluatArray
{
    if (!_hygieneEvaluatArray)
    {
        _hygieneEvaluatArray = [NSMutableArray array];
    }
    return _hygieneEvaluatArray;
}
- (NSMutableArray *)senseEvaluatArray
{
    if (!_senseEvaluatArray)
    {
        _senseEvaluatArray = [NSMutableArray array];
    }
    return _senseEvaluatArray;
}
#pragma mark - 控制器生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =BACKGROUND_COLOR;
    [self setNavigationBar];
    [self initSubViews];
    [self postToGetEvaluateTag];
    
    //注册键盘的两个通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
#pragma mark -初始化界面
- (void)setNavigationBar
{
    self.navigationItem.title = @"点评";
    UIImage *leftItemImage = [UIImage imageNamed:@"backarrow_black"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[leftItemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    UIImage *rightItemImage;
    if ([self.stopDetailRecord.complaintstatus isEqualToString:@"1"])
    {
        rightItemImage = [UIImage imageNamed:@"不可投诉"];
    }
    else
    {
        rightItemImage = [UIImage imageNamed:@"投诉"];   
    }
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[rightItemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickItemButtonToComplaint)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_TITLE_BLACK}];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}
-(void)goBack
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
    _chargerEvaluateSubView = [NKEvaluateSubView nk_evaluateSubView];
    _chargerEvaluateSubView.frame = CGRectMake(0, 64, WIDTH_VIEW, 180);
    _chargerEvaluateSubView.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < _chargerEvaluateSubView.starButtonArray.count; i++)
    {
        UIButton *button = _chargerEvaluateSubView.starButtonArray[i];
        [button addTarget:self action:@selector(clickStarButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1000 + i;
    }
    for (int i = 0; i < _chargerEvaluateSubView.tagButtonArray.count; i++)
    {
        UIButton *button = _chargerEvaluateSubView.tagButtonArray[i];
        [button addTarget:self action:@selector(clickTagButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1100 + i;
    }
    [_chargerEvaluateSubView.rightArrowButton addTarget:self action:@selector(clickChargerArrowButton) forControlEvents:UIControlEventTouchUpInside];
    _chargerEvaluateSubView.nameLabel.text = _stopDetailRecord.mepName;
    
    _parkingEvaluateSubView = [NKEvaluateSubView nk_evaluateSubView];
    _parkingEvaluateSubView.frame = CGRectMake(0, 254, WIDTH_VIEW, 180);
    _parkingEvaluateSubView.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < _parkingEvaluateSubView.starButtonArray.count; i++)
    {
        UIButton *button = _parkingEvaluateSubView.starButtonArray[i];
        [button addTarget:self action:@selector(clickStarButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 2000 + i;
    }
    for (int i = 0; i < _parkingEvaluateSubView.tagButtonArray.count; i++)
    {
        UIButton *button = _parkingEvaluateSubView.tagButtonArray[i];
        [button addTarget:self action:@selector(clickTagButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 2100 + i;
    }
    _parkingEvaluateSubView.nameLabel.text = _stopDetailRecord.parking;
    _parkingEvaluateSubView.iconImageView.image = [UIImage imageNamed:@"stopfine_defualtberth"];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 64 + 360 + 20, WIDTH_VIEW, 80)];
    _textView.delegate = self;
    _textView.editable = YES;
    _textView.text = @"对收费员/停车场的印象";
    
    UIButton *publicButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH_VIEW - 75) / 2, (HEIGHT_VIEW - 75 - 20), 75, 75)];
    [publicButton setTitle:@"发表" forState:UIControlStateNormal];
    [publicButton setTitleColor:COLOR_TITLE_WHITE forState:UIControlStateNormal];
    [publicButton setBackgroundColor:COLOR_BUTTON_RED];
    publicButton.layer.cornerRadius = 75 / 2;
    publicButton.layer.masksToBounds = YES;
    [publicButton addTarget:self action:@selector(clickPublishButton) forControlEvents:UIControlEventTouchUpInside];
    if (HEIGHT_VIEW > 666)
    {
        [self.view addSubview:_chargerEvaluateSubView];
        [self.view addSubview:_parkingEvaluateSubView];
        [self.view addSubview:_textView];
        [self.view addSubview:publicButton];
        [publicButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-20);
            make.centerX.equalTo(self.view.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(75, 75));
        }];
    }
    else
    {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -64, WIDTH_VIEW, HEIGHT_VIEW + 64)];
        scrollView.contentSize = CGSizeMake(WIDTH_VIEW, 666);
        scrollView.backgroundColor = BACKGROUND_COLOR;
        [self.view addSubview:scrollView];
        [scrollView addSubview:_chargerEvaluateSubView];
        [scrollView addSubview:_parkingEvaluateSubView];
        [scrollView addSubview:_textView];
        [scrollView addSubview:publicButton];
        [publicButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_textView.mas_bottom).offset(60);
            make.centerX.equalTo(self.view.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(75, 75));
        }];
        UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollTap:)];
        [scrollView addGestureRecognizer:myTap];
    }
    
}
#pragma mark - 点击NKEvaluateView页面方法
- (void)clickChargerArrowButton
{
    TollCollecterDetailViewController *tcdVC = [[TollCollecterDetailViewController alloc] initWithMepId:self.stopDetailRecord.mepNumber];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:tcdVC];
    [self.navigationController presentViewController:navi animated:YES completion:nil];
}
- (void)clickStarButton:(UIButton *)button
{
    if (button.tag < 2000)
    {
        [self.chargerCurrentTagArray removeAllObjects];
        [self.chargerParametersTagArray removeAllObjects];
        self.chargerStarLevel = [NSString stringWithFormat:@"%d", button.tag - 999];
        //收费员星星
        for (UIButton *button in self.chargerEvaluateSubView.starButtonArray)
        {
            button.selected = NO;
        }
        for (int i = 0; i < button.tag - 999; i++)
        {
            UIButton *button = self.chargerEvaluateSubView.starButtonArray[i];
            button.selected = YES;
        }
        //收费员评价标签清空
        for (UIButton *button in self.chargerEvaluateSubView.tagButtonArray)
        {
            button.selected = NO;
            button.layer.borderColor = COLOR_TITLE_GRAY.CGColor;
            button.hidden = NO;
        }
        //获取tag
        long currentLevel = button.tag - 1000;
        NSMutableArray *currentArray = [NSMutableArray arrayWithArray:self.surfaceEvaluatArray[currentLevel]];
        while (currentArray.count > 2)
        {
            int index = arc4random() % currentArray.count;
            [currentArray removeObjectAtIndex:index];
        }
        [self.chargerCurrentTagArray addObjectsFromArray:currentArray];
        currentArray = [NSMutableArray arrayWithArray:self.talkEvaluatArray[currentLevel]];
        while (currentArray.count > 2)
        {
            int index = arc4random() % currentArray.count;
            [currentArray removeObjectAtIndex:index];
        }
        [self.chargerCurrentTagArray addObjectsFromArray:currentArray];
        currentArray = [NSMutableArray arrayWithArray:self.actionEvaluatArray[currentLevel]];
        while (currentArray.count > 2)
        {
            int index = arc4random() % currentArray.count;
            [currentArray removeObjectAtIndex:index];
        }
        [self.chargerCurrentTagArray addObjectsFromArray:currentArray];
        //更新界面
        for (int i = 0; i < self.chargerCurrentTagArray.count; i++)
        {
            NKSspEvaluateTag *tag = self.chargerCurrentTagArray[i];
            UIButton *tagButton = _chargerEvaluateSubView.tagButtonArray[i];
            [tagButton setTitle:tag.content forState:UIControlStateNormal];
        }
        _chargerEvaluateSubView.pointLabel.text= [NSString stringWithFormat:@"%ld分", currentLevel + 1];
        //更新箭头
        if (_chargerArrowView) {
            _chargerArrowView.arrow_x = button.center.x;
            [_chargerArrowView setNeedsDisplay];
            return;
        }
        _chargerArrowView = [[NKArrowView alloc] initWithFrame:CGRectMake(0, button.frame.origin.y + 24, WIDTH_VIEW, 10)];
        _chargerArrowView.arrow_x = button.center.x;
        _chargerArrowView.backgroundColor = [UIColor whiteColor];
        [_chargerEvaluateSubView addSubview:_chargerArrowView];
    }
    else
    {
        [self.parkingCurrentTagArray removeAllObjects];
        [self.parkingParametersTagArray removeAllObjects];
        self.parkingStarLevel = [NSString stringWithFormat:@"%ld", button.tag - 1999];
        //停车场星星
        for (UIButton *button in self.parkingEvaluateSubView.starButtonArray)
        {
            button.selected = NO;
        }
        for (int i = 0; i < button.tag - 1999; i++)
        {
            UIButton *button = self.parkingEvaluateSubView.starButtonArray[i];
            button.selected = YES;
        }
        //收费员评价标签清空
        for (UIButton *button in self.parkingEvaluateSubView.tagButtonArray)
        {
            button.selected = NO;
            button.layer.borderColor = COLOR_TITLE_GRAY.CGColor;
            button.hidden = NO;
        }
        //获取tag
        long currentLevel = button.tag - 2000;
        NSMutableArray *currentArray = [NSMutableArray arrayWithArray:self.roadsignEvaluatArray[currentLevel]];
        while (currentArray.count > 2)
        {
            int index = arc4random() % currentArray.count;
            [currentArray removeObjectAtIndex:index];
        }
        [self.parkingCurrentTagArray addObjectsFromArray:currentArray];
        currentArray = [NSMutableArray arrayWithArray:self.hygieneEvaluatArray[currentLevel]];
        while (currentArray.count > 2)
        {
            int index = arc4random() % currentArray.count;
            [currentArray removeObjectAtIndex:index];
        }
        [self.parkingCurrentTagArray addObjectsFromArray:currentArray];
        currentArray = [NSMutableArray arrayWithArray:self.senseEvaluatArray[currentLevel]];
        while (currentArray.count > 2)
        {
            int index = arc4random() % currentArray.count;
            [currentArray removeObjectAtIndex:index];
        }
        [self.parkingCurrentTagArray addObjectsFromArray:currentArray];
        //更新界面
        for (int i = 0; i < self.parkingCurrentTagArray.count; i++)
        {
            NKSspEvaluateTag *tag = self.parkingCurrentTagArray[i];
            UIButton *tagButton = _parkingEvaluateSubView.tagButtonArray[i];
            [tagButton setTitle:tag.content forState:UIControlStateNormal];
        }
        _parkingEvaluateSubView.pointLabel.text= [NSString stringWithFormat:@"%ld分", currentLevel + 1];
        //更新箭头
        if (_parkingArrowView) {
            _parkingArrowView.arrow_x = button.center.x;
            [_parkingArrowView setNeedsDisplay];
            return;
        }
        _parkingArrowView = [[NKArrowView alloc] initWithFrame:CGRectMake(0, button.frame.origin.y + 24, WIDTH_VIEW, 10)];
        _parkingArrowView.arrow_x = button.center.x;
        _parkingArrowView.backgroundColor = [UIColor whiteColor];
        [_parkingEvaluateSubView addSubview:_parkingArrowView];
    }
}
- (void)clickTagButton:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.isSelected)
    {
        button.layer.borderColor = COLOR_TITLE_RED.CGColor;
    }
    else
    {
        button.layer.borderColor = COLOR_TITLE_GRAY.CGColor;
    }
    if (button.tag < 2000)
    {
        NKSspEvaluateTag *tag = self.chargerCurrentTagArray[button.tag - 1100];
        [self.chargerParametersTagArray addObject:tag];
    }
    else
    {
        NKSspEvaluateTag *tag = self.parkingCurrentTagArray[button.tag - 2100];
        [self.parkingParametersTagArray addObject:tag];
    }
}
#pragma mark -点击button的方法
- (void)clickItemButtonToComplaint
{
    if ([self.stopDetailRecord.complaintstatus isEqualToString:@"1"])
    {
        //不允许投诉
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"不能重复投诉";
        [hud hideAnimated:YES afterDelay:1.5];
        [hud removeFromSuperViewOnHide];
        return;
    }
    if ([self.stopDetailRecord.complaintstatus isEqualToString:@"2"])
    {
        //不允许投诉
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"已过投诉时效";
        [hud hideAnimated:YES afterDelay:1.5];
        [hud removeFromSuperViewOnHide];
        return;
    }
    else
    {
        //可投诉
        EvaluatComplaintViewController *ecVC = [[EvaluatComplaintViewController alloc] init];
        ecVC.stopDetailRecord = self.stopDetailRecord;
        [self.navigationController pushViewController:ecVC animated:YES];
    }
}
- (void)clickPublishButton
{
    self.saySomethingString = _textView.text;
    for (UIButton *tagButton in self.chargerEvaluateSubView.tagButtonArray)
    {
        if (tagButton.isSelected)
        {
            NKSspEvaluateTag *tag = self.chargerCurrentTagArray[tagButton.tag - 1100];
            if (self.chargerTagParameterString)
            {
                self.chargerTagParameterString = [self.chargerTagParameterString stringByAppendingString:[NSString stringWithFormat:@"-%@", tag.no]];
            }
            else
            {
                self.chargerTagParameterString = [NSString stringWithFormat:@"%@", tag.no];
            }
        }
    }
    for (UIButton *tagButton in self.parkingEvaluateSubView.tagButtonArray)
    {
        if (tagButton.isSelected)
        {
            NKSspEvaluateTag *tag = self.parkingCurrentTagArray[tagButton.tag - 2100];
            if (self.parkingTagParameterString)
            {
                self.parkingTagParameterString = [self.parkingTagParameterString stringByAppendingString:[NSString stringWithFormat:@"-%@", tag.no]];
            }
            else
            {
                self.parkingTagParameterString = [NSString stringWithFormat:@"%@", tag.no];
            }
        }
    }
    if (!self.chargerStarLevel || !self.parkingStarLevel)
    {
        [self popHUDWithString:@"请选择评价星级"];
        return;
    }
    else if (!self.parkingTagParameterString || !self.chargerTagParameterString)
    {
        [self popHUDWithString:@"请选择评价标签"];
        return;
    }
    else
    {
        [self postToPublish];
    }
}
#pragma mark - 网络请求相关方法
- (void)postToGetEvaluateTag
{
    MBProgressHUD *waithud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    waithud.mode = MBProgressHUDModeIndeterminate;
    
    _dataManager  = [NKDataManager sharedDataManager];
    [_dataManager POSTGetCommentTagWithParameters:nil Success:^(NSMutableArray *surfaceEvaluateArray, NSMutableArray *talkEvaluateArray, NSMutableArray *actionEvaluateArray, NSMutableArray *roadsignEvaluateArray, NSMutableArray *hygieneEvaluateArray, NSMutableArray *senseEvaluateArray) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [waithud hideAnimated:YES];
            [waithud removeFromSuperViewOnHide];
        });
        self.surfaceEvaluatArray = [NSMutableArray arrayWithArray:surfaceEvaluateArray];
        self.talkEvaluatArray = [NSMutableArray arrayWithArray:talkEvaluateArray];
        self.actionEvaluatArray = [NSMutableArray arrayWithArray:actionEvaluateArray];
        self.roadsignEvaluatArray = [NSMutableArray arrayWithArray:roadsignEvaluateArray];
        self.hygieneEvaluatArray = [NSMutableArray arrayWithArray:hygieneEvaluateArray];
        self.senseEvaluatArray = [NSMutableArray arrayWithArray:senseEvaluateArray];
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [waithud hideAnimated:YES];
            [waithud removeFromSuperViewOnHide];
            [self popHUDWithString:@"网络异常"];
        });
    }];

}
- (void)postToPublish
{
    
    MBProgressHUD *waithud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    waithud.mode = MBProgressHUDModeIndeterminate;
    
    NSString *parkingNo;//从berth中截取13位parkingNo
    if (self.stopDetailRecord.berth.length > 13 || self.stopDetailRecord.berth.length == 13)
    {
        parkingNo = [self.stopDetailRecord.berth substringWithRange:NSMakeRange(0, 13)];
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.stopDetailRecord.stopRecordId forKey:@"stoprecordid"];
    
    [parameters setValue:self.chargerTagParameterString forKey:@"tocarevaluatetag"];
    [parameters setValue:self.chargerStarLevel forKey:@"tocarevaluatestar"];
    [parameters setValue:self.parkingTagParameterString forKey:@"parkingevaluatetag"];
    [parameters setValue:self.parkingStarLevel forKey:@"parkingevaluatestar"];
    
    [parameters setValue:[NSNumber numberWithInteger:1] forKey:@"status"];
    [parameters setValue:self.saySomethingString forKey:@"supplementary"];
    [parameters setValue:self.stopDetailRecord.parking forKey:@"parkingname"];
    [parameters setValue:self.stopDetailRecord.mepNumber forKey:@"gocarregmepno"];
    if (self.stopDetailRecord.settleNo.length == 0)
    {
        [parameters setValue:self.stopDetailRecord.mepNumber forKey:@"tocarsettlemepno"];
    }
    else
    {
        [parameters setValue:self.stopDetailRecord.settleNo forKey:@"tocarsettlemepno"];
    }
    [parameters setValue:parkingNo forKey:@"parkingNo"];
    
    _dataManager = [NKDataManager sharedDataManager];
    [_dataManager POSTToCommentWithParameters:parameters Success:^(int ret) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [waithud hideAnimated:YES];
            [waithud removeFromSuperViewOnHide];
            UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
            hud.mode = MBProgressHUDModeText;
            switch (ret)
            {
                case 0:
                    hud.label.text = @"处理成功";
                    [self.navigationController popViewControllerAnimated:YES];
                    break;
                case 100:
                    hud.label.text = @"处理失败";
                    break;
                case 101:
                    hud.label.text = @"参数错误";
                    break;
                case 200:
                    hud.label.text = @"请求通过";
                    break;
                case 400:
                    hud.label.text = @"错误请求";
                    break;
                case 401:
                    hud.label.text = @"未授权";
                    break;
                case 402:
                    hud.label.text = @"你不是会员，不能访问此页面";
                    break;
                case 403:
                    hud.label.text = @"禁止访问";
                    break;
                case 404:
                    hud.label.text = @"找不到访问的路径，请检查路径是否正确";
                    break;
                case 500:
                    hud.label.text = @"服务器正在维修，请稍后访问~~";
                    break;
                    
                default:
                    break;
            }
            [hud hideAnimated:YES afterDelay:2.0];
            [hud removeFromSuperViewOnHide];
            if (ret == 0)
            {
                EvaluateSuccessViewController *esVC = [[EvaluateSuccessViewController alloc] init];
                [self.navigationController pushViewController:esVC animated:YES];
            }
        });

    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [waithud hideAnimated:YES];
            [waithud removeFromSuperViewOnHide];
            [self popHUDWithString:@"网络异常"];
        });
    }];

}
- (void)popHUDWithString:(NSString *)str
{
    MBProgressHUD *waithud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    waithud.mode = MBProgressHUDModeText;
    waithud.label.text = str;
    [waithud hideAnimated:YES afterDelay:2.0];
    [waithud removeFromSuperViewOnHide];
}
#pragma mark - 键盘弹出相关方法
//键盘将要出现
- (void)handleKeyboardWillShow:(NSNotification *)paramNotification
{
    NSValue *value = [[paramNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];//使用UIKeyboardFrameBeginUserInfoKey,会出现切换输入法时获取的搜狗键盘不对.
    CGRect keyboardRect = [value CGRectValue];
    CGFloat keyboardH = keyboardRect.size.height;
    self.view.transform = CGAffineTransformMakeTranslation(0, -keyboardH);
}

//键盘将要隐藏
- (void)handleKeyboardWillHide:(NSNotification *)paramNotification
{
    self.view.transform = CGAffineTransformIdentity;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self.view endEditing:YES];
}
- (void)scrollTap:(id)sender
{
    [self.view endEditing:YES];
}



@end
