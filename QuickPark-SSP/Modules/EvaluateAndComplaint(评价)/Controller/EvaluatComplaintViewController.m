//
//  EvaluatComplaintViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 2016/11/29.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "EvaluatComplaintViewController.h"
#import "Masonry.h"
#import "NKComplainTopView.h"
#import "NKDataManager.h"
#import "NKTimeManager.h"
#import "NKSspComplaintTag.h"
#import "MBProgressHUD/MBProgressHUD.h"

@interface EvaluatComplaintViewController ()<UITextViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic, strong)UIView *costTitleLabelView;
@property (nonatomic, strong)UIView *serviceTitleLableView;
@property (nonatomic, strong)UIView *operateTitleLabelView;

@property (nonatomic, strong)UIView *costChoseView;
@property (nonatomic, strong)UIView *serviceChoseView;
@property (nonatomic, strong)UIView *operateChoseView;

@property (nonatomic, strong)UIImageView *costImageView;
@property (nonatomic, strong)UIImageView *serviceImageView;
@property (nonatomic, strong)UIImageView *operateImageView;

@property (nonatomic, strong)UITextView *complaintTextView;

//三个标签的array
@property (nonatomic, strong)NSMutableArray *costTagListArray;
@property (nonatomic, strong)NSMutableArray *serviceTagListArray;
@property (nonatomic, strong)NSMutableArray *operateTagListArray;
//标签对应button的array
@property (nonatomic, strong)NSMutableArray *tagButtonsArray;

@property (nonatomic, strong)NKDataManager *dataManager;

//投诉传参
@property (nonatomic, strong)NSString *complaintReason;
@property (nonatomic, strong)NSString *complaintReason1;
@property (nonatomic, strong)NSString *complaintReason2;
@property (nonatomic, strong)NSString *complaintReason3;
@property (nonatomic, strong)NSString *complaintReason1code;
@property (nonatomic, strong)NSString *complaintReason2code;
@property (nonatomic, strong)NSString *complaintReason3code;
@property (nonatomic, strong)NSString *complaintDescription;
@property (nonatomic, strong)NSString *complaintType;

@end

@implementation EvaluatComplaintViewController

