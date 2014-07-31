//
//  PersonalViewController.m
//  Dinner
//
//  Created by 周 加飞 on 14-7-16.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "PersonalViewController.h"

@interface PersonalViewController ()

@property (nonatomic,strong) NSArray *labelArr;

@end

@implementation PersonalViewController

@synthesize userInfo = _userInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"个人资料";
        _userInfo = [NSMutableDictionary dictionary];
        self.labelArr = @[@"用户名",@"余额",@"手机",@"邮箱"];
        [self getAccessToken];
    }
    return self;
}

-(void)getAccessToken
{
    _accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    if (!_accessToken)
    {
        [self goToLogin];
        return;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getCacheData];
    [self showPersonal];
    [self requestPersoanlData];
}

#pragma mark -
#pragma mark Show Personal Interface

//获取个人信息的缓存数据
-(void)getCacheData
{
    NSDictionary *data = [[DataManage shareDataManage] getData:CACHE_NAME withNetworkApi:@"__userinfo"];
    if (data)
    {
        [_userInfo setDictionary:data];
    }
}

//显示个人信息的界面
-(void)showPersonal
{
    if(SYSTEM_VERSION >= 7.0)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsZero;//设置cell的分割线不偏移
    [self.view addSubview:_tableView];
}

//请求个人信息
-(void)requestPersoanlData
{
    ASIFormDataRequest *request_ = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:GET_USERINFO_API]];
    __weak ASIFormDataRequest *request = request_;
    [request addPostValue:_accessToken forKey:@"access_token"];
    [request setCompletionBlock:^{
        if ([request responseStatusCode] != 200)
        {
            return;
        }
        
        if (isNilNull([request responseData]))
        {
            return;
        }
        
        id returnData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:nil];
        if ([returnData isKindOfClass:[NSDictionary class]] && [returnData objectForKey:@"errorCode"])
        {
            //未登录，则调出登陆界面
            if ([[returnData objectForKey:@"errorCode"] isEqualToNumber:[NSNumber numberWithInt:40002]])
            {
                [self goToLogin];
                return;
            }
            [ProgressHUD showError:[returnData objectForKey:@"errorText"]];
            return;
        }
        else
        {
            [_userInfo setObject:[returnData objectForKey:@"balance"] forKey:@"balance"];
            //保存到数据库
            [[DataManage shareDataManage] insertData:CACHE_NAME withNetworkApi:@"__userinfo" withObject:_userInfo];
            [_tableView reloadData];
        }
    }];
    [request setFailedBlock:^{
        [ProgressHUD showError:@"网络连接错误"];
    }];
    [request startAsynchronous];
}

#pragma mark -
#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    PersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        cell = [[PersonalTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    NSInteger rowNo = indexPath.row;
    NSString *mobile = @"";
    NSString *email = @"";
    cell.labelName.text = [self.labelArr objectAtIndex:rowNo];
    if (_userInfo)
    {
        switch (rowNo)
        {
            case 0:
                cell.detailInfo.text = [_userInfo objectForKey:@"name"];
                break;
            case 1:
                cell.detailInfo.text = [NSString stringWithFormat:@"￥%@",[_userInfo objectForKey:@"balance"]];
                break;
            case 2:
                if (!isNilNull([_userInfo objectForKey:@"mobile"]))
                {
                    mobile = [_userInfo objectForKey:@"mobile"];
                }
                cell.detailInfo.text = mobile;
                break;
            case 3:
                if (!isNilNull([_userInfo objectForKey:@"email"]))
                {
                    email = [_userInfo objectForKey:@"email"];
                }
                cell.detailInfo.text = email;
                break;
            default:
                break;
        }
    }
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 68, 100, 30)];
    titleLabel.text = @"基本信息";
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor grayColor];
    [view addSubview:titleLabel];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark -
#pragma mark Go To Login Method

//跳转到登陆界面
-(void)goToLogin
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
