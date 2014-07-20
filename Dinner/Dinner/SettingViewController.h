//
//  MoreViewController.h
//  Dinner
//
//  Created by 刘 金兰 on 14-7-5.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "config.h"
#import "MoreTableViewCell.h"
#import "ClockViewController.h"

@interface SettingViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@end
