//
//  TollCollecterDetailViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 2017/3/10.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "TollCollecterDetailViewController.h"
#import "Masonry.h"
#import "NKDataManager.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "NKMepInfo.h"
#import "NSDictionary+Compared.h"

@interface TollCollecterDetailViewController ()

@property (nonatomic, strong) NSString *mepid;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *circleLabel;
@property (nonatomic, strong) NSString *mobileNo;
@property (nonatomic, strong) UIView *commentBaseView;
@property (nonatomic, strong) UIView *infoBaseView;
@property (nonatomic, strong) NSMutableArray *mepTagArray;
@property (nonatomic, strong) MBProgressHUD *HUD;

@end

@implementation TollCollecterDetailViewController
- (NSMutableArray *)mepTagArray
{
    if (!_mepTagArray)
    {
        _mepTagArray = [NSMutableArray array];
    }
    return _mepTagArray;
}

-(instancetype)initWithMepId:(NSString *)mepid
{
    if (self = [super init])
    {
        self.mepid = mepid;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self initSubViews];
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    [self postToGetMEPInfo];
}
#pragma mark - 界面初始化
- (void)setNavigationBar
{
    self.navigationItem.title = @"收费员主页";
    UIImage *leftItemImage = [UIImage imageNamed:@"左箭头"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[leftItemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_TITLE_WHITE}];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}
