//
//  LoginViewController.h
//  Dinner
//
//  Created by 周 加飞 on 14-7-7.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//  登陆界面

#import <UIKit/UIKit.h>
#import "config.h"
#import "RegisterViewController.h"
#import "CenterViewController.h"

@interface LoginViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITextField *username;
@property (nonatomic,strong) UITextField *password;
@property (nonatomic,strong) UITableView *tableView;

@end
