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
#import "LoginTextField.h"

@interface LoginViewController : BaseViewController

@property (nonatomic,strong) LoginTextField *username;
@property (nonatomic,strong) LoginTextField *password;

@end