-(void)goBack
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)initSubViews
{
    UIView *infoBaseView = [[UIView alloc] init];
    self.infoBaseView = infoBaseView;
    [self.view addSubview:infoBaseView];
    infoBaseView.backgroundColor = [UIColor whiteColor];
    [infoBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(184 + 120);
    }];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tollcollecter_bg"]];
    [infoBaseView addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(infoBaseView.mas_left);
        make.top.equalTo(infoBaseView.mas_top);
        make.right.equalTo(infoBaseView.mas_right);
        make.height.mas_equalTo(184);
    }];
    //第一部分
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"头像"]];
    [infoBaseView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    iconImageView.layer.cornerRadius = 30;
    iconImageView.layer.masksToBounds = YES;
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImageView.mas_top).offset(74);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 14)];
    [infoBaseView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    nameLabel.text = @"收费员";
    nameLabel.textColor = COLOR_TITLE_WHITE;
    nameLabel.font = [UIFont systemFontOfSize:14.0];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView.mas_bottom).offset(8);
        make.centerX.equalTo(iconImageView.mas_centerX);
        make.height.equalTo(@14);
    }];
    UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 12)];
    [infoBaseView addSubview:idLabel];
    idLabel.text = self.mepid;
    idLabel.textColor = COLOR_TITLE_WHITE;
    idLabel.font = [UIFont systemFontOfSize:12.0];
    [idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(8);
        make.centerX.equalTo(nameLabel.mas_centerX);
        make.height.equalTo(@12);
    }];
    //第二部分
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 14)];
    [infoBaseView addSubview:titleLabel];
    titleLabel.text = @"服务次数";
    titleLabel.textColor = COLOR_TITLE_BLACK;
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImageView.mas_bottom).offset(10);
        make.left.equalTo(infoBaseView.mas_left).offset(12);
        make.height.equalTo(@14);
    }];
    UIView *circleBaseView = [[UIView alloc] init];
    [infoBaseView addSubview:circleBaseView];
    circleBaseView.layer.borderWidth = 1;
    circleBaseView.layer.borderColor = COLOR_CIRCLE_RED.CGColor;
    circleBaseView.layer.cornerRadius = 48;
    circleBaseView.layer.masksToBounds = YES;
    [circleBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImageView.mas_bottom).offset(20);
        make.centerX.equalTo(infoBaseView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(96, 96));
    }];
    UIView *circleView = [[UIView alloc] init];
    [circleBaseView addSubview:circleView];
    circleView.layer.borderWidth = 1;
    circleView.layer.borderColor = COLOR_MAIN_RED.CGColor;
    circleView.layer.cornerRadius = 45;
    circleView.layer.masksToBounds = YES;
    [circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(circleBaseView.mas_centerY);
        make.centerX.equalTo(circleBaseView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    UILabel *circleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 24)];
    [circleView addSubview:circleLabel];
    self.circleLabel = circleLabel;
    circleLabel.text = @"0";
    circleLabel.textColor = COLOR_TITLE_RED;
    circleLabel.font = [UIFont systemFontOfSize:24.0];
    [circleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(circleView.center);
        make.height.equalTo(@24);
    }];
    UILabel *circleDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 12)];
    [circleView addSubview:circleDetailLabel];
    circleDetailLabel.text = @"次";
    circleDetailLabel.textColor = COLOR_TITLE_RED;
    circleDetailLabel.font = [UIFont systemFontOfSize:12.0];
    [circleDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(circleLabel.mas_right).offset(2);
        make.bottom.equalTo(circleLabel.mas_bottom).offset(-2);
        make.height.equalTo(@12);
    }];
    
    //综合评价
    UIView *commentBaseView = [[UIView alloc] init];
    self.commentBaseView = commentBaseView;
    [self.view addSubview:commentBaseView];
    commentBaseView.backgroundColor = [UIColor whiteColor];
    [commentBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoBaseView.mas_bottom).offset(1);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(120);
    }];
    UILabel *commentTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 14)];
    [commentBaseView addSubview:commentTitleLabel];
    commentTitleLabel.text = @"综合评价";
    commentTitleLabel.textColor = COLOR_TITLE_BLACK;
    commentTitleLabel.font = [UIFont systemFontOfSize:14.0];
    [commentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentBaseView.mas_top).offset(10);
        make.left.equalTo(commentBaseView.mas_left).offset(12);
        make.height.equalTo(@14);
    }];
    
    //电话
    UIButton *callButton = [[UIButton alloc] init];
    [self.view addSubview:callButton];
    [callButton setImage:[UIImage imageNamed:@"tollcollecter_call"] forState:UIControlStateNormal];
    callButton.backgroundColor = [UIColor whiteColor];
    callButton.layer.cornerRadius = 36;
    callButton.layer.masksToBounds = YES;
    [callButton addTarget:self action:@selector(clickCallButton) forControlEvents:UIControlEventTouchUpInside];
    [callButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentBaseView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(72, 72));
    }];
    
}
#pragma mark - 点击按钮的相关方法
- (void)clickCallButton
{
    UIWebView *callWebview =[[UIWebView alloc] init];
    //NSURL *telURL =[NSURL URLWithString:@"tel:10086"];// 貌似tel:// 或者 tel: 都行
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.mobileNo]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}
#pragma mark - 刷新评价内容
- (void)updateTagViewWithInfo:(NKMepInfo *)info
{
    self.nameLabel.text = info.realName;
    if (info.avatar.length > 0) {
        self.iconImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:info.avatar]]];
    }
    self.circleLabel.text = info.serviceCount;
    self.mobileNo = info.mobile;
    NSArray *allKeys = [info.evaluateTagStat nk_ascendingComparedAllKeys];
    for (NSString *key in allKeys)
    {
        NSString *value = info.evaluateTagStat[key];
        NSString *labelStr = [NSString stringWithFormat:@" %@  %@ ", key, value];
        [self.mepTagArray addObject:labelStr];
    }
    //动态添加标签
    CGFloat positionX = 24.0;
    CGFloat positionY = 38.0;
    CGFloat bgViewWidth = self.commentBaseView.frame.size.width;
    UIFont *labelFont = [UIFont systemFontOfSize:12];
    int num = self.mepTagArray.count > 6 ? 6 : (int)self.mepTagArray.count;
    for (int i = 0; i < num; i++)
    {
        //下面的方法
        CGSize labelSize = [self getSizeByString:self.mepTagArray[i] AndFontSize:14.0];
        CGFloat labelWidth = labelSize.width;
        if(positionX + labelWidth > bgViewWidth)
        {
            positionX = 24;
            positionY += 36;
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(positionX, positionY, labelWidth, 25)];
        label.font = labelFont;
        label.text = self.mepTagArray[i];
        label.textColor = COLOR_TITLE_GRAY;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 12;
        label.layer.borderColor = COLOR_TITLE_GRAY.CGColor;
        label.layer.borderWidth = 1;
        
        positionX += (labelWidth + 6);
        [self.commentBaseView addSubview:label];
    }
    [self.commentBaseView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_infoBaseView.mas_bottom).offset(1);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(positionY + 48);
    }];
}
#pragma  mark - 动态计算标签的长度
- (CGSize)getSizeByString:(NSString*)string AndFontSize:(CGFloat)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(999, 25) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    size.width += 5;
    return size;
}
#pragma mark - 网络请求

- (void)postToGetMEPInfo
{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.mepid forKey:@"mepId"];
    
    NKDataManager *dataManager = [NKDataManager sharedDataManager];
    [dataManager POSTToGetMEPInfomationWithParameters:parameters Success:^(NKMepInfo *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.HUD hideAnimated:YES];
            [self.HUD removeFromSuperViewOnHide];
        });
        if (info)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateTagViewWithInfo:info];
            });
        }
        else
        {
            [self popHUDWithString:@"获取数据失败"];
        }
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.HUD hideAnimated:YES];
            [self.HUD removeFromSuperViewOnHide];
            [self popHUDWithString:@"网络异常"];
        });
    }];
}
- (void)popHUDWithString:(NSString *)str
{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.mode = MBProgressHUDModeText;
    self.HUD.label.text = str;
    [self.HUD hideAnimated:YES afterDelay:2.0];
    [self.HUD removeFromSuperViewOnHide];
}

@end
