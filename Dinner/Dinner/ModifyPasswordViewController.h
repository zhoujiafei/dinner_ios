//
//  ModifyPasswordViewController.h
//  Dinner
//
//  Created by 周 加飞 on 14-7-16.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "config.h"
#import "LoginTextField.h"
#import "LoginViewController.h"

@interface ModifyPasswordViewController : BaseViewController

@property (nonatomic,strong) UITextField *originalName;//原密码
@property (nonatomic,strong) UITextField *modifyPassword;//新密码
@property (nonatomic,strong) UITextField *confirmPassword;//确认密码
@property (nonatomic,strong) NSString *accessToken;

@end
