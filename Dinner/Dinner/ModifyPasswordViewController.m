//
//  ModifyPasswordViewController.m
//  Dinner
//
//  Created by 周 加飞 on 14-7-16.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "ModifyPasswordViewController.h"

@implementation ModifyPasswordViewController

@synthesize originalName = _originalName;
@synthesize modifyPassword = _modifyPassword;
@synthesize confirmPassword = _confirmPassword;
@synthesize accessToken = _accessToken;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"修改密码";
        self.view.backgroundColor = [UIColor whiteColor];
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
    [self showModify];
    
    
    
    
    
}

//显示修改密码界面
-(void)showModify
{
    //原密码框
    _originalName = [[LoginTextField alloc] initWithFrame:CGRectMake(10, 80, self.view.frame.size.width - 20, 45)];
    _originalName.placeholder = @"原始密码";
    _originalName.borderStyle = UITextBorderStyleRoundedRect;
    _originalName.secureTextEntry = YES;
    _originalName.leftViewMode = UITextFieldViewModeAlways;
    _originalName.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_pw"]];
    _originalName.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //新密码框
    _modifyPassword = [[LoginTextField alloc] initWithFrame:CGRectMake(10, 140, self.view.frame.size.width - 20, 45)];
    _modifyPassword.placeholder = @"新密码";
    _modifyPassword.borderStyle = UITextBorderStyleRoundedRect;
    _modifyPassword.secureTextEntry = YES;
    _modifyPassword.leftViewMode = UITextFieldViewModeAlways;
    _modifyPassword.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_pw"]];
    _modifyPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //确认密码框
    _confirmPassword = [[LoginTextField alloc] initWithFrame:CGRectMake(10, 200, self.view.frame.size.width - 20, 45)];
    _confirmPassword.placeholder = @"确认密码";
    _confirmPassword.borderStyle = UITextBorderStyleRoundedRect;
    _confirmPassword.secureTextEntry = YES;
    _confirmPassword.leftViewMode = UITextFieldViewModeAlways;
    _confirmPassword.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_pw"]];
    _confirmPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //修改按钮
    UIButton *modifyBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    modifyBtn.frame = CGRectMake(10, 260, self.view.frame.size.width - 20, 45);
    modifyBtn.backgroundColor = APP_BASE_COLOR;
    modifyBtn.layer.cornerRadius = 5.0f;
    [modifyBtn setTitle:@"修改" forState:UIControlStateNormal];
    [modifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    modifyBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [modifyBtn addTarget:self action:@selector(goToModifyPassword) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_originalName];
    [self.view addSubview:_modifyPassword];
    [self.view addSubview:_confirmPassword];
    [self.view addSubview:modifyBtn];
}

//请求修改密码
-(void)goToModifyPassword
{
    
}

//跳转到登陆界面
-(void)goToLogin
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
}


@end
