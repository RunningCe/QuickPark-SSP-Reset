//
//  CarBrandTypeTableViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 2016/12/30.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "CarBrandTypeTableViewController.h"
#import "NKCarBrandData.h"
#import "NKCarBrandTypeData.h"
#import "NKCarBrandTableViewCell.h"
#import "NKImageManager.h"

@interface CarBrandTypeTableViewController ()

@end

@implementation CarBrandTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"NKCarBrandTableViewCell" bundle:nil] forCellReuseIdentifier:@"NKCarBrandTableViewCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self setNavigationBar];
}

#pragma mark - 视图创建
- (void)setNavigationBar
{
    self.navigationItem.title = @"选择车型";
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

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return self.carBrandData.btiList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NKCarBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NKCarBrandTableViewCell" forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[NKCarBrandTableViewCell alloc] init];
        }
        cell.carBrandLabel.text = self.carBrandData.cartypename;
        cell.carBrandImageView.image = [UIImage imageWithData:[NKImageManager getImageDataWithUrl:self.carBrandData.brandlogourl]];
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        NKCarBrandTypeData *type = self.carBrandData.btiList[indexPath.row];
        cell.textLabel.text = type.brandtype;
        cell.textLabel.textColor = COLOR_TITLE_BLACK;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //反向传值
    NKCarBrandTypeData *type = self.carBrandData.btiList[indexPath.row];
    NSString *backStr = [NSString stringWithFormat:@"%@-%@", type.cartypename, type.brandtype];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CarBrandDidSelect" object:nil userInfo:@{@"carTypeStr":backStr, @"logoPicUrl":self.carBrandData.brandlogourl}];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
