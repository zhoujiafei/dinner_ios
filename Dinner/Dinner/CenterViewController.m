//
//  MoreViewController.m
//  Dinner
//
//  Created by 刘 金兰 on 14-7-5.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "CenterViewController.h"

@interface CenterViewController ()

@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *balance;

@end


@implementation CenterViewController

@synthesize pathCover = _pathCover;
@synthesize tableView = _tableView;
@synthesize settingLabels = _settingLabels;
@synthesize userInfo = _userInfo;
@synthesize settingIcons = _settingIcons;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"用户中心";
    
    //根据保存的access_token获取用户信息
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    if (accessToken)
    {
        __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:GET_USERINFO_API]];
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
            
            NSData *data = [request responseData];
            NSDictionary *returnData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (![returnData objectForKey:@"errorCode"])
            {
                _userInfo = returnData;
                self.userName = [_userInfo objectForKey:@"name"];
                self.balance = [_userInfo objectForKey:@"balance"];
                //设置用户名与账户
                [_pathCover setInfo:[NSDictionary
                                     dictionaryWithObjectsAndKeys:
                                     self.userName, XHUserNameKey,
                                     [NSString stringWithFormat:@"账户余额：￥%@",self.balance], XHBirthdayKey, nil]];
            }
        }];
        [request setFailedBlock:^{
            [ProgressHUD showError:@"网络错误"];
        }];
        [request startAsynchronous];
    }
    
    //设置项
    _settingLabels = [NSArray arrayWithObjects:
                        @[@"个人资料",@"修改密码"],
                        @[@"今日订单",@"历史订单"],nil];
    
    _settingIcons = [NSArray arrayWithObjects:
                     @[@"personal_account",@"personal_recharge"],@[@"order_forPay",@"order_all"],nil];
    
    if(SYSTEM_VERSION >= 7.0)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsZero;//设置cell的分割线不偏移
    [self.view addSubview:_tableView];
    
    _pathCover = [[XHPathCover alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 220)];
    [_pathCover setBackgroundImage:[UIImage imageNamed:@"cover"]];
    [_pathCover setAvatarImage:[UIImage imageNamed:@"meicon.png"]];
    [_pathCover setInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.userName, XHUserNameKey, self.balance, XHBirthdayKey, nil]];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

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

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击之前判断当前用户有没有登陆,如果没有叫调出登陆界面
    if (!self.userName)
    {
        [self goToLogin];
        return;
    }
    
    if (indexPath.section)
    {
        switch (indexPath.row)
        {
            case 0:
                [self goToTargetInterface:[[TodayOrderViewController alloc] init]];
                break;
            case 1:
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

#pragma mark- scroll delegate
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
