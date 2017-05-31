//
//  PersonalInfoTableViewController.m
//  QuickPark-SSP
//
//  Created by Nick on 16/8/11.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "PersonalInfoTableViewController.h"
#import "ChangeNameViewController.h"
#import "ChangePhoneNumberViewController.h"
#import "NKDataManager.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "UIScrollView+JElasticPullToRefresh.h"
#import "LoginViewController.h"
#import "ChangeSignatureViewController.h"
#import "NKImageManager.h"
#import "WalletViewController.h"

@interface PersonalInfoTableViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong)NKDataManager *dataManager;

@property (nonatomic, strong) NKUser *user;

@property(nonatomic, strong)UIButton *iconButton;

@property (nonatomic, strong) UIView *overView;

@property (nonatomic, strong) UIView *datePickerBaseView;

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) UIView *sexPickerBaseView;

@property (nonatomic, strong) UIPickerView *sexPicker;

@end

@implementation PersonalInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    [self initTopView];
    [self initBottomView];
    [self setNavigationBar];
    [self addHeaderRefresh];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorColor = BACKGROUND_COLOR;
    
    //每次进入界面都刷新数据，数据刷新后，更新界面
    [self sendPostToRefreshData];
}
-(void)initTopView
{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW, 64)];
    _topView.backgroundColor = [UIColor whiteColor];
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH_VIEW - 48)/2, 8, 48, 48)];
    _iconImageView.layer.cornerRadius = self.iconImageView.bounds.size.width / 2;
    _iconImageView.layer.masksToBounds = YES;
    
    _iconButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH_VIEW - 48)/2, 8, 48, 48)];
    [_iconButton addTarget:self action:@selector(clickIconButton:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_iconImageView];
    [_topView addSubview:_iconButton];
    self.tableView.tableHeaderView = _topView;
}
-(void)initBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT_VIEW - 48 - 64, WIDTH_VIEW, 48)];
    bottomView.backgroundColor = [UIColor whiteColor];
    UIButton *quitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW, 48)];
    [quitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [quitButton setTitleColor:COLOR_TITLE_BLACK forState:UIControlStateNormal];
    [quitButton addTarget:self action:@selector(clickQuitButton) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:quitButton];
    [self.view addSubview:bottomView];
    self.tableView.tableFooterView = [[UIView alloc] init];
}
-(void)setNavigationBar
{
    self.navigationItem.title = @"个人信息";
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
//添加下拉刷新
-(void)addHeaderRefresh
{
    JElasticPullToRefreshLoadingViewCircle *loadingViewCircle = [[JElasticPullToRefreshLoadingViewCircle alloc] init];
    loadingViewCircle.tintColor = COLOR_NAVI_BLACK;
    __weak __typeof(self)weakSelf = self;
    [self.tableView addJElasticPullToRefreshViewWithActionHandler:^{
        [weakSelf sendPostToRefreshData];
    } LoadingView:loadingViewCircle];
    [self.tableView setJElasticPullToRefreshFillColor:self.tableView.backgroundColor];
    [self.tableView setJElasticPullToRefreshBackgroundColor:self.tableView.backgroundColor];
}
- (void)initInfoWhenViewWillAppear
{
    NSString *iconUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"];
    UIImage *iconImage = [UIImage imageWithData:[NKImageManager getImageDataWithUrl:iconUrl]];
    if (iconImage == nil)
    {
        _iconImageView.image = [UIImage imageNamed:@"头像"];;
    }
    else
    {
        _iconImageView.image = iconImage;
    }
    //刷新tableView上的数据
    [self.tableView reloadData];
}
- (void)dealloc
{
    [self.tableView removeJElasticPullToRefreshView];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
    {
        return 5;
    }
    else if (section == 1)
    {
        return 2;
    }
    else if (section == 2)
    {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"昵称";
                cell.detailTextLabel.text = _user.niName;
                break;
            case 1:
                cell.textLabel.text = @"电话";
                cell.detailTextLabel.text = _user.mobile;
                break;
            case 2:
                cell.textLabel.text = @"生日";
                cell.detailTextLabel.text = _user.birthDate;
                break;
            case 3:
                cell.textLabel.text = @"性别";
                cell.detailTextLabel.text = _user.sex ? @"女" : @"男";
                break;
            case 4:
                cell.textLabel.text = @"签名";
                cell.detailTextLabel.text = _user.signature;
                break;
            default:
                break;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"会籍";
                cell.detailTextLabel.text = _user.userType;
                break;
            case 1:
                cell.textLabel.text = @"积分";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", _user.points];
                break;
            default:
                break;
        }
    }
    if (indexPath.section == 2)
    {
        cell.textLabel.text = @"钱包";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.textColor = COLOR_TITLE_BLACK;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) {
            ChangeNameViewController *cnvc;
            //昵称
            cnvc = [[ChangeNameViewController alloc] init];
            [self.navigationController pushViewController:cnvc animated:YES];
        }else if (indexPath.row == 1){
            ChangePhoneNumberViewController *cpnvc;
            //电话
            cpnvc = [[ChangePhoneNumberViewController alloc] init];
            [self.navigationController pushViewController:cpnvc animated:YES];
        }else if (indexPath.row == 2){
            //生日 创建datepicker
            [self createDatePicker];
        }else if (indexPath.row == 3){
            //性别
            [self createSexPicker];
        }else if (indexPath.row == 4){
            //签名
            ChangeSignatureViewController *csvc = [[ChangeSignatureViewController alloc] init];
            [self.navigationController pushViewController:csvc animated:YES];
        }
    }
    if (indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            case 0:
                //会籍
                break;
            case 1:
                //积分
                break;
            default:
                break;
        }
    }
    if (indexPath.section == 2)
    {
        WalletViewController *wVC = [[WalletViewController alloc] init];
        [self.navigationController pushViewController:wVC animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
#pragma mark - datePicker
- (void)createDatePicker
{
    if (_overView)
    {
        _overView.hidden = NO;
    }else
    {
        _overView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW, HEIGHT_VIEW)];
        _overView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
        [self.tableView addSubview:_overView];
    }
    if (_datePickerBaseView)
    {
        [UIView animateWithDuration:0.3 animations:^{
            _datePickerBaseView.frame = CGRectMake(0, HEIGHT_VIEW - HEIGHT_VIEW * 0.4, WIDTH_VIEW, HEIGHT_VIEW * 0.4);
        }];
        return;
    }
    _datePickerBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT_VIEW - HEIGHT_VIEW * 0.4, WIDTH_VIEW, HEIGHT_VIEW * 0.4)];
    _datePickerBaseView.backgroundColor = BACKGROUND_COLOR;
    [self.tableView addSubview:_datePickerBaseView];
    //添加两个按钮
    CGFloat buttonW = 40;
    CGFloat buttonH = 30;
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 6, buttonW, buttonH)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:COLOR_TITLE_BLACK forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(clickDatePickerCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [_datePickerBaseView addSubview:cancelButton];
    UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH_VIEW - buttonW - 12, 6, buttonW, buttonH)];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:COLOR_TITLE_BLACK forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(clickDatePickerSureButton) forControlEvents:UIControlEventTouchUpInside];
    [_datePickerBaseView addSubview:sureButton];
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, buttonH, WIDTH_VIEW, _datePickerBaseView.frame.size.height - buttonH - 12)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    [_datePickerBaseView addSubview:_datePicker];
}
- (void)clickDatePickerCancelButton
{
    [UIView animateWithDuration:0.5 animations:^{
        _datePickerBaseView.frame = CGRectMake(0, HEIGHT_VIEW * 2, WIDTH_VIEW, HEIGHT_VIEW * 0.4);
        _overView.hidden = YES;
    }];
}
- (void)clickDatePickerSureButton
{
    //获取时间
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    _user.birthDate = [dateformatter stringFromDate:_datePicker.date];
    //刷新单独生日的一行
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
    NSArray *array = @[indexPath];
    [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
    //收起datepicker
    [UIView animateWithDuration:0.5 animations:^{
        _datePickerBaseView.frame = CGRectMake(0, HEIGHT_VIEW * 2, WIDTH_VIEW, HEIGHT_VIEW * 0.4);
        _overView.hidden = YES;
    }];
    //发送请求修改数据
    [self postToChangeUserInfoWithKey:@"birthDate" andValue:_user.birthDate];
}
#pragma mark - sexPicker
- (void)createSexPicker
{
    if (_overView)
    {
        _overView.hidden = NO;
    }else
    {
        _overView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW, HEIGHT_VIEW)];
        _overView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
        [self.tableView addSubview:_overView];
    }
    if (_sexPickerBaseView) {
        [UIView animateWithDuration:0.3 animations:^{
            _sexPickerBaseView.frame = CGRectMake(0, HEIGHT_VIEW - HEIGHT_VIEW * 0.3, WIDTH_VIEW, HEIGHT_VIEW * 0.3);
        }];
        return;
    }
    _sexPickerBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT_VIEW - HEIGHT_VIEW * 0.3, WIDTH_VIEW, HEIGHT_VIEW * 0.3)];
    _sexPickerBaseView.backgroundColor = BACKGROUND_COLOR;
    [self.tableView addSubview:_sexPickerBaseView];
    //添加两个按钮
    CGFloat buttonW = 40;
    CGFloat buttonH = 30;
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 6, buttonW, buttonH)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:COLOR_TITLE_BLACK forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(clickSexPickerCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [_sexPickerBaseView addSubview:cancelButton];
    UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH_VIEW - buttonW - 12, 6, buttonW, buttonH)];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:COLOR_TITLE_BLACK forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(clickSexPickerSureButton) forControlEvents:UIControlEventTouchUpInside];
    [_sexPickerBaseView addSubview:sureButton];
    
    _sexPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, buttonH, WIDTH_VIEW, 80)];
    _sexPicker.delegate = self;
    _sexPicker.dataSource = self;
    [_sexPickerBaseView addSubview:_sexPicker];
}
- (void)clickSexPickerCancelButton
{
    [UIView animateWithDuration:0.5 animations:^{
        _sexPickerBaseView.frame = CGRectMake(0, HEIGHT_VIEW * 2, WIDTH_VIEW, HEIGHT_VIEW * 0.3);
        _overView.hidden = YES;
    }];
}
- (void)clickSexPickerSureButton
{
    //刷新单独生日的一行
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
    NSArray *array = @[indexPath];
    [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
    //收起datepicker
    [UIView animateWithDuration:0.5 animations:^{
        _sexPickerBaseView.frame = CGRectMake(0, HEIGHT_VIEW * 2, WIDTH_VIEW, HEIGHT_VIEW * 0.3);
        _overView.hidden = YES;
    }];
    //发送请求修改数据
    //发送请求修改数据
    [self postToChangeUserInfoWithKey:@"sex" andValue:!_user.sex ? @"男" : @"女"];
}
#pragma mark - UIPickerDelegate && UIPickerDateSource
//指定pickerview有几个表盘
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;//第一个展示字母、第二个展示数字
}

