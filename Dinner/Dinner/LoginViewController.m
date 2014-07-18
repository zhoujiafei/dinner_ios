//
//  LoginViewController.m
//  Dinner
//
//  Created by 周 加飞 on 14-7-7.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController

@synthesize username    = _username;
@synthesize password    = _password;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"登陆";
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showLogin];
    
    
    
    
    
    
    
    
}

//显示登陆界面
-(void)showLogin
{
    //注册按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(goToRegister)];
    
    //回到上一个界面
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToOver)];
    
    //用户名
    _username = [[LoginTextField alloc] initWithFrame:CGRectMake(10, 80, self.view.frame.size.width - 20, 45)];
    _username.placeholder = @"请输入您的用户名";
    _username.borderStyle = UITextBorderStyleRoundedRect;
    _username.background = [UIImage imageNamed:@"account"];
    _username.leftViewMode = UITextFieldViewModeAlways;
    _username.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account"]];
    _username.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //密码框
    _password = [[LoginTextField alloc] initWithFrame:CGRectMake(10, 140, self.view.frame.size.width - 20, 45)];
    _password.placeholder = @"请输入您的密码";
    _password.borderStyle = UITextBorderStyleRoundedRect;
    _password.secureTextEntry = YES;
    _password.leftViewMode = UITextFieldViewModeAlways;
    _password.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_pw"]];
    _password.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //登陆按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginBtn.frame = CGRectMake(10, 200, self.view.frame.size.width - 20, 45);
    loginBtn.backgroundColor = APP_BASE_COLOR;
    loginBtn.layer.cornerRadius = 5.0f;
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [loginBtn addTarget:self action:@selector(goToLogin) forControlEvents:UIControlEventTouchUpInside];
    
    //注册按钮
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    registerBtn.frame = CGRectMake(10, 260, self.view.frame.size.width - 20, 45);
    registerBtn.backgroundColor = [UIColor colorWithRed:125.0/255.0 green:181.0/255.0 blue:0.0 alpha:1];
    registerBtn.layer.cornerRadius = 5.0f;
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [registerBtn addTarget:self action:@selector(goToRegister) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_username];
    [self.view addSubview:_password];
    [self.view addSubview:loginBtn];
    [self.view addSubview:registerBtn];
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
