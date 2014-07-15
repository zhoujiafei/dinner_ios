//
//  LoginViewController.m
//  Dinner
//
//  Created by 周 加飞 on 14-7-7.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (nonatomic,strong) NSArray *labelArr;//标签

@end

@implementation LoginViewController

@synthesize username    = _username;
@synthesize password    = _password;
@synthesize tableView   = _tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"登陆";
    //注册按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(goToRegister)];
    
    //回到上一个界面
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToOver)];
    
    self.labelArr = [NSArray arrayWithObjects:@[@"账号",@"密码"],@[@"登陆"],nil];
    //创建tableView
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsZero;//设置cell的分割线不偏移
    [self.view addSubview:_tableView];
}

#pragma mark -login UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    NSArray *sectionData = [self.labelArr objectAtIndex:section];
    return [sectionData count];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    if (indexPath.section)
    {
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = APP_BASE_COLOR;
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        loginBtn.frame = CGRectMake(cell.frame.size.width/2 - 50 , 0, 100, 44);
        [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
        [loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(goToLogin) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:loginBtn];
        [cell addSubview:loginBtn];
    }
    else
    {
        NSArray *sectionData = [self.labelArr objectAtIndex:indexPath.section];
        cell.textLabel.text = [sectionData objectAtIndex:indexPath.row];
        switch (indexPath.row)
        {
            case 0:
                self.username = [[UITextField alloc] initWithFrame:CGRectMake(80,11,220,32)];
                self.username.placeholder = @"用户名";
                [cell addSubview:self.username];
                break;
            case 1:
                self.password = [[UITextField alloc] initWithFrame:CGRectMake(80,11,220,32)];
                self.password.placeholder = @"密码";
                [cell addSubview:self.password];
                break;
            default:
                break;
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}

//去注册
-(void)goToRegister
{
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

//去登陆
-(void)goToLogin
{
    NSString *username = [self.username.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length] == 0)
    {
        [ProgressHUD showError:@"用户名不能为空"];
        return;
    }
    
    if ([password length] == 0)
    {
        [ProgressHUD showError:@"密码不能为空"];
        return;
    }
    
    //发送请求去登陆
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:LOGIN_API]];
    [request addPostValue:username forKey:@"name"];
    [request addPostValue:password forKey:@"password"];
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error)
    {
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:nil];
        if ([data objectForKey:@"errorCode"])
        {
            [ProgressHUD showError:[data objectForKey:@"errorText"]];
            return;
        }
        else
        {
            //登陆成功后保存accessToken
            [[NSUserDefaults standardUserDefaults] setObject:[data objectForKey:@"token"] forKey:@"access_token"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else
    {
        [ProgressHUD showError:@"网络错误"];
    }
}

//回到上一个界面
-(void)backToOver
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