//指定每个表盘上有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

//指定每行如何展示数据（此处和tableview类似）
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * title = nil;
    switch (row) {
        case 0:
            title = @"男";
            break;
        case 1:
            title = @"女";
            break;
        default:
            break;
    }
    return title;
}
//选中时回调
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row == 0) {
        _user.sex = 0;
    }
    else{
        _user.sex = 1;
    }
}
#pragma mark - itemMethod
- (void)clickIconButton:(UIButton *)sender
{
    NSLog(@"更改头像！");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更改头像" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action_photoFromCamera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhotoFromCamera];
        
    }];
    UIAlertAction *action_photoFromAlbum = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhotoFromAlbum];
    }];
    UIAlertAction *action_cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:action_photoFromCamera];
    [alertController addAction:action_photoFromAlbum];
    [alertController addAction:action_cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)clickQuitButton
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"退出登录" message:@"退出登录后需要重新登录，才能使用本账号" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action_exit = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //更改登录标记并且推出登录界面
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:@0 forKey:@"loginFlag"];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        //推出登陆界面
        [self presentViewController:loginVC animated:YES completion:nil];
        
    }];
    [action_exit setValue:[UIColor redColor] forKey:@"titleTextColor"];
    UIAlertAction *action_cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:action_exit];
    [alertController addAction:action_cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark -拍照相关方法
-(void)takePhotoFromCamera
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];//进入照相界面
}
-(void)takePhotoFromAlbum
{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = NO;
    [self presentViewController:pickerImage animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *iconImage = info[UIImagePickerControllerOriginalImage];
    self.iconImageView.image = iconImage;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //发送网络请求
    [self sentPOSTWithImage:iconImage];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"取消选取照片");
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 发送网络请求
- (void)sentPOSTWithImage:(UIImage *)image
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"myToken"];
    //提交照片
    _dataManager = [NKDataManager sharedDataManager];
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    
    //上传文件参数
    NSArray *imageArray = @[image];
    [parametersDic setObject:imageArray forKey:@"imageArray"];
    [parametersDic setObject:@3 forKey:@"appType"];
    [parametersDic setObject:@0 forKey:@"ext2"];
    [parametersDic setObject:token forKey:@"token"];
    [_dataManager POSTUploadImagesWithParameters:parametersDic Success:^(NKFile *file) {
        //实名验证参数
        if ([file.msg isEqualToString:@"ok"] && file.url)
        {
            NSLog(@"上传头像成功！");
            //将头像保存在本地
            [NKImageManager storImage:image WithKey:file.url];
            [[NSUserDefaults standardUserDefaults] setObject:file.url forKey:@"avatar"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView stopLoading];
                [self.tableView reloadData];
            });
            //发送网络请求更改服务器的头像URL
            [self postToChangeUserInfoWithKey:@"avatar" andValue:file.url];
        }
        else
        {
            NSLog(@"%@", file.msg);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView stopLoading];
            });
        }
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView stopLoading];
        });
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"服务器异常！";
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            [hud removeFromSuperViewOnHide];
        });
    }];

}
- (void)sendPostToRefreshData
{
    //发送网络请求数据
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"myToken"] forKey:@"token"];
    _dataManager = [NKDataManager sharedDataManager];
    [_dataManager POSTUpdateDataWithParameters:parameters Success:^(NKLogin *loginMsg) {
        if (loginMsg.ret == 0)
        {
            //获取数据成功
            [NKDataManager writeDataToTextWith:loginMsg];
            self.user = loginMsg.user;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView stopLoading];
                [self initInfoWhenViewWillAppear];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView stopLoading];
            });
        }
    } Failure:^(NSError *error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"服务器异常！";
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            [hud removeFromSuperViewOnHide];
        });
    }];
}