#pragma mark setter&&getter
- (NSMutableArray *)costTagListArray
{
    if (!_costTagListArray)
    {
        _costTagListArray = [NSMutableArray array];
    }
    return _costTagListArray;
}
- (NSMutableArray *)serviceTagListArray
{
    if (!_serviceTagListArray)
    {
        _serviceTagListArray = [NSMutableArray array];
    }
    return _serviceTagListArray;
}
- (NSMutableArray *)operateTagListArray
{
    if (!_operateTagListArray)
    {
        _operateTagListArray = [NSMutableArray array];
    }
    return _operateTagListArray;
}
- (NSMutableArray *)tagButtonsArray
{
    if (!_tagButtonsArray)
    {
        _tagButtonsArray = [NSMutableArray array];
    }
    return _tagButtonsArray;
}
#pragma mark - 控制器生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setNavigationBar];
    [self initSubViews];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self postToGetComplaintTagList];
}
#pragma mark - 初始化界面
- (void)setNavigationBar
{
    self.navigationItem.title = @"投诉";
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
    //背景scrollView
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW, HEIGHT_VIEW)];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(WIDTH_VIEW, HEIGHT_VIEW * 2);
    _scrollView.backgroundColor = BACKGROUND_COLOR;
    [self.view addSubview:_scrollView];
    //最上面的view
    NKComplainTopView *topView = [NKComplainTopView complainTopView];
    topView.backgroundColor = [UIColor whiteColor];
    topView.licenseLabel.text = self.stopDetailRecord.license;
    topView.startTimeLabel.text = [self.stopDetailRecord.arrive substringWithRange:NSMakeRange(11, 8)];
    topView.endTimeLabel.text = [self.stopDetailRecord.leave substringWithRange:NSMakeRange(11, 8)];
    topView.startDateLabel.text = [self.stopDetailRecord.arrive substringWithRange:NSMakeRange(0, 10)];
    topView.endDateLabel.text = [self.stopDetailRecord.leave substringWithRange:NSMakeRange(0, 10)];
    //获取停车总时长
    NSString *totalTime = [NKTimeManager dateTimeDifferenceWithStartTime:self.stopDetailRecord.arrive endTime:self.stopDetailRecord.leave];
    topView.totalTimeLabel.text = [NSString stringWithFormat:@"%@ %ld元", totalTime, (long)self.stopDetailRecord.fee / 100];
    [_scrollView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).offset(12);
        make.top.equalTo(_scrollView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(WIDTH_VIEW - 24, 72));
    }];
    //费用titleView
    _costTitleLabelView = [[UIView alloc] init];
    [_scrollView addSubview:_costTitleLabelView];
    _costTitleLabelView.backgroundColor = [UIColor whiteColor];
    _costTitleLabelView.layer.cornerRadius = 2;
    _costTitleLabelView.layer.masksToBounds = YES;
    _costTitleLabelView.layer.borderWidth = 1;
    _costTitleLabelView.layer.borderColor = COLOR_BORDER_GRAY.CGColor;
    [_costTitleLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).offset(12);
        make.top.equalTo(topView.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(WIDTH_VIEW - 24, 36));
    }];
    UILabel *costTitleLabel = [[UILabel alloc] init];
    [_costTitleLabelView addSubview:costTitleLabel];
    costTitleLabel.text = @"费用有问题";
    costTitleLabel.textColor = COLOR_TITLE_BLACK;
    costTitleLabel.font = [UIFont systemFontOfSize:14.0];
    [costTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_costTitleLabelView.mas_left).offset(12);
        make.centerY.equalTo(_costTitleLabelView.mas_centerY);
        make.height.equalTo(@14);
    }];
    _costImageView = [[UIImageView alloc] init];
    [_costTitleLabelView addSubview:_costImageView];
    _costImageView.image = [UIImage imageNamed:@"投诉展开"];
    [_costImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_costTitleLabelView.mas_right).offset(-12);
        make.top.equalTo(_costTitleLabelView.mas_top).offset(12);
        make.size.mas_equalTo(CGSizeMake(12, 6));
    }];
    UIButton *costTitleButton = [[UIButton alloc] init];
    [_costTitleLabelView addSubview:costTitleButton];
    [costTitleButton addTarget:self action:@selector(clickCostTitleButton:) forControlEvents:UIControlEventTouchUpInside];
    [costTitleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_costTitleLabelView.mas_left);
        make.top.equalTo(_costTitleLabelView.mas_top);
        make.right.equalTo(_costTitleLabelView.mas_right);
        make.bottom.equalTo(_costTitleLabelView.mas_bottom);
    }];
    //费用选项view
    _costChoseView = [[UIView alloc] init];
    [_scrollView addSubview:_costChoseView];
    _costChoseView.backgroundColor = [UIColor whiteColor];
    _costChoseView.layer.cornerRadius = 2;
    _costChoseView.layer.masksToBounds = YES;
    _costChoseView.layer.borderWidth = 1;
    _costChoseView.layer.borderColor = COLOR_BORDER_GRAY.CGColor;
    [_costChoseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_costTitleLabelView.mas_bottom);
        make.left.equalTo(_scrollView.mas_left).offset(12);
        make.size.mas_equalTo(CGSizeMake(WIDTH_VIEW - 24, 130));
    }];
    
    //服务titleView
    _serviceTitleLableView = [[UIView alloc] init];
    [_scrollView addSubview:_serviceTitleLableView];
    _serviceTitleLableView.backgroundColor = [UIColor whiteColor];
    _serviceTitleLableView.layer.cornerRadius = 2;
    _serviceTitleLableView.layer.masksToBounds = YES;
    _serviceTitleLableView.layer.borderWidth = 1;
    _serviceTitleLableView.layer.borderColor = COLOR_BORDER_GRAY.CGColor;
    [_serviceTitleLableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_costChoseView.mas_bottom).offset(6);
        make.left.equalTo(_scrollView.mas_left).offset(12);
        make.size.mas_equalTo(CGSizeMake(WIDTH_VIEW - 24, 36));
    }];
    UILabel *serviceTitleLabel = [[UILabel alloc] init];
    [_serviceTitleLableView addSubview:serviceTitleLabel];
    serviceTitleLabel.text = @"服务不满意";
    serviceTitleLabel.textColor = COLOR_TITLE_BLACK;
    serviceTitleLabel.font = [UIFont systemFontOfSize:14.0];
    [serviceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_serviceTitleLableView.mas_left).offset(12);
        make.centerY.equalTo(_serviceTitleLableView.mas_centerY);
        make.height.equalTo(@14);
    }];
    _serviceImageView = [[UIImageView alloc] init];
    [_serviceTitleLableView addSubview:_serviceImageView];
    _serviceImageView.image = [UIImage imageNamed:@"投诉展开"];
    [_serviceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_serviceTitleLableView.mas_right).offset(-12);
        make.top.equalTo(_serviceTitleLableView.mas_top).offset(12);
        make.size.mas_equalTo(CGSizeMake(12, 6));
    }];
    UIButton *serviceButton = [[UIButton alloc] init];
    [_serviceTitleLableView addSubview:serviceButton];
    [serviceButton addTarget:self action:@selector(clickServiceTitleButton:) forControlEvents:UIControlEventTouchUpInside];
    [serviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_serviceTitleLableView.mas_left);
        make.top.equalTo(_serviceTitleLableView.mas_top);
        make.right.equalTo(_serviceTitleLableView.mas_right);
        make.bottom.equalTo(_serviceTitleLableView.mas_bottom);
    }];
    //服务选项view
    _serviceChoseView  = [[UIView alloc] init];
    [_scrollView addSubview:_serviceChoseView];
    _serviceChoseView.backgroundColor = [UIColor whiteColor];
    _serviceChoseView.layer.cornerRadius = 2;
    _serviceChoseView.layer.masksToBounds = YES;
    _serviceChoseView.layer.borderWidth = 1;
    _serviceChoseView.layer.borderColor = COLOR_BORDER_GRAY.CGColor;
    [_serviceChoseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_serviceTitleLableView.mas_bottom);
        make.left.equalTo(_scrollView.mas_left).offset(12);
        make.size.mas_equalTo(CGSizeMake(WIDTH_VIEW - 24, 130));
    }];
    //经营titleView
    _operateTitleLabelView = [[UIView alloc] init];
    [_scrollView addSubview:_operateTitleLabelView];
    _operateTitleLabelView.backgroundColor = [UIColor whiteColor];
    _operateTitleLabelView.layer.cornerRadius = 2;
    _operateTitleLabelView.layer.masksToBounds = YES;
    _operateTitleLabelView.layer.borderWidth = 1;
    _operateTitleLabelView.layer.borderColor = COLOR_BORDER_GRAY.CGColor;
    [_operateTitleLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_serviceChoseView.mas_bottom).offset(6);
        make.left.equalTo(_scrollView.mas_left).offset(12);
        make.size.mas_equalTo(CGSizeMake(WIDTH_VIEW - 24, 36));
    }];
    UILabel *operateTitleLabel = [[UILabel alloc] init];
    [_operateTitleLabelView addSubview:operateTitleLabel];
    operateTitleLabel.text = @"经营不规范";
    operateTitleLabel.font = [UIFont systemFontOfSize:14.0];
    operateTitleLabel.textColor = COLOR_TITLE_BLACK;
    [operateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_operateTitleLabelView.mas_left).offset(12);
        make.centerY.equalTo(_operateTitleLabelView.mas_centerY);
        make.height.equalTo(@14);
    }];
    _operateImageView = [[UIImageView alloc] init];
    [_operateTitleLabelView addSubview:_operateImageView];
    _operateImageView.image = [UIImage imageNamed:@"投诉展开"];
    [_operateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_operateTitleLabelView.mas_right).offset(-12);
        make.top.equalTo(_operateTitleLabelView.mas_top).offset(12);
        make.size.mas_equalTo(CGSizeMake(12, 6));
    }];
    UIButton *operateButton = [[UIButton alloc] init];
    [_operateTitleLabelView addSubview:operateButton];
    [operateButton addTarget:self action:@selector(clickOperateTitleButton:) forControlEvents:UIControlEventTouchUpInside];
    [operateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_operateTitleLabelView.mas_left);
        make.top.equalTo(_operateTitleLabelView.mas_top);
        make.right.equalTo(_operateTitleLabelView.mas_right);
        make.bottom.equalTo(_operateTitleLabelView.mas_bottom);
    }];
    //经营选项view
    _operateChoseView  = [[UIView alloc] init];
    [_scrollView addSubview:_operateChoseView];
    _operateChoseView.backgroundColor = [UIColor whiteColor];
    _operateChoseView.layer.cornerRadius = 2;
    _operateChoseView.layer.masksToBounds = YES;
    _operateChoseView.layer.borderWidth = 1;
    _operateChoseView.layer.borderColor = COLOR_BORDER_GRAY.CGColor;
    [_operateChoseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_operateTitleLabelView.mas_bottom);
        make.left.equalTo(_scrollView.mas_left).offset(12);
        make.size.mas_equalTo(CGSizeMake(WIDTH_VIEW - 24, 130));
    }];
    
    //投诉原因
    UIView *complaintReasonBaseView = [[UIView alloc] init];
    [_scrollView addSubview:complaintReasonBaseView];
    complaintReasonBaseView.backgroundColor = [UIColor whiteColor];
    complaintReasonBaseView.layer.cornerRadius = 2;
    complaintReasonBaseView.layer.masksToBounds = YES;
    complaintReasonBaseView.layer.borderColor = COLOR_BORDER_GRAY.CGColor;
    complaintReasonBaseView.layer.borderWidth = 1;
    [complaintReasonBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_operateChoseView.mas_bottom).offset(12);
        make.left.equalTo(_scrollView.mas_left).offset(12);
        make.size.mas_equalTo(CGSizeMake(WIDTH_VIEW - 24, 138));
    }];
    UILabel *complaintReasonLabel = [[UILabel alloc] init];
    [complaintReasonBaseView addSubview:complaintReasonLabel];
    complaintReasonLabel.backgroundColor = [UIColor whiteColor];
    complaintReasonLabel.text = @"投诉原因";
    complaintReasonLabel.textColor = COLOR_MAIN_RED;
    complaintReasonLabel.font = [UIFont systemFontOfSize:14.0];
    [complaintReasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(complaintReasonBaseView.mas_top);
        make.left.equalTo(complaintReasonBaseView.mas_left).offset(12);
        make.right.equalTo(complaintReasonBaseView.mas_right).offset(-12);
        make.height.equalTo(@36);
    }];
    UIView *cutlineView = [[UIView alloc] init];
    [complaintReasonBaseView addSubview:cutlineView];
    cutlineView.backgroundColor = COLOR_BORDER_GRAY;
    [cutlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(complaintReasonBaseView.mas_left);
        make.right.equalTo(complaintReasonBaseView.mas_right);
        make.top.equalTo(complaintReasonLabel.mas_bottom);
        make.height.equalTo(@1);
    }];
    _complaintTextView = [[UITextView alloc] init];
    [complaintReasonBaseView addSubview:_complaintTextView];
    _complaintTextView.delegate = self;
    _complaintTextView.backgroundColor = [UIColor whiteColor];
    _complaintTextView.delegate = self;
    _complaintTextView.text = @"尽可能提供详细的信息，帮助我们尽快处理您的投诉";
    _complaintTextView.textColor = COLOR_TITLE_GRAY;
    _complaintTextView.font = [UIFont systemFontOfSize:10.0];
    [_complaintTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(complaintReasonBaseView.mas_left).offset(12);
        make.right.equalTo(complaintReasonBaseView.mas_right).offset(-12);
        make.top.equalTo(complaintReasonLabel.mas_bottom).offset(1);
        make.height.equalTo(@102);
    }];
    
    //投诉button
    UIButton *complaintButton = [[UIButton alloc] init];
    [_scrollView addSubview:complaintButton];
    [complaintButton setTitle:@"匿名投诉" forState:UIControlStateNormal];
    [complaintButton addTarget:self action:@selector(clickComplaintButton) forControlEvents:UIControlEventTouchUpInside];
    [complaintButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [complaintButton setBackgroundColor:COLOR_MAIN_RED];
    complaintButton.layer.cornerRadius = CORNERRADIUS;
    complaintButton.layer.masksToBounds = YES;
    [complaintButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(complaintReasonBaseView.mas_bottom).offset(12);
        make.left.equalTo(_scrollView.mas_left).offset(12);
        make.size.mas_equalTo(CGSizeMake(WIDTH_VIEW - 24, 44));
    }];
    
}
- (void) addTagToChoseView
{
    //动态控制选择base视图的高度
    [_costChoseView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(WIDTH_VIEW - 24, 0));
    }];
    [_serviceChoseView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(WIDTH_VIEW - 24, 0));
    }];
    [_operateChoseView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(WIDTH_VIEW - 24, 0));
    }];
    for (int i = 0; i < self.costTagListArray.count; i++)
    {
        NKSspComplaintTag *tag = self.costTagListArray[i];
        UIButton *button = [[UIButton alloc] init];
        button.tag = 500 + i;
        [button addTarget:self action:@selector(clickTagButton:) forControlEvents:UIControlEventTouchUpInside];
        [_costChoseView addSubview:button];
        [button setImage:[UIImage imageNamed:@"投诉选框"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"投诉选中"] forState:UIControlStateSelected];
        [self.tagButtonsArray addObject:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_costChoseView.mas_top).offset(12 + 30 * i);
            make.left.equalTo(_costChoseView.mas_left).offset(12);
            make.size.mas_equalTo(CGSizeMake(12, 12));
        }];
        UILabel *label = [[UILabel alloc] init];
        [_costChoseView addSubview:label];
        label.text = tag.content;
        label.textColor = COLOR_TITLE_GRAY;
        label.font = [UIFont systemFontOfSize:12.0];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_costChoseView.mas_left).offset(32);
            make.top.equalTo(_costChoseView.mas_top).offset(12 + 30 * i);
            make.height.equalTo(@12);
        }];
    }
    for (int i = 0; i < self.serviceTagListArray.count; i++)
    {
        NKSspComplaintTag *tag = self.serviceTagListArray[i];
        UIButton *button = [[UIButton alloc] init];
        button.tag = 600 + i;
        [button addTarget:self action:@selector(clickTagButton:) forControlEvents:UIControlEventTouchUpInside];
        [_serviceChoseView addSubview:button];
        [button setImage:[UIImage imageNamed:@"投诉选框"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"投诉选中"] forState:UIControlStateSelected];
        [self.tagButtonsArray addObject:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_serviceChoseView.mas_top).offset(12 + 30 * i);
            make.left.equalTo(_serviceChoseView.mas_left).offset(12);
            make.size.mas_equalTo(CGSizeMake(12, 12));
        }];
        UILabel *label = [[UILabel alloc] init];
        [_serviceChoseView addSubview:label];
        label.text = tag.content;
        label.textColor = COLOR_TITLE_GRAY;
        label.font = [UIFont systemFontOfSize:12.0];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_serviceChoseView.mas_left).offset(32);
            make.top.equalTo(_serviceChoseView.mas_top).offset(12 + 30 * i);
            make.height.equalTo(@12);
        }];
    }
    for (int i = 0; i < self.operateTagListArray.count; i++)
    {
        NKSspComplaintTag *tag = self.operateTagListArray[i];
        UIButton *button = [[UIButton alloc] init];
        button.tag = 700 + i;
        [button addTarget:self action:@selector(clickTagButton:) forControlEvents:UIControlEventTouchUpInside];
        [_operateChoseView addSubview:button];
        [button setImage:[UIImage imageNamed:@"投诉选框"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"投诉选中"] forState:UIControlStateSelected];
        [self.tagButtonsArray addObject:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_operateChoseView.mas_top).offset(12 + 30 * i);
            make.left.equalTo(_operateChoseView.mas_left).offset(12);
            make.size.mas_equalTo(CGSizeMake(12, 12));
        }];
        UILabel *label = [[UILabel alloc] init];
        [_operateChoseView addSubview:label];
        label.text = tag.content;
        label.textColor = COLOR_TITLE_GRAY;
        label.font = [UIFont systemFontOfSize:12.0];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_operateChoseView.mas_left).offset(32);
            make.top.equalTo(_operateChoseView.mas_top).offset(12 + 30 * i);
            make.height.equalTo(@12);
        }];
    }
}
#pragma mark 点击button相关方法
- (void)clickCostTitleButton:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.isSelected)
    {
        _costChoseView.hidden = YES;
        _costImageView.image = [UIImage imageNamed:@"投诉展开"];
        [_costChoseView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(WIDTH_VIEW - 24, 0));
        }];
    }
    else
    {
        _costChoseView.hidden = NO;
        _costImageView.image = [UIImage imageNamed:@"投诉收起"];
        [_costChoseView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(WIDTH_VIEW - 24, 32 * self.costTagListArray.count));
        }];
    }
    
}
- (void)clickServiceTitleButton:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.isSelected)
    {
        _serviceChoseView.hidden = YES;
        _serviceImageView.image = [UIImage imageNamed:@"投诉展开"];
        [_serviceChoseView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(WIDTH_VIEW - 24, 0));
        }];
    }
    else
    {
        _serviceChoseView.hidden  = NO;
        _serviceImageView.image = [UIImage imageNamed:@"投诉收起"];
        [_serviceChoseView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(WIDTH_VIEW - 24, 32 * self.serviceTagListArray.count));
        }];
    }
}
- (void)clickOperateTitleButton:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.isSelected)
    {
        _operateChoseView.hidden = YES;
        _operateImageView.image = [UIImage imageNamed:@"投诉展开"];
        [_operateChoseView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(WIDTH_VIEW - 24, 0));
        }];
    }
    else
    {
        _operateChoseView.hidden = NO;
        _operateImageView.image = [UIImage imageNamed:@"投诉收起"];
        [_operateChoseView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(WIDTH_VIEW - 24, 32 * self.operateTagListArray.count));
        }];
    }
}
-(void)clickTagButton:(UIButton *)sender
{
    sender.selected = !sender.selected;
}
- (void)clickComplaintButton
{
    for (UIButton *button in self.tagButtonsArray)
    {
        if (button.isSelected)
        {
            if (button.tag > 500 && button.tag < 600)
            {
                NKSspComplaintTag *tag = self.costTagListArray[button.tag - 500];
                if (!_complaintReason)
                {
                    self.complaintReason = [NSString stringWithFormat:@"%@", tag.content];
                    self.complaintType = [NSString stringWithFormat:@"%@", tag.tagtypeid];
                }
                else
                {
                    self.complaintReason = [self.complaintReason stringByAppendingFormat:@"-%@", tag.content];
                    self.complaintType = [self.complaintType stringByAppendingFormat:@"-%@", tag.tagtypeid];
                }
                if (!_complaintReason1)
                {
                    self.complaintReason1 = [NSString stringWithFormat:@"%@", tag.content];
                    self.complaintReason1code = [NSString stringWithFormat:@"%@", tag.complaintNo];
                }
                else
                {
                    self.complaintReason1 = [self.complaintReason1 stringByAppendingFormat:@"-%@", tag.content];
                    self.complaintReason1code = [self.complaintReason1code stringByAppendingFormat:@"-%@", tag.complaintNo];
                }
            }
            else if(button.tag > 599 && button.tag < 700)
            {
                NKSspComplaintTag *tag = self.serviceTagListArray[button.tag - 600];
                if (!_complaintReason)
                {
                    self.complaintReason = [NSString stringWithFormat:@"%@", tag.content];
                    self.complaintType = [NSString stringWithFormat:@"%@", tag.tagtypeid];
                }
                else
                {
                    self.complaintReason = [self.complaintReason stringByAppendingFormat:@"-%@", tag.content];
                    self.complaintType = [self.complaintType stringByAppendingFormat:@"-%@", tag.tagtypeid];
                }
                if (!_complaintReason2)
                {
                    self.complaintReason2 = [NSString stringWithFormat:@"%@", tag.content];
                    self.complaintReason2code = [NSString stringWithFormat:@"%@", tag.complaintNo];
                }
                else
                {
                    self.complaintReason2 = [self.complaintReason2 stringByAppendingFormat:@"-%@", tag.content];
                    self.complaintReason2code = [self.complaintReason2code stringByAppendingFormat:@"-%@", tag.complaintNo];
                }
            }
            else if(button.tag > 699 && button.tag < 800)
            {
                NKSspComplaintTag *tag = self.operateTagListArray[button.tag - 700];
                if (!_complaintReason)
                {
                    self.complaintReason = [NSString stringWithFormat:@"%@", tag.content];
                    self.complaintType = [NSString stringWithFormat:@"%@", tag.tagtypeid];
                }
                else
                {
                    self.complaintReason = [self.complaintReason stringByAppendingFormat:@"-%@", tag.content];
                    self.complaintType = [self.complaintType stringByAppendingFormat:@"-%@", tag.tagtypeid];
                }
                if (!_complaintReason3)
                {
                    self.complaintReason3 = [NSString stringWithFormat:@"%@", tag.content];
                    self.complaintReason3code = [NSString stringWithFormat:@"%@", tag.complaintNo];
                }
                else
                {
                    self.complaintReason3 = [self.complaintReason3 stringByAppendingFormat:@"-%@", tag.content];
                    self.complaintReason3code = [self.complaintReason3code stringByAppendingFormat:@"-%@", tag.complaintNo];
                }
            }
        }
    }
    NSLog(@"reason:%@    type:%@", _complaintReason, _complaintType);
    [self postToComplaint];
}
#pragma mark - UIScrollViewDelegate && UITextViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.textColor = COLOR_TITLE_BLACK;
    if ([textView.text isEqualToString:@"尽可能提供详细的信息，帮助我们尽快处理您的投诉"])
    {
        textView.text = @"";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    textView.textColor = COLOR_TITLE_GRAY;
    if (textView.text.length < 1)
    {
        textView.text = @"尽可能提供详细的信息，帮助我们尽快处理您的投诉";
    }
}
#pragma mark - 网络请求相关的方法
- (void)postToGetComplaintTagList
{
    MBProgressHUD *waithud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    waithud.mode = MBProgressHUDModeIndeterminate;
    
    _dataManager = [NKDataManager sharedDataManager];
    
    [_dataManager POSTGetComplaintTagWithParameters:nil Success:^(NSArray *backArray) {
        for (NKSspComplaintTag *tag in backArray)
        {
            if (tag.tagtype == 0)
            {
                [self.costTagListArray addObject:tag];
            }
            else if (tag.tagtype == 1)
            {
                [self.serviceTagListArray addObject:tag];
            }
            else if (tag.tagtype == 2)
            {
                [self.operateTagListArray addObject:tag];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [waithud hideAnimated:YES];
            [waithud removeFromSuperViewOnHide];
            [self addTagToChoseView];
        });
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [waithud hideAnimated:YES];
            [waithud removeFromSuperViewOnHide];
        });
        [self showHUDWithText:@"网络异常"];
    }];
    
}
- (void)postToComplaint
{
    MBProgressHUD *waithud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    waithud.mode = MBProgressHUDModeIndeterminate;
    /*
     private String stoprecordid;//停车记录id
     private Date complainttime;//投诉时间
     private String complaintreason;//投诉原因
     private String complaintdetail;//投诉描述
     private String tagtypeid;//投诉类型id
     private String complaintstatus;//投诉状态:0:已投诉1:未投诉
     */
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[NSNumber numberWithInt:1] forKey:@"id"];
    [parameters setValue:self.stopDetailRecord.stopRecordId forKey:@"stoprecordid"];
    //[parameters setValue:[NSDate date] forKey:@"complainttime"];
    [parameters setValue:_complaintReason forKey:@"complaintreason"];
    [parameters setValue:_complaintTextView.text forKey:@"complaintdetail"];
    [parameters setValue:_complaintType forKey:@"tagtypeid"];
    [parameters setValue:@"1" forKey:@"complaintstatus"];
    
