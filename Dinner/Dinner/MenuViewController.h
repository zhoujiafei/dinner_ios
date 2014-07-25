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
#import "FoodCartBtn.h"

@interface MenuViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,UIAlertViewDelegate>

@property(nonatomic,assign) NSString *shopId;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) EGORefreshTableHeaderView *refreshTableHeaderView;
@property (nonatomic,assign) BOOL reloading;
@property (nonatomic,strong) NSMutableArray *menusData;
@property (nonatomic,strong) FoodCartBtn *cartBtn;
@property (nonatomic,strong) UIView *emptyBgView;

@end
