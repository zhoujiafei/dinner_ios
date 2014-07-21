//
//  NoticeViewController.h
//  Dinner
//
//  Created by 刘 金兰 on 14-7-20.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "config.h"
#import "EGORefreshTableHeaderView.h"
#import "NoticeTableViewCell.h"
#import "NoticeDetailViewController.h"

@interface NoticeViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) EGORefreshTableHeaderView *refreshTableHeaderView;
@property (nonatomic,assign) BOOL reloading;
@property (nonatomic,strong) NSMutableArray *noticeData;
@property (nonatomic,strong) UIView *emptyBgView;

@end
