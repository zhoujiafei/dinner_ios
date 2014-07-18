//
//  OrderTableViewCell.h
//  Dinner
//
//  Created by 周 加飞 on 14-7-17.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//  订单列表

#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *shopName;
@property (nonatomic,strong) UILabel *orderStatus;
@property (nonatomic,strong) UILabel *totalPrice;
@property (nonatomic,strong) UILabel *orderTime;

@end
