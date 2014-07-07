//
//  LoginViewController.m
//  Dinner
//
//  Created by 周 加飞 on 14-7-7.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController

@synthesize username = _username;
@synthesize password = _password;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 100, 45)];
    usernameLabel.text = @"昵称：";
    
    _username = [[UITextField alloc] initWithFrame:CGRectMake(130, 40, 100, 45)];
    _username.placeholder = @"请输入昵称";
    
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 100, 45)];
    passwordLabel.text = @"密码：";
    
    _password = [[UITextField alloc] initWithFrame:CGRectMake(130, 100, 100, 45)];
    _password.placeholder = @"请输入密码";
    _password.secureTextEntry = YES;
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginBtn.frame = CGRectMake(20, 160, 100, 45);
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    
    [self.view addSubview:usernameLabel];
    [self.view addSubview:passwordLabel];
    [self.view addSubview:_username];
    [self.view addSubview:_password];
    
}

@end
