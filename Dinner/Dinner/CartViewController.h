//
//  CartViewController.h
//  Dinner
//
//  Created by 刘 金兰 on 14-7-8.
//  Copyright (c) 2014年 周加飞. All rights reserved.
// 购物车

#import <UIKit/UIKit.h>
#import "config.h"
#import "FoodCartTableViewCell.h"

@interface CartViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *cartData;
@property (nonatomic,strong) UILabel *totalPrice;

@end
