//
//  MoreViewController.m
//  Dinner
//
//  Created by 刘 金兰 on 14-7-5.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "CenterViewController.h"

@implementation CenterViewController

@synthesize pathCover = _pathCover;
@synthesize tableView = _tableView;
@synthesize settingLabels = _settingLabels;
@synthesize userInfo = _userInfo;
@synthesize settingIcons = _settingIcons;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"用户中心";
        _userInfo = [NSMutableDictionary dictionary];
        //设置项
        _settingLabels = [NSArray arrayWithObjects:
                          @[@"个人资料",@"修改密码"],
                          @[@"我的订单"],nil];
        
        _settingIcons = [NSArray arrayWithObjects:
                         @[@"personal_account",@"personal_recharge"],@[@"order_all"],nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getCacheData];
    [self showCenter];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self changeInterface];
}

#pragma mark -
#pragma mark Show Center Interface

//获取用户缓存信息
-(void)getCacheData
{
    NSDictionary *data = [[DataManage shareDataManage] getData:CACHE_NAME withNetworkApi:@"__userinfo"];
    if (data)
    {
        [_userInfo setDictionary:data];
    }
}

//显示用户中心界面
-(void)showCenter
{
    if(SYSTEM_VERSION >= 7.0)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsZero;//设置cell的分割线不偏移
    [self.view addSubview:_tableView];
    
    _pathCover = [[XHPathCover alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 220)];
    [_pathCover setBackgroundImage:[UIImage imageNamed:@"banner"]];
//    [_pathCover.avatarButton addTarget:self action:@selector(modifyAvatar:) forControlEvents:UIControlEventTouchUpInside];
    [_pathCover.loginButton addTarget:self action:@selector(goToLogin) forControlEvents:UIControlEventTouchUpInside];
    [_pathCover.logoutButton addTarget:self action:@selector(goLogout) forControlEvents:UIControlEventTouchUpInside];
    
    if ([_userInfo objectForKey:@"name"])
    {
//        if (!isNilNull([_userInfo objectForKey:@"avatar"]))
//        {
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                NSString *avatarPath = [NSString stringWithFormat:@"%@%@%@",
//                                        [[_userInfo objectForKey:@"avatar"] objectForKey:@"host"],
//                                        [[_userInfo objectForKey:@"avatar"] objectForKey:@"filepath"],
//                                        [[_userInfo objectForKey:@"avatar"] objectForKey:@"filename"]];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [_pathCover setAvatarImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:avatarPath]]]];
//                });  
//            });
//        }
//        else
//        {
            [_pathCover setAvatarImage:[UIImage imageNamed:@"avatar.jpg"]];
//        }
        
        NSString *balance = [NSString stringWithFormat:@"￥ %@",[_userInfo objectForKey:@"balance"]];
        [_pathCover setInfo:[NSDictionary dictionaryWithObjectsAndKeys:[_userInfo objectForKey:@"name"], XHUserNameKey, balance, XHBirthdayKey, nil]];
        _pathCover.logoutButton.hidden = NO;
        _pathCover.loginButton.hidden = YES;
    }
    else
    {
        _pathCover.logoutButton.hidden = YES;
        _pathCover.loginButton.hidden = NO;
        [_pathCover setAvatarImage:[UIImage imageNamed:@"avatar.jpg"]];
    }
    self.tableView.tableHeaderView = self.pathCover;
    
    //刷新
    __weak CenterViewController *wself = self;
    [_pathCover setHandleRefreshEvent:^{
        double delayInSeconds = 4.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [wself.pathCover stopRefresh];
        });
    }];
}