- (void)postToChangeUserInfoWithKey:(NSString *)key andValue:(NSString *)value
{
    //发送网络请求
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"Loding";
    
    NKDataManager *dataManager = [NKDataManager sharedDataManager];
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"myToken"];
    
    //性别参数传递的非字符串，需要判断
    if ([key isEqualToString:@"sex"])
    {
        NSInteger sexInt = [value isEqualToString:@"男"] ? 0 : 1;
        [parametersDic setValue:[NSNumber numberWithInteger:sexInt] forKey:@"sex"];
    }
    else if ([key isEqualToString:@"avatar"])
    {
        [parametersDic setObject:value forKey:@"avatarPic"];
    }
    else
    {
        [parametersDic setObject:value forKey:key];
    }
    [parametersDic setObject:token forKey:@"token"];
    [dataManager POSTUpdateMyInfoWithParameters:parametersDic Success:^(NKBase *base) {
        //将数据写入本地
        NSUserDefaults *userDefualt = [NSUserDefaults standardUserDefaults];
        [userDefualt setObject:value forKey:key];
        //更新user数据
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:_user];
        [userDefault setObject:userData forKey:@"userData"];
        //跟新界面
        dispatch_async(dispatch_get_main_queue(), ^{
            //界面消失
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        });
    } Failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }];
}


@end
