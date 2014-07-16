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
    
    cell.textLabel.text = [[_settingLabels objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
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
