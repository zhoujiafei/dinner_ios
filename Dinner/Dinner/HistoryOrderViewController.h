//
//  HistoryOrderViewController.h
//  Dinner
//
//  Created by 周 加飞 on 14-7-15.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//  历史订单

#import <UIKit/UIKit.h>
#import "config.h"
#import "OrderTableViewCell.h"
#import "EGORefreshTableHeaderView.h"
#import "LoginViewController.h"

@interface HistoryOrderViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) EGORefreshTableHeaderView *refreshTableHeaderView;
@property (nonatomic,assign) BOOL reloading;
@property (nonatomic,strong) NSMutableArray *orderData;
@property (nonatomic,strong) NSString *accessToken;

@end
