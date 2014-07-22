//
//  RegisterViewController.h
//  Dinner
//
//  Created by 周 加飞 on 14-7-9.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "config.h"
#import "LoginTextField.h"

@interface RegisterViewController : BaseViewController <UIAlertViewDelegate>

@property (nonatomic,strong) LoginTextField *username;
@property (nonatomic,strong) LoginTextField *firstPassword;
@property (nonatomic,strong) LoginTextField *secondPassword;

@end
