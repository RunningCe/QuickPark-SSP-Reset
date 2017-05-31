//
//  MassageCenterDetailViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 16/8/30.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "MassageCenterDetailViewController.h"
#import "Masonry.h"

@interface MassageCenterDetailViewController ()

@property (nonatomic, strong)NKMessageRecord *record;

@end

@implementation MassageCenterDetailViewController
- (instancetype)initWithRecord:(NKMessageRecord *)record
{
    if (self = [super init])
    {
        self.record = record;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setNavigationBar];
    [self initSubViews];
}
- (void)setNavigationBar
{
    self.navigationItem.title = @"消息详情";
    UIImage *itemImage = [UIImage imageNamed:@"左箭头"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[itemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_TITLE_WHITE}];
    
    self.navigationController.navigationBar.barTintColor = COLOR_NAVI_BLACK;
    self.navigationController.navigationBar.backgroundColor = COLOR_NAVI_BLACK;
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
    NSString *messageString = self.record.pushContent;
    NSData *data = [messageString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    [self.view addSubview:titleLabel];
    titleLabel.text = self.record.pushTitle;
    titleLabel.textColor = COLOR_TITLE_BLACK;
    titleLabel.font = [UIFont systemFontOfSize:20.0];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(12);
        make.top.equalTo(self.view.mas_top).offset(80);
    }];
    
    NSDateFormatter *matter = [[NSDateFormatter alloc]init];
    matter.dateFormat =@"YYYY年MM月dd日 HH:mm";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.record.pushTime / 1000];
    NSString *timeStr = [matter stringFromDate:date];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 12)];
    [self.view addSubview:dateLabel];
    dateLabel.text = [NSString stringWithFormat:@"%@", timeStr];
    dateLabel.textColor = COLOR_TITLE_GRAY;
    dateLabel.font = [UIFont systemFontOfSize:12.0];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(12);
        make.top.equalTo(titleLabel.mas_bottom).offset(12);
    }];
    
    for (int i = 0; i < array.count; i++)
    {
        if ([[array[i] objectForKey:@"group"] hasPrefix:@"备注"])
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 16)];
            [self.view addSubview:label];
            label.textColor = COLOR_TITLE_BLACK;
            label.text = [array[i] objectForKey:@"group"];
            label.font = [UIFont systemFontOfSize:16.0];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view.mas_left).offset(12);
                make.top.equalTo(dateLabel.mas_bottom).offset(28 + 28 * i + 8);
            }];
            UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            [self.view addSubview:detailLabel];
            detailLabel.textColor = COLOR_TITLE_GRAY;
            detailLabel.text = [array[i] objectForKey:@"params"];
            detailLabel.font = [UIFont systemFontOfSize:16.0];
            [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label.mas_right).offset(6);
                make.top.equalTo(label.mas_top);
                make.right.equalTo(self.view.mas_right).offset(-30);
            }];
            NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
            CGSize labelSize = [detailLabel.text boundingRectWithSize:CGSizeMake(200, 5000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            detailLabel.frame = CGRectMake(detailLabel.frame.origin.x, detailLabel.frame.origin.y, detailLabel.frame.size.width, labelSize.height);
            //保持原来Label的位置和宽度，只是改变高度。
            detailLabel.numberOfLines = 0;//表示label可以多行显示
        }
        else
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 16)];
            [self.view addSubview:label];
            label.textColor = COLOR_TITLE_BLACK;
            label.text = [NSString stringWithFormat:@"%@:", [array[i] objectForKey:@"group"]];
            label.font = [UIFont systemFontOfSize:16.0];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view.mas_left).offset(12);
                make.top.equalTo(dateLabel.mas_bottom).offset(28 + 28 * i);
            }];
            UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 16)];
            [self.view addSubview:detailLabel];
            detailLabel.textColor = COLOR_TITLE_GRAY;
            detailLabel.text = [array[i] objectForKey:@"params"];
            detailLabel.font = [UIFont systemFontOfSize:16.0];
            [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(label.mas_top);
                make.left.equalTo(label.mas_right).offset(6);
            }];
        }
    }
}


@end