#pragma mark -
#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_settingLabels objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    CenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        cell = [[CenterTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    NSInteger rowNo = indexPath.row;
    cell.textLabel.text = [[_settingLabels objectAtIndex:indexPath.section] objectAtIndex:rowNo];
    cell.imageView.image = [UIImage imageNamed:[[_settingIcons objectAtIndex:indexPath.section] objectAtIndex:rowNo]];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击之前判断当前用户有没有登陆,如果没有叫调出登陆界面
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    if (!accessToken)
    {
        [self goToLogin];
        return;
    }
    
    if (indexPath.section)
    {
        switch (indexPath.row)
        {
            case 0:
                [self goToTargetInterface:[[HistoryOrderViewController alloc] init]];
                break;
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row)
        {
            case 0:
                [self goToTargetInterface:[[PersonalViewController alloc] init]];
                break;
            case 1:
                [self goToTargetInterface:[[ModifyPasswordViewController alloc] init]];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark -
#pragma mark Go To Interface

//跳到指定的界面
-(void)goToTargetInterface:(BaseViewController *)viewController
{
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}


//跳转到登陆界面
-(void)goToLogin
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
}

//退出操作
-(void)goLogout
{
    //点击之前判断当前用户有没有登陆,如果没有叫调出登陆界面
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    if (!accessToken)
    {
        [self clearUserInfo];
        [ProgressHUD showSuccess:@"您已经退出"];
        //头像换成默认头像
        [_pathCover setAvatarImage:[UIImage imageNamed:@"avatar.jpg"]];
        return;
    }
    
    [ProgressHUD show:@"正在退出..."];
    ASIFormDataRequest *request_ = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:LOGOUT_API]];
    __weak ASIFormDataRequest *request = request_;
    [request addPostValue:accessToken forKey:@"access_token"];
    [request setCompletionBlock:^{
        if ([request responseStatusCode] != 200)
        {
            return;
        }
        
        if (isNilNull([request responseData]))
        {
            return;
        }
        
        NSDictionary *returnData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:nil];
        if ([returnData objectForKey:@"errorCode"])
        {
            [ProgressHUD showError:[returnData objectForKey:@"errorText"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ProgressHUD dismiss];
            });
            return;
        }
        else
        {
            [ProgressHUD showSuccess:@"退出成功"];
            //清空用户信息缓存
            [self clearUserInfo];
            //改变界面的显示
            [self changeInterface];
        }
    }];
    [request setFailedBlock:^{
        [ProgressHUD showError:@"网络连接错误"];
    }];
    [request startAsynchronous];
}

