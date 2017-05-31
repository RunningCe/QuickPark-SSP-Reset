//
//  ConsumerDetailsTableViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 2017/2/18.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "ConsumerDetailsTableViewController.h"
#import "NKDataManager.h"
#import "MJRefresh.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "NKBillDetail.h"
#import "NKBillDetailTableViewCell.h"

@interface ConsumerDetailsTableViewController ()

@property (nonatomic, strong) NSMutableArray *billListArray;

//网络请求参数-请求分页页码
@property (nonatomic, assign)NSInteger pageNo;
//网络请求参数-请求分页每页的大小
@property (nonatomic, assign)NSInteger pageSize;

@end

@implementation ConsumerDetailsTableViewController
#pragma mark - setter && getter
-(NSMutableArray *)billListArray
{
    if (_billListArray == nil)
    {
        _billListArray = [NSMutableArray array];
    }
    return _billListArray;
}

#pragma mark - viewLife
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(postToGetBillList)];
    
    _pageNo = 0;
    _pageSize = 10;
    [self postToGetBillList];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NKBillDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"NKBillDetailTableViewCell"];
    self.tableView.separatorColor = [UIColor colorWithRed:189.0 / 255.0 green:189.0 / 255.0 blue:189.0 / 255.0 alpha:1.0];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] init];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self setNavigationBar];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _pageNo = 0;
    _pageSize = 0;
}
#pragma mark - 界面初始化方法
-(void)setNavigationBar
{
    self.navigationItem.title = @"明细";
    UIImage *itemImage = [UIImage imageNamed:@"左箭头"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[itemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_TITLE_WHITE}];
    
    self.navigationController.navigationBar.barTintColor = COLOR_NAVI_BLACK;
    self.navigationController.navigationBar.backgroundColor = COLOR_NAVI_BLACK;
    
    //设置statusBar颜色，不设置会变成白色
    UIView *statusBar = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
    statusBar.backgroundColor = COLOR_NAVI_BLACK;
    [self.navigationController.navigationBar addSubview:statusBar];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.billListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NKBillDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NKBillDetailTableViewCell" forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[NKBillDetailTableViewCell alloc] init];
    }
    NKBillDetail *bill = self.billListArray[indexPath.row];
    cell.billTypeLabel.text = bill.recordType;
    cell.billCreateTimeLabel.text = bill.createTime;
    cell.moneyLabel.text = bill.money;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - 网络请求
- (void)postToGetBillList
{
    // 启动风火轮
    MBProgressHUD __block *hud;
    dispatch_async(dispatch_get_main_queue(), ^{
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = @"Loding";
    });
    
    NSString *sspId = [[NSUserDefaults standardUserDefaults] objectForKey:@"sspId"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:sspId forKey:@"sspid"];
    [parameters setObject:[NSNumber numberWithInteger:_pageSize] forKey:@"pageSize"];
    [parameters setObject:[NSNumber numberWithInteger:_pageNo] forKey:@"pageNo"];
    
    NKDataManager *dataManager = [NKDataManager sharedDataManager];
    [dataManager POSTGetBillDetailWithParameters:parameters Success:^(NSArray *billDetailArray) {
        if (billDetailArray.count == 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                [hud removeFromSuperViewOnHide];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            });
            return;
        }
        [self.billListArray addObjectsFromArray:billDetailArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            [hud removeFromSuperViewOnHide];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            _pageNo++;
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView reloadData];
        });
        
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            [hud removeFromSuperViewOnHide];
            [self.tableView.mj_footer endRefreshing];
        });
    }];
}


@end
