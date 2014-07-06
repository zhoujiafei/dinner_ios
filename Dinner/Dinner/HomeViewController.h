//
//  HomeViewController.h
//  Dinner
//
//  Created by 刘 金兰 on 14-7-5.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "ShopTableViewCell.h"
#import "config.h"

@interface HomeViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *shopData;
@property (nonatomic,assign) BOOL isOnTime;

@end
