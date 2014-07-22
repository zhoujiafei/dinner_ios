//
//  RegisterViewController.m
//  Dinner
//
//  Created by 周 加飞 on 14-7-9.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "RegisterViewController.h"

@implementation RegisterViewController

@synthesize username = _username;
@synthesize firstPassword = _firstPassword;
@synthesize secondPassword = _secondPassword;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"注册";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showRegister];
}

#pragma mark -
#pragma mark Show Register Interface

-(void)showRegister
{
    //原密码框
    _username = [[LoginTextField alloc] initWithFrame:CGRectMake(10, 80, self.view.frame.size.width - 20, 45)];
    _username.placeholder = @"请输入用户名";
    _username.borderStyle = UITextBorderStyleRoundedRect;
    _username.leftViewMode = UITextFieldViewModeAlways;
    _username.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account"]];
    _username.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //新密码框
    _firstPassword = [[LoginTextField alloc] initWithFrame:CGRectMake(10, 140, self.view.frame.size.width - 20, 45)];
    _firstPassword.placeholder = @"请输入密码";
    _firstPassword.borderStyle = UITextBorderStyleRoundedRect;
    _firstPassword.secureTextEntry = YES;
    _firstPassword.leftViewMode = UITextFieldViewModeAlways;
    _firstPassword.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_pw"]];
    _firstPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //确认密码框
    _secondPassword = [[LoginTextField alloc] initWithFrame:CGRectMake(10, 200, self.view.frame.size.width - 20, 45)];
    _secondPassword.placeholder = @"确认输入密码";
    _secondPassword.borderStyle = UITextBorderStyleRoundedRect;
    _secondPassword.secureTextEntry = YES;
    _secondPassword.leftViewMode = UITextFieldViewModeAlways;
    _secondPassword.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_pw"]];
    _secondPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //注册按钮
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    registerBtn.frame = CGRectMake(10, 260, self.view.frame.size.width - 20, 45);
    registerBtn.backgroundColor = APP_BASE_COLOR;
    registerBtn.layer.cornerRadius = 5.0f;
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [registerBtn addTarget:self action:@selector(goToRegister) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_username];
    [self.view addSubview:_firstPassword];
    [self.view addSubview:_secondPassword];
    [self.view addSubview:registerBtn];
}

//去注册
-(void)goToRegister
{
    //获取用户名
    NSString *name = [_username.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //获取新密码
    NSString *password1 = [_firstPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //获取确认密码
    NSString *password2 = [_secondPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([name length] == 0)
    {
        [ProgressHUD showError:@"请输入用户名"];
        return;
    }
    else if([name length] > 15)
    {
        [ProgressHUD showError:@"用户名过长，不能超过15个字符"];
        return;
    }
    
    if ([password1 length] == 0)
    {
        [ProgressHUD showError:@"请输入新密码"];
        return;
    }
    else if ([password1 length] > 15)
    {
        [ProgressHUD showError:@"输入的密码过长，不能超过15个字符"];
        return;
    }
    
    if ([password2 length] == 0)
    {
        [ProgressHUD showError:@"请输入确认密码"];
        return;
    }
    
    if (![password1 isEqualToString:password2])
    {
        [ProgressHUD showError:@"两次输入的密码不一致"];
        return;
    }
    
    [ProgressHUD show:@"正在提交注册..."];
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:REGISTER_API]];
    [request addPostValue:name forKey:@"name"];
    [request addPostValue:password1 forKey:@"password1"];
    [request addPostValue:password2 forKey:@"password2"];
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
            [ProgressHUD showError:[returnData objectForKey:@"errorText"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ProgressHUD dismiss];
            });
            return;
        }
        else
        {
            [ProgressHUD dismiss];
            if ([returnData isKindOfClass:[NSDictionary class]])
            {
                NSString *successMsg = [NSString stringWithFormat:@"您的用户名是：%@,您的密码是：%@",name,password1];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册成功" message:successMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }];
    [request setFailedBlock:^{
        [ProgressHUD showError:@"网络连接错误"];
    }];
    [request startAsynchronous];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