//    [parameters setValue:_complaintReason1 forKey:@"tagcontent1"];
//    [parameters setValue:_complaintReason2 forKey:@"tagcontent2"];
//    [parameters setValue:_complaintReason3 forKey:@"tagcontent3"];
    [parameters setValue:_complaintReason1code forKey:@"tagcontent1code"];
    [parameters setValue:_complaintReason2code forKey:@"tagcontent2code"];
    [parameters setValue:_complaintReason3code forKey:@"tagcontent3code"];
    
    _dataManager = [NKDataManager sharedDataManager];
    [_dataManager POSTComplaintWithParameters:parameters Susccess:^(int ret) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [waithud hideAnimated:YES];
            [waithud removeFromSuperViewOnHide];
        });
        if (ret == 0)
        {
            [self showHUDWithText:@"投诉成功"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else
        {
            [self showHUDWithText:@"投诉失败"];
        }
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [waithud hideAnimated:YES];
            [waithud removeFromSuperViewOnHide];
        });
        [self showHUDWithText:@"网络异常"];
    }];
    //每次网络请求完成后清空评价字符串
    self.complaintReason = @"";
    self.complaintType = @"";
}
#pragma mark - HUD
- (void) showHUDWithText:(NSString *)str
{
    UIWindow *mainWindow = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = str;
    [hud hideAnimated:YES afterDelay:2.0];
    [hud removeFromSuperViewOnHide];
}
@end
