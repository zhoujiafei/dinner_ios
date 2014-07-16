//
//  CenterViewController.h
//  Dinner
//
//  Created by 刘 金兰 on 14-7-5.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "config.h"
#import "LoginViewController.h"
#import "CenterTableViewCell.h"
#import "XHPathCover.h"

@interface CenterViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) XHPathCover *pathCover;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *settingLabels;
@property (nonatomic,strong) NSDictionary *userInfo;//保存用户信息

@end
