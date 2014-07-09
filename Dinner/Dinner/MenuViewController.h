//
//  MenuViewController.h
//  Dinner
//
//  Created by 刘 金兰 on 14-7-5.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "config.h"
#import "EGORefreshTableHeaderView.h"
#import "MenuTableViewCell.h"
#import "CartViewController.h"

@interface MenuViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>

@property(nonatomic,assign) NSString *shopId;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) EGORefreshTableHeaderView *refreshTableHeaderView;
@property (nonatomic,assign) BOOL reloading;
@property (nonatomic,strong) NSArray *menusData;

@end
