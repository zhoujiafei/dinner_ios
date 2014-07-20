//
//  MoreViewController.h
//  Dinner
//
//  Created by 刘 金兰 on 14-7-19.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "config.h"
#import "MoreTableViewCell.h"
#import "NoticeViewController.h"
#import "ScanViewController.h"
#import "AboutUsViewController.h"
#import "FeedbackViewController.h"
#import "SettingViewController.h"

@interface MoreViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@end