//清除用户缓存信息
-(void)clearUserInfo
{
    [_userInfo removeAllObjects];
    [[DataManage shareDataManage] deleteData:CACHE_NAME withNetworkApi:@"__userinfo"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//改变界面的显示
-(void)changeInterface
{
    [_userInfo removeAllObjects];
    NSDictionary *data = [[DataManage shareDataManage] getData:CACHE_NAME withNetworkApi:@"__userinfo"];
    if (data)
    {
        [_userInfo setDictionary:data];
        if ([_userInfo objectForKey:@"name"])
        {
//            if (!isNilNull([_userInfo objectForKey:@"avatar"]))
//            {
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    NSString *avatarPath = [NSString stringWithFormat:@"%@%@%@",
//                                            [[_userInfo objectForKey:@"avatar"] objectForKey:@"host"],
//                                            [[_userInfo objectForKey:@"avatar"] objectForKey:@"filepath"],
//                                            [[_userInfo objectForKey:@"avatar"] objectForKey:@"filename"]];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [_pathCover setAvatarImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:avatarPath]]]];
//                    });
//                });
//            }
//            else
//            {
                [_pathCover setAvatarImage:[UIImage imageNamed:@"avatar.jpg"]];
//            }
            
            NSString *balance = [NSString stringWithFormat:@"￥ %@",[_userInfo objectForKey:@"balance"]];
            [_pathCover setInfo:[NSDictionary dictionaryWithObjectsAndKeys:[_userInfo objectForKey:@"name"], XHUserNameKey, balance, XHBirthdayKey, nil]];
            _pathCover.logoutButton.hidden = NO;
            _pathCover.loginButton.hidden = YES;
            _pathCover.userNameLabel.hidden = NO;
            _pathCover.birthdayLabel.hidden = NO;
        }
    }
    else
    {
        [_pathCover setInfo:[NSDictionary dictionaryWithObjectsAndKeys:nil, XHUserNameKey, nil, XHBirthdayKey, nil]];
        _pathCover.logoutButton.hidden = YES;
        _pathCover.loginButton.hidden = NO;
        _pathCover.userNameLabel.hidden = YES;
        _pathCover.birthdayLabel.hidden = YES;
        [_pathCover setAvatarImage:[UIImage imageNamed:@"avatar.jpg"]];
    }
}

//修改用户头像
-(void)modifyAvatar:(UIButton *)btn
{
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    if (!accessToken)
    {
        [self goToLogin];
        return;
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"上传头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从相册里取照片" otherButtonTitles:@"拍照", nil];
    [actionSheet showInView:self.view];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0://从相册取照片
            [self getPictureFromPhotoLibrary];
            break;
        case 1://拍照
            [self getPictureFromCamera];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark Get Picture Methods

//从相册取照片
-(void)getPictureFromPhotoLibrary
{
    //检查相册是否可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        [ProgressHUD showError:@"相册不可用"];
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

//拍照
-(void)getPictureFromCamera
{
    //检查当前相机是否可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [ProgressHUD showError:@"相机不可用"];
        return;
    }
    
    //检查相机是否支持拍照
    NSArray *avalableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    BOOL canTakePhoto = NO;
    for (NSString *mediaType in avalableMediaTypes)
    {
        if ([mediaType isEqualToString:(NSString*)kUTTypeImage])
        {
            //支持拍照
            canTakePhoto = YES;
            break;
        }
    }
    
    if (!canTakePhoto)
    {
        [ProgressHUD showError:@"不支持拍照"];
        return;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    //设置图像选取控制器的来源模式为相机模式
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //设置图像选取控制器的类型为静态图像
    imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
    //允许用户编辑
    imagePickerController.allowsEditing = YES;
    //设置代理
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissViewControllerAnimated:YES completion:^{
        //先保存图片
        NSString *imagePath = [self saveImageWithImage:image];
        //再上传图片
        [self uploadImage:imagePath];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
     [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Save Avatar Picture

- (NSString *)saveImageWithImage:(UIImage *)image
{
    if (image)
    {
        NSString *imagePath = [PATH_OF_TEMP stringByAppendingPathComponent:@"avatar.png"];
        //保存图片
        [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
        return imagePath;
    }
    else
    {
        return nil;
    }
}

#pragma mark -
#pragma mark Upload image Whitch was Picked

//上传选择的图片
-(void)uploadImage:(NSString *)imagePath
{
    //点击之前判断当前用户有没有登陆,如果没有叫调出登陆界面
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    [ProgressHUD show:@"正在上传图片..."];
    ASIFormDataRequest *request_ = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:MODIFY_AVATAR_API]];
    __weak ASIFormDataRequest *request = request_;
    [request addFile:imagePath forKey:@"avatar"];
    [request addPostValue:accessToken forKey:@"access_token"];
    [request setCompletionBlock:^{
        if ([request responseStatusCode] != 200)
        {
            return;
        }
        
        if (isNilNull([request responseData]))
        {
            return;
        }
        
        NSDictionary *returnData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:nil];
        if ([returnData objectForKey:@"errorCode"])
        {
            [ProgressHUD showError:[returnData objectForKey:@"errorText"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ProgressHUD dismiss];
            });
            return;
        }
        else
        {
            [ProgressHUD showSuccess:@"上传成功"];
            dispatch_async(dispatch_get_main_queue(), ^{
               [_pathCover setAvatarImage:[UIImage imageWithContentsOfFile:imagePath]];
            });
        }
    }];
    [request setFailedBlock:^{
        [ProgressHUD showError:@"网络连接错误"];
    }];
    [request startAsynchronous];
}


#pragma mark -
#pragma mark scroll delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_pathCover scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_pathCover scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_pathCover scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_pathCover scrollViewWillBeginDragging:scrollView];
}

@end
