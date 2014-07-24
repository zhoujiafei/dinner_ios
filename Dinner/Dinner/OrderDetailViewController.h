//
//  OrderDetailViewController.h
//  Dinner
//
//  Created by 刘 金兰 on 14-7-20.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "BaseViewController.h"
#import "config.h"

@interface OrderDetailViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSDictionary *orderInfo;
@property (nonatomic,strong) UITableView *tableView;

@end
