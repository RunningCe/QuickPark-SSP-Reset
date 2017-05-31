//
//  MassageCenterTableViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 16/8/22.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "MassageCenterTableViewController.h"
#import "MassageCenterTableViewCell.h"
#import "NKDataManager.h"
#import "NKMessageRecord.h"
#import "MassageCenterDetailViewController.h"
#import "MBProgressHUD/MBProgressHUD.h"

@interface MassageCenterTableViewController ()

@property (nonatomic, strong)NSMutableArray *messageRecordMutableArray;

@end

@implementation MassageCenterTableViewController

-(NSMutableArray *)messageMutableArray
{
    if (_messageRecordMutableArray == nil)
    {
        _messageRecordMutableArray = [NSMutableArray array];
    }
    return _messageRecordMutableArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.tableView.tableFooterView=[[UIView alloc]init];
    [self.tableView registerNib:[UINib nibWithNibName:@"MassageCenterTableViewCell" bundle:nil] forCellReuseIdentifier:@"MassageCenterTableViewCell"];
    [self setNavigationBar];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self sentPOSTforData];
}
- (void)setNavigationBar
{
    self.navigationItem.title = @"消息中心";
    UIImage *itemImage = [UIImage imageNamed:@"左箭头"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[itemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_TITLE_WHITE}];
    
    self.navigationController.navigationBar.barTintColor = COLOR_NAVI_BLACK;
    self.navigationController.navigationBar.backgroundColor = COLOR_NAVI_BLACK;
}
-(void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.messageRecordMutableArray.count;
    //return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MassageCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MassageCenterTableViewCell" forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[MassageCenterTableViewCell alloc] init];
    }
    cell.contentView.backgroundColor = BACKGROUND_COLOR;
    /*******设置单元格具体内容********/
    cell.label_0.text = @"产品消费";
    //根据网络加载内容填充单元格
    NKMessageRecord *record = self.messageRecordMutableArray[indexPath.section];
    NSString *messageString = record.pushContent;
    NSData *data = [messageString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    cell.topLabel.text = record.pushTitle;
    cell.label_0.text = [array[0] objectForKey:@"group"];
    cell.label_1.text = [array[1] objectForKey:@"group"];
    cell.label_2.text = [array[2] objectForKey:@"group"];
    cell.label_3.text = [array[3] objectForKey:@"group"];
    
    cell.detailLabel_0 = [array[0] objectForKey:@"params"];
    cell.detailLabel_1 = [array[1] objectForKey:@"params"];
    cell.detailLabel_2 = [array[2] objectForKey:@"params"];
    cell.detailLabel_3 = [array[3] objectForKey:@"params"];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了单元格%lu",indexPath.section);
    MassageCenterDetailViewController *mcdVC = [[MassageCenterDetailViewController alloc] initWithRecord:self.messageRecordMutableArray[indexPath.section]];
    [self.navigationController pushViewController:mcdVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 16;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW, 16)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, view.bounds.size.width, 10)];
    label.text = @"16:20";
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont systemFontOfSize:10.0]];
    label.textColor = COLOR_TITLE_GRAY;
    [view addSubview:label];
    return view;
}
#pragma mark - 网络请求
- (void)sentPOSTforData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"Loding";
    
    NKDataManager *dataManager = [NKDataManager sharedDataManager];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefault objectForKey:@"myToken"];
    
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    [parametersDic setObject:token forKey:@"token"];
    
    [dataManager POSTGetMessageWithParameters:parametersDic Success:^(NSMutableArray *messageArray) {
        NSLog(@"消息请求成功！");
        [self.messageRecordMutableArray removeAllObjects];
        self.messageRecordMutableArray = [NSMutableArray arrayWithArray:messageArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView reloadData];
        });
        
    } Failure:^(NSError *error) {
        NSLog(@"消息请求失败！");
        NSLog(@"%@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
    }];
    
}

@end
