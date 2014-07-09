//
//  CenterViewController.m
//  Dinner
//
//  Created by 刘 金兰 on 14-7-5.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "CenterViewController.h"

@implementation CenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"用户中心";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginBtn.frame = CGRectMake(20, 160, 100, 45);
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loginBtn];
}

-(void)login
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
