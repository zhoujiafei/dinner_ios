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

#pragma mark -
#pragma mark Login Interface

//显示登陆界面
-(void)showLogin
{
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

#pragma mark -
#pragma mark Go To Register

//去注册
-(void)goToRegister
{
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark -
#pragma mark Go To Login

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
    
    [ProgressHUD show:@"正在登陆..."];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:LOGIN_API]];
    [request addPostValue:username forKey:@"name"];
    [request addPostValue:password forKey:@"password"];
    [request setCompletionBlock:^{
        if ([request responseStatusCode] != 200)
        {
            return;
        }
        
        if (isNilNull([request responseData]))
        {
            return;
        }
        
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:nil];
        if ([data objectForKey:@"errorCode"])
        {
            [ProgressHUD showError:[data objectForKey:@"errorText"]];
            return;
        }
        else
        {
            [ProgressHUD showSuccess:@"登陆成功"];
            //登陆成功后保存accessToken
            [[NSUserDefaults standardUserDefaults] setObject:[data objectForKey:@"token"] forKey:@"access_token"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //保存用户信息
            NSMutableDictionary *userData = [NSMutableDictionary dictionaryWithDictionary:data];
            [userData setObject:password forKey:@"password"];
            [[DataManage shareDataManage] insertData:CACHE_NAME withNetworkApi:@"__userinfo" withObject:userData];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    [request setFailedBlock:^{
        [ProgressHUD showError:@"网络连接错误"];
    }];
    [request startAsynchronous];
}

#pragma mark -
#pragma mark 返回

//回到上一个界面
-(void)backToOver
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark 隐藏键盘

//隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_username resignFirstResponder];
    [_password resignFirstResponder];
}

@end
