//
//  PersonalViewController.h
//  Dinner
//
//  Created by 周 加飞 on 14-7-16.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//  个人资料界面

#import <UIKit/UIKit.h>
#import "config.h"
#import "LoginViewController.h"
#import "PersonalTableViewCell.h"

@interface PersonalViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableDictionary *userInfo;
@property (nonatomic,strong) NSString *accessToken;

@end
