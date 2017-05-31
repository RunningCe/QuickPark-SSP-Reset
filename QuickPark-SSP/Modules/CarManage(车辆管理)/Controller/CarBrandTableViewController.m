//
//  CarBrandTableViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 2016/12/29.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "CarBrandTableViewController.h"
#import "NKCarBrandTableViewCell.h"
#import "NKDataManager.h"
#import "NKCarBrandBaseData.h"
#import "NKCarBrandData.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "CarBrandTypeTableViewController.h"
#import "NKImageManager.h"

@interface CarBrandTableViewController ()
//保存分区的大写字母的数组
@property (nonatomic, strong) NSArray *lettersArray;
//保存所有车辆品牌的字典 字典-》A->[]->对象
@property (nonatomic, strong) NSDictionary *carBrandDictionary;

@end

@implementation CarBrandTableViewController
#pragma mark - setter && getter
- (NSArray *)lettersArray
{
    if (_lettersArray == nil)
    {
        _lettersArray = [NSArray array];
    }
    return _lettersArray;
}
- (NSDictionary *)carBrandDictionary
{
    if (_carBrandDictionary == nil)
    {
        _carBrandDictionary = [NSDictionary dictionary];
    }
    return _carBrandDictionary;
}
#pragma mark - controller生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"NKCarBrandTableViewCell" bundle:nil] forCellReuseIdentifier:@"NKCarBrandTableViewCell"];
    [self setNavigationBar];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    self.tableView.sectionIndexColor = COLOR_TITLE_BLACK;
    self.tableView.sectionIndexBackgroundColor =[UIColor clearColor];
    
    [self postToGetCarBrandList];
}
#pragma mark - 设置界面方法
- (void)setNavigationBar
{
    self.navigationItem.title = @"选择品牌";
    UIImage *leftItemImage = [UIImage imageNamed:@"左箭头"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[leftItemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_TITLE_WHITE}];
    
    self.navigationController.navigationBar.barTintColor = COLOR_NAVI_BLACK;
    self.navigationController.navigationBar.backgroundColor = COLOR_NAVI_BLACK;
}
- (void)goBack
{
    if (self.navigationController.childViewControllers.count == 1)
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
    return self.lettersArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *carBrandArray = self.carBrandDictionary[self.lettersArray[section]];
    return carBrandArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NKCarBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NKCarBrandTableViewCell" forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[NKCarBrandTableViewCell alloc] init];
    }
    NSArray *carBrandArray = self.carBrandDictionary[self.lettersArray[indexPath.section]];
    NKCarBrandData *carBrand = carBrandArray[indexPath.row];
    cell.carBrandLabel.text = carBrand.cartypename;
    cell.carBrandImageView.image = [UIImage imageWithData:[NKImageManager getImageDataWithUrl:carBrand.brandlogourl]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 18;
}
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.lettersArray;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW, 18)];
    headerView.backgroundColor = BACKGROUND_COLOR;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, WIDTH_VIEW / 2, 12)];
    titleLabel.text = self.lettersArray[section];
    titleLabel.font = [UIFont systemFontOfSize:12.0];
    titleLabel.textColor = COLOR_TITLE_BLACK;
    [headerView addSubview:titleLabel];
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *carBrandArray = self.carBrandDictionary[self.lettersArray[indexPath.section]];
    NKCarBrandData *carBrand = carBrandArray[indexPath.row];
    CarBrandTypeTableViewController *cbtTVC = [[CarBrandTypeTableViewController alloc] init];
    cbtTVC.carBrandData = carBrand;
    [self.navigationController pushViewController:cbtTVC animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}
#pragma mark - 网络请求方法
- (void)postToGetCarBrandList
{
    MBProgressHUD *waitHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NKDataManager *dataManager = [NKDataManager sharedDataManager];
    [dataManager POSTToGetAllCarBrandWithParameters:nil Success:^(NKCarBrandBaseData *carBrandBaseData) {
        if (carBrandBaseData.ret == 0)
        {
            NSComparator finderSort = ^(NSString *string1,NSString *string2){
                
                if (string1 > string2) {
                    return (NSComparisonResult)NSOrderedDescending;
                }else if (string1 < string2){
                    return (NSComparisonResult)NSOrderedAscending;
                }
                else
                    return (NSComparisonResult)NSOrderedSame;
            };
            NSArray *newKeyArray = [carBrandBaseData.result allKeys];
            self.lettersArray = [newKeyArray sortedArrayUsingComparator:finderSort];
            self.carBrandDictionary = [NSDictionary dictionaryWithDictionary:carBrandBaseData.result];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [waitHUD hideAnimated:YES];
            [waitHUD removeFromSuperViewOnHide];
            [self.tableView reloadData];
        });
        
    } Failure:^(NSError *error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"网络异常";
        dispatch_async(dispatch_get_main_queue(), ^{
            [waitHUD hideAnimated:YES];
            [waitHUD removeFromSuperViewOnHide];
            [hud hideAnimated:YES afterDelay:1.0];
            [hud removeFromSuperViewOnHide];
        });
    }];
}
@end
