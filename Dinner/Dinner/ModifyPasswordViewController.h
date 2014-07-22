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
#import "CenterTableViewCell.h"

@interface ModifyPasswordViewController : BaseViewController

@property (nonatomic,strong) LoginTextField *originalName;//原密码
@property (nonatomic,strong) LoginTextField *modifyPassword;//新密码
@property (nonatomic,strong) LoginTextField *confirmPassword;//确认密码
@property (nonatomic,strong) NSString *accessToken;

@end
